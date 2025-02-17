//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

/// Rate Service should fetch data from https://api.coindesk.com/v1/bpi/currentprice.json
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// The service should be covered by unit tests

import Combine

protocol BitcoinRateService: AnyObject {
    func getBtcCurrency(onCompletion: @escaping ResultCompletion<BTCCurrency>)
}

final class BitcoinRateServiceImpl {
    private var bag = Bag()
    
    private let apiEndpoint: APIEndpoints
    private let networkService: NetworkService

    // MARK: - Init
    
    init(
        apiEndpoint: APIEndpoints,
         networkService: NetworkService
    ) {
        self.apiEndpoint = apiEndpoint
        self.networkService = networkService
    }
}

extension BitcoinRateServiceImpl: BitcoinRateService {
    func getBtcCurrency(onCompletion: @escaping ResultCompletion<BTCCurrency>) {
        let response: AnyPublisher<BTCCurrency, APIError> = networkService.request(apiEndpoint)
        
        response
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("❌ Network error: \(error)")
                    onCompletion(.failure(error))
                }
            } receiveValue: { response in
                onCompletion(.success(response))
            }
            .store(in: &bag)
    }
}
