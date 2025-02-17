//
//  APIEndpoints.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 17.02.2025.
//

import Foundation

enum APIEndpoints {
    case btcCurrencyEndpoint
    
    var path: String {
        switch self {
        case .btcCurrencyEndpoint:
            return "/v2/assets/bitcoin"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .btcCurrencyEndpoint:
            return .get
        }
    }
}
