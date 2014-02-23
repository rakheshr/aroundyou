//
//  ContentListViewController.h
//  AroundYou
//
//  Created by Rakhesh on 1/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray* places;

@end
