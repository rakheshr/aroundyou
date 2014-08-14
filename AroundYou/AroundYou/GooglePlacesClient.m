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
//"AIzaSyCb9GiMdCLxntAA_wWeqL7-245deUXS3hg"
//"AIzaSyABtRDBQ1KcUmNwaiisOa4dbMHrkE3LMVM"
//"AIzaSyCb9GiMdCLxntAA_wWeqL7-245deUXS3hg"
//AIzaSyBQQT6ryjFeilOm5_CYyK3Ej--oCFjXphs"
//"AIzaSyCE-44YjiGJtME1dHhXiHgmLkd7HvciMig"
//"AIzaSyDQGIhIhZxLNZjWUx5og7aOY3I-GzvE8tk"
//"AIzaSyCaneVaTyKTNzRpLat8C8TzaqpGs6sHxnM"

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


- (void) placeDetails:(NSString*)reference success:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, id data))success failure:(void (^)(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error, id data))failure{
    
    NSMutableString* urlPath = [NSMutableString stringWithString: @""];
    [urlPath appendString:[NSString stringWithFormat: @"reference=%@",reference]];
    [urlPath appendString:[NSString stringWithFormat: @"&sensor=false&key=%@",@(GOOGLE_API_KEY)]];
    NSLog(@"RequestURL: %@",urlPath);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?%@", [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    
    [operation start];
    
}

+ (NSString*) getImageURL:(NSString*)reference maxwidth:(int) maxwidth maxheight:(int) maxheight{
    
    NSMutableString* urlPath = [NSMutableString stringWithString: @""];
    [urlPath appendString:[NSString stringWithFormat: @"photoreference=%@",reference]];
    [urlPath appendString:[NSString stringWithFormat: @"&sensor=false&key=%@",@(GOOGLE_API_KEY)]];
    if(maxwidth > 0){
        [urlPath appendString:[NSString stringWithFormat: @"&maxwidth=%d",maxwidth]];
    }else if(maxheight > 0){
        [urlPath appendString:[NSString stringWithFormat: @"&maxheight=%d",maxheight]];
    }
    NSLog(@"RequestURL: %@",urlPath);
    return [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?%@", [urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
}


@end
