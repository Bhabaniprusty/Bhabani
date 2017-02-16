//
//  MGNetworkManager.swift
//  MyntraGame
//
//  Created by Bhabani on 09/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation


class MGNetworkManager{
    
    struct Static {
        static var networkErrorDomain = "com.gj.error"
        static var cardUrl = "https://api.flickr.com/services/feeds/photos_public.gne?tags=gardenning&;tagmode=any&format=json&nojsoncallback=1"
    }
    
    
    static let sharedInstance: MGNetworkManager = MGNetworkManager()
    fileprivate let session: URLSession
    private init() {
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func fetchCards(completion: @escaping (_ cards: [String]?) -> Void)  -> URLSessionDataTask?{
        let allContactsEndpoint = Static.cardUrl
        guard let url = URL(string: allContactsEndpoint) else {
            completion(nil)
            return nil
        }
        
        let urlRequest = URLRequest(url: url)
        let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error)  in
            if response?.url == url{
                if let responseData = data{
                    guard let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject], let items = jsonData?["items"] as? [[String: AnyObject]] else {
                        completion(nil)
                        return
                    }
                    
                    let imageUrls =  items.prefix(MGStatic.numberOfCardtoPlay).flatMap { $0["media"]?["m"] as? String}
                    completion(imageUrls)
                }
            }
        })
        task.resume()
        
        return task
    }
    
}
