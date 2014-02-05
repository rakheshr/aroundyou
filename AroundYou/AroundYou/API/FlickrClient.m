//
//  FlickrClient.m
//  AroundYou
//
//  Created by Rakhesh on 2/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "FlickrClient.h"
#import "AFNetworking.h"

#define FLICKR_BASE_URL = [NSURL URLWithString:@"https://api.flickr.com/services/"]
#define API_KEY = [NSString URLWithString:@"edcc64136c3019f39814935b8299360e"]
//http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=edcc64136c3019f39814935b8299360e&lat=-33.8670522&lon=151.1957362&radius=20&format=json&nojsoncallback=1


@implementation FlickrClient

- (void) searchPopularPhotos:(NSArray*)types latitute:(float)latitute longitude:(float)longitude success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure{
    
    NSMutableString* urlPath = [NSMutableString stringWithString: @""];
    [urlPath appendString:[NSString stringWithFormat: @"lat=%f",latitute]];
    [urlPath appendString:@"&radius=20"];
    [urlPath appendString:[NSString stringWithFormat: @"&lon=%f",longitude]];
    [urlPath appendString:[NSString stringWithFormat: @"&format=json&nojsoncallback=1@api_key=edcc64136c3019f39814935b8299360e"]];
    NSLog(@"RequestURL: %@",urlPath);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search", [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    
    [operation start];
    
}

@end
