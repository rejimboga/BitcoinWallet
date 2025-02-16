//
//  Variable.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import Combine

@propertyWrapper
final class Variable<Value> {
    
    var wrappedValue: Value {
        get { projectedValue.value }
        set { projectedValue.send(newValue) }
    }
    
    var projectedValue: CurrentValueSubject<Value, Never>
    
    init(wrappedValue: Value) {
        self.projectedValue = .init(wrappedValue)
    }
}
