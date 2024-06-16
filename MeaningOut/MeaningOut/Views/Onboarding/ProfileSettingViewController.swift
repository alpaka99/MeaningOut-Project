//
//  ProfileSettingViewController.swift
//  MeaningOut
//
//  Created by user on 6/15/24.
//

import UIKit

final class ProfileSettingViewController: MOBaseViewController {    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        baseView.configureUI()
    }
}


extension ProfileSettingViewController: ProfileSettingViewDelegate {
    func toProfileSelectionViewController() {
        print(#function)
        let nextViewController = ProfileSelectionViewController(ProfileSelectionView())
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func toNextViewController() {
        print(#function)
        let nextViewController = MainViewController(MainView())
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

