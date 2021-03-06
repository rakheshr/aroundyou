//
//  CategoryViewController.m
//  AroundYou
//
//  Created by Rakhesh on 1/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "CategoryViewController.h"
#import "GooglePlacesClient.h"
#import "Place.h"
#import "CategoryViewHeaderCell.h"
#import "CategoryViewItemCell.h"

@interface CategoryViewController ()

@property (nonatomic,strong) NSMutableArray* places;
@property (nonatomic,strong) NSMutableDictionary* categoryPlaces;
@property (nonatomic) int noOfRequests;

@end

@implementation CategoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryViewHeaderCell" bundle:nil] forCellReuseIdentifier:@"CategoryViewHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryViewItemCell" bundle:nil] forCellReuseIdentifier:@"CategoryViewItemCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = self.category;
    self.places = [[NSMutableArray alloc] init];
    
    GooglePlacesClient* client = [[GooglePlacesClient alloc] init];
    self.noOfRequests = self.types.count;
    for(int i = 0 ; i < self.types.count ; i++){
        NSArray* type = [[NSArray alloc] initWithObjects: [self.types objectAtIndex:i], nil];

        [client searchPlaces:type latitute:-33.8670522f longitude:151.1957362f success:^(NSURLRequest *request, NSHTTPURLResponse *response, id data) {
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.categoryPlaces.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.categoryPlaces objectForKey:[self.types objectAtIndex:section] ] count] +1;//[self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row == 0){
        static NSString *CellIdentifier = @"CategoryViewHeaderCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        ((CategoryViewHeaderCell*)cell).categoryHeaderLabel.text = [self.types objectAtIndex:indexPath.section];
    }else{
        static NSString *CellIdentifier = @"CategoryViewItemCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Place* place = [[self.categoryPlaces objectForKey:[self.types objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row -1];
        
        // Configure the cell...
        ((CategoryViewItemCell*)cell).itemLabel.text = place.name;
        if(place.rating){
            ((CategoryViewItemCell*)cell).itemRating.text = [NSString stringWithFormat: @"%@", place.rating];
        }
        
        // Create and initialize a tap gesture
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(respondToTapGesture:)];
        // Specify that the gesture must be a single tap
        tapRecognizer.numberOfTapsRequired = 1;
        // Add the tap gesture recognizer to the view
        [((CategoryViewItemCell*)cell).viewForTab addGestureRecognizer:tapRecognizer];
            
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
    return cell;
}

- (void)respondToTapGesture:(id)sender {
    NSLog(@"tab");
}

-(BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return false;
}

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
