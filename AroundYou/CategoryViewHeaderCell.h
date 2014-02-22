//
//  CategoryViewHeaderCell.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/21/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewHeaderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* categoryHeaderLabel;
@property (nonatomic, weak) IBOutlet UIImageView* categoryHeaderImage;
@property (nonatomic, weak) IBOutlet UIView* headerView;

@end
