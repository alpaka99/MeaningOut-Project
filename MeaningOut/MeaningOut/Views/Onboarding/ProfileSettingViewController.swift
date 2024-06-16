//
//  ProfileSettingViewController.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class ProfileSettingViewController: MOBaseViewController {
    
    var selectedImage: ProfileImage = ProfileImage.randomProfileImage
    
    override func configureUI() {
        baseView.delegate = self
        if let baseView = baseView as? ProfileSettingView {
            baseView.setImage(selectedImage)
        }
    }
}

extension ProfileSettingViewController: BaseViewDelegate {
    func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .profileImageAction(let detailAction):
            switch detailAction {
            case .profileImageTapped:
                let profileSelectionViewController = ProfileSelectionViewController(ProfileSelectionView(selectedImage: selectedImage))
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
        self.selectedImage = image
        if let baseView = baseView as? ProfileSettingView {
            baseView.setImage(image)
        }
    }
}
