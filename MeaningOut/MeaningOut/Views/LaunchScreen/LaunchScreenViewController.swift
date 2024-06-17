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


extension UINavigationController {
    func removeBackBarButtonTitle() {
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor : UIColor.clear]
        backButtonAppearance.normal.backgroundImage?.withTintColor(.black)
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backButtonAppearance = backButtonAppearance
        self.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    func setTintColor(with color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = color
        
        self.navigationBar.standardAppearance = appearance
    }
}
