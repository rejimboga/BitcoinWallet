//
//  BitcoinRateServiceTest.swift
//  TransactionsTestTaskTests
//
//  Created by Pavlo Bahan on 19.02.2025.
//

import XCTest

final class BitcoinRateServiceTest: XCTestCase {

    private let service = BitcoinRateServiceMock()
    
    func testGetBtcCurrency() {
        let promise = expectation(description: "Completion handler invoked")
        var responseError: Error?
        
        service.getBtcCurrency { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                responseError = error
            }
            
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 10) /// Should be started alone
        
        XCTAssertNil(responseError)
    }

}
