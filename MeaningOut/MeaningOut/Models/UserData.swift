//
//  SettingHeaderViewData.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import Foundation

struct UserData: Codable, BaseViewControllerState {
    var userName: String
    var profileImage: ProfileImage
    var signUpDate: Date
    var likedItems: [ShoppingItem]
}
