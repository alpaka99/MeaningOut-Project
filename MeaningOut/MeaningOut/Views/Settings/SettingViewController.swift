//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

final class SettingViewController: MOBaseViewController, CommunicatableBaseViewController {
    struct State: SettingViewControllerState {
        var userName = ""
        var profileImage = ProfileImage.randomProfileImage
        var signUpDate = Date.now
        var likedItems:[ShoppingItem] = []
    }
    
    var state = State() {
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
    
    func headerViewTapped() {
        let profileSettingViewController = ProfileSettingViewController(ProfileSettingView())
        
        profileSettingViewController.setUserData(
            userName: state.userName,
            profileImage: state.profileImage
        )
        profileSettingViewController.setProfileSettingViewType(.setting)
        
        navigationController?.pushViewController(profileSettingViewController, animated: true)
    }
    
    func likedItemsCellTapped() {
        // TODO: Fetch Liked Button Items
        print(#function)
    }
    
    func quitCellTapped() {
        let ac = UIAlertController(title: "데이터 초기화", message: "정말 모든 데이터를 초기화하실건가요?", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        let conformButton = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            UserDefaults.standard.resetData(of: UserData.self)
            
            self?.moveToLaunchScreen()
        }
        ac.addAction(cancelButton)
        ac.addAction(conformButton)
        
        present(ac, animated: true)
    }
    
    func moveToLaunchScreen() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let launchScreen = LaunchScreenViewController(LogoView(type: .launching))
        
        
        sceneDelegate?.window?.rootViewController = launchScreen
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
