//
//  UITableView+Extensions.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 18.02.2025.
//

import UIKit

extension UITableView {
    
    @discardableResult
    func dataSource(_ value: UITableViewDataSource) -> Self {
        dataSource = value
        return self
    }
    
    @discardableResult
    func delegate(_ value: UITableViewDelegate) -> Self {
        delegate = value
        return self
    }
    
    @discardableResult
    func registerCell(_ cellClass: AnyClass) -> Self {
        register(cellClass.self, forCellReuseIdentifier: String(describing: cellClass))
        return self
    }
    
    @discardableResult
    func showSeparator(_ value: Bool) -> Self {
        if !value {
            separatorColor = .clear
        }
        return self
    }
}
