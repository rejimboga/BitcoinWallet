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
    private var selectedCategory: String = ""
    
    // MARK: - Input
    
    enum Input {
        case selectCategory(String)
        case addTransaction
    }
    
    // MARK: - Init
    
    init() { }
    
    // MARK: - Private methods
    
    private func selectCategory(_ category: String) {
        selectedCategory = category
    }
    
    private func addTransaction() {
        
    }
}

// MARK: - Trigger
extension NewTransactionViewModel {
    func trigger(_ input: Input) {
        switch input {
        case .selectCategory(let category):
            selectCategory(category)
            
        case .addTransaction:
            addTransaction()
        }
    }
}
