//
//  Navigation.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import UIKit

protocol Routable {
    var vc: UIViewController { get }
}

protocol Navigatable {
    associatedtype Route: Routable
}
