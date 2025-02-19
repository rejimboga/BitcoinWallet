//
//  String+Extensions.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 17.02.2025.
//

import Foundation

public extension String {
    func toRoundedDouble() -> Double {
        let doubleValue = Double(self) ?? 0
        return (doubleValue * 100).rounded() / 100
    }
}
