//
//  Film.h
//  MovieWebService
//
//  Created by Bhabani on 4/11/17.
//  Copyright © 2017 TestCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Actor.h"
#import "Director.h"

typedef enum {
    G = 0,
    PG,
    PG13,
    R,
    NC17
} FilmRating;

NS_ASSUME_NONNULL_BEGIN

@interface Film : NSObject

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) FilmRating filmRating;
@property (assign, nonatomic) double rating;
@property (strong, nonatomic) NSDate *releaseDate;
@property (assign, nonatomic) BOOL nominated;
@property (strong, nonatomic) NSArray *languages;
@property (strong, nonatomic) NSArray<Actor*> *cast;
@property (strong, nonatomic) Director *director;

- (id)initWithData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
