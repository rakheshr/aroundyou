//
//  Photo.h
//  AroundYou
//
//  Created by Rakhesh on 2/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, strong) NSString* farm;
@property (nonatomic, strong) NSString* height_s;
@property (nonatomic, strong) NSString* photoid;
@property (nonatomic, strong) NSString* owner;
@property (nonatomic, strong) NSString* secret;
@property (nonatomic, strong) NSString* server;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* url_s;
@property (nonatomic, strong) NSString* url_m;
@property (nonatomic, strong) NSString* width_s;
@property (nonatomic, strong) NSDictionary* description;

-(id) initWithDictionary:(NSDictionary*) photosDictionary;

@end
