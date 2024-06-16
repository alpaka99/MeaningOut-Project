//
//  SearchDetailViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

final class DetailSearchViewController: MOBaseViewController {
    
    func configureData(_ data: ShoppingItem) {
        self.navigationItem.title = data.title
        
        if let baseView = baseView as? DetailSearchView {
            baseView.configureData(data)
        }
    }
    
    override func configureUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "cart"),
            style: .plain,
            target: self,
            action: #selector(likeButtonTapped)
        )
    }
    
    @objc
    func likeButtonTapped(_ sender: UIBarButtonItem) {
        print("Like Button Tapped")
    }
}
