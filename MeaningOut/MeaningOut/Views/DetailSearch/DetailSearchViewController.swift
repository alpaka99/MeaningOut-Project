//
//  SearchDetailViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

final class DetailSearchViewController: MOBaseViewController, CommunicatableBaseViewController {
    
    struct State: DetailSearchViewControllerState {
        var link = ""
    }
    
    var state: State = State() {
        didSet {
            baseView.configureData(state)
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
    
    func fetchShoppingItem(_ shoppingItem: ShoppingItem) {
        state.link = shoppingItem.link
    }
    
    @objc
    func likeButtonTapped(_ sender: UIBarButtonItem) {
        print("Like Button Tapped")
    }
}
