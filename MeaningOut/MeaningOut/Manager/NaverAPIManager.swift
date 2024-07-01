//
//  NetworkManager.swift
//  MeaningOut
//
//  Created by user on 6/23/24.
//
import Foundation
import UIKit

import Alamofire
import Kingfisher

final class NaverAPIManager {
    static let shared = NaverAPIManager()
    
    private init() { }
    
    internal func fetchNaverShoppingResponse(_ searchText: String, start: Int = 1, sortOption: String ,completionHandler: @escaping (NaverShoppingResponse) -> ()) {
//            let parameters: Parameters = [
//                ParameterKey.query : searchText,
//                ParameterKey.display : PageNationConstants.pageAmount,
//                ParameterKey.start : start,
//                ParameterKey.sort : sortOption
//            ]
            
//            let url = APIKey.Naver.shoppingURL
            
//            AF.request(
//                url,
//                parameters: parameters,
//                headers: APIKey.Naver.headers
//            ).responseDecodable(of: NaverShoppingResponse.self) { response in
//                switch response.result {
//                case .success(let value):
//                    completionHandler(value)
//                case .failure(let error):
//                    print(error)
//                }
//        }
        
        guard let testURL = URLRouter.naverShopping("으앙", 1, .simularity).urlRequest else { return }
        print(testURL.url?.absoluteString)
        URLSession.shared.dataTask(with: testURL) { data, response, error in
            print(data)

            print(response)
            
            print(error)
        }.resume()
        
        
    }
    
    enum URLRouter {
        case naverShopping(String, Int, SortOptions)
        
        var baseURL: String {
            switch self {
            case .naverShopping(_, _, _):
                return APIKey.Naver.shoppingURL
            }
        }
        
        var urlComponents: URLComponents {
            var components = URLComponents()
            components.scheme = "https"
            components.path = self.baseURL
            
            
            switch self {
            case .naverShopping(let searchText, let start, let sortOption):
                components.queryItems = [
                    URLQueryItem(name: "method", value: "get"),
                    URLQueryItem(name: "query", value: searchText),
                    URLQueryItem(name: "start", value: String(start)),
                    URLQueryItem(name: "sort", value: sortOption.rawValue)
                ]
            }
            
            return components
        }
        
//        var headers: HTTPHeaders {
//            switch self {
//            case .naverShopping(_, _, _):
//                return APIKey.Naver.headers
//            }
//        }
        
        var headers: [String:String] {
            switch self {
            case .naverShopping(_, _, _):
                return APIKey.Naver.headers
            }
        }
        
        
        var urlRequest: URLRequest? {
            guard let url = self.urlComponents.url else { return nil }
            var urlRequest = URLRequest(url: url)
            
            urlRequest.allHTTPHeaderFields = self.headers
            
            return urlRequest
        }
    }
}
