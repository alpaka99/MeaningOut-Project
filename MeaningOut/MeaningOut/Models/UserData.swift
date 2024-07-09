//
//  SettingHeaderViewData.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import Foundation

internal struct UserData: Codable {
    var userName: String
    var profileImage: ProfileImage
    var signUpDate: Date
    var likedItems: [ShoppingItem]
}

extension UserData {
    static func dummyUserData() -> Self {
        return UserData(
            userName: String.emptyString,
            profileImage: .randomProfileImage,
            signUpDate: Date.now,
            likedItems: []
        )
    }
}
