//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

final class SettingViewController: BaseViewController<SettingView> {
    internal struct State {
        var userName = String.emptyString
        var profileImage = ProfileImage.randomProfileImage
        var signUpDate = Date.now
        var likedItems:[ShoppingItem] = []
    }
    
    private let settingOptions = SettingOptions.allCases
    
    private(set) var userData = UserData.dummyUserData() {
        didSet {
            baseView.tableView.reloadData()
        }
    }
    
    private(set) var state = State() {
        didSet {
//            baseView.configureData(state)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userData = UserDefaults.standard.loadData(of: UserData.self) {
            state.userName = userData.userName
            state.profileImage = userData.profileImage
            state.signUpDate = userData.signUpDate
            state.likedItems = userData.likedItems
        }
    }
    
    override func configureNavigationItem() {
        navigationItem.title = SettingViewConstants.navigationTitle
    }
    
    override func configureDelegate() {
        baseView.tableView.delegate = self
        baseView.tableView.dataSource = self
        
        baseView.tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: UITableViewCell.identifier
        )
        baseView.tableView.register(
            SettingHeaderCell.self,
            forCellReuseIdentifier: SettingHeaderCell.identifier
        )
        baseView.tableView.register(
            MOTableViewCell.self,
            forCellReuseIdentifier: MOTableViewCell.identifier
        )
    }
    
    private func headerViewTapped() {
        let profileSettingViewController = ProfileSettingViewController(baseView: ProfileSettingView())
    
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
    
            let launchScreen = LaunchScreenViewController(baseView: LogoView(type: .launching))
    
            sceneDelegate?.window?.rootViewController = launchScreen
            sceneDelegate?.window?.makeKeyAndVisible()
        }
}

//extension SettingViewController: BaseViewDelegate {
//    func baseViewAction(_ type: BaseViewActionType) {
//        switch type {
//        case .settingViewAction(let detailAction):
//            switch detailAction {
//            case .headerViewTapped:
//                headerViewTapped()
//            case .likedItemsCellTapped:
//                likedItemsCellTapped()
//            case .quitCellTapped:
//                quitCellTapped()
//            }
//        default:
//            break
//        }
//    }
//    
//    private func headerViewTapped() {
//        let profileSettingViewController = ProfileSettingViewController(ProfileSettingView())
//        
//        profileSettingViewController.setUserData(
//            userName: state.userName,
//            profileImage: state.profileImage
//        )
//        profileSettingViewController.setProfileSettingViewType(.setting)
//        
//        navigationController?.pushViewController(
//            profileSettingViewController,
//            animated: true
//        )
//    }
//    
//    private func likedItemsCellTapped() {
//        // TODO: Fetch Liked Button Items
//        
//    }
//    
//    private func quitCellTapped() {
//        showAlert(
//            title: SettingViewConstants.alertControllerTitle,
//            message: SettingViewConstants.alertControllerMessage,
//            conformButtonTitle: SettingViewConstants.conformButtonTitle) { [weak self] in
//                UserDefaults.standard.resetData(of: UserData.self)
//                self?.moveToLaunchScreen()
//            }
//    }
//    
//    private func moveToLaunchScreen() {
//        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//        
//        let sceneDelegate = windowScene?.delegate as? SceneDelegate
//        
//        let launchScreen = LaunchScreenViewController(LogoView(type: .launching))
//        
//        sceneDelegate?.window?.rootViewController = launchScreen
//        sceneDelegate?.window?.makeKeyAndVisible()
//    }
//}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return SettingViewConstants.numberOfSection
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return SettingViewConstants.numberOfHeaderCell
        } else {
            return settingOptions.count
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let  cell = tableView.dequeueReusableCell(
                withIdentifier: SettingHeaderCell.identifier,
                for: indexPath
            ) as? SettingHeaderCell else { return UITableViewCell() }
            
            cell.configureData(userData)
            
            return cell
        } else {
            guard let  cell = tableView.dequeueReusableCell(
                withIdentifier: MOTableViewCell.identifier,
                for: indexPath
            ) as? MOTableViewCell else { return UITableViewCell() }
            
            let settingOption = settingOptions[indexPath.row]
            
            switch settingOption {
            case .qna, .notification, .oneOnOneQuestion:
                cell.isUserInteractionEnabled = false
            default:
                break
            }
                
            let moCellData = MOButtonLabelData(
                leadingIconName: nil,
                leadingText: settingOption.leadingTitle,
                trailingButtonName: settingOption.trailingImageName,
                trailingButtonType: .assetImage,
                trailingText: settingOption.getTrailingText(userData.likedItems.count)
            )
            cell.configureData(moCellData)
            
            return cell
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return SettingViewConstants.settingCellHeight
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let section = indexPath.section

        if section == 0 {
            headerViewTapped()
        } else {
            let row = indexPath.row
            switch settingOptions[row] {
            case .liked:
                likedItemsCellTapped()
            case .quit:
                quitCellTapped()
            default:
                break
            }
        }
    }
}
