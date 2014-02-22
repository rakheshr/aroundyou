//
//  LandingViewController.m
//  AroundYou
//
//  Created by Rakhesh on 1/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "LandingViewController.h"
#import "CategoryViewController.h"
#import "Category2ViewController.h"

@interface LandingViewController ()

@end

@implementation LandingViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (IBAction)shop:(id)sender {
    NSArray* types = [NSArray arrayWithObjects:@"shopping_mall",@"shoe_store",@"real_estate_agency",@"pet_store",@"jewelry_store",@"home_goods_store",@"hardware_store",@"grocery_or_supermarket",@"furniture_store",@"electronics_store",@"department_store",@"convenience_store",@"clothing_store",@"car_rental",@"car_dealer",@"book_store",@"bicycle_store", nil];
    //CategoryViewController* categoryViewController = [[CategoryViewController alloc] init];
    //categoryViewController.category = @"Shop";
    //categoryViewController.types = types;
    [self.navigationController pushViewController:categoryViewController animated:YES];
}
*/
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    Category2ViewController* categoryViewController = [segue destinationViewController];
    UIButton* button = (UIButton*)sender;
    if([button.titleLabel.text isEqualToString: @"Shop"]){
        NSArray* types = [NSArray arrayWithObjects:@"shopping_mall",@"shoe_store",@"real_estate_agency",@"pet_store",@"jewelry_store",@"home_goods_store",@"hardware_store",@"grocery_or_supermarket",@"furniture_store",@"electronics_store",@"department_store",@"convenience_store",@"clothing_store",@"car_rental",@"car_dealer",@"book_store",@"bicycle_store", nil];
        categoryViewController.category = @"Shop";
        categoryViewController.types = types;
    }else if([button.titleLabel.text isEqualToString: @"Eat"]){
        NSArray* types = [NSArray arrayWithObjects:@"bakery",@"cafe",@"meal_takeaway",@"meal_delivery",@"food",@"restaurant", nil];
        categoryViewController.category = @"Eat";
        categoryViewController.types = types;
    }else if([button.titleLabel.text isEqualToString: @"Drink"]){
        NSArray* types = [NSArray arrayWithObjects:@"bar",@"liquor_store",@"night_club", nil];
        categoryViewController.category = @"Drink";
        categoryViewController.types = types;
    }else if([button.titleLabel.text isEqualToString: @"Utilities"]){
        NSArray* types = [NSArray arrayWithObjects:@"airport",@"atm",@"bank",@"bus_station",@"car_wash",@"fire_station",@"gas_station", @"gym", @"parking", @"train_station", nil];
        categoryViewController.category = @"Utilities";
        categoryViewController.types = types;
    }else if([button.titleLabel.text isEqualToString: @"Business"]){
        NSArray* types = [NSArray arrayWithObjects:@"accounting",@"beauty_salon",@"doctor",@"electrician",@"finance",@"locksmith", @"hair_care", @"hospital", @"insurance_agency", @"lawyer", @"painter", @"pharmacy",nil];
        categoryViewController.category = @"Business";
        categoryViewController.types = types;
    }else if([button.titleLabel.text isEqualToString: @"Play"]){
        NSArray* types = [NSArray arrayWithObjects:@"amusement_park",@"aquarium",@"art_gallery",@"bowling_alley",@"casino",@"library",@"movie_theater", @"museum", @"park", @"spa", @"zoo", nil];
        categoryViewController.category = @"Play";
        categoryViewController.types = types;
    }
    
}

- (IBAction)play:(id)sender {
}

- (IBAction)activities:(id)sender {
}

- (IBAction)utilities:(id)sender {
}

- (IBAction)drink:(id)sender {
}

- (IBAction)eat:(id)sender {
}

- (IBAction)news:(id)sender {
}
@end
