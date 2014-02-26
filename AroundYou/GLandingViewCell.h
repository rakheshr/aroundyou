//
//  GLandingViewCell.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/24/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLandingViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *sideFirstImage;
@property (weak, nonatomic) IBOutlet UIImageView *sideSecondImage;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

@end
