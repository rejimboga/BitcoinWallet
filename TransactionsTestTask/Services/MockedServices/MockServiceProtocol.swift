//
//  MockServiceProtocol.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 19.02.2025.
//

import Foundation

protocol MockServiceProtocol {
    
    func substituteResposeFile<T: Decodable>(
        named filename: String,
        bundle: Bundle,
        completion: @escaping ResultCompletion<T>
    )
    
}

extension MockServiceProtocol {
    
    func substituteResposeFile<T: Decodable>(
        named filename: String,
        bundle: Bundle,
        completion: @escaping ResultCompletion<T>
    ) {
        DispatchQueue.global(
            qos: .background
        ).asyncAfter(
            deadline: .now() + 1.5
        ) {
            let filetype = "json"
            
            guard let path = bundle.path(
                forResource: filename,
                ofType: filetype
            ) else {
                let error = NSError(
                    domain: "com.your",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Resource not found: \(filename).\(filetype)"]
                )
                completion(.failure(.requestFailed("Error is \(error)")))
                return
            }
            
            guard let data = FileManager.default.contents(
                atPath: path
            ) else {
                let error = NSError(
                    domain: "com.your",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Can not load file at: \(path)"]
                )
                completion(.failure(.requestFailed("Error is \(error)")))
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                
                jsonDecoder.dateDecodingStrategy = .iso8601
                
                let cpResponse = try jsonDecoder.decode(ResponseWrapper<T>.self, from: data)
                guard let respone = cpResponse.data else { return }
                
                DispatchQueue.main.async { completion(.success(respone)) }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed("Error is \(error)")))
                }
            }
        }
    }
}

public extension JSONDecoder.DateDecodingStrategy {
    
    static let customISO8601 = custom { decoder throws -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
    }
    
}
