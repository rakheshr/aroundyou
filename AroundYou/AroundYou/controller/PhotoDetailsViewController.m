//
//  PhotoDetailsViewController.m
//  AroundYou
//
//  Created by Rakhesh on 2/9/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "Photo.h"
#import "UIImageView+AFNetworking.h"


@interface PhotoDetailsViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;


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
    self.title =self.flickPhoto.title;
    NSLog(@" photo %@", self.flickPhoto.url_s);
    NSLog(@" photo %@", self.flickPhoto.url_m);
    NSURL *imageURL = [NSURL URLWithString:self.flickPhoto.url_m];
    [self.photoView setImageWithURL:imageURL];
    self.photoLabel.text = [self.flickPhoto.description valueForKey:@"_content"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
