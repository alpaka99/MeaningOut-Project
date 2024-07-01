//
//  RemoteImageManager.swift
//  MeaningOut
//
//  Created by user on 6/24/24.
//
import UIKit

import Alamofire
import Kingfisher
final class MOImageManager {
    static let shared = MOImageManager()
    var totalImageCache: [String : [String : UIImage]] = [:]
    
    private init() { }
    
    
    internal func fetchImage(objectName: String, urlString: String, completionHandler: @escaping (UIImage) -> ()) throws {
        if let designatedCache = totalImageCache[objectName] {
            if let cachedImage = designatedCache[urlString] {
                completionHandler(cachedImage)
                return
            }
        }
        
        guard let url = URL(string: urlString) else { throw NetworkError.urlNotGenerated }
                
        AF.request(url)
            .response {[weak self] response in
                switch response.result {
                case .success(let value):
                    if let unwrappedValue = value,
                       let image = UIImage(data: unwrappedValue) {
                        self?.cacheImage(objectName: objectName, urlString: urlString, image: image)
                        completionHandler(image)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    private func cacheImage(objectName: String, urlString: String, image: UIImage) {
        if var designatedCache = totalImageCache[objectName] {
            designatedCache[urlString] = image
            totalImageCache[objectName] = designatedCache
        } else {
            let newImageCache: [String:UIImage] = [urlString:image]
            totalImageCache.updateValue(newImageCache, forKey: objectName)
        }
    }
    
    internal func removeCachedImage(objectName: String) {
        self.totalImageCache.removeValue(forKey: objectName)
    }
    
    // MARK: Schedule Remove Cached Image
//    private func scheduleRemoveCachedObejct(objectName: String, urlString: String, time: Double) {
//        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + time) { [weak self] in
//
//            if let designatedDict = self?.totalImageCache[objectName] {
//                print(designatedDict.keys)
//                self?.totalImageCache[objectName]?.removeValue(forKey: urlString)
//            }
//        }
//    }
}
