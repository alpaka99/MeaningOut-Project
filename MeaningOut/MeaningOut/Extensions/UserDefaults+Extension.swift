//
//  UserDefaults+Extension.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

extension UserDefaults {
    func saveData<T: Codable>(_ data: T) {
        print(#function)
        if let encodedData = try? JSONHelper.jsonEncoder.encode(data) {
            UserDefaults.standard.setValue(encodedData, forKey: String(describing: T.self))
        }
    }
    
    func loadData<T: Codable>(of: T.Type) -> T? {
        print(#function)
        if let loadedData = UserDefaults.standard.data(forKey: String(describing: T.self)) {
            if let decodedData = try? JSONHelper.jsonDecoder.decode(T.self, from: loadedData) {
                print(decodedData)
                return decodedData
            }
        }
        return nil
    }
    
    func resetData<T: Codable>(of: T.Type) {
        UserDefaults.standard.setValue(nil, forKey: String(describing: T.self))
    }
}
