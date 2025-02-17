//
//  APIEnvironment.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 17.02.2025.
//

import Foundation

enum APIEnvironment {
    case prod
    /// Also you can add stage, dev environments

    var baseURL: String {
        switch self {
        case .prod:
            return "https://api.coincap.io"
        }
    }
}
