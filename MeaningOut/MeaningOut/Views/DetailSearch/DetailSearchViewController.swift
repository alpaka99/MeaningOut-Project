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
    
    private var likedItems = RealmRepository.shared.readAll(of: LikedItems.self)
    
    internal struct State {
        var shoppingItem: ShoppingItem = ShoppingItem.dummyShoppingItem()
        var userData: UserData = UserData.dummyUserData()
    }
    
    internal var state: State = State()
    
    convenience init(
        baseView: DetailSearchView,
        shoppingItem: ShoppingItem
    ) {
        self.init(baseView: baseView)
        state.shoppingItem = shoppingItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureData(state.shoppingItem)
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
    
    private func checkItemIsLiked() {
        if likedItems.contains(where: {$0.productId == state.shoppingItem.productId}) {
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
    }
    
    
    
    private func addToLikedItems() {
        let item = state.shoppingItem
        let data = LikedItems(
            title: item.title,
            mallName: item.mallName,
            lprice: item.lprice,
            image: item.image,
            link: item.link,
            productId: item.productId
        )
        
        if RealmRepository.shared.readLikedItems(data) != nil {
            removeFromLikedItems()
        } else {
            RealmRepository.shared.create(data)
        }
    }
    
    private func removeFromLikedItems() {
        let item = state.shoppingItem
        
        let data = LikedItems(
            title: item.title,
            mallName: item.mallName,
            lprice: item.lprice,
            image: item.image,
            link: item.link,
            productId: item.productId
        )
        if let target = RealmRepository.shared.readLikedItems(data) {
            RealmRepository.shared.delete(target)
        }
    }
    
    internal func configureData(_ data: ShoppingItem) {
        if let url = URL(string: data.link),
           let request = try? URLRequest(url: url, method: .get) {
            baseView.webView.load(request)
        }
    }
}
