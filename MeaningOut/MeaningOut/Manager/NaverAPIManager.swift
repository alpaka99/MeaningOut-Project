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

final class NaverAPIManager: NSObject {
    static let shared = NaverAPIManager()
    private var total: Double = 0
    private var buffer: Data?
    private var session = URLSession()
    
    private override init() {
        super.init()
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    }
    
    internal func fetchNaverShoppingResponse<T: Decodable>(
        _ router: URLRouter,
        as: T.Type,
        completionHandler: @escaping (T) -> ()
    ) {
        
        guard let url = router.urlRequest else { return }
        
//        URLSession.shared.dataTask(with: url)
        session
            .dataTask(with: url)
            .resume()
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let response = response as? HTTPURLResponse else {
//                print("Cannot convert response to HTTPURLResponse")
//                return
//            }
//            
//            guard error == nil else {
//                print("Error while fetching Network job")
//                return
//            }
//            
//            guard (200...299).contains(response.statusCode) else {
//                print("Status code not success")
//                return
//            }
//            
//            if let data = data,
//               let decodedData = try? JSONHelper.jsonDecoder.decode(T.self, from: data) {
//                DispatchQueue.main.async {
//                    completionHandler(decodedData)
//                }
//            } else {
//                print("Decoding Fail")
//            }
//        }.resume()
        
        
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

extension NaverAPIManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        guard let response = response as? HTTPURLResponse else {
            print("Response Convertion Failed")
            return .cancel
        }
        
        guard (200...299).contains(response.statusCode) else {
            print("Response Status not Success")
            return .cancel
        }
        
        guard let contentLength = response.allHeaderFields["Content-Length"] else {
            print("No Content-Length")
            return .cancel
        }
        
        total = 0
        buffer = Data()
        
        return .allow
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer?.append(data)
        NotificationCenter.default.post(
            name: Notification.Name("NaverAPIComplete"),
            object: buffer
        )
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if let error = error {
            print(error)
        }
    }
}
