//
//  UILabel+Extensions.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import UIKit

extension UILabel {
    
    @discardableResult
    func font(_ value: UIFont) -> Self {
        font = value
        return self
    }
    
    @discardableResult
    func text(_ value: String?) -> Self {
        text = value
        return self
    }
    
    @discardableResult
    func textColor(_ value: UIColor) -> Self {
        textColor = value
        return self
    }
    
    @discardableResult
    func alignment(_ value: NSTextAlignment) -> Self {
        textAlignment = value
        return self
    }
    
    @discardableResult
    func numberOfLines(_ value: Int) -> Self {
        numberOfLines = value
        return self
    }
}
