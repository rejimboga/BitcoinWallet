//
//  UIStackView+Extensions.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import UIKit

extension UIStackView {

    @discardableResult
    func spacing(_ value: CGFloat) -> Self {
        spacing = value
        return self
    }

    @discardableResult
    func axis(_ value: NSLayoutConstraint.Axis) -> Self {
        axis = value
        return self
    }

    @discardableResult
    func distribution(_ value: Distribution) -> Self {
        distribution = value
        return self
    }

    @discardableResult
    func alignment(_ value: UIStackView.Alignment) -> Self {
        alignment = value
        return self
    }
    
    @discardableResult
    func addArrangedSubviews(_ value: [UIView]) -> Self {
        value.forEach { addArrangedSubview($0) }
        return self
    }
    
    @discardableResult
    func clear() -> Self {
        arrangedSubviews.forEach({ $0.removeFromSuperview() })
        return self
    }
}
