//
//  OSPhotoAnnotation.h
//  geoKitty
//
//  Created by Oleg Suhockiy on 31.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "OSPhoto.h"

@interface OSPhotoAnnotation : NSObject <MKAnnotation>

@property (nonatomic)         CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)   NSString * title;
@property (nonatomic, copy)   NSString * subtitle;
@property (nonatomic, strong) OSPhoto  * photo;

@end
