//
//  GLandingViewController.m
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/24/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "GLandingViewController.h"
#import "GLandingViewCell.h"
#import "FlickrClient.h"
#import "Photo.h"
#import "UIImageView+AFNetworking.h"
#import "Category2ViewController.h"
#import "Place.h"
#import "FlickrViewController.h"

@interface GLandingViewController ()

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (nonatomic,strong) NSMutableArray* photoList;
@property (nonatomic,strong) NSArray* types;
@property (nonatomic,strong) NSMutableDictionary* typesCategories;
@property (atomic) int noOfRequests;


@end

@implementation GLandingViewController{
    float latitute;
    float longitude;
    bool initiating;
}

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
    initiating = true;
    latitute=40.7127;//37.368830;//40.759011;//-33.8670522f;
    longitude=74.0059;//-122.036350;//-73.984472;//151.1957362f;
    /*    UIButton* button = (UIButton*)sender;
     if([button.titleLabel.text isEqualToString: @"Shop"]){
     NSMutableArray* types = ;
     categoryViewController.category = @"Shop";
     categoryViewController.types = types;
     }else if([button.titleLabel.text isEqualToString: @"Eat"]){
     NSMutableArray* types =
     categoryViewController.category = @"Eat";
     categoryViewController.types = types;
     }else if([button.titleLabel.text isEqualToString: @"Drink"]){
     NSMutableArray* types = [NSMutableArray arrayWithObjects:@"bar",@"liquor_store",@"night_club", nil];
     categoryViewController.category = @"Drink";
     categoryViewController.types = types;
     }else if([button.titleLabel.text isEqualToString: @"Utilities"]){
     NSMutableArray* types = ;
     categoryViewController.category = @"Utilities";
     categoryViewController.types = types;
     }else if([button.titleLabel.text isEqualToString: @"Business"]){
     NSMutableArray* types = ;
     categoryViewController.category = @"Business";
     categoryViewController.types = types;
     }else if([button.titleLabel.text isEqualToString: @"Play"]){
     NSMutableArray* types = ;
     categoryViewController.category = @"Play";
     categoryViewController.types = types;
     }
     */
    //self.types = @[@"Eat"];
    self.types = @[@"Eat",@"Places",@"Shop",@"Drink",@"Utilities",@"Business",@"Activities"];
    self.typesCategories = [[NSMutableDictionary alloc] init];
    [self.typesCategories setObject:[NSMutableArray arrayWithObjects:@"bakery",@"cafe",@"meal_takeaway",@"meal_delivery",@"food",@"restaurant", nil] forKey:@"Eat"];
    [self.typesCategories setObject:[NSMutableArray arrayWithObjects: @"Attractions",@"Popular Locations",@"Site Seeing",nil] forKey:@"Places"];
    [self.typesCategories setObject:[NSMutableArray arrayWithObjects:@"shopping_mall",@"shoe_store",@"real_estate_agency",@"pet_store",@"jewelry_store",@"home_goods_store",@"hardware_store",@"grocery_or_supermarket",@"furniture_store",@"electronics_store",@"department_store",@"convenience_store",@"clothing_store",@"car_rental",@"car_dealer",@"book_store",@"bicycle_store", nil] forKey:@"Shop"];
    [self.typesCategories setObject:[NSMutableArray arrayWithObjects:@"bar",@"liquor_store",@"night_club", nil] forKey:@"Drink"];
    [self.typesCategories setObject:[NSMutableArray arrayWithObjects:@"airport",@"atm",@"bank",@"bus_station",@"car_wash",@"fire_station",@"gas_station", @"gym", @"parking", @"train_station", nil] forKey:@"Utilities"];
    [self.typesCategories setObject: [NSMutableArray arrayWithObjects:@"accounting",@"beauty_salon",@"doctor",@"electrician",@"finance",@"locksmith", @"hair_care", @"hospital", @"insurance_agency", @"lawyer", @"painter", @"pharmacy",nil] forKey:@"Business"];
    [self.typesCategories setObject:[NSMutableArray arrayWithObjects:@"amusement_park",@"aquarium",@"art_gallery",@"bowling_alley",@"casino",@"library",@"movie_theater", @"museum", @"park", @"spa", @"zoo", nil] forKey:@"Activities"];
    
    self.noOfRequests = self.types.count;
    self.photoList = [[NSMutableArray alloc] initWithArray:@[@[],@[],@[],@[],@[],@[],@[]]];
    for(int i = 0 ; i < self.types.count ; i++){
        
        FlickrClient *flickrClient = [[FlickrClient alloc]init];
        [flickrClient searchPopularPhotosWithTag: [self.types objectAtIndex:i] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id data) {
            //NSLog(@"Success: %@",data);
            NSDictionary* photos = [data valueForKey:@"photos"];
            NSArray* photoArray = [photos valueForKey:@"photo"];
            NSMutableArray* photosForType = [[NSMutableArray alloc] init];
            for(NSDictionary* photo in photoArray){
                //add to photo modal.
                [photosForType addObject:[[Photo alloc]initWithDictionary:photo]];
            }
            //random 1st photo
            if(photosForType.count > 0){
                int randomIndex = (int)(arc4random() % [photosForType count]);
                NSString* first = [photosForType objectAtIndex:0];
                [photosForType replaceObjectAtIndex:0 withObject: [photosForType objectAtIndex:randomIndex]];
                [photosForType replaceObjectAtIndex:randomIndex withObject: first];
            }
            [self.photoList replaceObjectAtIndex:i withObject:photosForType];
            
            [self onCompletePlaceDetailRequest];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id data) {
            [self onCompletePlaceDetailRequest];
            NSLog(@"Error : %@", error);
        }];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLandingViewCell" bundle:nil] forCellReuseIdentifier:@"GLandingViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

    [self.tableView registerNib:[UINib nibWithNibName:@"GLandingViewCell" bundle:nil] forCellReuseIdentifier:@"GLandingViewCell"];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed:0.94 green:0.95 blue:0.95 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
