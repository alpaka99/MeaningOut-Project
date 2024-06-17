//
//  LaunchScreen.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class LaunchScreenViewController: MOBaseViewController {
    override func configureUI() {
        self.view.alpha = 0
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseOut
        ) { [weak self] in
            self?.view.alpha = 1
        } completion: { _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let onBoardingViewController = OnboardingViewController(LogoView(type: .onBoarding))
            let navigationViewController = UINavigationController(rootViewController: onBoardingViewController)
            navigationViewController.removeBackBarButtonTitle()
            
     
            sceneDelegate?.window?.rootViewController = navigationViewController
            sceneDelegate?.window?.makeKeyAndVisible()
        }
    }
}
