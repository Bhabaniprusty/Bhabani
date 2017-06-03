//
//  MoviesListViewController.h
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoviesListPresenterInput;

@interface MoviesListViewController : UIViewController

@property (strong, nonatomic) id<MoviesListPresenterInput> presenter;

@end
