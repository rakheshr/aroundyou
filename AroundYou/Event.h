//
//  Event.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/22/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong, readonly) NSString* eventId;
@property (nonatomic, readonly) long startTime;
@property (nonatomic, strong, readonly) NSString* summary;
@property (nonatomic, strong, readonly) NSString* url;

-(id) initWithDictionary:(NSDictionary*) dictionary;

@end
