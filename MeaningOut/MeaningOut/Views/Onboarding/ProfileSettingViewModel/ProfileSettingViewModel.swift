//
//  ProfileSettingViewModel.swift
//  MeaningOut
//
//  Created by user on 7/9/24.
//

import Foundation

final class ProfileSettingViewModel {
//    var selectedImage = ProfileImage.randomProfileImage
//    var userName = String.emptyString
//    var profileSettingViewType = ProfileSettingViewType.onBoarding
    var selectedImage = Observable(ProfileImage.randomProfileImage)
    var userName: Observable<String?> = Observable("")
    var profileSettingViewType = Observable(ProfileSettingViewType.onBoarding)
}
