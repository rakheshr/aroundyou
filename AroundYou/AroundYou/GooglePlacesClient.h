//
//  GooglePlacesClient.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GooglePlacesClient : NSObject


- (void) searchPlaces:(NSArray*)types latitute:(float)latitute longitude:(float)longitude success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure;

+ (NSString*) getImageURL:(NSString*)reference maxwidth:(int) maxwidth maxheight:(int) maxheight;

@end
