//
//  LocalDataManager.swift
//  IMDB Clone
//
//  Created by Konstantin Kostadinov on 17.07.21.
//

import Foundation
import RealmSwift

enum LocalDataManagerError: Error {
    case wrongQueue
}

class LocalDataManager {
    // swiftlint:disable all
    static let realm: Realm = {
        return try! initializeRealm(checkForMainThread: true)
    }()

    static func backgroundRealm(queue: DispatchQueue = DispatchQueue.main) -> Realm {
        return try! initializeRealm(checkForMainThread: false, queue: queue)
    }
    // swiftlint:enable all

    class func initializeRealm(checkForMainThread: Bool = false, queue: DispatchQueue = DispatchQueue.main) throws -> Realm {
           if checkForMainThread {
               guard OperationQueue.current?.underlyingQueue == DispatchQueue.main else {
                   throw LocalDataManagerError.wrongQueue
               }
           }
           do {
               return try Realm(configuration: realmConfiguration, queue: queue)
           } catch {
               throw error
           }
       }

    static let realmConfiguration: Realm.Configuration = {
        var configuration = Realm.Configuration.defaultConfiguration

        configuration.schemaVersion = 3
        configuration.migrationBlock = { (migration, version) in

        }

        return configuration
    }()
    
    class func addData<T: Object>(_ data: [T], update: Bool = true, realm: Realm = LocalDataManager.realm) {

        realm.refresh()

        var policy: Realm.UpdatePolicy = .error

        if update {
            policy = .all
        }

        if realm.isInWriteTransaction {
            realm.add(data, update: policy)
        } else {
            try? realm.write {
                realm.add(data, update: policy)
            }
        }
    }
    
    class func addData<T: Object>(_ data: T, update: Bool = true, realm: Realm = LocalDataManager.realm ) {
        addData([data], update: update, realm: realm)
    }

}
