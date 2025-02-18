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
        
        @Event<BTCCurrency?> var btcCurrency
    }
    
    // MARK: - Output
    
    var output: Output = .init()
    
    // MARK: - Dependencies
    
    private let btcCurrencyService: BitcoinRateService
    private let coreDataManager: CoreDataManager
    private(set) var accountRepo: AccountRepo
    
    // MARK: - Properties
    
    private var bag = Bag()
    
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
//        fetchBalance()
    }
    
    private func getBtcCurrency() {
        fetchBtcCurrency()
        
        Timer.publish(every: 300, on: .main, in: .common)
            .autoconnect()
            .sink{ [weak self] _ in
                print("make request")
                self?.fetchBtcCurrency()
            }
            .store(in: &bag)
    }
    
    private func fetchBtcCurrency() {
        btcCurrencyService.getBtcCurrency { [weak self] result in
            switch result {
            case .success(let currency):
                self?.output.$btcCurrency.send(currency)
            case .failure:
                self?.output.$btcCurrency.send(nil)
            }
        }
    }
    
    private func fetchTransactions() {
        accountRepo.$transactions
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching entities: \(error)")
                }
            } receiveValue: { [weak self] transactions in
                self?.grouping(transactions)
            }
            .store(in: &bag)

    }
    
    private func grouping(_ transactions: [Transaction]) {
        let groupingTransactions = Dictionary(grouping: transactions) {
            $0.date
        }.sorted {
            $0.key?.dayMonthYear() ?? Date.distantFuture > $1.key?.dayMonthYear() ?? Date.distantPast
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
