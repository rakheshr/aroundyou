//
//  ImageScrollViewCell.m
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "ImageScrollViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "GooglePlacesClient.h"

@implementation ImageScrollViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setImagesList : (NSMutableArray*) imageList{
    _imagesList = imageList;
    NSLog(@"Setting images");
    if(self.widthImage == 0){
        self.widthImage = 146;
    }
    self.imageScrollView.contentSize = CGSizeMake([self.imagesList count]*self.widthImage, self.frame.size.height-2);
    //self.imageScrollView.contentInset=UIEdgeInsetsMake(0.0,0.0,5.0,0.0);
    for(int i = 0 ; i < [self.imagesList count] ; i++){
        NSString* url = [GooglePlacesClient getImageURL:[self.imagesList objectAtIndex:i] maxwidth:-1 maxheight:800];
        UIImageView* imgView = [[UIImageView alloc] initWithFrame: CGRectMake(self.widthImage*i, 0, self.widthImage, self.frame.size.height-2)];
        [imgView setImageWithURL: [NSURL URLWithString:url] placeholderImage:[[UIImage alloc] init]];
        [self.imageScrollView addSubview: imgView];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
