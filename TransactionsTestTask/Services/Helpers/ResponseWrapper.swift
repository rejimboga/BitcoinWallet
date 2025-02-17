//
//  ResponseWrapper.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 17.02.2025.
//

import Foundation

struct ResponseWrapper<T: Decodable>: Decodable {
    /// Usually also get status, message
    let data: T?
    
    enum CodingKeys: CodingKey {
        case data
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}
