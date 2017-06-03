//
//  TappableLabel.h
//  MovieWebService
//
//  Created by Bhabani on 4/11/17.
//  Copyright © 2017 TestCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TappableLabelDelegate;

@interface TappableLabel : UILabel

@property (nonatomic, weak) id<TappableLabelDelegate> delegate;

@end

@protocol TappableLabelDelegate

@optional

- (void)didReceiveTouch:(TappableLabel *)label;

@end
