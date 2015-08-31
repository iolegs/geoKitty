//
//  OSCoreDataManager.h
//  geoKitty
//
//  Created by Oleg Suhockiy on 31.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OSPhoto;

@interface OSCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)createManagedAnnotationWithTitle:(NSString *)title andPhoto:(OSPhoto *)photo;
- (NSArray *)getAllPhotos;

@end
