//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

final class SettingViewController: MOBaseViewController, CommunicatableBaseViewController {
    struct State: SettingViewControllerState {
        var settingHeaderViewData = SettingHeaderViewData(
            userName: "",
            signUpDate: Date.now
        )
        var likedItems: [ShoppingItem] = []
    }
    
    var state = State() {
        didSet {
            baseView.configureData(state)
        }
    }
    
    override func configureUI() {
        baseView.delegate = self
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
        //MARK: 현재 profile 데이터 넣어주기
        let profileSettingViewController = ProfileSettingViewController(ProfileSettingView())
        
        navigationController?.pushViewController(profileSettingViewController, animated: true)
    }
    
    func likedItemsCellTapped() {
        // TODO: Fetch Liked Button Items
        print(#function)
    }
    
    func quitCellTapped() {
        // MARK: Erase user data and Move to Launch Screen
    }
}
