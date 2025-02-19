//
//  CoreDataManagerMock.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 19.02.2025.
//

import Foundation
import Combine
import CoreData

final class CoreDataManagerMock: CoreDataManager {
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Transaction")
        
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetchEntities<T>(ofType type: T.Type) -> AnyPublisher<[T], any Error> where T : NSManagedObject {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchEntities<T>(ofType type: T.Type, limit: Int?, offset: Int?) -> AnyPublisher<[T], any Error> where T : NSManagedObject {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func addEntity<T>(entity: T) -> AnyPublisher<[T], any Error> where T : NSManagedObject {
        return Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    
}
