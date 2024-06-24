//
//  UIViewController+Extension.swift
//  MeaningOut
//
//  Created by user on 6/24/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .alert ,conformButtonTitle: String, conformAction: @escaping () -> ()) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let cancelButton = UIAlertAction(title: SettingViewConstants.cancelButtonTitle, style: .cancel)
        ac.addAction(cancelButton)
        let conformButton = UIAlertAction(title: conformButtonTitle, style: .default) { _ in
            conformAction()
        }
        ac.addAction(conformButton)
        
        present(ac, animated: true)
    }
}
