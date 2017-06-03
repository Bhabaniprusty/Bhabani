//
//  DetailsInteractor.swift
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

final class DetailsInteractor: DetailsInteractorInput {

    private let movie: Film
    init(with film: Film) {
        movie = film
    }
    
    var directorName: String {
        return movie.director.name
    }
    
    var castCount: Int {
        return movie.cast.count
    }
    
    func castInfo(withIndex index: Int) -> (name: String, screenName: String) {
        let actor = movie.cast[index]
        
        return (actor.name, actor.screenName)
    }
}
