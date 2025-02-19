//
//  Date+Extensions.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 18.02.2025.
//

import Foundation

extension Date {
    func headerTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        let title = formatter.string(from: self)
        return title
    }
    
    func transactionTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let title = formatter.string(from: self)
        return title
    }
    
    func dayMonthYear() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        let dateString = formatter.string(from: self)
        
        return formatter.date(from: dateString) ?? Date()
    }
}
