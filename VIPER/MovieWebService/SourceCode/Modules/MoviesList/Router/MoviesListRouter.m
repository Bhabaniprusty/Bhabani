//
//  MoviesListRouter.m
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

#import "MoviesListRouter.h"
#import "MovieWebService-Swift.h"
#import "Film.h"

@implementation MoviesListRouter

#pragma mark - MoviesListRouterInput

- (void)showDetailWithFilm:(Film *)film{
    
    DetailsModuleBuilder *builder = [DetailsModuleBuilder new];
    [self.view.navigationController pushViewController:[builder buildWith:film] animated:YES];
}

@end
