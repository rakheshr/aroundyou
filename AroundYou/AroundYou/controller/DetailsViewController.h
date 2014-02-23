//
//  DetailsViewController.h
//  AroundYou
//
//  Created by Rakhesh on 1/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface DetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Place* place;

@end
