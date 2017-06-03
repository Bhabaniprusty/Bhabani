//
//  MoviesListInteractorInput.h
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//


#import <Foundation/Foundation.h>

@class Film;

typedef void (^MWCallBack)(NSArray<Film *> *_Nullable);

@protocol MoviesListInteractorInput

- (void)fetchFilmsWithCallback:(MWCallBack _Nullable )callback;

@end
