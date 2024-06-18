//
//  ProfileSettingViewController.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class ProfileSettingViewController: MOBaseViewController, CommunicatableBaseViewController {
    
    struct State: ProfileSettingViewControllerState {
        var selectedImage = ProfileImage.randomProfileImage
        var userName = String.emptyString
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
        
        baseView.configureData(state)
        switch state.profileSettingViewType {
        case .onBoarding:
            navigationItem.title = ProfileSettingViewConstants.onBoardingTitle
        case .setting:
            setRightBarButtonItem()
            navigationItem.title = ProfileSettingViewConstants.settingTitle
        }
    }
    
    func setProfileSettingViewType(_ type: ProfileSettingViewType) {
        self.state.profileSettingViewType = type
    }
    
    func setUserData(userName: String, profileImage: ProfileImage) {
        self.state.userName = userName
        self.state.selectedImage = profileImage
    }
    
    func setRightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(
            title: ProfileSettingViewConstants.saveButtonTitle,
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc
    func saveButtonTapped(_ sender: UIBarButtonItem) {
        baseView.triggerAction()
    }
}

extension ProfileSettingViewController: BaseViewDelegate {
    func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .profileImageAction(let detailAction):
            switch detailAction {
            case .profileImageTapped:
                let profileSelectionViewController = ProfileSelectionViewController(
                    ProfileSelectionView(),
                    selectedImage: state.selectedImage
                )
                profileSelectionViewController.delegate = self
                navigationController?.pushViewController(
                    profileSelectionViewController,
                    animated: true
                )
            }
        case .profileSettingViewAction(let detailAction):
            switch detailAction {
            case .completeButtonTapped(let userName):
                saveUserData(userName: userName)
            case .saveButtonTapped(let userName):
                updateUserData(userName: userName)
            case .textFieldTextChanged(let isEnabled):
                setSaveButtonEnabledState(isEnabled)
            }
        default:
            break
        }
    }
    
    func saveUserData(userName: String) {
        let userData = UserData(
            userName: userName, 
            profileImage: state.selectedImage,
            signUpDate: Date.now,
            likedItems: []
        )
        
        UserDefaults.standard.saveData(userData)
        
        moveToMainView()
    }
    
    func updateUserData(userName: String) {
        let userData = UserData(
            userName: userName,
            profileImage: state.selectedImage,
            signUpDate: Date.now,
            likedItems: []
        )
        
        UserDefaults.standard.saveData(userData)
    }
    
    func moveToMainView() {
        if let userData = UserDefaults.standard.loadData(of: UserData.self) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let tabBarController = TabBarController(userData: userData)
            
            
            sceneDelegate?.window?.rootViewController = tabBarController
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
    
    func setSaveButtonEnabledState(_ isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
}

extension ProfileSettingViewController: ProfileSelectionViewControllerDelegate {
    func profileImageSelected(_ image: ProfileImage) {
        self.state.selectedImage = image
    }
}
