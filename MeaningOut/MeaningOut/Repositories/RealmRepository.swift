//
//  RealmRepository.swift
//  MeaningOut
//
//  Created by user on 7/4/24.
//

import RealmSwift

final class RealmRepository {
    static let shared = RealmRepository()
    private let realm = try! Realm() // 이 부분 에러 핸들링 안되나...
    
    internal func createItem<T: Object>(_ data: T) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Realm Create Error")
        }
    }
    
    internal func readAllItem<T: Object>(of: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    
    internal func readItem<T: Object>(_ pk: ObjectId) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: pk)
    }
    
    internal func updateItem<T: Object>(from oldValue: T, to newValue: T) {
        realm.create(T.self, value: newValue, update: .modified)
    }
}
