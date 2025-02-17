//
//  WalletViewModel.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 16.02.2025.
//

import Foundation

final class WalletViewModel: BaseViewModel {
    typealias Output = WalletOutput
    
    // MARK: - Outputable
    
    struct WalletOutput: Outputable {
        @Variable var btcBalance: Double = .init()
        @Variable var transactions: [Transaction] = []
    }
    
    // MARK: - Output
    
    var output: Output = .init()
    
    // MARK: - Dependencies
    
    private let btcCurrencyService: BitcoinRateService
    
    // MARK: - Init
    init(btcCurrencyService: BitcoinRateService) {
        self.btcCurrencyService = btcCurrencyService
    }
}
