//
//  SCNetworkMager.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation
import SwiftyJSON

class SCNetworkMager{
    
    struct Static {
        static let networkErrorDomain = "com.sc.error"
        static let shoppingCartUrl = "<storageUrl>"
        static let invalidUrl = "Invalid url"
        static let invalidJSON = "error trying to convert data to JSON"
        static let invalidParameters = "Parameters are not available as specified"
        static let kayPathForStorage = "storages"
        static let keyPathForCatalog = ["catalogs"]
    }
    
    static let sharedInstancer = SCNetworkMager()
    fileprivate let session: URLSession
    private init() {
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    // Login, Signup, session management is not in this scope
    func fetchProductCatalogs(updatedAfterDate updatedAfter: Date?,
                              pageIndex: Int,
                              pageSize: Int,
                              completion: @escaping (_ catalogs: [JSON]?, _ error: Error?) -> Void)  -> URLSessionDataTask? {
        
        //Prepare proper url string with provided paramaters
        let allContactsEndpoint = Static.shoppingCartUrl + "<Additional path to catalog fetch>"
        guard let url = URL(string: allContactsEndpoint) else {
            let error = SCUtility.prepareError(domain: Static.networkErrorDomain, localisedString: Static.invalidUrl)
            completion(nil, error)
            
            return nil
        }
        
        //Prepare proper URLRequest with provided paramaters
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error)  in
            if response?.url == url{
                
                guard let dataFromNetworking = data,
                    let catalogs = JSON(data: dataFromNetworking)[Static.keyPathForCatalog].array else {
                    completion(nil, error)
                    return
                }
                
                completion(catalogs, nil)
            }
        })
        
        task.resume()
        
        return task
    }
    
    func fetchProductStorages(updatedAfterDate updatedAfter: Date?,
                              pageIndex: Int,
                              pageSize: Int,
                              completion: @escaping (_ storages: [JSON]?, _ error: Error?) -> Void)  -> URLSessionDataTask? {
        
        //Prepare proper url string with provided paramaters
        let allContactsEndpoint = Static.shoppingCartUrl + "<Additional path to product storagefetch>"
        guard let url = URL(string: allContactsEndpoint) else {
            let error = SCUtility.prepareError(domain: Static.networkErrorDomain, localisedString: Static.invalidUrl)
            completion(nil, error)
            
            return nil
        }
        
        //Prepare proper URLRequest with provided paramaters
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest,
                                    completionHandler: {(data, response, error)  in
            if response?.url == url{
                
                guard let dataFromNetworking = data, let storages = JSON(data: dataFromNetworking)[Static.kayPathForStorage].array else{
                    completion(nil, error)
                    return
                }
                
                completion(storages, nil)
            }
        })
        
        task.resume()
        
        return task
    }
}
