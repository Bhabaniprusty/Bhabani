//
//  MovieViewModel.swift
//  MovieWebService
//
//  Created by Bhabani on 11/05/2017.
//  Copyright © 2017 TestCompany. All rights reserved.
//

import Foundation

@objc class MovieViewModel: NSObject{
    private let film: Film
    
    init(film: Film) {
        self.film = film
    }
    
    var movieName: String? {
        return film.name
    }
    
    var releaseDate: String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.dateFormat = "MMM dd, YYYY"
        
        return dateFormatter.string(from: film.releaseDate)
    }
    
    
    var ratingCode: String? {
        
        var ratingText: String?
        switch film.filmRating {
        case G:
            ratingText = "G"
        case PG:
            ratingText = "PG"
        case PG13:
            ratingText = "PG13"
        case R:
            ratingText = "R"
        default:
            ratingText = nil
        }
        
        return ratingText
    }
    
    var rating: String {
        return String(film.rating)
    }
}
