//
//  ProfileSelectionViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import SnapKit

final class ProfileSelectionViewController: MOBaseViewController, CommunicatableBaseViewController {
    struct State: ProfileSelectionViewControllerState {
        var selectedImage = ProfileImage.randomProfileImage
    }
    
    private(set) var state = State() {
        didSet {
            baseView.configureData(state)
        }
    }
    
    convenience init(_ baseView: BaseViewBuildable, selectedImage: ProfileImage) {
        self.init(baseView)
        state.selectedImage = selectedImage
        configureUI()
        configureData(state)
    }
    
    internal weak var delegate: ProfileSelectionViewControllerDelegate?
    
    override func configureUI() {
        baseView.delegate = self
    }
}


extension ProfileSelectionViewController: BaseViewDelegate {
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
