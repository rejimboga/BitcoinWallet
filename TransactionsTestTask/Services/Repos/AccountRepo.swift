//
//  AccountRepo.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 18.02.2025.
//

import Foundation

final class AccountRepo {
    @Published var balance: Double = 0
    @Published var transactions: [Transaction] = []
    
    private let coreDataManager: CoreDataManager
    private var bag = Bag()
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        
        fetchBalance()
        fetchTransactions()
    }
    
    private func fetchBalance() {
        coreDataManager.fetchEntities(ofType: UserBalance.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching entities: \(error)")
                }
            } receiveValue: { [weak self] entity in
                guard let balance = entity.last?.balance else { return }
                self?.balance = balance
            }
            .store(in: &bag)
    }
    
    private func fetchTransactions() {
        coreDataManager.fetchEntities(ofType: Transaction.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching entities: \(error)")
                }
            } receiveValue: { [weak self] transactions in
                self?.transactions = transactions
            }
            .store(in: &bag)
    }
}
