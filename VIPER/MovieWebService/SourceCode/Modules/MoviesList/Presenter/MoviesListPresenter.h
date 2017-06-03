//
//  MoviesListPresenter.h
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//


#import "MoviesListPresenterInput.h"

@protocol MoviesListInteractorInput;
@protocol MoviesListRouterInput;


@interface MoviesListPresenter : NSObject <MoviesListPresenterInput>

@property (strong, nonatomic) id<MoviesListInteractorInput> interactor;
@property (strong, nonatomic) id<MoviesListRouterInput> router;

@end
