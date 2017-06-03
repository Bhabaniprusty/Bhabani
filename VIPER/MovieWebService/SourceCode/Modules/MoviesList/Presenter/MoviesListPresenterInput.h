//
//  MoviesListPresenterInput.h
//  MovieWebService
//
//  Created by Bhabani on 13/05/2017.
//  Copyright © 2017 TestCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef MoviesListPresenterInput_h
#define MoviesListPresenterInput_h

@protocol MoviesListPresenterInput

- (void)setupView:(UIView *)view;
- (void)prepareData;

@end



#endif /* MoviesListPresenterInput_h */
