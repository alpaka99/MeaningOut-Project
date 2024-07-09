//
//  ProfileSettingViewController.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class ProfileSettingViewController: BaseViewController<ProfileSettingView> {
    
    struct State {
        var selectedImage = ProfileImage.randomProfileImage
        var userName = String.emptyString
        var profileSettingViewType = ProfileSettingViewType.onBoarding
    }
    
    private(set) var state = State() {
        didSet {
            configureUI()
        }
    }
    
    
    func configureUI() {
        switch state.profileSettingViewType {
        case .onBoarding:
            navigationItem.title = ProfileSettingViewConstants.onBoardingTitle
        case .setting:
            setRightBarButtonItem()
            navigationItem.title = ProfileSettingViewConstants.settingTitle
        }
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        
        baseView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        
    }
    
    @objc
    func completeButtonTapped() {
        saveUserData(userName: baseView.textField.textField.text ?? "")
        moveToMainView()
    }
    
    private func moveToMainView() {
        if let userData = UserDefaults.standard.loadData(of: UserData.self) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let tabBarController = TabBarController(userData: userData)
            
            
            sceneDelegate?.window?.rootViewController = tabBarController
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
    
    internal func setProfileSettingViewType(_ type: ProfileSettingViewType) {
        self.state.profileSettingViewType = type
    }
    
    internal func setUserData(userName: String, profileImage: ProfileImage) {
        self.state.userName = userName
        self.state.selectedImage = profileImage
    }
    
    internal func setRightBarButtonItem() {
        let rightBarButtonItem = UIBarButtonItem(
            title: ProfileSettingViewConstants.saveButtonTitle,
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc
    private func saveButtonTapped(_ sender: UIBarButtonItem) {
        
    }
}

extension ProfileSettingViewController {
    internal func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .profileImageAction(let detailAction):
            switch detailAction {
            case .profileImageTapped:
                let profileSelectionViewController = ProfileSelectionViewController(
                    baseView: ProfileSelectionView(),
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
    
    private func saveUserData(userName: String) {
        let userData = UserData(
            userName: userName, 
            profileImage: state.selectedImage,
            signUpDate: Date.now,
            likedItems: []
        )
        
        UserDefaults.standard.saveData(userData)
        
        moveToMainView()
    }
    
    private func updateUserData(userName: String) {
        let userData = UserData(
            userName: userName,
            profileImage: state.selectedImage,
            signUpDate: Date.now,
            likedItems: []
        )
        
        UserDefaults.standard.saveData(userData)
    }
    
    private func setSaveButtonEnabledState(_ isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    internal func profileImageSelected(_ image: ProfileImage) {
        self.state.selectedImage = image
    }
}



extension ProfileSettingViewController: ProfileSelectionViewControllerDelegate {
    
}
