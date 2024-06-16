//
//  CodeBaseBuildable.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//
import UIKit

protocol BaseViewBuildable: UIView {
    var delegate: BaseViewDelegate? { get set }
    func configureHierarchy()
    func configureLayout()
    func configureUI()   
}

protocol BaseViewDelegate: AnyObject {
    func baseViewAction(_ type: BaseViewActionType)
}



enum BaseViewActionType {
    case logoViewAction(LogoViewAction)
    case profileImageAction(ProfileImageAction)
    case profileSelectionAction(ProfileSelectionAction)
}


enum LogoViewAction {
    case startButtonTapped
}

enum ProfileImageAction {
    case profileImageTapped
}

enum ProfileSelectionAction {
    case profileImageCellTapped(ProfileImage)
}
