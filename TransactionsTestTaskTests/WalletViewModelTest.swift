//
//  WalletViewModelTest.swift
//  TransactionsTestTaskTests
//
//  Created by Pavlo Bahan on 19.02.2025.
//

import XCTest
import Combine
import CoreData

final class WalletViewModelTest: XCTestCase {

    private var viewModel: WalletViewModel!
    private var btcCurrencyRateService: BitcoinRateService!
    private var coreDataManager: CoreDataManager!
    private var accountRepo: AccountRepo!
    
    private var bag = Bag()
    
    override func setUp() {
        super.setUp()
        
        btcCurrencyRateService = BitcoinRateServiceMock()
        coreDataManager = CoreDataManagerMock()
        accountRepo = AccountRepo(coreDataManager: coreDataManager)
        
        viewModel = WalletViewModel(btcCurrencyService: btcCurrencyRateService, coreDataManager: coreDataManager, accountRepo: accountRepo)
    }
    
    func testFetchBtcCurrency() {
        let expectation = self.expectation(description: "BTC Currency fetched")
        var responseError: Error?
        var didFulfillExpectation = false
        
        viewModel.output.$btcCurrency
            .sink { currency in
                XCTAssertEqual(currency?.id, "bitcoin")
                XCTAssertNotEqual(currency?.priceUsd, "50000")

                if !didFulfillExpectation {
                    expectation.fulfill()
                    didFulfillExpectation = true
                }
            }
            .store(in: &bag)
        
        /// Make mock request
        btcCurrencyRateService.getBtcCurrency { [weak self] result in
            switch result {
            case .success(let currency):
                self?.viewModel.output.$btcCurrency.send(currency)
            case .failure(let error):
                responseError = error
                if !didFulfillExpectation {
                    expectation.fulfill()
                    didFulfillExpectation = true
                }
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNil(responseError)
    }
}
