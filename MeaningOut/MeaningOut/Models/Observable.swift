//
//  Observable.swift
//  MeaningOut
//
//  Created by user on 7/9/24.
//

import Foundation

final class Observable<T> {
    var closure: ((T)->Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T)->Void) {
        self.closure = closure
    }
}
