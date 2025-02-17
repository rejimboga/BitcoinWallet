//
//  Event.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 17.02.2025.
//

import Foundation
import Combine

@propertyWrapper
final class Event<Value> {
    
    var wrappedValue: Any? {
        get { nil }
        set {
            if let newValue = newValue as? Value {
                projectedValue.send(newValue)
            } else {
                debugPrint("Wrong type sended! Waiting for \(Value.self) but takes \(String(describing: newValue))")
            }
        }
    }
    
    var projectedValue: PassthroughSubject<Value, Never>
    
    init() {
        self.projectedValue = .init()
    }
}

extension PassthroughSubject {
    
    var ui: AnyPublisher<Output, Failure> {
        return self.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
}
