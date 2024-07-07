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
    
    internal func create<T: Object>(_ data: T) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Realm Create Error")
            print(error.localizedDescription)
        }
    }
    
    internal func readAll<T: Object>(of: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    
    internal func read<T: Object>(_ data: Object) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: data.objectSchema.primaryKeyProperty)
    }
    
    internal func readLikedItems<T: LikedItems>(_ data: T) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: data.productId)
    }
    
    internal func delete<T: Object>(_ data: T) {
        do {
            try realm.write {
//                realm.delete(data)
                
            }
        } catch {
            print("Realm Delete Error")
            print(error.localizedDescription)
        }
    }
}
