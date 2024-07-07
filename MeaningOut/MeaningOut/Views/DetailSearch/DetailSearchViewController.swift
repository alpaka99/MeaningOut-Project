//
//  SearchDetailViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

final class DetailSearchViewController: MOBaseViewController, CommunicatableBaseViewController {
    
    private var isLiked = false {
        didSet {
            configureNavigationItem()
        }
    }
    
    private var likedItems = RealmRepository.shared.readAll(of: LikedItems.self)
    
    internal struct State: DetailSearchViewControllerState {
        var shoppingItem: ShoppingItem = ShoppingItem.dummyShoppingItem()
        var userData: UserData = UserData.dummyUserData()
    }
    
    internal var state: State = State() {
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
    
    private func configureNavigationItem() {
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
    
    override func configureData() {
        baseView.configureData(state)
    }
    
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
        let data = LikedItems(
            title: state.shoppingItem.title,
            mallName: state.shoppingItem.mallName,
            lprice: state.shoppingItem.lprice,
            image: state.shoppingItem.image,
            link: state.shoppingItem.link,
            productId: state.shoppingItem.productId
        )
        
        if RealmRepository.shared.readLikedItems(data) != nil {
            RealmRepository.shared.create(data)
        }
    }
    
    private func removeFromLikedItems() {
        let data = LikedItems(
            title: state.shoppingItem.title,
            mallName: state.shoppingItem.mallName,
            lprice: state.shoppingItem.lprice,
            image: state.shoppingItem.image,
            link: state.shoppingItem.link,
            productId: state.shoppingItem.productId
        )
        
        
        RealmRepository.shared.delete(data)
    }
}
