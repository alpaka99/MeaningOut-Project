//
//  NaverShoppigResponse.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

internal struct NaverShoppingResponse: Codable {
    var start: Int
    let total: Int
    var items: [ShoppingItem]
}

extension NaverShoppingResponse {
    static func dummyNaverShoppingResponse() -> Self {
        return NaverShoppingResponse(
            start: 1,
            total: 0,
            items: []
        ) 
    }
}

struct ShoppingItem: Codable, BaseViewControllerState {
    let title: String
    let image: String
    let mallName: String
    let lprice: String
    let link: String
    let productId: String
}

extension ShoppingItem {
    static func dummyShoppingItem() -> Self {
        return ShoppingItem(
            title: String.emptyString,
            image: String.emptyString,
            mallName: String.emptyString,
            lprice: String.emptyString,
            link: String.emptyString,
            productId: String.emptyString
        )
    }
}
