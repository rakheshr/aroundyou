//
//  ImageScrollViewCell.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

@property (nonatomic, strong) NSMutableArray* imagesList;

@property (nonatomic) int widthImage;

@end
