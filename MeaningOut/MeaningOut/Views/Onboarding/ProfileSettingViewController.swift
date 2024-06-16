//
//  ProfileSettingViewController.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class ProfileSettingViewController: MOBaseViewController {    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        baseView.configureUI()
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
                let profileSelectionViewController = ProfileSelectionViewController(ProfileSelectionView())
                profileSelectionViewController.delegate = self
                navigationController?.pushViewController(profileSelectionViewController, animated: true)
            }
        default:
            break
        }
    }
}

extension ProfileSettingViewController: ProfileSelectionViewControllerDelegate {
    func profileImageSelected(_ imageName: String) {
        print(#function)
        if let baseView = baseView as? ProfileSettingView {
            baseView.setImage(imageName)
        }
    }
}
