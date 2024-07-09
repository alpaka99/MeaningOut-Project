//
//  ProfileSettingViewController.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class ProfileSettingViewController: BaseViewController<ProfileSettingView> {
    
    let viewModel = ProfileSettingViewModel()
    
    override func bindData() {
        super.bindData()
        
        viewModel.inputProfileSettingViewType.bind { [weak self] value in
            switch value {
            case .onBoarding:
                self?.navigationItem.title = ProfileSettingViewConstants.onBoardingTitle
            case .setting:
                self?.setRightBarButtonItem()
                self?.navigationItem.title = ProfileSettingViewConstants.settingTitle
            }
        }
        
        viewModel.inputSelectedImage.actionBind { [weak self] value in
            self?.baseView.profileImage.setImage(value)
        }
        
        viewModel.inputProfileImageTapped.bind { [weak self] _ in
            guard let selectedImage = self?.viewModel.inputSelectedImage.value else { return }
            let profileSelectionViewController = ProfileSelectionViewController(
                baseView: ProfileSelectionView(),
                selectedImage: selectedImage
            )
            profileSelectionViewController.delegate = self
            
            self?.navigationController?.pushViewController(
                profileSelectionViewController,
                animated: true
            )
        }
        
        viewModel.inputCompleteButtonTapped.bind { [weak self] _ in
            if let validatedUserName = self?.viewModel.inputUserName.value {
                self?.saveUserData(userName: validatedUserName)
                self?.moveToMainView()
            }
        }
        
        viewModel.outputValidated.bind { [weak self] value in
            self?.baseView.completeButton.isEnabled = value
            self?.baseView.completeButton.setBackgroundColor(with: value ? MOColors.moOrange.color : MOColors.moGray200.color)
        }
        
        viewModel.outputCheckLabelText.bind { [weak self] value in
            self?.baseView.textField.checkLabel.text = value
        }
    }
    
    override func configureNavigationItem() {
        navigationItem.title = ProfileSettingViewConstants.onBoardingTitle
    }
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(profileImageTapped)
        )
        tapGestureRecognizer.cancelsTouchesInView = false
        baseView.profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        baseView.textField.textField.addTarget(
            self,
            action: #selector(inputChanged),
            for: .editingChanged
        )
        baseView.textField.textField.addTarget(
            self,
            action: #selector(inputChanged),
            for: .editingDidBegin
        )
    }
    
    @objc
    private func profileImageTapped() {
        viewModel.inputProfileImageTapped.value = ()
    }
    
    @objc
    func completeButtonTapped() {
        viewModel.inputCompleteButtonTapped.value = ()
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
    
    @objc
    private func inputChanged(_ sender: UITextField) {
        viewModel.inputUserName.value = sender.text
    }
    
//    @discardableResult
//    private func validateNickname(_ nickName: String?) -> String {
//        do {
//            let validatedNickname = try nickName.validateNickname()
//            
////            return nicknameValidated(validatedNickname)
//        } catch StringValidationError.isNil, StringValidationError.isEmpty, StringValidationError.isShort, StringValidationError.isLong {
//            baseView.textField.checkLabel.text = StringValidationConstants.lengthError
//        } catch StringValidationError.isUsingNumeric {
//            baseView.textField.checkLabel.text = StringValidationConstants.containsNumericError
//        } catch StringValidationError.isUsingSpecialLetter {
//            baseView.textField.checkLabel.text = StringValidationConstants.containsSpecialLetterError
//        } catch {
//            print(StringValidationConstants.unHandledError)
//        }
//        return String.emptyString
//    }
    
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
    private func saveUserData(userName: String) {
        let userData = UserData(
            userName: userName, 
            profileImage: viewModel.inputSelectedImage.value,
            signUpDate: Date.now,
            likedItems: []
        )
        
        UserDefaults.standard.saveData(userData)
    }
    
    private func updateUserData(userName: String) {
        let userData = UserData(
            userName: userName,
            profileImage: viewModel.inputSelectedImage.value,
            signUpDate: Date.now,
            likedItems: []
        )
        
        UserDefaults.standard.saveData(userData)
    }
    
    private func setSaveButtonEnabledState(_ isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
}



extension ProfileSettingViewController: ProfileSelectionViewControllerDelegate {
    internal func profileImageSelected(_ image: ProfileImage) {
        self.viewModel.inputSelectedImage.value = image
    }
}
