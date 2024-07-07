//
//  LikedItems.swift
//  MeaningOut
//
//  Created by user on 7/4/24.
//
import Foundation

import RealmSwift

final class LikedItems: Object {
    @Persisted var title: String
    @Persisted var mallName: String
    @Persisted var lprice: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted(primaryKey: true) var productId: String
    @Persisted var createdAt: Date = Date.now
    //    @Persisted var image: Data -> id로 bundle에서 찾아 쓰기
    
    convenience init(title: String, mallName: String, lprice: String, image: String ,link: String, productId: String) {
        self.init()
        
        self.title = title
        self.mallName = mallName
        self.lprice = lprice
        self.image = image
        self.link = link
        self.productId = productId
    }
}
