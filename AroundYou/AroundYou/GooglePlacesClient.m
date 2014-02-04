//
//  GooglePlacesClient.m
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/3/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import "GooglePlacesClient.h"
#import "AFNetworking.h"

#define GOOGLE_API_KEY "AIzaSyBE95bVaivtbIYDouJK9CB3h6lyRzvYPAw"

@implementation GooglePlacesClient

- (void) searchPlaces:(NSArray*)types latitute:(float)latitute longitude:(float)longitude success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure{
    
    NSMutableString* urlPath = [NSMutableString stringWithString: @""];
    [urlPath appendString:[NSString stringWithFormat: @"location=%f,%f",latitute,longitude]];
    [urlPath appendString:@"&radius=500"];
    [urlPath appendString:[NSString stringWithFormat: @"&types=%@",[types componentsJoinedByString:@"|"]]];
    [urlPath appendString:[NSString stringWithFormat: @"&sensor=false&key=%@",@(GOOGLE_API_KEY)]];
    NSLog(@"RequestURL: %@",urlPath);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?%@", [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
        
    [operation start];

}

@end
