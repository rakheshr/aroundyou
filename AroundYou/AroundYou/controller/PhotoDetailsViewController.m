//
//  PhotoDetailsViewController.m
//  AroundYou
//
//  Created by Rakhesh on 2/9/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "Photo.h"

@interface PhotoDetailsViewController ()




@end

@implementation PhotoDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@" photo %@", self.flickPhoto.title);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
