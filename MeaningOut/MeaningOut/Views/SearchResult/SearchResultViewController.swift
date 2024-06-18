//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by user on 6/16/24.
//

import UIKit

import Alamofire

final class SearchResultViewController: MOBaseViewController, CommunicatableBaseViewController {
    struct State: SearchResultViewControllerState {
        var searchResult: NaverShoppingResponse
        var userData: UserData
        var keyword: String
        var filterOption: SortOptions
    }
    
    var state: State = State(
        searchResult: NaverShoppingResponse.dummyNaverShoppingResponse(),
        userData: UserData.dummyUserData(),
        keyword: String.emptyString,
        filterOption: SortOptions.simularity
    ) {
        didSet {
            configureData(state)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userData = UserDefaults.standard.loadData(of: UserData.self) {
            setStateWithUserData(userData)
        }
    }
    
    func fetchSearchResult(
        _ keyword: String,
        filterOption: SortOptions
    ) {
        state.keyword = keyword
        
        let url = APIKey.Naver.shoppingURL
        
        let parameters: Parameters = [
            ParameterKey.query : keyword,
            ParameterKey.display : PageNationConstants.pageAmount,
            ParameterKey.start : PageNationConstants.start,
            ParameterKey.sort : filterOption.rawValue
        ]
        
        AF.request(
            url,
            parameters: parameters,
            headers: APIKey.Naver.headers
        )
        .responseDecodable(of: NaverShoppingResponse.self) { [weak self] response in
            switch response.result {
            case .success(let value):
                self?.state.searchResult = value
                self?.navigationItem.title = keyword
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setStateWithUserData(_ userData: UserData) {
        self.state.userData = userData
    }
}


extension SearchResultViewController: BaseViewDelegate {
    func baseViewAction(_ type: BaseViewActionType) {
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
                prefetchData()
            case .filterOptionButtonTapped(let filterOption):
                fetchSearchResult(
                    state.keyword,
                    filterOption: filterOption
                )
            }
        default:
            break
        }
    }
    
    func moveToDetailSearchViewController(_ shoppingItem: ShoppingItem) {
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
    
    func syncData() {
        let newUserData = state.userData
        
        if let syncedData = UserDefaults.standard.syncData(newUserData) {
            setStateWithUserData(syncedData)
        }
    }
    
    func prefetchData() {
        if state.searchResult.start + PageNationConstants.pageAmount <= state.searchResult.total {
            let parameters: Parameters = [
                ParameterKey.query : state.keyword,
                ParameterKey.display : PageNationConstants.pageAmount,
                ParameterKey.start : state.searchResult.start + PageNationConstants.pageAmount,
                ParameterKey.sort : state.filterOption.rawValue
            ]
            
            let url = APIKey.Naver.shoppingURL
            
            AF.request(
                url,
                parameters: parameters,
                headers: APIKey.Naver.headers
            ).responseDecodable(of: NaverShoppingResponse.self) { [weak self] response in
                switch response.result {
                case .success(let value):
                    self?.state.searchResult.items.append(contentsOf: value.items)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
