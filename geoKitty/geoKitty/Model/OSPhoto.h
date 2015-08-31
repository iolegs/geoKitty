//
//  OSMapAnnotation.h
//  geoKitty
//
//  Created by Oleg Suhockiy on 26.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSPhoto : NSObject 

@property (nonatomic, strong) NSNumber * photoID;
@property (nonatomic, strong) NSNumber * album_id;
@property (nonatomic, strong) NSNumber * owner_id;
@property (nonatomic, strong) NSNumber * user_id;
@property (nonatomic, strong) NSNumber * date;
@property (nonatomic, strong) NSNumber * width;
@property (nonatomic, strong) NSNumber * height;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, strong) NSString * photo_75;
@property (nonatomic, strong) NSString * photo_130;
@property (nonatomic, strong) NSString * photo_604;
@property (nonatomic, strong) NSString * photo_807;
@property (nonatomic, strong) NSString * photo_1280;
@property (nonatomic, strong) NSString * photo_2560;

@end
