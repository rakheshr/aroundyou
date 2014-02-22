//
//  CategoryViewHeaderCell.m
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/21/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "CategoryViewHeaderCell.h"

//@interface CategoryViewHeaderCell()

//@property (nonatomic, weak) IBOutlet UILabel* categoryHeaderLabel;
//@property (nonatomic, weak) IBOutlet UIImageView* categoryHeaderImage;


//@end

@implementation CategoryViewHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
