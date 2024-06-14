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
        self.view.backgroundColor = .orange
        
        UIView.animate(
            withDuration: 3,
            delay: 0,
            options: .curveEaseOut
        ) { [weak self] in
            self?.view.alpha = 1
        } completion: { [weak self] _ in
            self?.navigationController?.pushViewController(OnboardingViewController(LogoView()), animated: false)
        }
    }
}
