//
//  FlickrClient.m
//  AroundYou
//
//  Created by Rakhesh on 2/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "FlickrClient.h"
#import "AFNetworking.h"

#define FLICKR_BASE_URL = "http://api.flickr.com/services/rest/?method=flickr.photos.search"
#define FLICKR_API_KEY "edcc64136c3019f39814935b8299360e"


/*
 
 http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
 or
 http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
 or
 http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)

 http://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg
 
 */


@implementation FlickrClient

- (void) searchPopularPhotosWithLatitude:(float)latitute longitude:(float)longitude success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure{
    
    NSMutableString* urlPath = [NSMutableString stringWithString: @""];
    [urlPath appendString:[NSString stringWithFormat: @"&lat=%f",latitute]];
    [urlPath appendString:@"&radius=20"];
    [urlPath appendString:[NSString stringWithFormat: @"&lon=%f",longitude]];
    [urlPath appendString:[NSString stringWithFormat: @"&format=json&nojsoncallback=1&api_key=%@", @(FLICKR_API_KEY)]];
    NSLog(@"RequestURL: %@",urlPath);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search%@", [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    
    [operation start];
    
}

@end
