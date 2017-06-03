//
//  GenericRole.h
//  MovieWebService
//
//  Created by Bhabani on 4/11/17.
//  Copyright © 2017 TestCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Film;

@interface GenericRole : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *biography;
@property (strong, nonatomic) NSDate *dateOfBirth;
@property (assign, nonatomic) BOOL nominated;

@property (weak, nonatomic) Film *film;

- (id)initWithData:(NSDictionary *)data;

@end
