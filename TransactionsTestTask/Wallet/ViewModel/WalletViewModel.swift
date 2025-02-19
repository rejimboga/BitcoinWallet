//
//  WalletViewModel.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import Foundation
import CoreData

final class WalletViewModel: BaseViewModel {
    typealias Output = WalletOutput
    
    // MARK: - Outputable
    
    struct WalletOutput: Outputable {
        @Variable var btcBalance: Double = .init()
        @Variable var transactionSections: [SectionModeling] = []
        @Variable var isLoading = false
        
        @Event<BTCCurrency?> var btcCurrency
        @Event<String> var cachedBtcCurrency
    }
    
    // MARK: - Output
    
    var output: Output = .init()
    
    // MARK: - Dependencies
    
    private let btcCurrencyService: BitcoinRateService
    private let coreDataManager: CoreDataManager
    private(set) var accountRepo: AccountRepo
    
    // MARK: - Properties
    
    private var bag = Bag()
    
    private var currentPage = 1
    private var transactions: [Transaction] = []
    private var hasMore: Bool = true
    
    private enum LocalConstant {
        static let pageSize = 10
    }
    
    enum Input {
        case loadTransactions
        case updateCurrentPage
    }
    
    // MARK: - Init
    
    init(
        btcCurrencyService: BitcoinRateService,
        coreDataManager: CoreDataManager,
        accountRepo: AccountRepo
    ) {
        self.btcCurrencyService = btcCurrencyService
        self.coreDataManager = coreDataManager
        self.accountRepo = accountRepo
        
        getBtcCurrency()
        fetchTransactions()
    }
    
    // MARK: - Private methods
    
    private func fetchTransactions() {
        guard !output.isLoading else { return }  // It's still loading
        
        output.isLoading = true
        
        coreDataManager.fetchEntities(ofType: Transaction.self, limit: LocalConstant.pageSize, offset: LocalConstant.pageSize * (currentPage - 1))
            .sink(receiveCompletion: { [weak self] completion in
                self?.output.isLoading = false
                switch completion {
                case .failure(let error):
                    print("Pagination error \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] transactions in
                if transactions.isEmpty {
                    // if transactions is empty we don't do request
                    self?.output.isLoading = false
                    self?.hasMore = false
                } else {
                    self?.transactions.append(contentsOf: transactions) // update transaction list
                    self?.hasMore = !transactions.isEmpty // update hasMore for new request
                    
                    self?.grouping(self?.transactions ?? transactions)
                    self?.currentPage += 1  // update page
                }
            })
            .store(in: &bag)
    }
    
    private func getBtcCurrency() {
        fetchBtcCurrency()
        
        Timer.publish(every: 300, on: .main, in: .common)
            .autoconnect()
            .sink{ [weak self] _ in
                self?.fetchBtcCurrency()
            }
            .store(in: &bag)
    }
    
    private func fetchBtcCurrency() {
        btcCurrencyService.getBtcCurrency { [weak self] result in
            switch result {
            case .success(let currency):
                self?.output.$btcCurrency.send(currency)
                self?.saveBtc(currency.priceUsd)
            case .failure:
                self?.output.$btcCurrency.send(nil)
                self?.getCachedBtcCurrency()
            }
        }
    }
    
    private func saveBtc(_ currency: String) {
        let btcCurrency = BtcCurrency(context: coreDataManager.context)
        btcCurrency.currency = currency
        
        coreDataManager.addEntity(entity: btcCurrency)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    debugPrint("Couldn't save transaction, because of \(error)")
                }
            } receiveValue: { _ in }
            .store(in: &bag)
    }
    
    private func getCachedBtcCurrency() {
        coreDataManager.fetchEntities(ofType: BtcCurrency.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching entities: \(error)")
                }
            } receiveValue: { [weak self] entity in
                guard let currency = entity.last else { return }
                self?.output.$cachedBtcCurrency.send(currency.currency ?? "")
            }
            .store(in: &bag)
    }
    
    private func grouping(_ transactions: [Transaction]) {
        let groupingTransactions = Dictionary(grouping: transactions) {
            $0.date
        }.sorted {
            ($0.key ?? Date.distantFuture) > ($1.key ?? Date.distantPast)
        }
        
        let sections = groupingTransactions.compactMap { (date, operations) -> SectionModeling? in
            guard let headerTitle = date?.headerTitle() else { return nil}
            
            let cellModels = operations.compactMap { operation -> CellModeling? in
                return TransactionCellModel(
                    transactionType: operation.type,
                    transactionAmount: operation.amount,
                    transactionCategory: operation.category,
                    transactionDate: operation.date ?? Date()
                )
            }
            
            return TransactionSections(headerTitle: headerTitle, cellModels: cellModels)
        }
        
        output.$transactionSections.send(sections)
    }
}

// MARK: - Trigger
extension WalletViewModel {
    func trigger(_ input: Input) {
        switch input {
            
        case .loadTransactions:
            fetchTransactions()
            
        case .updateCurrentPage:
            currentPage = 1
            transactions = []
            fetchTransactions()
        }
    }
}
