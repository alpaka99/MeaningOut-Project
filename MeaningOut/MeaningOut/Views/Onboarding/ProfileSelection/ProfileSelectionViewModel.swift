//
//  ProfileSelectionViewModel.swift
//  MeaningOut
//
//  Created by user on 7/10/24.
//

import Foundation

final class ProfileSelectionViewModel {
    let profileImages = ProfileImage.allCases
    
    var selectedImage = Observable<ProfileImage>(ProfileImage.randomProfileImage)
}
