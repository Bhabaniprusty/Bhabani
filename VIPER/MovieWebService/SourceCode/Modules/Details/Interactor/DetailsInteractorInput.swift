//
//  DetailsInteractorInput.swift
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

protocol DetailsInteractorInput {
    
    var directorName: String { get }
    var castCount: Int { get }
    func castInfo(withIndex index: Int) -> (name: String, screenName: String)
}
