//
//  FlickrClient.m
//  AroundYou
//
//  Created by Rakhesh on 2/4/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "FlickrClient.h"
#import "AFNetworking.h"

#define FLICKR_API_KEY "edcc64136c3019f39814935b8299360e"


@implementation FlickrClient

- (void) searchPopularPhotosWithLatitude:(float)latitute longitude:(float)longitude success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure{
    
    NSMutableString* urlPath = [NSMutableString stringWithString: @""];
    [urlPath appendString:@"&radius=32&has_geo=1&extras=url_s,description&accuracy=6&sort=interestingness-desc&privacy_filter=1"];
    [urlPath appendString:[NSString stringWithFormat: @"&per_page=40&page=1&lat=%f",latitute]];
    [urlPath appendString:[NSString stringWithFormat: @"&lon=%f",longitude]];
    [urlPath appendString:[NSString stringWithFormat: @"&format=json&nojsoncallback=1&api_key=%@", @(FLICKR_API_KEY)]];
    NSLog(@"RequestURL: %@",urlPath);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search%@", [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    
    [operation start];
    
}

- (void) searchPopularPhotosWithText:(NSString*)text success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure{
    
    NSMutableString* urlPath = [NSMutableString stringWithString: @""];
    [urlPath appendString:@"&has_geo=0&extras=url_s,description&sort=interestingness-desc&privacy_filter=1"];
    [urlPath appendString:[NSString stringWithFormat: @"&per_page=40&page=1&text=%@",text]];
    [urlPath appendString:[NSString stringWithFormat: @"&format=json&nojsoncallback=1&api_key=%@", @(FLICKR_API_KEY)]];
    NSLog(@"RequestURL: %@",urlPath);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search%@", [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    
    [operation start];
    
}

- (void) searchPopularPhotosWithTag:(NSString*)tag success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure{
    
    NSMutableString* urlPath = [NSMutableString stringWithString: @""];
    [urlPath appendString:@"&has_geo=0&extras=url_s,description&sort=interestingness-desc&privacy_filter=1"];
    [urlPath appendString:[NSString stringWithFormat: @"&per_page=40&page=1&tags=%@",tag]];
    [urlPath appendString:[NSString stringWithFormat: @"&format=json&nojsoncallback=1&api_key=%@", @(FLICKR_API_KEY)]];
    NSLog(@"RequestURL: %@",urlPath);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search%@", [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    
    [operation start];
    
}

@end
