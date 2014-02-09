//
//  FlickrViewController.m
//  AroundYou
//
//  Created by Rakhesh on 2/8/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "FlickrViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FlickrClient.h"
#import "Photo.h"
#import "UIImageView+AFNetworking.h"

@interface FlickrViewController ()

@property (nonatomic,strong) NSMutableArray* photoList;


@end

@implementation FlickrViewController

CLLocationManager *locationManager;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startStandardUpdates];
    self.photoList = [[NSMutableArray alloc] init];
    
    float latitude = 37.371111 ; // locationManager.location.coordinate.latitude;
    float longitude = -122.0375;   //locationManager.location.coordinate.longitude;
    
    NSLog(@"latitude = %+.6f", latitude);
    NSLog(@"longitude = %+.6f" , longitude);
    
    FlickrClient *flickrClient = [[FlickrClient alloc]init];
    [flickrClient searchPopularPhotosWithLatitude:latitude longitude:longitude success:^(NSURLRequest *request, NSHTTPURLResponse *response, id data) {
        NSLog(@"Success: %@",data);
        NSDictionary* photos = [data valueForKey:@"photos"];
        NSArray* photoArray = [photos valueForKey:@"photo"];
        
        for(NSDictionary* photo in photoArray){
            //add to photo modal.
            [self.photoList addObject:[[Photo alloc]initWithDictionary:photo]];
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id data) {
        NSLog(@"Error : %@", error);
    }];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.photoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrCell";
    UITableViewCell *flickrCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Photo* photo = [self.photoList objectAtIndex:indexPath.row];
    UITextView * description = (UITextView*)[flickrCell viewWithTag:1];
    description.text = [photo.description valueForKey:@"_content"];
    NSURL *imageURL = [NSURL URLWithString:photo.url_s];
    
    UILabel *titleLabel = (UILabel *) [flickrCell viewWithTag:3];
    titleLabel.text = photo.title;
    UIImageView *localtionImage = (UIImageView*)[flickrCell viewWithTag:2];
    [localtionImage setImageWithURL:imageURL];
    
    localtionImage.layer.cornerRadius = 4.0;

    localtionImage.clipsToBounds = YES;
//    NSLog(photo.url_s);
    
    
    
    
    // Configure the cell...
    
    return flickrCell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

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

@end
