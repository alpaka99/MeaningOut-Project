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
        var profileSettingViewType = ProfileSettingViewType.onBoarding
    }
    var state = State() {
        didSet {
            baseView.configureData(state)
            configureUI()
        }
    }
    
    override func configureUI() {
        baseView.delegate = self
        
        switch state.profileSettingViewType {
        case .onBoarding:
            break
        case .setting:
            setRightBarButtonItem()
        }
    }
    
    func setProfileSettingViewType(_ type: ProfileSettingViewType) {
        self.state.profileSettingViewType = type
    }
    
    func setRightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc
    func saveButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
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
        case .profileSettingViewAction(let detailAction):
            moveToMainView()
        default:
            break
        }
    }
    
    func moveToMainView() {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let tabBarController = TabBarController()
        
 
        sceneDelegate?.window?.rootViewController = tabBarController
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}

extension ProfileSettingViewController: ProfileSelectionViewControllerDelegate {
    func profileImageSelected(_ image: ProfileImage) {
        self.state.selectedImage = image
    }
}
