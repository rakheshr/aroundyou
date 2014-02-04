//
//  Place.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (nonatomic, strong, readonly) NSString* lat;
@property (nonatomic, strong, readonly) NSString* lng;
@property (nonatomic, strong, readonly) NSString* icon;
@property (nonatomic, strong, readonly) NSString* rid;
@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, strong, readonly) NSString* rating;
@property (nonatomic, strong, readonly) NSString* reference;
@property (nonatomic, strong, readonly) NSArray* types;
@property (nonatomic, strong, readonly) NSArray* vicinity;
@property (nonatomic, readonly) BOOL open;

-(id) initWithDictionary:(NSDictionary*) dictionary;

@end
