//
//  Film.m
//  MovieWebService
//
//  Created by Bhabani on 4/11/17.
//  Copyright © 2017 TestCompany. All rights reserved.
//

#import "Film.h"
#import "Actor.h"
#import "Director.h"

@implementation Film

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        
        self.name = [data objectForKey:@"name"];
        self.filmRating = [[data objectForKey:@"filmRating"] doubleValue];
        self.languages = [data objectForKey:@"languages"];
        self.nominated = [[data objectForKey:@"nominated"] boolValue];
        self.releaseDate = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"releaseDate"] doubleValue]];
        self.rating = [[data objectForKey:@"rating"] doubleValue];
        self.director = [[Director alloc] initWithData:[data objectForKey:@"director"]];
        self.director.film = self;
        NSArray *castsData = [data objectForKey:@"casts"];
        NSMutableArray *castsList = [NSMutableArray arrayWithCapacity:castsData.count];
        for (NSDictionary *castData in castsData) {
            Actor *actor = [[Actor alloc] initWithData:castData];
            actor.film = self;
            [castsList addObject:actor];
        }
        
        self.cast = castsList;
    }
    
    return self;
}

@end
