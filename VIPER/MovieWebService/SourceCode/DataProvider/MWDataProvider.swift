//
//  MWDataProvider.swift
//  MovieWebService
//
//  Created by Bhabani on 11/05/2017.
//  Copyright © 2017 TestCompany. All rights reserved.
//

import Foundation

@objc final class  MWDataProvider: NSObject{
    
    static let sharedInstance = MWDataProvider()
    private override init() {
    }
    
    func getFilms(callback: @escaping (_ films: [Film]?)->Void) -> Void {
        DispatchQueue.global(qos: .utility).async {
            
            
            let data: [String: Any] = ["filmRating" : 3,
                                       "languages" : ["English", "Thai"],
                                       "nominated" : true,
                                       "releaseDate" : 1350000000,
                                       "casts" : [["dateOfBirth" : -436147200,
                                                  "nominated" : true,
                                                  "name" : "Bryan Cranston",
                                                  "screenName" : "Jack Donnell",
                                                  "biography" : "Bryan Lee Cranston is an American actor, voice actor, writer and director."
                                        ]],
                                       "name" : "Argo",
                                       "rating" : 7.8,
                                       "director" : ["dateOfBirth" : 82684800,
                                                     "nominated" :  true,
                                                     "name" : "Ben Affleck",
                                                     "biography" : "Benjamin Geza Affleck was born on August 15, 1972 in Berkeley, California, USA but raised in Cambridge, Massachusetts, USA."]]
            
            
            let film = Film(data: data)
            callback([film])
        }
    }
    
}
