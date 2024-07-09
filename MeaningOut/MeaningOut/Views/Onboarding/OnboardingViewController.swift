//
//  OnboardingViewController.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class OnboardingViewController: BaseViewController<LogoView> {
    
    override func configureDelegate() {
        super.configureDelegate()
        
        baseView.startButton.addTarget(
            self,
            action: #selector(startButtonTapped),
            for: .touchUpInside
        )
    }
    
    @objc
    private func startButtonTapped() {
        print(#function)
        let profileSettingViewController = ProfileSettingViewController(baseView: ProfileSettingView())
        navigationController?.pushViewController(profileSettingViewController, animated: true)
    }
}
