//
//  LaunchScreen.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class LaunchScreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0
        
        UIView.animate(withDuration: 3,  delay: 0, options: .curveEaseOut) { [weak self] in
            self?.view.alpha = 1
        } completion: { [weak self] _ in
            self?.navigationController?.pushViewController(OnboardingViewController(), animated: false)
        }
    }
}
