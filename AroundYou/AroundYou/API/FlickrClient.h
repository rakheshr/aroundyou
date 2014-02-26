//
//  FlickrClient.h
//  AroundYou
//
//  Created by Rakhesh on 2/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrClient : NSObject

- (void) searchPopularPhotosWithLatitude:(float)latitute longitude:(float)longitude success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure;

- (void) searchPopularPhotosWithText:(NSString*)text success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure;

- (void) searchPopularPhotosWithTag:(NSString*)tag success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure;


@end
