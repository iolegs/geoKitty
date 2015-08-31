//
//  OSMappingProvider.m
//  geoKitty
//
//  Created by Oleg Suhockiy on 29.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import "OSMappingProvider.h"
#import "OSPhoto.h"

@implementation OSMappingProvider

+ (EKObjectMapping *)photoMapping
{
    return [EKObjectMapping mappingForClass:[OSPhoto class] withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromDictionary:@{@"id"   : @"photoID",
                                               @"lat"  : @"latitude",
                                               @"long" : @"longitude"}];
        [mapping mapPropertiesFromArray:@[@"album_id", @"owner_id", @"user_id", @"text", @"date", @"photo_75", @"photo_130", @"photo_604", @"photo_807", @"photo_1280", @"photo_2560", @"width", @"height"]];
    }];

}

@end
