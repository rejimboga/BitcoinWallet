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
        
        @Event<BTCCurrency?> var btcCurrency
    }
    
    // MARK: - Output
    
    var output: Output = .init()
    
    // MARK: - Dependencies
    
    private let btcCurrencyService: BitcoinRateService
    
    // MARK: - Properties
    private var bag = Bag()
    
    // MARK: - Init
    
    init(btcCurrencyService: BitcoinRateService) {
        self.btcCurrencyService = btcCurrencyService
        
        getBtcCurrency()
    }
    
    private func getBtcCurrency() {
        fetchBtcCurrency()
        
        Timer.publish(every: 300, on: .main, in: .common)
            .autoconnect()
            .sink{ [weak self] _ in
                print("make request")
                self?.fetchBtcCurrency()
            }
            .store(in: &bag)
    }
    
    private func fetchBtcCurrency() {
        btcCurrencyService.getBtcCurrency { [weak self] result in
            switch result {
            case .success(let currency):
                self?.output.$btcCurrency.send(currency)
            case .failure:
                self?.output.$btcCurrency.send(nil)
            }
        }
    }
}
