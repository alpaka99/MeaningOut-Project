//
//  ProfileSettingViewController.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class ProfileSettingViewController: MOBaseViewController, CommunicatableBaseViewController {
    
    struct State: ProfileSettingViewControllerState {
        var selectedImage: ProfileImage = ProfileImage.randomProfileImage
    }
    var state = State() {
        didSet {
            baseView.configureData(state)
        }
    }
    
    override func configureUI() {
        baseView.delegate = self
    }
}

extension ProfileSettingViewController: BaseViewDelegate {
    func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .profileImageAction(let detailAction):
            switch detailAction {
            case .profileImageTapped:
                let profileSelectionViewController = ProfileSelectionViewController(ProfileSelectionView(selectedImage: state.selectedImage))
                profileSelectionViewController.delegate = self
                navigationController?.pushViewController(profileSelectionViewController, animated: true)
            }
        default:
            break
        }
    }
}

extension ProfileSettingViewController: ProfileSelectionViewControllerDelegate {
    func profileImageSelected(_ image: ProfileImage) {
        self.state.selectedImage = image
    }
}
