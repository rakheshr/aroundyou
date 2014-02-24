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
#import "DetailsActionViewCell.h"
#import "DetailsHeaderViewCell.h"
#import "DetailsMoreInfoCell.h"
#import "DetailsReviewCell.h"
#import "DetailsSectionHeaderCell.h"

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
    int sectionPhotoIndex;
    int sectionReviewIndex;
    int sectionMoreInfoIndex;
    int noOfMoreInfoRows;
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

    //self.navigationController.navigationBarHidden = YES;
    
    latitute=37.368830;//-33.8670522f;
    longitude=-122.036350;//151.1957362f;
    sectionReviewIndex = -1;
    sectionPhotoIndex = -1;
    sectionMoreInfoIndex = 2;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsHeaderViewCell" bundle:nil] forCellReuseIdentifier:@"DetailsHeaderViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsActionViewCell" bundle:nil] forCellReuseIdentifier:@"DetailsActionViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsMoreInfoCell" bundle:nil] forCellReuseIdentifier:@"DetailsMoreInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsReviewCell" bundle:nil] forCellReuseIdentifier:@"DetailsReviewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsSectionHeaderCell" bundle:nil] forCellReuseIdentifier:@"DetailsSectionHeaderCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.placeTitle.text = self.place.name;
    if(self.place.rating){
        int roundedRating = roundf(self.place.rating);
        NSString* stars = (roundedRating == 5)? @"*****": ((roundedRating == 4)? @"****" : ((roundedRating==3? @"***": ((roundedRating==2)? @"**": @"*"))));
        self.placeRatings.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat: @"%.1f", self.place.rating]];
        self.placeRatingsSymbol.text = stars;
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
    int sections = 3;
    if([self.place.photos count] > 0){
        sections++;
        sectionPhotoIndex = 2;
        sectionMoreInfoIndex = 3;
    }
    if([self.place.reviews count] > 0){
        sections++;
        sectionReviewIndex = (sectionPhotoIndex >=0)? 4 : 3;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == sectionReviewIndex){
        return [self.place.reviews count] +1;
    }else if(section == sectionMoreInfoIndex){
        noOfMoreInfoRows = 0;///1; //header row
        if(self.place.url){
            noOfMoreInfoRows++;
        }
        if(self.place.website){
            noOfMoreInfoRows++;
        }
        return noOfMoreInfoRows;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == sectionReviewIndex) {
        if(indexPath.row == 0){
            return 44.0;
        }
        return 129.0;
    }
    if(indexPath.section == sectionMoreInfoIndex){
        return 44.0;
    }
    if(indexPath.section == sectionPhotoIndex){
        return 90.0;
    }
    if(indexPath.section == 0){
        return 44.0;
    }
    if(indexPath.section == 1){
        return 44.0;
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell;
//#import "DetailsActionViewCell.h"
//#import "DetailsHeaderViewCell.h"
//#import "DetailsMoreInfoCell.h"
//#import "DetailsReviewCell.h"
//#import "DetailsSectionHeaderCell.h"

    // Configure the cell...
    if(indexPath.section == sectionReviewIndex) {
        if(indexPath.row == 0){
            static NSString *CellIdentifier = @"DetailsSectionHeaderCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            ((DetailsSectionHeaderCell*)cell).sectionHeaderLabel.text = @"Reviews";
            UIView* selectedView = [[UIView alloc] init];
            selectedView.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = selectedView;
        }else{
            static NSString *CellIdentifier = @"DetailsReviewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            Review* rv = [self.place.reviews objectAtIndex:indexPath.row -1];
            ((DetailsReviewCell*)cell).authorName.text = rv.authorName;
            ((DetailsReviewCell*)cell).authoredTime.text = @"2 months ago";
            if(rv.rating){
                int roundedRating = roundf(rv.rating);
                NSString* stars = (roundedRating == 5)? @"*****": ((roundedRating == 4)? @"****" : ((roundedRating==3? @"***": ((roundedRating==2)? @"**": @"*"))));
                ((DetailsReviewCell*)cell).authoredSubject.text = stars;
            }
            ((DetailsReviewCell*)cell).authorComment.text = rv.text;
            UIView* selectedView = [[UIView alloc] init];
            selectedView.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = selectedView;
        }
    }else if(indexPath.section == sectionMoreInfoIndex){
        /*if(indexPath.row == 0){
            static NSString *CellIdentifier = @"DetailsSectionHeaderCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            ((DetailsSectionHeaderCell*)cell).sectionHeaderLabel.text = @"More Info";
            UIView* selectedView = [[UIView alloc] init];
            selectedView.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = selectedView;
            
        }else{*/
            static NSString *CellIdentifier = @"DetailsMoreInfoCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            if(indexPath.row == 0 && self.place.url){
                ((DetailsMoreInfoCell*)cell).infoLabel.text = @"Places";
                ((DetailsMoreInfoCell*)cell).infoDetail.text = self.place.url;
            }else{
                ((DetailsMoreInfoCell*)cell).infoLabel.text = @"Website";
                ((DetailsMoreInfoCell*)cell).infoDetail.text = self.place.website;
            }
            cell.selectedBackgroundView = [[[NSBundle mainBundle] loadNibNamed:@"HighLightView" owner:self options:nil] objectAtIndex:0];
        //}
    }else if(indexPath.section == sectionPhotoIndex){
        cell = [[UITableViewCell alloc] init];
    }else if(indexPath.section == 0){
        static NSString *CellIdentifier = @"DetailsHeaderViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        ((DetailsHeaderViewCell*)cell).addressLabel.text = self.place.vicinity;
        ((DetailsHeaderViewCell*)cell).categoryLabel.text = [Place formattedCategory:[self.place.types objectAtIndex: 0]];
        ((DetailsHeaderViewCell*)cell).statusLabel.text = (self.place.open) ? @"Open" : @"Closed";
        UIView* selectedView = [[UIView alloc] init];
        selectedView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = selectedView;
    }else if(indexPath.section == 1){
        static NSString *CellIdentifier = @"DetailsActionViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UIView* selectedView = [[UIView alloc] init];
        selectedView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = selectedView;
    }
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
