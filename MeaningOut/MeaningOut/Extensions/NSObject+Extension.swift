//
//  NSObject+Extension.swift
//  MeaningOut
//
//  Created by user on 6/24/24.
//

import Foundation

extension NSObject {
    func getTypeName() -> String {
        return String(describing: type(of: self))
    }
}
