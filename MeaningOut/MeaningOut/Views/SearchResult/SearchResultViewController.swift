//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import Alamofire

final class SearchResultViewController: MOBaseViewController, CommunicatableBaseViewController {
    internal struct State: SearchResultViewControllerState {
        var searchResult: NaverShoppingResponse
        var userData: UserData
        var keyword: String
        var sortOption: SortOptions
    }
    
    internal var state: State = State(
        searchResult: NaverShoppingResponse.dummyNaverShoppingResponse(),
        userData: UserData.dummyUserData(),
        keyword: String.emptyString,
        sortOption: SortOptions.simularity
    ) {
        didSet {
            configureData(state)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchData(_:)),
            name: Notification.Name("NaverAPIComplete"),
            object: nil
        )
    }
    
    @objc
    func fetchData(_ notification: NSNotification) {
        guard let data = notification.object as? Data, let decodedData = try? JSONHelper.jsonDecoder.decode(NaverShoppingResponse.self, from: data) else {
            print("decoding failed")
            return
        }
        
        DispatchQueue.main.async {[weak self] in
//            self?.state.searchResult = decodedData
            self?.state.searchResult.items.append(contentsOf: decodedData.items)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userData = UserDefaults.standard.loadData(of: UserData.self) {
            setStateWithUserData(userData)
        }
    }
    
    internal func fetchSearchResult(
        _ searchText: String,
        sortOptions: SortOptions
    ) {
        state.keyword = searchText
        NaverAPIManager.shared.fetchNaverShoppingResponse(
            .naverShopping(searchText, 1, sortOptions),
            as: NaverShoppingResponse.self
        ) { [weak self] naverShoppingResponse in
            print(#function)
            self?.state.searchResult = naverShoppingResponse
            self?.navigationItem.title = searchText
        }
    }
    
    private func prefetchSearchResult() {
        let nextPage = state.searchResult.start + PageNationConstants.pageAmount
        if nextPage <= state.searchResult.total {
            print(#function, nextPage)
            NaverAPIManager.shared.fetchNaverShoppingResponse(
                .naverShopping(state.keyword, nextPage, state.sortOption),
                as: NaverShoppingResponse.self
            ) { [weak self] naverShoppingResponse in
                if (self?.state.searchResult.start ?? 1) + PageNationConstants.pageAmount <= naverShoppingResponse.start {
                        self?.state.searchResult.items.append(contentsOf: naverShoppingResponse.items)
                        self?.state.searchResult.start = naverShoppingResponse.start
                    }
            }
        }
    }
    
    private func setStateWithUserData(_ userData: UserData) {
        self.state.userData = userData
    }
}


extension SearchResultViewController: BaseViewDelegate {
    internal func baseViewAction(_ type: BaseViewActionType) {
        switch type {
        case .searchResultViewAction(let detailAction):
            switch detailAction {
            case .resultCellTapped(let shoppingItem):
                moveToDetailSearchViewController(shoppingItem)
            case .likeShoppingItem(let shoppingItem):
                addToLikedItems(shoppingItem)
            case .cancelLikeShoppingItem(let shoppingItem):
                removeFromLikedItems(shoppingItem)
            case .prefetchItems:
                prefetchSearchResult()
            case .filterOptionButtonTapped(let sortOption):
                fetchSearchResult(
                    state.keyword,
                    sortOptions: sortOption
                )
            }
        default:
            break
        }
    }
    
    private func moveToDetailSearchViewController(_ shoppingItem: ShoppingItem) {
        let detailSearchViewController = DetailSearchViewController(
            DetailSearchView(),
            shoppingItem: shoppingItem,
            userData: state.userData
        )
        
        navigationController?.pushViewController(detailSearchViewController, animated: true)
    }
    
    private func addToLikedItems(_ shoppingItem: ShoppingItem) {
        if state.userData.likedItems.contains(where: { $0.productId == shoppingItem.productId }) == false {
            state.userData.likedItems.append(shoppingItem)
            syncData()
        }
    }
    
    private func removeFromLikedItems(_ shoppingItem: ShoppingItem) {
        for i in 0..<state.userData.likedItems.count {
            let likedItem = state.userData.likedItems[i]
            if likedItem.productId == shoppingItem.productId {
                state.userData.likedItems.remove(at: i)
                syncData()
                return
            }
        }
    }
    
    private func syncData() {
        let newUserData = state.userData
        
        if let syncedData = UserDefaults.standard.syncData(newUserData) {
            setStateWithUserData(syncedData)
        }
    }
}
