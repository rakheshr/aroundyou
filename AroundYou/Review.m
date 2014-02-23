//
//  Review.m
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "Review.h"

@interface Review()

@property (nonatomic, strong) NSString* authorName;
@property (nonatomic, strong) NSString* authorUrl;
@property (nonatomic, strong) NSString* language;
@property (nonatomic) int rating;
@property (nonatomic, strong) NSString* text;
@property (nonatomic) long time;

@end

@implementation Review

-(id) initWithDictionary:(NSDictionary*) dictionary{
    self = [super init];
    if(self){
        self.authorUrl = [dictionary valueForKey:@"author_url"];
        self.authorName = [dictionary valueForKey:@"author_name"];
        self.language = [dictionary valueForKey:@"language"];
        self.rating = [[dictionary valueForKey:@"rating"] integerValue];
        self.text = [dictionary valueForKey:@"text"];
        self.time = [[dictionary valueForKey:@"time"] longValue];
    }
    return self;
}

@end
