//
//  SCNetworkMager.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation
import SwiftyJSON

final class  SCNetworkMager{
    
    struct Static {
        static let networkErrorDomain = "com.sc.error"
        static let shoppingCartUrl = "shoppingcart.getsandbox.com/"
        static let invalidUrl = "Invalid url"
        static let invalidJSON = "error trying to convert data to JSON"
        static let invalidParameters = "Parameters are not available as specified"
        static let kayPathForStorage = "storages"
        static let keyPathForCatalog = ["catalogs"]
    }
    
    static let sharedInstancer = SCNetworkMager()
    fileprivate let session: URLSession
    fileprivate let urlTemplate: URLComponents
    private init() {
        session = URLSession(configuration: URLSessionConfiguration.default)
        var template = URLComponents()
        template.scheme = "http"
        template.host = Static.shoppingCartUrl
        urlTemplate = template
    }
    
    // Login, Signup, session management is not in this scope
    @discardableResult
    func fetchProductCatalogs(updatedAfterDate updatedAfter: Date?,
                              pageIndex: Int,
                              pageSize: Int,
                              completion: @escaping (_ catalogs: [JSON]?, _ error: Error?) -> Void)  -> URLSessionDataTask? {
        
        //Prepare proper url string with provided paramaters
        var template = urlTemplate
        template.path = "/catalogs"
        template.queryItems = [URLQueryItem(name: "start", value: "\(pageIndex*pageSize)"), URLQueryItem(name: "end", value: "\(pageIndex*pageSize + pageSize)")]
        
        guard let url = template.url else {
            let error = SCUtility.prepareError(domain: Static.networkErrorDomain, localisedString: Static.invalidUrl)
            completion(nil, error)
            
            return nil
        }
        
        //Prepare proper URLRequest with provided paramaters
        let urlRequest = URLRequest(url: url)
        
        let task = dataTask(with: urlRequest) {(data, response, error)  in
            if response?.url == url {
                
                guard let dataFromNetworking = data,
                    let catalogs = JSON(data: dataFromNetworking)[Static.keyPathForCatalog].array else {
                    completion(nil, error)
                    return
                }
                
                completion(catalogs, nil)
            }
        }
        
        task.resume()
        
        return task
    }
    
    func fetchProductStorages(updatedAfterDate updatedAfter: Date?,
                              pageIndex: Int,
                              pageSize: Int,
                              completion: @escaping (_ storages: [JSON]?, _ error: Error?) -> Void)  -> URLSessionDataTask? {
        
        //Prepare proper url string with provided paramaters
        var template = urlTemplate
        template.path = "/storages"
        template.queryItems = [URLQueryItem(name: "start", value: "\(pageIndex*pageSize)"), URLQueryItem(name: "end", value: "\(pageIndex*pageSize + pageSize)")]
        
        guard let url = template.url else {
            let error = SCUtility.prepareError(domain: Static.networkErrorDomain, localisedString: Static.invalidUrl)
            completion(nil, error)
            
            return nil
        }

        //Prepare proper URLRequest with provided paramaters
        let urlRequest = URLRequest(url: url)
        
        let task = dataTask(with: urlRequest) {(data, response, error)  in
            if response?.url == url{
                
                guard let dataFromNetworking = data, let storages = JSON(data: dataFromNetworking)[Static.kayPathForStorage].array else {
                    completion(nil, error)
                    return
                }
                
                completion(storages, nil)
            }
        }
        
        task.resume()
        
        return task
    }
    
    private func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask{
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        return session.dataTask(with: request) { (data, response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            completionHandler(data, response, error)
        }
    }
}
