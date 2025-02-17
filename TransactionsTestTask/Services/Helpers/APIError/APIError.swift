//
//  APIError.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 17.02.2025.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case requestFailed(String)
    case decodingFailed
    case unknown
}
