//
//  ContentListViewController.m
//  AroundYou
//
//  Created by Rakhesh on 1/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "ContentListViewController.h"
#import "ContentListCell.h"
#import "Place.h"
#import "UIImageView+AFNetworking.h"
#import "CoreLocation/CoreLocation.h"

@interface ContentListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContentListViewController{
    UIView *selectionColor;
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

    latitute=-33.8670522f;
    longitude=151.1957362f;
    
	// Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ContentListCell" bundle:nil] forCellReuseIdentifier:@"ContentListCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    selectionColor =[[[NSBundle mainBundle] loadNibNamed:@"HighLightView" owner:self options:nil] objectAtIndex:0];
    
    self.title = @"List";
    //self.places = [[NSMutableArray alloc] init];

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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.places.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
        static NSString *CellIdentifier = @"ContentListCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Place* place = [self.places objectAtIndex:indexPath.section];
        
        // Configure the cell...
        ((ContentListCell*)cell).itemLabel.text = place.name;
        if(place.rating){
            unichar bullet = 0x2022;
            ((ContentListCell*)cell).itemRating.text = [NSString stringWithFormat:@"Rating: %@  %@  ",[NSString stringWithFormat: @"%@", place.rating],[NSString stringWithCharacters:&bullet length:1]];
        }/*else{
          for(NSLayoutConstraint* con in ((CategoryViewItemCell*)cell).itemRating.constraints){
          if([con firstAttribute] == NSLayoutAttributeWidth){
          con.constant = 0.0;
          }
          }
          }*/
        
        if(!place.open){
            unichar bullet = 0x2022;
            ((ContentListCell*)cell).status.text = [NSString stringWithFormat:@"Closed  %@  ",[NSString stringWithCharacters:&bullet length:1]];
        }
        
        CLLocation* second = [[CLLocation alloc] initWithLatitude:latitute longitude:longitude];
        CLLocation* first = [[CLLocation alloc] initWithLatitude:[place.lat floatValue] longitude:[place.lng floatValue]];
        
        CLLocationDistance distance = [first distanceFromLocation:second];
        float miles = distance*0.00062137;
        float ft = miles*5280;
        if(miles < 0.1){
            ((ContentListCell*)cell).distance.text = [NSString stringWithFormat:@"%.1f mi",miles];
        }else{
            ((ContentListCell*)cell).distance.text = [NSString stringWithFormat:@"%d ft",(int)ft];
        }
        
    
    
    cell.selectedBackgroundView = selectionColor;
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
