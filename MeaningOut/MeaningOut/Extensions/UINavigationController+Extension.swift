//
//  UINavigationController+Extension.swift
//  MeaningOut
//
//  Created by user on 6/18/24.
//

import UIKit

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
