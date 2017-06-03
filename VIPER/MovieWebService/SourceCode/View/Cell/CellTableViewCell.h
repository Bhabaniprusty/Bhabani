//
//  CellTableViewCell.h
//  MovieWebService
//
//  Created by Bhabani on 4/11/17.
//  Copyright © 2017 TestCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *filmRating;
@property (weak, nonatomic) IBOutlet UILabel *rating;

@end
