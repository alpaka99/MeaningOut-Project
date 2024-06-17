//
//  BaseViewStates.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//
import Foundation

protocol MainViewControllerState: BaseViewControllerState {
    var searchHistory: [String] { get set }
    var userData: UserData { get set }
}


protocol SearchResultViewControllerState: BaseViewControllerState {
    var searchResult: NaverShoppingResponse { get set }
}

protocol MOButtonLabelState: BaseViewControllerState {
    var leadingIconName: String? { get set }
    var leadingText: String? { get set }
    var trailingButtonName: String? { get set }
    var trailingText: String? { get set }
}


protocol DetailSearchViewControllerState: BaseViewControllerState {
    var link: String { get set }
}


protocol SettingViewControllerState: BaseViewControllerState {
    var userName: String { get set }
    var profileImage: ProfileImage { get set }
    var signUpDate: Date { get set }
    var likedItems: [ShoppingItem] { get set }
}

protocol ProfileSettingViewControllerState: BaseViewControllerState {
    var selectedImage: ProfileImage { get set }
    var userName: String { get set }
    var profileSettingViewType: ProfileSettingViewType { get set }
}
