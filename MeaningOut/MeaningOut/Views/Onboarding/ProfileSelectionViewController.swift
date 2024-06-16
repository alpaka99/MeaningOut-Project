//
//  ProfileSelectionViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSelectionViewController: MOBaseViewController {
    weak var delegate: ProfileSelectionViewControllerDelegate?
    
    override func configureUI() {
        baseView.delegate = self
    }
}


extension ProfileSelectionViewController: BaseViewDelegate {
    func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .profileSelectionAction(let detailAction):
            switch detailAction {
            case .profileImageCellTapped(let imageName):
                profileImageCellTapped(imageName)
            }
        default:
            break
        }
    }
    
    func profileImageCellTapped(_ imageName: String) {
        // MARK: send selected profile image to ProfileSettingViewController
        print(#function, imageName)
        delegate?.profileImageSelected(imageName)
        
    }
}

protocol ProfileSelectionViewControllerDelegate: AnyObject {
    func profileImageSelected(_ imageName: String)
}
