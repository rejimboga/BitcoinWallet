//
//  TransactionCellModel.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 18.02.2025.
//

import Foundation

struct TransactionCellModel: CellModeling {
    var cellClass: AnyClass { TransactionCell.self }
    
    let transactionType: String?
    let transactionAmount: Double
    let transactionCategory: String?
    let transactionDate: Date
}
