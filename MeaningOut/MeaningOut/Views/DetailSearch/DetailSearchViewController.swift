//
//  SearchDetailViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

final class DetailSearchViewController: BaseViewController<DetailSearchView> {
    
    private var isLiked = false {
        didSet {
            configureNavigationItem()
        }
    }
    
    internal struct State {
        var shoppingItem: ShoppingItem = ShoppingItem.dummyShoppingItem()
        var userData: UserData = UserData.dummyUserData()
    }
    
    internal var state: State = State() {
        didSet {
//            baseView.configureData(state)
        }
    }
    
    convenience init(
        baseView: DetailSearchView,
        shoppingItem: ShoppingItem,
        userData: UserData
    ) {
        self.init(baseView: baseView)
        state.shoppingItem = shoppingItem
        state.userData = userData
//        configureData()
        checkItemIsLiked()
        configureNavigationItem()
    }
    
    override internal func configureNavigationItem() {
        navigationItem.title = state.shoppingItem.title.replacingOccurrences(
            of: ReplaceStringConstants.boldHTMLOpenTag,
            with: String.emptyString
        ).replacingOccurrences(
            of: ReplaceStringConstants.boldHTMLCloseTag,
            with: String.emptyString
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: isLiked ? ImageName.selectedLikeButtonImage : ImageName.unSelecteLikeButtonImage)?
                .withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(likeButtonTapped)
        )
    }
    
//    override func configureData() {
//        baseView.configureData(state)
//    }
    
    private func checkItemIsLiked() {
        if state.userData.likedItems.contains(where: {$0.productId == state.shoppingItem.productId}) {
            isLiked = true
        } else {
            isLiked = false
        }
    }
    
    @objc
    private func likeButtonTapped(_ sender: UIBarButtonItem) {
        isLiked.toggle()
        
        if isLiked {
            addToLikedItems()
        } else {
            removeFromLikedItems()
        }
        
        if let syncedData = UserDefaults.standard.syncData(state.userData) {
            state.userData = syncedData
        }
    }
    
    private func addToLikedItems() {
        if state.userData.likedItems.contains(where: {$0.productId == state.shoppingItem.productId}) == false {
            state.userData.likedItems.append(state.shoppingItem)
        }
    }
    
    private func removeFromLikedItems() {
        for i in 0..<state.userData.likedItems.count {
            let likedItem = state.userData.likedItems[i]
            if likedItem.productId == state.shoppingItem.productId {
                state.userData.likedItems.remove(at: i)
                return
            }
        }
    }
}
