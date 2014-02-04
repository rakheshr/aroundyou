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
@property (nonatomic, strong) NSString* rating;
@property (nonatomic, strong) NSString* reference;
@property (nonatomic, strong) NSArray* types;
@property (nonatomic, strong) NSArray* vicinity;
@property (nonatomic) BOOL open;

@end

@implementation Place

-(id) initWithDictionary:(NSDictionary*) dictionary{
    self = [super init];
    if(self){
        self.lat = [dictionary valueForKey:@"geometry.location.lat"];
        self.lng = [dictionary valueForKey:@"geometry.location.lng"];
        self.icon = [dictionary valueForKey:@"icon"];
        self.rid = [dictionary valueForKey:@"id"];
        self.name = [dictionary valueForKey:@"name"];
        self.open = [[dictionary valueForKey:@"opening_hours.open_now"] boolValue];
        self.rating = [dictionary valueForKey:@"rating"];
        self.reference = [dictionary valueForKey:@"reference"];
        self.types = [dictionary valueForKey:@"types"];
        self.vicinity = [dictionary valueForKey:@"vicinity"];
    }
    return self;
}

@end

