//
//  MoviesListRouter.h
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoviesListRouterInput.h"

@interface MoviesListRouter : NSObject <MoviesListRouterInput>

@property (weak, nonatomic) UIViewController *view;

@end
