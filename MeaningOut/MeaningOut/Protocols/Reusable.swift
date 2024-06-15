//
//  Reusable.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

protocol Reusable {
    
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: Reusable {
    
}
