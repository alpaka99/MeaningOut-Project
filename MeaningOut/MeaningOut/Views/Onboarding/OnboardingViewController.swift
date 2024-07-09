//
//  OnboardingViewController.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class OnboardingViewController: BaseViewController<LogoView> {
    
    
}


extension OnboardingViewController {
    internal func baseViewAction(_ type: BaseViewActionType) {
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
    
    private func moveToProfileSettingView() {
        let profileSettingViewController = ProfileSettingViewController(baseView: ProfileSettingView())
        navigationController?.pushViewController(profileSettingViewController, animated: true)
    }
}
