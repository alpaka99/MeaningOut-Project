//
//  ProfileSelectionViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSelectionViewController: BaseViewController<ProfileSelectionView> {
    struct State {
        var selectedImage = ProfileImage.randomProfileImage
    }
    
    private(set) var state = State() {
        didSet {
//            baseView.configureData(state)
        }
    }
    
    convenience init(baseView: ProfileSelectionView, selectedImage: ProfileImage) {
        self.init(baseView: baseView)
        state.selectedImage = selectedImage
//        configureData(state)
    }
    
    internal weak var delegate: ProfileSelectionViewControllerDelegate?
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView
    }
}


extension ProfileSelectionViewController {
    internal func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .profileSelectionAction(let detailAction):
            switch detailAction {
            case .profileImageCellTapped(let image):
                profileImageCellTapped(image)
            }
        default:
            break
        }
    }
    
    private func profileImageCellTapped(_ image: ProfileImage) {
        // MARK: send selected profile image to ProfileSettingViewController
        delegate?.profileImageSelected(image)
        
    }
}

protocol ProfileSelectionViewControllerDelegate: AnyObject {
    func profileImageSelected(_ image: ProfileImage)
}
