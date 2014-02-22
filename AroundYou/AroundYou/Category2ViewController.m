//
//  Category2ViewController.m
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#define HEADER_IMAGE_HEIGHT 800

#import "Category2ViewController.h"
#import "GooglePlacesClient.h"
#import "Place.h"
#import "CategoryViewHeaderCell.h"
#import "CategoryViewItemCell.h"
#import "CategoryViewFooterCell.h"
#import "UIImageView+AFNetworking.h"
#import "CoreLocation/CoreLocation.h"

@interface Category2ViewController ()

@property (nonatomic,strong) NSMutableArray* places;
@property (nonatomic,strong) NSMutableDictionary* categoryPlaces;
@property (nonatomic) int noOfRequests;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation Category2ViewController{
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

- (id)initWithTypes:(NSArray*)types
{
    self = [super init];
    if (self) {
        self.types = types;
        // Custom initialization
    }
    return self;
}

- (void)setTypes:(NSArray *)types{
    _types = types;
    self.categoryPlaces = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < types.count; i++) {
        [self.categoryPlaces setObject:[[NSMutableArray alloc] init] forKey: [types objectAtIndex:i]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    latitute=-33.8670522f;
    longitude=151.1957362f;

	// Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryViewHeaderCell" bundle:nil] forCellReuseIdentifier:@"CategoryViewHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryViewItemCell" bundle:nil] forCellReuseIdentifier:@"CategoryViewItemCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryViewFooterCell" bundle:nil] forCellReuseIdentifier:@"CategoryViewFooterCell"];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    selectionColor =[[[NSBundle mainBundle] loadNibNamed:@"HighLightView" owner:self options:nil] objectAtIndex:0];
    
    self.title = self.category;
    self.places = [[NSMutableArray alloc] init];
    
    GooglePlacesClient* client = [[GooglePlacesClient alloc] init];
    self.noOfRequests = self.types.count;
    for(int i = 0 ; i < self.types.count ; i++){
        NSArray* type = [[NSArray alloc] initWithObjects: [self.types objectAtIndex:i], nil];
        
        [client searchPlaces:type latitute:latitute longitude:longitude success:^(NSURLRequest *request, NSHTTPURLResponse *response, id data) {
            NSLog(@"Success: %@",data);
            NSArray* results = [data valueForKey:@"results"];
            for(NSDictionary* result in results){
                Place* place = [[Place alloc] initWithDictionary:result];
                [self.places addObject: place];
                //for(int i = 0 ; i< place.types.count ; i++){
                [[self.categoryPlaces objectForKey:[type objectAtIndex:0]] addObject: place];
                //}
            }
            
            self.noOfRequests--;
            if(self.noOfRequests == 0){
                //load top values.
                [self loadTopPlacesDetails];
                NSLog(@"Reloading...");
                [self.tableView reloadData];
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id data) {
            NSLog(@"Failure: %@",error);
        }];
    }

}

- (void)loadTopPlacesDetails{
    
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
    // Return the number of rows in the section.
    return [[self.categoryPlaces objectForKey:[self.types objectAtIndex:section] ] count] +2;//[self.places count];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 110.0;
    }else if(indexPath.row == ([[self.categoryPlaces objectForKey:[self.types objectAtIndex:        indexPath.section] ] count]+1)){
        return 40.0;
    }else{
        return 55.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row == 0){
        static NSString *CellIdentifier = @"CategoryViewHeaderCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        ((CategoryViewHeaderCell*)cell).categoryHeaderLabel.text = [self.types objectAtIndex:indexPath.section];
        UIImageView* headerImage = ((CategoryViewHeaderCell*)cell).categoryHeaderImage;
        NSMutableArray* allPhotos = [[NSMutableArray alloc] init];
        NSArray* allPlacesInCategory = [self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section]];
        for(Place* place in allPlacesInCategory){
            if([place.photos count] > 0){
                for (NSString* pRef in place.photos) {
                    [allPhotos addObject: [GooglePlacesClient getImageURL:pRef maxwidth:-1 maxheight:HEADER_IMAGE_HEIGHT] ];
                }
            }
        }
        if([allPhotos count] > 0){
            [headerImage setImageWithURL: [NSURL URLWithString:[allPhotos objectAtIndex:0]]];
        }/*else if([allPhotos count] > 1){
            [headerImage setImageWithURL
        }*/
        
    }else if(indexPath.row == ([[self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section] ] count]+1)){
        static NSString *CellIdentifier = @"CategoryViewFooterCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }else{
        static NSString *CellIdentifier = @"CategoryViewItemCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Place* place = [[self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row -1];
        
        // Configure the cell...
        ((CategoryViewItemCell*)cell).itemLabel.text = place.name;
        if(place.rating){
            unichar bullet = 0x2022;
            ((CategoryViewItemCell*)cell).itemRating.text = [NSString stringWithFormat:@"Rating: %@  %@  ",[NSString stringWithFormat: @"%@", place.rating],[NSString stringWithCharacters:&bullet length:1]];
        }else{
            for(NSLayoutConstraint* con in ((CategoryViewItemCell*)cell).itemRating.constraints){
                if([con firstAttribute] == NSLayoutAttributeWidth){
                    con.constant = 0.0;
                }
            }
        }
        
        CLLocation* second = [[CLLocation alloc] initWithLatitude:latitute longitude:longitude];
        CLLocation* first = [[CLLocation alloc] initWithLatitude:[place.lat floatValue] longitude:[place.lng floatValue]];
        
        CLLocationDistance distance = [first distanceFromLocation:second];
        float miles = distance*0.00062137;
        float ft = miles*5280;
        if(miles < 0.1){
            ((CategoryViewItemCell*)cell).distance.text = [NSString stringWithFormat:@"%.1f mi",miles];
        }else{
            ((CategoryViewItemCell*)cell).distance.text = [NSString stringWithFormat:@"%d ft",(int)ft];
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

    cell.selectedBackgroundView = selectionColor;
    return cell;
}

//-(BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
  //  return false;
//}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.types objectAtIndex:section];
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
