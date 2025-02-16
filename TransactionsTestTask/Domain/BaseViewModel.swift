//
//  BaseViewModel.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import Foundation

protocol BaseViewModel {
    associatedtype Output: Outputable
    
    var output: Output { get }
}

protocol Outputable { }
