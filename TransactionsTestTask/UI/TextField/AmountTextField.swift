//
//  AmountTextField.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import UIKit

final class AmountTextField: UITextField {
    // MARK: - Properties
    
    private(set) var doubleValue: Double? {
        didSet {
            text(formatText(text ?? ""))
        }
    }
    
    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(textChanged), for: .editingChanged)
        delegate = self
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Private methods
    
    @objc private func textChanged() {
        text = text?.replacingOccurrences(of: ",", with: ".")
        guard text?.last != "," && text?.last != "." else { return }
        let double = Double(text?
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: ".") ?? "")
        
        doubleValue = double
    }
    
    private func formatText(_ text: String) -> String {
        let alreadyHasDot = text.contains(where: { $0 == "," || $0 == "." })
        guard alreadyHasDot else {
            let double = Double(text
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ",", with: "."))
            return double?.formattedWithSeparator ?? ""
        }
        
        let separated = text.split(separator: ".")
        guard separated.count >= 2 else {
            return "0.\(separated.first ?? "")"
        }
        
        let beforeDot = separated.first ?? "0"
        let afterDot = separated.last?.replacingOccurrences(of: " ", with: "")
        let beforeDotDouble = Double(beforeDot
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: "."))
        
        let result = (beforeDotDouble?.formattedWithSeparator ?? "") + "." + (afterDot ?? "")
        
        return result
    }
}

// MARK: - UITextFieldDelegate

extension AmountTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        
        let isDot = (string == "," || string == ".")
        let alreadyHasDot = currentText.contains(where: { $0 == "," || $0 == "." })
        let isEmpty = currentText.isEmpty
        
        if (isDot && alreadyHasDot) || (isDot && isEmpty) {
            return false
        }
        
        // Don't allow to enter letters
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil && string != "," {
            return false
        }
        
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        if newText.isEmpty {
            return true
        }
                
        if newText.contains(".") {
            let parts = newText.split(separator: ".")
            // Max digits = 2
            if parts.count == 2 && parts[1].count > 2 {
                return false
            }
        }
        
        return true
    }
}
