//
//  MoviesListInteractor.m
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

#import "MoviesListInteractor.h"
#import "MovieWebService-Swift.h"   // will be add into common header


@implementation MoviesListInteractor

- (void)fetchFilmsWithCallback:(MWCallBack) callback{
    // Can have configuration or conditional usages, for demo let it as is
    [self fetchFilmsForProvider:[MWDataProvider sharedInstance] WithCallback:callback];
}

- (void)fetchFilmsForProvider:(MWDataProvider *)provider WithCallback:(MWCallBack) callback{
    [provider getFilmsWithCallback:callback];
}

@end
