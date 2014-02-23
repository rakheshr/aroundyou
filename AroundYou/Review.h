//
//  Review.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject

@property (nonatomic, strong, readonly) NSString* authorName;
@property (nonatomic, strong, readonly) NSString* authorUrl;
@property (nonatomic, strong, readonly) NSString* language;
@property (nonatomic, readonly) int rating;
@property (nonatomic, strong, readonly) NSString* text;
@property (nonatomic, readonly) long time;


-(id) initWithDictionary:(NSDictionary*) dictionary;

@end
