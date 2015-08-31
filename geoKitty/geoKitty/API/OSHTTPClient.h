//
//  OSHTTPClient.h
//  geoKitty
//
//  Created by Oleg Suhockiy on 28.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface OSHTTPClient : NSObject

- (void)getPhotosByCoordinate:(CLLocationCoordinate2D)coordinate
                    withLimit:(NSUInteger)limit
                    onSuccess:(void(^)(NSArray *photosArray))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

@end
