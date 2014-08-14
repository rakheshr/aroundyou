//
//  ContentListViewController.m
//  AroundYou
//
//  Created by Rakhesh on 1/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#define CONTENT_LIST_IMAGE_HEIGHT 2000

#import "ContentListViewController.h"
#import "ContentListCell.h"
#import "Place.h"
#import "UIImageView+AFNetworking.h"
#import "CoreLocation/CoreLocation.h"
#import "GooglePlacesClient.h"
#import "DetailsViewController.h"

@interface ContentListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int noOfRequests;
@property (nonatomic,strong) NSMutableArray* placesDetails;

@end

@implementation ContentListViewController{
    float latitute;
    float longitude;
}

/*- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    latitute=40.7127;//37.368830;//40.759011;//-33.8670522f;
    longitude=74.0059;//-122.036350;//-73.984472;//151.1957362f;

//    latitute=37.368830;//40.759011;//-33.8670522f;
//    longitude=-122.036350;//-73.984472;//151.1957362f;

	// Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ContentListCell" bundle:nil] forCellReuseIdentifier:@"ContentListCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = [Place formattedCategory: self.category];
    self.placesDetails = [[NSMutableArray alloc] initWithCapacity: self.places.count];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    GooglePlacesClient* client = [[GooglePlacesClient alloc] init];
    self.noOfRequests = self.places.count;
    for(int i = 0 ; i < self.places.count; i++){
        Place* place = [self.places objectAtIndex:i];
        if(place.isPopulatedFully){
            [self onCompletePlaceDetailRequest];
            continue;
        }
        [client placeDetails:place.reference success:^(NSURLRequest *request, NSHTTPURLResponse *response, id data) {
            NSLog(@"Success: %@",data);
            NSDictionary* result = [data valueForKey:@"result"];
            Place* place = [[Place alloc] initWithDictionary:result];
            [self.places replaceObjectAtIndex:i withObject:place];
            place.isPopulatedFully = true;
            [self onCompletePlaceDetailRequest];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id data) {
            [self onCompletePlaceDetailRequest];
            NSLog(@"Failure: %@",error);
        }];
    }
    
}
- (void)onCompletePlaceDetailRequest{
    self.noOfRequests--;
    if(self.noOfRequests == 0){
        NSLog(@"Reloading list view...");
        self.placesDetails = self.places;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithWhite:0.94f alpha:1];//[UIColor clearColor];
    return headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.placesDetails.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
        static NSString *CellIdentifier = @"ContentListCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Place* place = [self.placesDetails objectAtIndex:indexPath.section];
        
        // Configure the cell...
    unichar bullet = 0x2022;
    NSString* bulletStr =[NSString stringWithFormat:@"  %@  ",[NSString stringWithCharacters:&bullet  length:1]];
    bool append = false;
    ((ContentListCell*)cell).itemLabel.text = [NSString stringWithFormat: @"%@", place.name];
    if(place.rating){
        append = true;
        ((ContentListCell*)cell).itemRating.text = [NSString stringWithFormat:@"%@ ",[NSString stringWithFormat: @"%.1f", place.rating]];
        int roundedRating = roundf(place.rating);
        NSString* stars = (roundedRating == 5)? @"*****": ((roundedRating == 4)? @"****" : ((roundedRating==3? @"***": ((roundedRating==2)? @"**": @"*"))));
        //((ContentListCell*)cell).starts.text = [NSString stringWithFormat:@"%@  ",stars];
    }/*else{
        for(NSLayoutConstraint* con in ((CategoryViewItemCell*)cell).itemRating.constraints){
          if([con firstAttribute] == NSLayoutAttributeWidth){
          con.constant = 0.0;
          }
          }
    }*/
    if(place.noOfReviews > 0){
        ((ContentListCell*)cell).noOfReviews.text = [NSString stringWithFormat:@"%@%@ reviews",(append? bulletStr: @""),[NSString stringWithFormat: @"%d", place.noOfReviews]];
        append= true;
    }
    
    if(place.priceLevel > 0){
        NSString* priceLevel = (place.priceLevel == 1)? @"$" : ((place.priceLevel ==2)? @"$$": ((place.priceLevel ==3)? @"$$$": @"$$$$"));
        ((ContentListCell*)cell).priceLevel.text = [NSString stringWithFormat:@"%@%@",(append? bulletStr: @""),[NSString stringWithFormat: @"%@", priceLevel]];
    }
        
    CLLocation* second = [[CLLocation alloc] initWithLatitude:latitute longitude:longitude];
    CLLocation* first = [[CLLocation alloc] initWithLatitude:[place.lat floatValue] longitude:[place.lng floatValue]];

    CLLocationDistance distance = [first distanceFromLocation:second];
    float miles = distance*0.00062137;
    float ft = miles*5280;
    if(miles > 0.1){
        ((ContentListCell*)cell).distance.text = [NSString stringWithFormat:@"%.1f mi",miles];
    }else{
        ((ContentListCell*)cell).distance.text = [NSString stringWithFormat:@"%d ft",(int)ft];
    }
    
    ((ContentListCell*)cell).itemCategory.text = [Place formattedCategory: [place.types objectAtIndex:0]];
    /*if(!place.open){
        ((ContentListCell*)cell).status.text = [NSString stringWithFormat:@"%@Closed",bulletStr];
    }*/
    
    NSLog(@"Place:%@",place.name);
    if(place.photos.count > 0){
        NSString* url = [GooglePlacesClient getImageURL:[place.photos objectAtIndex:0] maxwidth:-1 maxheight:CONTENT_LIST_IMAGE_HEIGHT];
        [((ContentListCell*)cell).placeImage setImageWithURL: [NSURL URLWithString:url] placeholderImage:[[UIImage alloc] init]];
        
    }else{
        //headerImage.image= [[UIImage alloc] init];
        NSLog(@"No image found for: %@",place.name);
        for(NSLayoutConstraint* con in ((ContentListCell*)cell).placeImage.constraints){
            if([con firstAttribute] == NSLayoutAttributeWidth){
                con.constant = 0.0;
            }
        }
    }
    
    
    cell.selectedBackgroundView = [[[NSBundle mainBundle] loadNibNamed:@"HighLightView" owner:self options:nil] objectAtIndex:0];
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    //NSLog(@"Go to Place Details");
    DetailsViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    vc.place = [self.places objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
    //[self presentViewController:vc animated:YES completion:nil];
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*/Users/anshah/Ankit/work/iphone/project/aroundyou/AroundYou/AroundYou/en.lproj/InfoPlist.strings
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
