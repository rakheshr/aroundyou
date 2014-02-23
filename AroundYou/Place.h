//
//  Place.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "Review.h"

@interface Place : NSObject

//readonly
@property (nonatomic, strong, readonly) NSString* lat;
@property (nonatomic, strong, readonly) NSString* lng;
@property (nonatomic, strong, readonly) NSString* icon;
@property (nonatomic, strong, readonly) NSString* rid;
@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, readonly) float rating;
@property (nonatomic, strong, readonly) NSString* reference;
@property (nonatomic, strong, readonly) NSArray* types;
@property (nonatomic, readonly) BOOL open;
@property (nonatomic, readonly) int priceLevel;
@property (nonatomic, strong, readonly) NSString* vicinity;

//from details api
@property (nonatomic, strong, readonly) NSArray* events;
@property (nonatomic, strong, readonly) NSString* formattedAddress;
@property (nonatomic, strong, readonly) NSString* formattedPhoneNo;
@property (nonatomic, strong, readonly) NSString* internationalPhoneNumber;
@property (nonatomic, strong, readonly) NSArray* reviews;
@property (nonatomic, strong, readonly) NSString* url;
@property (nonatomic, strong, readonly) NSString* website;
@property (nonatomic, strong, readonly) NSArray* openPeriods;
@property (nonatomic, readonly) int utcOffset;
@property (nonatomic, readonly) int noOfReviews;

//read-write
@property (nonatomic, strong) NSMutableArray* photos;


-(id) initWithDictionary:(NSDictionary*) dictionary;

+(NSString*) formattedCategory: (NSString*) from;

@end
