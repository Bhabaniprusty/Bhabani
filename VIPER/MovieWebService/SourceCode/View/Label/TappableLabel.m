//
//  TappableLabel.m
//  MovieWebService
//
//  Created by Bhabani on 4/11/17.
//  Copyright © 2017 TestCompany. All rights reserved.
//

#import "TappableLabel.h"

@implementation TappableLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    BOOL selected = (CGRectContainsPoint(self.bounds, touchPoint));

    if (selected) {
        [self.delegate didReceiveTouch:self];
    }
}

@end
