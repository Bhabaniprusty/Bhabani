//
//  SPNetworkEngine.swift
//  SamsungPOC
//
//  Created by Bhabani on 24/04/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct SPNetworkEngine{

    @discardableResult
    static func loadItems(completionHandler: @escaping ([SPItem]?) -> Void) -> Alamofire.DataRequest {
        
        return Alamofire.request(SPRouter.fetchImage(jsonName: "PDP.js")).responseJSON { (response: DataResponse<Any>) in
            
            guard let value = response.result.value, let images = JSON(value)["images"]["gallery"].array else {
                completionHandler(nil)
                return
            }
            
            let items = images.flatMap({
                 SPItem(json: $0)
            })

            completionHandler(items)
        }
    }
}


