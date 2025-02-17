//
//  NetworkService.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 17.02.2025.
//

import Foundation
import Combine

typealias Result<T> = Swift.Result<T, APIError>
typealias ResultCompletion<T> = (Result<T>) -> Void

protocol NetworkService: AnyObject {
    func request<T: Decodable>(_ endpoint: APIEndpoints) -> AnyPublisher<T, APIError>
}

final class NetworkServiceImpl {
    private let baseURL: String
    
    init(baseURL: String = "") {
        self.baseURL = APIEnvironment.prod.baseURL
    }
}

extension NetworkServiceImpl: NetworkService {
    func request<T>(_ endpoint: APIEndpoints) -> AnyPublisher<T, APIError> where T : Decodable {
        guard let url = URL(string: baseURL + endpoint.path) else {
            return Fail(error: APIError.invalidUrl).eraseToAnyPublisher()
        }
        
        let urlRequest = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                if let httpResponse = response as? HTTPURLResponse,
                   (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    throw APIError.requestFailed("Request failed with status code: \(statusCode)")
                }
            }
            .decode(type: ResponseWrapper<T>.self, decoder: JSONDecoder())
            .tryMap { (responseWrapper) -> T in
                guard let data = responseWrapper.data else {
                    throw APIError.requestFailed("Missing data.")
                }
                return data
            }
            .mapError { error -> APIError in
                if error is DecodingError {
                    return APIError.decodingFailed
                } else if let apiError = error as? APIError {
                    return apiError
                } else {
                    return APIError.unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
