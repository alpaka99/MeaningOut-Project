//
//  TabBarController.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    var userData: UserData
    
    init(userData: UserData) {
        self.userData = userData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = MOColors.moOrange.color
        
        let mainViewController = MainViewController(MainView())
        let mainViewNavigationController = UINavigationController(rootViewController: mainViewController)
        mainViewNavigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        mainViewNavigationController.tabBarItem.title = "검색"
        
        
        let settingViewController = SettingViewController(SettingView())
        let settingViewNavigationController = UINavigationController(rootViewController: settingViewController)
        settingViewController.tabBarItem.image = UIImage(systemName: "person")
        settingViewController.tabBarItem.title = "설정"
        
        
        setViewControllers(
            [mainViewNavigationController, settingViewNavigationController],
            animated: true
        )
        
    }
}
