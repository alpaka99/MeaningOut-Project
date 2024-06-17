//
//  SearchDetailViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

final class DetailSearchViewController: MOBaseViewController, CommunicatableBaseViewController {
    
    var isLiked = false {
        didSet {
            configureNavigationItem()
        }
    }
    
    struct State: DetailSearchViewControllerState {
        var shoppingItem: ShoppingItem = ShoppingItem(
            title: "",
            image: "",
            mallName: "",
            lprice: "",
            link: "",
            productId: ""
        )
        var userData: UserData = UserData(
            userName: "",
            profileImage: .randomProfileImage,
            signUpDate: Date.now,
            likedItems: []
        )
    }
    
    var state: State = State() {
        didSet {
            baseView.configureData(state)
        }
    }
    
    convenience required init(
        _ baseView: any BaseViewBuildable,
        shoppingItem: ShoppingItem,
        userData: UserData
    ) {
        self.init(baseView)
        state.shoppingItem = shoppingItem
        state.userData = userData
        configureData()
        checkItemIsLiked()
        configureNavigationItem()
    }
    
    func configureNavigationItem() {
        navigationItem.title = state.shoppingItem.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: isLiked ? "like_selected" : "like_unselected")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(likeButtonTapped)
        )
    }
    
    override func configureData() {
        baseView.configureData(state)
    }
    
    func checkItemIsLiked() {
        if state.userData.likedItems.contains(where: {$0.productId == state.shoppingItem.productId}) {
            isLiked = true
        } else {
            isLiked = false
        }
    }
    
    @objc
    func likeButtonTapped(_ sender: UIBarButtonItem) {
        isLiked.toggle()
        
        if isLiked {
            addToLikedItems()
        } else {
            removeFromLikedItems()
        }
        
        if let syncedData = UserDefaults.standard.syncData(state.userData) {
            print(syncedData.likedItems.count)
            state.userData = syncedData
        }
    }
    
    func addToLikedItems() {
        if state.userData.likedItems.contains(where: {$0.productId == state.shoppingItem.productId}) == false {
            state.userData.likedItems.append(state.shoppingItem)
        }
    }
    
    func removeFromLikedItems() {
        for i in 0..<state.userData.likedItems.count {
            let likedItem = state.userData.likedItems[i]
            if likedItem.productId == state.shoppingItem.productId {
                state.userData.likedItems.remove(at: i)
                return
            }
        }
    }
}
