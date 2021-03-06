//
//  Category2ViewController.m
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#define HEADER_IMAGE_HEIGHT 2000
#define NO_OF_TOP_PLACES_IN_CATEGORY 3

#import "Category2ViewController.h"
#import "GooglePlacesClient.h"
#import "Place.h"
#import "CategoryViewHeaderCell.h"
#import "CategoryViewItemCell.h"
#import "CategoryViewFooterCell.h"
#import "UIImageView+AFNetworking.h"
#import "CoreLocation/CoreLocation.h"
#import "ContentListViewController.h"
#import "DetailsViewController.h"

@interface Category2ViewController ()

//@property (nonatomic,strong) NSMutableArray* places;
@property (nonatomic,strong) NSMutableDictionary* categoryPlaces;
@property (nonatomic) int noOfRequests;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation Category2ViewController{
    float latitute;
    float longitude;
    NSMutableIndexSet* removeTypesIndexes;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTypes:(NSMutableArray*)types
{
    self = [super init];
    if (self) {
        self.types = types;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.categoryPlaces = [[NSMutableDictionary alloc] init];
    

    
    //latitute=37.368830;//-33.8670522f;
    //longitude=-122.036350;//151.1957362f;
    //latitute=37.368830;//40.759011;//-33.8670522f;
    //longitude=-122.036350;//-73.984472;//151.1957362f;
    latitute=40.714269;//37.368830;//40.759011;//-33.8670522f;
    longitude=-74.005973;//-122.036350;//-73.984472;//151.1957362f;

	// Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryViewHeaderCell" bundle:nil] forCellReuseIdentifier:@"CategoryViewHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryViewItemCell" bundle:nil] forCellReuseIdentifier:@"CategoryViewItemCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryViewFooterCell" bundle:nil] forCellReuseIdentifier:@"CategoryViewFooterCell"];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = self.category;
    //self.places = [[NSMutableArray alloc] init];
    
    GooglePlacesClient* client = [[GooglePlacesClient alloc] init];
    self.noOfRequests = self.types.count;
    //NSArray* ;
    removeTypesIndexes = [[NSMutableIndexSet alloc] init];
    for(int i = 0 ; i < self.types.count ; i++){
        NSArray* type = [[NSArray alloc] initWithObjects: [self.types objectAtIndex:i], nil];
        [client searchPlaces:type latitute:latitute longitude:longitude success:^(NSURLRequest *request, NSHTTPURLResponse *response, id data) {
            //NSLog(@"%@ Success: %@",[type objectAtIndex:0], data);
            NSArray* results = [data valueForKey:@"results"];
           // NSLog(@"i: %d Category: %@ Resutls: %d",i, [type objectAtIndex:0], [results count]);
            if([results count] > 0){
                [self.categoryPlaces setObject:[[NSMutableArray alloc] init] forKey: [self.types objectAtIndex:i]];
                
                //NSLog(@"Removing category: %@",[type objectAtIndex:0]);
                //[self.categoryPlaces removeObjectForKey:[type objectAtIndex:0]];
                for(NSDictionary* result in results){
                    Place* place = [[Place alloc] initWithDictionary:result];
                    [[self.categoryPlaces objectForKey:[type objectAtIndex:0]] addObject: place];
                    
                }
                int noOfPlacesToLoad = [results count];
                if(noOfPlacesToLoad > NO_OF_TOP_PLACES_IN_CATEGORY){
                    noOfPlacesToLoad = NO_OF_TOP_PLACES_IN_CATEGORY;
                }
                
                self.noOfRequests += noOfPlacesToLoad;
                [self loadTopPlacesDetailsForCategory: [self.categoryPlaces objectForKey:[type objectAtIndex:0]] noOfPlaces: noOfPlacesToLoad];
                
            }else{
                [removeTypesIndexes addIndex:i];
            }
            
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
        //remove the types
        [self.types removeObjectsAtIndexes: removeTypesIndexes];
        [removeTypesIndexes removeAllIndexes];
        NSLog(@"Reloading list view...");
        [self.tableView reloadData];
    }
}

- (void)loadTopPlacesDetailsForCategory  :(NSMutableArray*) places noOfPlaces: (int) noOfPlaces{
    
    GooglePlacesClient* client = [[GooglePlacesClient alloc] init];
    for(int i = 0 ; i < noOfPlaces; i++){
        Place* place = [places objectAtIndex:i];
        if(place.isPopulatedFully){
            [self onCompletePlaceDetailRequest];
            continue;
        }
        [client placeDetails:place.reference success:^(NSURLRequest *request, NSHTTPURLResponse *response, id data) {
            NSLog(@"Success: %@",data);
            NSDictionary* result = [data valueForKey:@"result"];
            Place* place = [[Place alloc] initWithDictionary:result];
            [places replaceObjectAtIndex:i withObject:place];
            place.isPopulatedFully = true;
            [self onCompletePlaceDetailRequest];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id data) {
            [self onCompletePlaceDetailRequest];
            NSLog(@"Failure: %@",error);
        }];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.categoryPlaces.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int noOfPlacesDisplay = [[self.categoryPlaces objectForKey:[self.types objectAtIndex:section] ] count];
    if(noOfPlacesDisplay > NO_OF_TOP_PLACES_IN_CATEGORY){
        noOfPlacesDisplay = NO_OF_TOP_PLACES_IN_CATEGORY;
    }
    // Return the number of rows in the section.
    return  noOfPlacesDisplay+2;//[self.places count];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int noOfPlacesDisplay = [[self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section] ] count];
    if(noOfPlacesDisplay > NO_OF_TOP_PLACES_IN_CATEGORY){
        noOfPlacesDisplay = NO_OF_TOP_PLACES_IN_CATEGORY;
    }
    if(indexPath.row == 0){
        bool imageFound = false;
        NSArray* allPlacesInCategory = [self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section]];
        for(Place* place in allPlacesInCategory){
            if([place.photos count] > 0){
                imageFound = true;
                    break;
            }
        }
        if(!imageFound){
            return 40.0;
        }
        return 110.0;
    }else if(indexPath.row == (noOfPlacesDisplay+1)){
        return 40.0;
    }else{
        return 55.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    int noOfPlacesDisplay = [[self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section] ] count];
    if(noOfPlacesDisplay > NO_OF_TOP_PLACES_IN_CATEGORY){
        noOfPlacesDisplay = NO_OF_TOP_PLACES_IN_CATEGORY;
    }
    
    if(indexPath.row == 0){
        static NSString *CellIdentifier = @"CategoryViewHeaderCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        ((CategoryViewHeaderCell*)cell).categoryHeaderLabel.text = [Place formattedCategory: [self.types objectAtIndex:indexPath.section] ];
        UIImageView* headerImage = ((CategoryViewHeaderCell*)cell).categoryHeaderImage;
        
        //NSMutableArray* allPhotos = [[NSMutableArray alloc] init];
        bool imageFound = false;
        NSArray* allPlacesInCategory = [self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section]];
        for(Place* place in allPlacesInCategory){
            if([place.photos count] > 0){
                for (NSString* pRef in place.photos) {
                    NSString* url = [GooglePlacesClient getImageURL:pRef maxwidth:-1 maxheight:HEADER_IMAGE_HEIGHT];
                    [headerImage setImageWithURL: [NSURL URLWithString:url] placeholderImage:[[UIImage alloc] init]];
                    imageFound = true;
                    break;
                    //[allPhotos addObject: [GooglePlacesClient getImageURL:pRef maxwidth:-1 maxheight:HEADER_IMAGE_HEIGHT] ];
                }
            }
        }
        if(!imageFound){
            NSLog(@"No image found for %@", [self.types objectAtIndex:indexPath.section]);
            for(NSLayoutConstraint* con in headerImage.constraints){
                if([con firstAttribute] == NSLayoutAttributeHeight){
                    con.constant = 0.0;
                }
            }
        }
        
    }else if(indexPath.row == noOfPlacesDisplay+1){
        static NSString *CellIdentifier = @"CategoryViewFooterCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }else{
        static NSString *CellIdentifier = @"CategoryViewItemCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Place* place = [[self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row -1];
        
        // Configure the cell...
        ((CategoryViewItemCell*)cell).itemLabel.text = place.name;
        unichar bullet = 0x2022;
        NSString* bulletStr = [NSString stringWithCharacters:&bullet length:1];
        bool addBullet = false;
        if(place.rating){
            //addBullet = true;
            ((CategoryViewItemCell*)cell).itemRating.text = [NSString stringWithFormat:@"%@ ",[NSString stringWithFormat: @"%.1f", place.rating]];
            int roundedRating = roundf(place.rating);
            NSString* stars = (roundedRating == 5)? @"*****": ((roundedRating == 4)? @"****" : ((roundedRating==3? @"***": ((roundedRating==2)? @"**": @"*"))));
            ((CategoryViewItemCell*)cell).starts.text = [NSString stringWithFormat:@"%@  ",stars];
        }/*else{
            for(NSLayoutConstraint* con in ((CategoryViewItemCell*)cell).itemRating.constraints){
                if([con firstAttribute] == NSLayoutAttributeWidth){
                    con.constant = 0.0;
                }
            }
        }*/
        
        if(!place.open){
            addBullet = true;
            ((CategoryViewItemCell*)cell).status.text = [NSString stringWithFormat:@"  %@  Closed",bulletStr];
        }
        
        CLLocation* second = [[CLLocation alloc] initWithLatitude:latitute longitude:longitude];
        CLLocation* first = [[CLLocation alloc] initWithLatitude:[place.lat floatValue] longitude:[place.lng floatValue]];
        
        CLLocationDistance distance = [first distanceFromLocation:second];
        float miles = distance*0.00062137;
        float ft = miles*5280;
        if(miles > 0.1){
            ((CategoryViewItemCell*)cell).distance.text = [NSString stringWithFormat:@"%@%.1f mi",(addBullet?[NSString stringWithFormat:@"  %@  ",bulletStr] : @""),miles];
        }else{
            ((CategoryViewItemCell*)cell).distance.text = [NSString stringWithFormat:@"%@%d ft",(addBullet?[NSString stringWithFormat:@"  %@  ",bulletStr] : @""),(int)ft];
        }
        
        // Do any additional setup after loading the view, typically from a nib
        
        
        /*UIView *selectionColor = [[UIView alloc] init];
         selectionColor.backgroundColor = [UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
         cell.selectedBackgroundView = selectionColor;*/
        
        /*
         static NSString *CellIdentifier = @"CategoryViewCell";
         cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
         Place* place = [[self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row -1];
         
         // Configure the cell...
         UILabel* title = (UILabel*)[cell viewWithTag:1];
         title.text = place.name;
         if(place.rating){
         UILabel* rating = (UILabel*)[cell viewWithTag:2];
         rating.text = [NSString stringWithFormat: @"%@", place.rating];
         }*/
    }

    cell.selectedBackgroundView = [[[NSBundle mainBundle] loadNibNamed:@"HighLightView" owner:self options:nil] objectAtIndex:0];
    return cell;
}

//-(BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
  //  return false;
//}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.types objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int noOfPlacesDisplay = [[self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section] ] count];
    if(noOfPlacesDisplay > NO_OF_TOP_PLACES_IN_CATEGORY){
        noOfPlacesDisplay = NO_OF_TOP_PLACES_IN_CATEGORY;
    }
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    
    if(indexPath.row > 0 && indexPath.row <= noOfPlacesDisplay){
        //NSLog(@"Go to Place Details");
        DetailsViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        vc.place = [[self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row -1];
        [self.navigationController pushViewController:vc animated:YES];
        //[self presentViewController:vc animated:YES completion:nil];
    }else{
        ContentListViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ContentListViewController"];
        vc.places = [self.categoryPlaces objectForKey: [self.types objectAtIndex: indexPath.section]];
        vc.category = [self.types objectAtIndex: indexPath.section];
        [self.navigationController pushViewController:vc animated:YES];
        //[self presentViewController:vc animated:YES completion:nil];
    }
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
