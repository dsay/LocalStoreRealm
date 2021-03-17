import RealmSwift
import SwiftRepository
import Foundation

private extension UpdatePolicy {

    func toReal() -> Realm.UpdatePolicy {
        Realm.UpdatePolicy(rawValue: rawValue) ?? .all
    }
}

open class LocalStoreRealm<Item: Object>: LocalStoreDataBase {

    public let context: Realm

    public init(_ context: Realm) {
        self.context = context
    }

    public func getItem(response: @escaping (Result<Item, RepositoryError>) -> Void) {
        if let item: Item = context.objects(Item.self).first {
            response(.success(item))
        } else {
            response(.failure(.notFound))
        }
    }

    public func getItems(response: @escaping (Result<[Item], RepositoryError>) -> Void) {
        let items: [Item] = context.objects(Item.self).compactMap { $0 }
        if items.isEmpty == false {
            response(.success(items))
        } else {
            response(.failure(.notFound))
        }
    }

    public func get(with id: Int, response: @escaping (Result<Item, RepositoryError>) -> Void) {
        let predicate = NSPredicate(format: "%K = %d", Item.primaryKey() ?? "", id)
        if let item: Item = context.objects(Item.self).filter(predicate).first {
            response(.success(item))
        } else {
            response(.failure(.notFound))
        }
    }

    public func get(with id: String, response: @escaping (Result<Item, RepositoryError>) -> Void) {
        let predicate = NSPredicate(format: "%K = %@", Item.primaryKey() ?? "", id)
        if let item: Item = context.objects(Item.self).filter(predicate).first {
            response(.success(item))
        } else {
            response(.failure(.notFound))
        }
    }
    
    public func get(with predicate: NSPredicate, response: @escaping (Result<[Item], RepositoryError>) -> Void) {
        let items: [Item] = context.objects(Item.self).filter(predicate).compactMap { $0 }
        if items.isEmpty == false {
            response(.success(items))
        } else {
            response(.failure(.notFound))
        }
    }

   public func update(_ write: @escaping () -> Void, response: @escaping (Result<Void, RepositoryError>) -> Void) {
        do {
            try context.write {
                write()
                response(.success(()))
            }
        } catch {
            response(.failure(.notUpdate))
        }
    }

    public func save(_ item: Item, policy: UpdatePolicy = .all, response: @escaping (Result<Void, RepositoryError>) -> Void) {
        do {
            try context.write {
                context.add(item, update: policy.toReal())
                response(.success(()))
            }
        } catch {
            response(.failure(.notSave))
        }
    }

    public func save(_ items: [Item], policy: UpdatePolicy = .all, response: @escaping (Result<Void, RepositoryError>) -> Void) {
        do {
            try context.write {
                context.add(items, update: policy.toReal())
                response(.success(()))
            }
        } catch {
            response(.failure(.notSave))
        }
    }

    public func remove(_ item: Item, response: @escaping (Result<Void, RepositoryError>) -> Void) {
        do {
            try context.write {
                context.delete(item)
                response(.success(()))
            }
        } catch {
            response(.failure(.notDelete))
        }
    }

    public func remove(_ items: [Item], response: @escaping (Result<Void, RepositoryError>) -> Void) {
        do {
            try context.write {
                context.delete(items)
                response(.success(()))
            }
        } catch {
            response(.failure(.notDelete))
        }
    }
}
