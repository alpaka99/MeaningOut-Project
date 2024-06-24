//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

final class SettingViewController: MOBaseViewController, CommunicatableBaseViewController {
    internal struct State: SettingViewControllerState {
        var userName = String.emptyString
        var profileImage = ProfileImage.randomProfileImage
        var signUpDate = Date.now
        var likedItems:[ShoppingItem] = []
    }
    
    private(set) var state = State() {
        didSet {
            baseView.configureData(state)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userData = UserDefaults.standard.loadData(of: UserData.self) {
            state.userName = userData.userName
            state.profileImage = userData.profileImage
            state.signUpDate = userData.signUpDate
            state.likedItems = userData.likedItems
            configureUI()
        }
    }
    
    override func configureUI() {
        baseView.delegate = self
        baseView.configureData(state)
        navigationItem.title = SettingViewConstants.navigationTitle
    }
}

extension SettingViewController: BaseViewDelegate {
    func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .settingViewAction(let detailAction):
            switch detailAction {
            case .headerViewTapped:
                headerViewTapped()
            case .likedItemsCellTapped:
                likedItemsCellTapped()
            case .quitCellTapped:
                quitCellTapped()
            }
        default:
            break
        }
    }
    
    private func headerViewTapped() {
        let profileSettingViewController = ProfileSettingViewController(ProfileSettingView())
        
        profileSettingViewController.setUserData(
            userName: state.userName,
            profileImage: state.profileImage
        )
        profileSettingViewController.setProfileSettingViewType(.setting)
        
        navigationController?.pushViewController(
            profileSettingViewController,
            animated: true
        )
    }
    
    private func likedItemsCellTapped() {
        // TODO: Fetch Liked Button Items
        
    }
    
    private func quitCellTapped() {
        showAlert(
            title: SettingViewConstants.alertControllerTitle,
            message: SettingViewConstants.alertControllerMessage,
            conformButtonTitle: SettingViewConstants.conformButtonTitle) { [weak self] in
                UserDefaults.standard.resetData(of: UserData.self)
                self?.moveToLaunchScreen()
            }
    }
    
    private func moveToLaunchScreen() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let launchScreen = LaunchScreenViewController(LogoView(type: .launching))
        
        sceneDelegate?.window?.rootViewController = launchScreen
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
