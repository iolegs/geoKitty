//
//  OSManagedAnnotation.h
//  geoKitty
//
//  Created by Oleg Suhockiy on 31.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OSManagedPhoto;

@interface OSManagedAnnotation : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) OSManagedPhoto * photo;

@end
