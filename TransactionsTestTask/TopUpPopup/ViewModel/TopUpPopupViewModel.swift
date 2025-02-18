//
//  TopUpPopupViewModel.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 18.02.2025.
//

import Foundation

final class TopUpPopupViewModel: BaseViewModel {
    typealias Output = TopUpPopupOutput
    
    // MARK: - Outputable
    
    struct TopUpPopupOutput: Outputable { }
    
    // MARK: - Output
    
    var output: Output = .init()
    
    // MARK: - Dependencies
    
    private let coreDataManager: CoreDataManager
    private let accountRepo: AccountRepo
    
    // MARK: - Properties
    
    private var bag = Bag()
    
    // MARK: - Init
    
    init(coreDataManager: CoreDataManager, accountRepo: AccountRepo) {
        self.coreDataManager = coreDataManager
        self.accountRepo = accountRepo
    }
    
    // MARK: - Input
    
    enum Input {
        case topUp(Double)
    }
    
    // MARK: - Private methods
    
    private func saveTransaction(with amount: Double) {
        let transaction = Transaction(context: coreDataManager.context)
        
        transaction.date = Date()
        transaction.amount = amount
        transaction.type = "Earn"
        
        coreDataManager.addEntity(entity: transaction)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    debugPrint("Couldn't save transaction, because of \(error)")
                }
            } receiveValue: { [weak self] transactions in
                print("Earns is saved")
                self?.accountRepo.transactions = transactions
            }
            .store(in: &bag)
    }
    
    private func saveBalance(with amount: Double) {
        let userBalance = UserBalance(context: coreDataManager.context)
        let currentBalance = accountRepo.balance
        let updatedBalance =  currentBalance + amount
        
        userBalance.balance = updatedBalance
        
        coreDataManager.addEntity(entity: userBalance)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    debugPrint("Couldn't save transaction, because of \(error)")
                }
            } receiveValue: { [weak self] _ in
                print("Earns is saved")
                self?.accountRepo.balance = updatedBalance
            }
            .store(in: &bag)
    }
}

// MARK: - Trigger

extension TopUpPopupViewModel {
    func trigger(_ input: Input) {
        switch input {
            
        case .topUp(let amount):
            saveTransaction(with: amount)
            saveBalance(with: amount)
        }
    }
}
