//
//  DetailsReviewCell.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *authoredTime;
@property (weak, nonatomic) IBOutlet UILabel *authoredSubject;
@property (weak, nonatomic) IBOutlet UILabel *authorComment;
@end
