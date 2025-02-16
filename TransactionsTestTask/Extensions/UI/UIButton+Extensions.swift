//
//  UIButton+Extensions.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import UIKit

extension UIButton {
    
    @discardableResult
    func tag(_ value: Int) -> Self {
        self.tag = value
        return self
    }
    
    @discardableResult
    func text(_ value: String) -> Self {
        setTitle(value, for: .normal)
        return self
    }
    
    @discardableResult
    func tintColor(_ value: UIColor) -> Self {
        tintColor = value
        return self
    }
    
    @discardableResult
    func font(_ value: UIFont) -> Self {
        titleLabel?.font(value)
        return self
    }
    
    @discardableResult
    func textColor(_ value: UIColor) -> Self {
        setTitleColor(value, for: .normal)
        return self
    }
    
    @discardableResult
    func image(_ value: UIImage?) -> Self {
        setImage(value, for: .normal)
        return self
    }
    
    @discardableResult
    func underline(_ value: Bool) -> Self {
        setAttributedTitle(
            NSAttributedString(
                string: titleLabel?.text ?? "",
                attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]),
            for: .normal
        )
        return self
    }
    
    @discardableResult
    func addTarget(_ target: Any?, selector: Selector, event: Event) -> Self {
        addTarget(target, action: selector, for: event)
        return self
    }
    
    @discardableResult
    func imageWithTintColor(_ value: UIImage?) -> Self {
        setImage(value?.withRenderingMode(.alwaysTemplate), for: .normal)
        return self
    }
}
