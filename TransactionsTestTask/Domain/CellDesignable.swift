//
//  CellDesignable.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 18.02.2025.
//

import Foundation

protocol CellDesignable {
    @discardableResult
    func configure(with cellModel: CellModeling) -> Self
}
