//
//  Event.m
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "Event.h"

@interface Event()

@property (nonatomic, strong) NSString* eventId;
@property (nonatomic) long startTime;
@property (nonatomic, strong) NSString* summary;
@property (nonatomic, strong) NSString* url;

@end

@implementation Event


-(id) initWithDictionary:(NSDictionary*) dictionary{
    self = [super init];
    if(self){
        self.eventId = [dictionary valueForKey:@"event_id"];
        self.startTime = [[dictionary valueForKey:@"start_time"] longValue];
        self.summary = [dictionary valueForKey:@"summary"];
        self.url = [dictionary valueForKey:@"url"];
    }
    return self;
}

@end
