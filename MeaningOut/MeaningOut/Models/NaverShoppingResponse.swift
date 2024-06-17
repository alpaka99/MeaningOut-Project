//
//  NaverShoppigResponse.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

struct NaverShoppingResponse: Codable {
    let start: Int
    let total: Int
    let items: [ShoppingItem]
}

struct ShoppingItem: Codable, BaseViewControllerState {
    let title: String
    let image: String
    let mallName: String
    let lprice: String
    let link: String
    let productId: String
}