//    self.navigationController.navigationBar.backItem.backBarButtonItem.title = @"";
    [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:6.0]} forState:UIControlStateNormal];
    self.title = @"Around Me";
    
	// Do any additional setup after loading the view.
}
- (void)onCompletePlaceDetailRequest{
    self.noOfRequests--;
    if(self.noOfRequests == 0){
        //remove the types
        initiating=false;
        NSLog(@"Reloading landingpage list view...");
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(initiating == true){
        return 0;
    }
    return [self.types count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(initiating == true){
        return 44.0;
    }
    return 133.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(initiating == true){
        return [[UITableViewCell alloc] init];
    }
    
    static NSString *CellIdentifier = @"GLandingViewCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSArray* photosForSection = [self.photoList objectAtIndex:indexPath.section];
    ((GLandingViewCell*)cell).mainLabel.text =  [self.types objectAtIndex:indexPath.section];
    NSString* categories = @"";
    for(NSString* cat in [self.typesCategories objectForKey:[self.types objectAtIndex:indexPath.section]]){
        categories = [categories stringByAppendingFormat:@"%@    ", [Place formattedCategory:cat]];
    }
    ((GLandingViewCell*)cell).categoriesLabel.text =  categories;
    //[Place formattedCategory: [self.types objectAtIndex:indexPath.section] ];
    //NSLog(@"Index%d",indexPath.section);
    UIImageView* mainImage = ((GLandingViewCell*)cell).mainImage;
    Photo* mainPhoto = [photosForSection objectAtIndex:0];
    [mainImage setImageWithURL: [NSURL URLWithString:mainPhoto.url_s] placeholderImage:[[UIImage alloc] init]];
    
    UIImageView* sideFirstImage = ((GLandingViewCell*)cell).sideFirstImage;
    Photo* sideFirstPhoto = [photosForSection objectAtIndex:1];
    [sideFirstImage setImageWithURL: [NSURL URLWithString:sideFirstPhoto.url_s] placeholderImage:[[UIImage alloc] init]];

    UIImageView* sideSecondImage = ((GLandingViewCell*)cell).sideSecondImage;
    Photo* sideSecondPhoto = [photosForSection objectAtIndex:2];
    [sideSecondImage setImageWithURL: [NSURL URLWithString:sideSecondPhoto.url_s] placeholderImage:[[UIImage alloc] init]];
    
    cell.selectedBackgroundView = [[[NSBundle mainBundle] loadNibNamed:@"HighLightView" owner:self options:nil] objectAtIndex:0];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(initiating == true || [self.photoList count] == 0){
        return;
    }

    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];

    if (indexPath.section == 1) {
        FlickrViewController* flickrViewController = [storyboard instantiateViewControllerWithIdentifier:@"FlickrViewController"];
        [self.navigationController pushViewController:flickrViewController animated:YES];
        return;
    }else{
    Category2ViewController* categoryViewController = [storyboard instantiateViewControllerWithIdentifier:@"Category2ViewController"];
        NSMutableArray* types = [self.typesCategories objectForKey:[self.types objectAtIndex:indexPath.section]];//[NSMutableArray arrayWithObjects:@"bakery",@"cafe",@"meal_takeaway",@"meal_delivery",@"food",@"restaurant", nil];
    categoryViewController.category = [self.types objectAtIndex:indexPath.section];
    categoryViewController.types = types;
    [self.navigationController pushViewController:categoryViewController animated:YES];
    }
}

@end
