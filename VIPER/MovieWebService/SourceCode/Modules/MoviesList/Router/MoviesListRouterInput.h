//
//  MoviesListRouterInput.h
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

@class Film;

@protocol MoviesListRouterInput

- (void)showDetailWithFilm:(Film *)film;

@end
