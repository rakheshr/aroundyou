//
//  DetailsHeaderViewCell.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsHeaderViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
