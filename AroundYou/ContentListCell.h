//
//  ContentListCell.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView* placeImage;
@property (nonatomic, weak) IBOutlet UILabel* itemLabel;
@property (nonatomic, weak) IBOutlet UILabel* itemRating;
@property (nonatomic, weak) IBOutlet UILabel* itemCategory;
@property (nonatomic, weak) IBOutlet UILabel* distance;
@property (nonatomic, weak) IBOutlet UILabel* status;

//highlight
@property (nonatomic, weak) IBOutlet UIView* viewForTab;

@end
