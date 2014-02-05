//
//  PhotosViewController.m
//  AroundYou
//
//  Created by Rakhesh on 2/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "PhotosViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FlickrClient.h"

@interface PhotosViewController ()

@end

@implementation PhotosViewController

CLLocationManager *locationManager;

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
    
    [self startStandardUpdates];
    
    float latitude = 37.371111 ; // locationManager.location.coordinate.latitude;
    float longitude = -122.0375;   //locationManager.location.coordinate.longitude;
    
    NSLog(@"latitude = %+.6f", latitude);
    NSLog(@"longitude = %+.6f" , longitude);
    
    FlickrClient *flickrClient = [[FlickrClient alloc]init];
   [flickrClient searchPopularPhotosWithLatitude:latitude longitude:longitude success:^(NSURLRequest *request, NSHTTPURLResponse *response, id data) {
      NSLog(@"Success: %@",data);
       NSArray* results = [data valueForKey:@"photos"];
       for(NSDictionary* result in results){
          //add to photo modal. 
       }
       
       
   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id data) {
       NSLog(@"Error : %@", error);
   }];
    
    
	// Do any additional setup after loading the view.
}

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
