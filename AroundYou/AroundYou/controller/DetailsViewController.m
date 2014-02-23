//
//  DetailsViewController.m
//  AroundYou
//
//  Created by Rakhesh on 1/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CoreLocation/CoreLocation.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *placeTitle;
@property (weak, nonatomic) IBOutlet UILabel *placeRatings;
@property (weak, nonatomic) IBOutlet UILabel *placeRatingsSymbol;
@property (weak, nonatomic) IBOutlet UILabel *noReviews;
@property (weak, nonatomic) IBOutlet UILabel *priceLevel;
@property (weak, nonatomic) IBOutlet UILabel *distance; //time drive
@property (weak, nonatomic) IBOutlet UIImageView *distanceIcon; //time drive

@end

@implementation DetailsViewController{
    UIView *selectionColor;
    float latitute;
    float longitude;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    latitute=37.368830;//-33.8670522f;
    longitude=-122.036350;//151.1957362f;

    self.placeTitle.text = self.place.name;
    if(self.place.rating){
        self.placeRatings.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat: @"%.1f", self.place.rating]];
        self.placeRatingsSymbol.text = @"*****";
    }
    
    unichar bullet = 0x2022;
    NSString* bulletStr =[NSString stringWithFormat:@"  %@  ",[NSString stringWithCharacters:&bullet  length:1]];
    bool append = false;
    if(self.place.noOfReviews > 0){
        self.noReviews.text = [NSString stringWithFormat:@"%@ reviews",[NSString stringWithFormat: @"%d", self.place.noOfReviews]];
        append= true ;
    }
    
    if(self.place.priceLevel > 0){
        NSString* priceLevel = (self.place.priceLevel == 1)? @"$" : ((self.place.priceLevel ==2)? @"$$": ((self.place.priceLevel ==3)? @"$$$": @"$$$$"));
        self.priceLevel.text = [NSString stringWithFormat:@"%@%@",(append? bulletStr: @""),[NSString stringWithFormat: @"%@", priceLevel]];
    }
    
    CLLocation* second = [[CLLocation alloc] initWithLatitude:latitute longitude:longitude];
    CLLocation* first = [[CLLocation alloc] initWithLatitude:[self.place.lat floatValue] longitude:[self.place.lng floatValue]];
    
    CLLocationDistance distance = [first distanceFromLocation:second];
    float miles = distance*0.00062137;
    float ft = miles*5280;
    if(miles > 0.1){
        self.distance.text = [NSString stringWithFormat:@"%.1f mi",miles];
    }else{
        self.distance.text = [NSString stringWithFormat:@"%d ft",(int)ft];
    }
    
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
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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

@end
