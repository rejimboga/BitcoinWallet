//
//  CoreDataManager.swift
//  TransactionsTestTask
//
//  Created by Pavlo Bahan on 18.02.2025.
//

import Foundation
import CoreData
import Combine

protocol CoreDataManager: AnyObject {
    var context: NSManagedObjectContext { get }
    
    func fetchEntities<T: NSManagedObject>(ofType type: T.Type) -> AnyPublisher<[T], Error>
    func addEntity<T: NSManagedObject>(entity: T) -> AnyPublisher<[T], Error>
}

final class CoreDataManagerImpl {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Transaction")
        
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    private var bag = Bag()

}

// MARK: - CoreDataManager
extension CoreDataManagerImpl: CoreDataManager {
    var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    
    func fetchEntities<T>(ofType type: T.Type) -> AnyPublisher<[T], any Error> where T : NSManagedObject {
        Future { promise in
            let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
            do {
                let result = try self.context.fetch(fetchRequest)
                promise(.success(result))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addEntity<T>(entity: T) -> AnyPublisher<[T], any Error> where T : NSManagedObject {
        Future { promise in
            do {
                self.context.insert(entity)
                try self.context.save()
                
                let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
                let updatedEntities = try self.context.fetch(fetchRequest)
                            
                // Возвращаем обновленные данные
                promise(.success(updatedEntities))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
