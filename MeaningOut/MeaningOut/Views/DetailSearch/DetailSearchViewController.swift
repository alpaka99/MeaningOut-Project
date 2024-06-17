//
//  SearchDetailViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

final class DetailSearchViewController: MOBaseViewController, CommunicatableBaseViewController {
    
    struct State: DetailSearchViewControllerState {
        var title = ""
        var link = ""
    }
    
    var state: State = State() {
        didSet {
            baseView.configureData(state)
        }
    }
    
    
    func fetchShoppingItem(_ shoppingItem: ShoppingItem) {
        state.title = shoppingItem.title
        state.link = shoppingItem.link
        
        configureNavigationItem()
    }
    
    func configureNavigationItem() {
        navigationItem.title = state.title
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
