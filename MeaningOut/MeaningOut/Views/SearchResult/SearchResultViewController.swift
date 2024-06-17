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
        var userName: String
        var profileImage: ProfileImage
        var signUpDate: Date
        var likedItems: [ShoppingItem]
    }
    
    var state: State = State(
        searchResult: NaverShoppingResponse(
            start: 1,
            total: 0,
            items: []
        ),
        userName: "",
        profileImage: ProfileImage.randomProfileImage,
        signUpDate: Date.now,
        likedItems: []
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
        filterOption: FilterOption
    ) {
        let url = APIKey.Naver.shoppingURL
        
        let parameters: Parameters = [
            "query" : keyword,
            "display" : 30,
            "start" : 1,
            "sort" : filterOption.rawValue
        ]
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.Naver.clientID,
            "X-Naver-Client-Secret" : APIKey.Naver.ClientSecret
        ]
        
        AF.request(
            url,
            parameters: parameters,
            headers: headers
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
        self.state.userName = userData.userName
        self.state.profileImage = userData.profileImage
        self.state.signUpDate = userData.signUpDate
        self.state.likedItems = userData.likedItems
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
                likeShoppingItem(shoppingItem)
            case .cancelLikeShoppingItem(let shoppingItem):
                cancelLikeShoppingItem(shoppingItem)
            }
        default:
            break
        }
    }
    
    func moveToDetailSearchViewController(_ shoppingItem: ShoppingItem) {
        let detailSearchViewController = DetailSearchViewController(DetailSearchView())
        detailSearchViewController.fetchShoppingItem(shoppingItem)
        
        navigationController?.pushViewController(detailSearchViewController, animated: true)
    }
    
    private func likeShoppingItem(_ shoppingItem: ShoppingItem) {
        if state.likedItems.contains(where: { $0.productId == shoppingItem.productId }) == false {
            state.likedItems.append(shoppingItem)
            syncData()
        }
    }
    
    private func cancelLikeShoppingItem(_ shoppingItem: ShoppingItem) {
        for i in 0..<state.likedItems.count {
            let likedItem = state.likedItems[i]
            if likedItem.productId == shoppingItem.productId {
                state.likedItems.remove(at: i)
                syncData()
                return
            }
        }
    }
    
    func syncData() {
        print(#function)
        let newUserData = UserData(
            userName: state.userName,
            profileImage: state.profileImage,
            signUpDate: state.signUpDate,
            likedItems: state.likedItems
        )
        
        if let syncedData = UserDefaults.standard.syncData(newUserData) {
            setStateWithUserData(syncedData)
        }
    }
}
