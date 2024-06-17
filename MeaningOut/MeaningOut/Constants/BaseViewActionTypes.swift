//
//  BaseViewActionType.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import Foundation

enum BaseViewActionType {
    case logoViewAction(LogoViewAction)
    case profileImageAction(ProfileImageAction)
    case profileSelectionAction(ProfileSelectionViewAction)
    case mainViewAction(MainViewAction)
    case moButtonLabelAction(MOButtonLabelAction)
    case searchResultViewAction(SearchResultViewAction)
    case searchCollectionViewCellAction(SearchCollectionViewCellAction)
    case settingViewAction(SettingViewAction)
    case profileSettingViewAction(ProfileSettingViewAction)
}


enum LogoViewAction {
    case startButtonTapped
}

enum ProfileImageAction {
    case profileImageTapped
}

enum ProfileSelectionViewAction {
    case profileImageCellTapped(ProfileImage)
}

enum MainViewAction {
    case searchKeyword(String)
    case eraseAllHistoryButtonTapped
    case deleteButtonTapped(MOButtonLabelData)
}

enum MOButtonLabelAction {
    case trailingButtonTapped(MOButtonLabelData)
    case eraseAllHistoryButtonTapped
}

enum SearchResultViewAction {
    case resultCellTapped(ShoppingItem)
    case likeShoppingItem(ShoppingItem)
    case cancelLikeShoppingItem(ShoppingItem)
    case prefetchItems
}

enum SearchCollectionViewCellAction {
    case likeShoppingItem(ShoppingItem)
    case cancelLikeShoppingItem(ShoppingItem)
}

enum SettingViewAction {
    case headerViewTapped
    case likedItemsCellTapped
    case quitCellTapped
}

enum ProfileSettingViewAction {
    case completeButtonTapped(String)
    case saveButtonTapped(String)
}
