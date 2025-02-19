//
//  BitcoinRateServiceMock.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 19.02.2025.
//

import Foundation

final class BitcoinRateServiceMock: BitcoinRateService, MockServiceProtocol {
    
    // MARK: - Init
    
    init() { }
    
    func getBtcCurrency(onCompletion: @escaping ResultCompletion<BTCCurrency>) {
        _ = substituteResposeFile(named: "btcCurrencyMock", bundle: .main, completion: onCompletion)
    }
}
