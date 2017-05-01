//
//  SPRouter.swift
//  SamsungPOC
//
//  Created by Bhabani on 24/04/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Alamofire

enum SPRouter: URLRequestConvertible {
    case fetchImage(jsonName: String)
    
    static let baseURLString = "https://s3.amazonaws.com"
    
    var method: HTTPMethod {
        switch self {
        case .fetchImage:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchImage(let jsonName):
            return "/ecom-temp/iostemp/\(jsonName)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try SPRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        
        return urlRequest
    }
}
