//
//  OSManagedPhoto.h
//  geoKitty
//
//  Created by Oleg Suhockiy on 31.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OSManagedAnnotation;

@interface OSManagedPhoto : NSManagedObject

@property (nonatomic, retain) NSNumber * photoID;
@property (nonatomic, retain) NSNumber * album_id;
@property (nonatomic, retain) NSNumber * owner_id;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * photo_75;
@property (nonatomic, retain) NSString * photo_130;
@property (nonatomic, retain) NSString * photo_604;
@property (nonatomic, retain) NSString * photo_807;
@property (nonatomic, retain) NSString * photo_1280;
@property (nonatomic, retain) NSString * photo_2560;
@property (nonatomic, retain) OSManagedAnnotation *owner;

@end
