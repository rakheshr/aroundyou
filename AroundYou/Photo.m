//
//  Photo.m
//  AroundYou
//
//  Created by Rakhesh on 2/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "Photo.h"

@implementation Photo


-(id) initWithDictionary:(NSDictionary*) photosDictionary{
    self = [super init];
    if(self){
        self.title =  [photosDictionary valueForKey:@"title"];
        self.photoid = [photosDictionary valueForKey:@"id"];
        self.farm = [photosDictionary valueForKey:@"farm"];
        self.owner = [photosDictionary valueForKey:@"owner"];
        self.secret = [photosDictionary valueForKey:@"secret"];
        self.server = [photosDictionary valueForKey:@"server"];
        self.url_s = [photosDictionary valueForKey:@"url_s"];
        self.url_m = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",self.farm, self.server,self.photoid, self.secret ];
        self.description = [photosDictionary valueForKey:@"description"];
        
       // NSLog([NSString stringWithFormat:@" URL = %@", self.url_s]);
    }
    
    return self;
    
}

@end
