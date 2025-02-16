//
//  UpdateUI.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import Foundation

public func UpdateUI(after delay: Double? = nil, _ handler: @escaping () -> ()) {
    if let delay = delay {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            handler()
        }
        
        return
    }
    
    DispatchQueue.main.async {
        handler()
    }
}
