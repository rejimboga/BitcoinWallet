//
//  UITextField+Extensions.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import UIKit
import Combine

extension UITextField {
    @discardableResult
    func delegate(_ value: UITextFieldDelegate) -> Self {
        self.delegate = value
        return self
    }
    
    @discardableResult
    func placeholder(_ value: String) -> Self {
        self.placeholder = value
        return self
    }
    
    @discardableResult
    func leftInset() -> Self {
        self.leftViewMode = .always
        self.leftView = .init(frame: .init(x: 0, y: 0, width: 8, height: 0))
        return self
    }
    
    @discardableResult
    func keyboardType(_ value: UIKeyboardType) -> Self {
        self.keyboardType = value
        return self
    }
    
    @discardableResult
    func text(_ value: String?) -> Self {
        self.text = value
        return self
    }
    
    // MARK: - Reactive
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextField)?.text?.trimmingCharacters(in: .whitespacesAndNewlines) }
        .eraseToAnyPublisher()
    }
}
