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
    }
    
    var state: State = State(searchResult: NaverShoppingResponse(start: 1, total: 0, items: [])) {
        didSet {
            configureData(state)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func fetchSearchResult(
        _ keyword: String,
        filterOption: FilterOption
    ) {
        
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
        
        let url = APIKey.Naver.shoppingURL
        
        AF.request(
            url,
            parameters: parameters,
            headers: headers
        )
        .responseDecodable(of: NaverShoppingResponse.self) { [weak self] response in
            switch response.result {
            case .success(let value):
                self?.state.searchResult = value
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct NaverShoppingResponse: Codable {
    let start: Int
    let total: Int
    let items: [ShoppingItem]
}

struct ShoppingItem: Codable {
    let title: String
    let image: String
    let mallName: String
    let lprice: String
    let link: String
}
