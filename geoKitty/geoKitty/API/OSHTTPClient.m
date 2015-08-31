//
//  OSHTTPClient.m
//  geoKitty
//
//  Created by Oleg Suhockiy on 28.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import "OSHTTPClient.h"
#import "AFHTTPRequestOperationManager.h"

static NSString * const kVKBaseURL    = @"https://api.vk.com/method/";
static NSString * const kVKAPIVersion = @"5.37";
NSUInteger const kVKPhotosLimit = 10;


@interface OSHTTPClient ()

@property (nonatomic, strong) AFHTTPRequestOperationManager * requestOperationManager;

@end

@implementation OSHTTPClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kVKBaseURL]];
    }
    return self;
}

- (void)getPhotosByCoordinate:(CLLocationCoordinate2D)coordinate
                    withLimit:(NSUInteger)limit
                    onSuccess:(void(^)(NSArray *photosArray))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode))failure
{
    NSDictionary *parameters = @{@"lat"    : @(coordinate.latitude),
                                 @"long"   : @(coordinate.longitude),
                                 @"sort"   : @(0),
                                 @"count"  : @(kVKPhotosLimit),
                                 @"radius" : @(100),
                                 @"v"      : kVKAPIVersion};
    
    [self.requestOperationManager GET:@"photos.search"
                           parameters:parameters
                              success:^(AFHTTPRequestOperation *operation, id responseObject){

                                  NSArray *photosArray = responseObject[@"response"][@"items"];
                                  if (success) {
                                      success(photosArray);
                                  }
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
    
}

@end
