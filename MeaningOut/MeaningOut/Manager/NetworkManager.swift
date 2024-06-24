//
//  NetworkManager.swift
//  MeaningOut
//
//  Created by user on 6/23/24.
//
import Foundation

import Alamofire
import Kingfisher
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    internal func fetchNaverShoppingResponse(_ searchText: String, start: Int = 1, sortOption: String ,completionHandler: @escaping (NaverShoppingResponse) -> ()) {
            let parameters: Parameters = [
                ParameterKey.query : searchText,
                ParameterKey.display : PageNationConstants.pageAmount,
                ParameterKey.start : start,
                ParameterKey.sort : sortOption
            ]
            
            let url = APIKey.Naver.shoppingURL
            
            AF.request(
                url,
                parameters: parameters,
                headers: APIKey.Naver.headers
            ).responseDecodable(of: NaverShoppingResponse.self) { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value)
                case .failure(let error):
                    print(error)
                }
        }
    }
}
