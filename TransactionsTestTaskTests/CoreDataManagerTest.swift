//
//  CoreDataManagerTest.swift
//  TransactionsTestTaskTests
//
//  Created by Pavlo Bahan on 19.02.2025.
//

import XCTest
import CoreData

final class CoreDataManagerTest: XCTestCase {

    private let coreDataManager = CoreDataManagerMock()
    private var bag = Bag()

    func testFetchEntities() {
        let expectation = self.expectation(description: "Fetch entities")
        
        coreDataManager.fetchEntities(ofType: NSManagedObject.self)
            .sink(receiveCompletion: { _ in }, receiveValue: { entities in
                XCTAssertEqual(entities.count, 0)
                expectation.fulfill()
            })
            .store(in: &bag)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddEntity() {
        let expectation = self.expectation(description: "Fetch entities")
        let transaction = Transaction(context: coreDataManager.persistentContainer.viewContext)
        
        coreDataManager.addEntity(entity: transaction)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { entity in
                    XCTAssertEqual(entity.count, 0)
                    expectation.fulfill()
                }
            )
            .store(in: &bag)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
