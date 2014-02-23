//
//  Place.m
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "Place.h"

@interface Place()

@property (nonatomic, strong) NSString* lat;
@property (nonatomic, strong) NSString* lng;
@property (nonatomic, strong) NSString* icon;
@property (nonatomic, strong) NSString* rid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic) float rating;
@property (nonatomic, strong) NSString* reference;
@property (nonatomic, strong) NSArray* types;
@property (nonatomic) int priceLevel;
@property (nonatomic, strong) NSString* vicinity;
@property (nonatomic) BOOL open;

//from details api
@property (nonatomic, strong) NSArray* events;
@property (nonatomic, strong) NSString* formattedAddress;
@property (nonatomic, strong) NSString* formattedPhoneNo;
@property (nonatomic, strong) NSString* internationalPhoneNumber;
@property (nonatomic, strong) NSArray* reviews;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSString* website;
@property (nonatomic, strong) NSArray* openPeriods;
@property (nonatomic) int utcOffset;
@property (nonatomic) int noOfReviews;


@end

@implementation Place

-(id) initWithDictionary:(NSDictionary*) dictionary{
    self = [super init];
    if(self){
        self.lat = [[[dictionary valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"];
        self.lng = [[[dictionary valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"];
        //self.lng = [dictionary valueForKey:@"geometry.location.lng"];
        self.icon = [dictionary valueForKey:@"icon"];
        self.rid = [dictionary valueForKey:@"id"];
        self.name = [dictionary valueForKey:@"name"];
        self.open = [[[dictionary valueForKey:@"opening_hours"] valueForKey:@"open_now"] boolValue];
        self.rating = [[dictionary valueForKey:@"rating"] floatValue];
        self.reference = [dictionary valueForKey:@"reference"];
        self.types = [dictionary valueForKey:@"types"];
        self.vicinity = [dictionary valueForKey:@"vicinity"];
        self.priceLevel = [[dictionary valueForKey:@"price_level"] integerValue];
        NSArray* photosRef = [dictionary valueForKey:@"photos"];
        self.photos = [[NSMutableArray alloc] init];
        for(NSDictionary* item in photosRef){
            [self.photos addObject:[item valueForKey:@"photo_reference"]];
        }
        //random 1st photo
        if(self.photos.count > 0){
            int randomIndex = (int)(arc4random() % [self.photos count]);
            NSString* first = [self.photos objectAtIndex:0];
            [self.photos replaceObjectAtIndex:0 withObject: [self.photos objectAtIndex:randomIndex]];
            [self.photos replaceObjectAtIndex:randomIndex withObject: first];
        }
        NSArray* events = [dictionary valueForKey:@"events"];
        NSMutableArray* tempArr = [[NSMutableArray alloc] init];
        for(NSDictionary* item in events){
            [tempArr addObject:[[Event alloc]initWithDictionary:item]];
        }
        self.events = [[NSArray alloc] initWithArray:tempArr];
        
        self.formattedAddress = [dictionary valueForKey:@"formatted_address"];
        self.formattedPhoneNo = [dictionary valueForKey:@"formatted_phone_number"];
        self.internationalPhoneNumber = [dictionary valueForKey:@"international_phone_number"];
        self.url = [dictionary valueForKey:@"url"];
        self.website = [dictionary valueForKey:@"website"];
        
        NSArray* reviews = [dictionary valueForKey:@"reviews"];
        tempArr = [[NSMutableArray alloc] init];
        for(NSDictionary* item in reviews){
            [tempArr addObject:[[Review alloc]initWithDictionary:item]];
        }
        self.reviews = [[NSArray alloc] initWithArray:tempArr];
        
        tempArr = [[dictionary valueForKey:@"opening_hours"] valueForKey:@"periods"];
        NSMutableArray* openPeriod = [[NSMutableArray alloc] initWithObjects:
                                      @[@0, @2359],
                                      @[@0, @2359],
                                      @[@0, @2359],
                                      @[@0, @2359],
                                      @[@0, @2359],
                                      @[@0, @2359],
                                      @[@0, @2359],nil];
        for(NSDictionary* item in tempArr){
            NSInteger openDay = [[[item valueForKey:@"open"] valueForKey:@"day"] integerValue];
            NSInteger openTime = [[[item valueForKey:@"open"] valueForKey:@"time"] integerValue];
            NSInteger closeDay = [[[item valueForKey:@"close"] valueForKey:@"day"] integerValue];
            NSInteger closeTime = [[[item valueForKey:@"close"] valueForKey:@"time"] integerValue];
            if([[item valueForKey:@"open"] valueForKey:@"day"]){
                openPeriod[openDay] = @[@(openTime),openPeriod[openDay][1]];
            }
            if([[item valueForKey:@"close"] valueForKey:@"day"]){
                openPeriod[closeDay] = @[openPeriod[closeDay][0], @(closeTime)];
            }
        }
        
        self.utcOffset = [[dictionary valueForKey:@"utc_offset"] integerValue];
        self.noOfReviews = [[dictionary valueForKey:@"user_ratings_total"] integerValue];
        

    }
    return self;
}

@end

