//
//  NewTransactionViewModel.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 17.02.2025.
//

import Foundation

final class NewTransactionViewModel: BaseViewModel {
    
    typealias Output = NewTransactionOutput
    
    // MARK: - Outputable
    
    struct NewTransactionOutput: Outputable {
        @Variable var categories: [String] = ["Taxi", "Groceries", "Gym", "Study", "Electronics", "Restaurant"]
    }
    
    // MARK: - Output
    
    var output: Output = .init()
    
    // MARK: - Private properties
    private var selectedCategory: String = "Taxi"
    private var bag = Bag()
    
    // MARK: - Input
    
    enum Input {
        case selectCategory(String)
        case addTransaction(Double)
    }
    
    // MARK: - Dependencies
    
    private let accountRepo: AccountRepo
    private let coreDataManager: CoreDataManager
    
    // MARK: - Init
    
    init(accountRepo: AccountRepo, coreDataManager: CoreDataManager) {
        self.accountRepo = accountRepo
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Private methods
    
    private func selectCategory(_ category: String) {
        selectedCategory = category
    }
    
    private func addTransaction(with amount: Double) {
        let transaction = Transaction(context: coreDataManager.context)
        
        transaction.date = Date()
        transaction.amount = amount
        transaction.type = "Spend"
        transaction.category = selectedCategory
        
        coreDataManager.addEntity(entity: transaction)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    debugPrint("Couldn't save transaction, because of \(error)")
                }
            } receiveValue: { [weak self] transactions in
                print("Transaction is saved")
                self?.accountRepo.transactions = transactions
                self?.accountRepo.$transactionDidUpdate.send(true)
                self?.updateBalance(with: amount)
            }
            .store(in: &bag)
    }
    
    private func updateBalance(with amount: Double) {
        let userBalance = UserBalance(context: coreDataManager.context)
        let currentBalance = accountRepo.balance
        let updatedBalance =  currentBalance - amount
        
        userBalance.balance = updatedBalance
        
        coreDataManager.addEntity(entity: userBalance)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    debugPrint("Couldn't save transaction, because of \(error)")
                }
            } receiveValue: { [weak self] _ in
                print("Balance is saved")
                self?.accountRepo.balance = updatedBalance
            }
            .store(in: &bag)
    }
}

// MARK: - Trigger
extension NewTransactionViewModel {
    func trigger(_ input: Input) {
        switch input {
        case .selectCategory(let category):
            selectCategory(category)
            
        case .addTransaction(let amount):
            addTransaction(with: amount)
        }
    }
}
