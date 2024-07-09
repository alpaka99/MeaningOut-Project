//
//  TabBarController.swift
//  MeaningOut
//
//  Created by user on 6/17/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private var userData: UserData
    
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
        
        let mainViewController = MainViewController(baseView: MainView())
        let mainViewNavigationController = UINavigationController(rootViewController: mainViewController)
        mainViewNavigationController.removeBackBarButtonTitle()
        mainViewNavigationController.tabBarItem.image = UIImage(systemName: TabBarItemProperty.mainView.systemName)
        mainViewNavigationController.tabBarItem.title = TabBarItemProperty.mainView.title
        
        let settingViewController = SettingViewController(baseView: SettingView())
        let settingViewNavigationController = UINavigationController(rootViewController: settingViewController)
        settingViewNavigationController.removeBackBarButtonTitle()
        settingViewController.tabBarItem.image = UIImage(systemName: TabBarItemProperty.settingView.systemName)
        settingViewController.tabBarItem.title = TabBarItemProperty.settingView.title
        
        setViewControllers(
            [mainViewNavigationController, settingViewNavigationController],
            animated: true
        )
        
    }
}
