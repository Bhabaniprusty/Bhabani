//
//  MoviesListAssembly.m
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

#import "MoviesListBuilder.h"

#import "MoviesListViewController.h"
#import "MoviesListInteractor.h"
#import "MoviesListPresenter.h"
#import "MoviesListRouter.h"

@implementation MoviesListBuilder

- (UIViewController *)build {
    
    MoviesListViewController *viewController = [MoviesListViewController new];

    MoviesListRouter *router = [MoviesListRouter new];
    router.view = viewController;

    MoviesListInteractor *interactor = [MoviesListInteractor new];

    MoviesListPresenter *presenter = [MoviesListPresenter new];
    presenter.router = router;
    presenter.interactor = interactor;
    
    viewController.presenter = presenter;
    
    return viewController;

}

@end
