//
//  OnboardingViewController.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class OnboardingViewController: MOBaseViewController {
    
    override func configureUI() {
        baseView.delegate = self
    }
}


extension OnboardingViewController: BaseViewDelegate {
    func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .logoViewAction(let action):
            switch action {
            case .startButtonTapped:
                moveToProfileSettingView()
            }
        default:
            break
        }
    }
    
    func moveToProfileSettingView() {
        let profileSettingViewController = ProfileSettingViewController(ProfileSettingView())
        navigationController?.pushViewController(profileSettingViewController, animated: true)
    }
}
