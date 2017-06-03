//
//  Actor.h
//  MovieWebService
//
//  Created by Bhabani on 4/11/17.
//  Copyright © 2017 TestCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericRole.h"

@interface Actor : GenericRole

@property (strong, nonatomic) NSString *screenName;

- (id)initWithData:(NSDictionary *)data;

@end
