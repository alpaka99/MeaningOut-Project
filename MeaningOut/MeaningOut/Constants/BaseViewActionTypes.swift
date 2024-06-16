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
    case deleteButtonTapped(MOButtonLabelData)
    case eraseAllHistoryButtonTapped
}
