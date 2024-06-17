//
//  UserDefaults+Extension.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

extension UserDefaults {
    func saveData<T: Codable>(_ data: T) {
        if let encodedData = try? JSONHelper.jsonEncoder.encode(data) {
            UserDefaults.standard.setValue(encodedData, forKey: String(describing: T.self))
        }
    }
    
    func loadData<T: Codable>(of: T.Type) -> T? {
        if let loadedData = UserDefaults.standard.data(forKey: String(describing: T.self)) {
            if let decodedData = try? JSONHelper.jsonDecoder.decode(T.self, from: loadedData) {
                return decodedData
            }
        }
        return nil
    }
    
    func resetData<T: Codable>(of: T.Type) {
        UserDefaults.standard.setValue(nil, forKey: String(describing: T.self))
    }
    
    // UserDefault는 ThreadSafe하다
    func syncData<T: Codable>(_ data: T) -> T? {
        self.saveData(data)
        let data = self.loadData(of: T.self)
        return data
    }
}
