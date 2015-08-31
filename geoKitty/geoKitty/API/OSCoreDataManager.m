//
//  OSCoreDataManager.m
//  geoKitty
//
//  Created by Oleg Suhockiy on 31.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import "OSCoreDataManager.h"
#import "OSPhoto.h"
#import "OSManagedPhoto.h"
#import "OSManagedAnnotation.h"

@implementation OSCoreDataManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "OS.geoKitty" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"geoKitty" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"geoKitty.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Methods
- (void)createManagedAnnotationWithTitle:(NSString *)title andPhoto:(OSPhoto *)photo
{
    OSManagedPhoto *managedPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"OSManagedPhoto"
                                                                 inManagedObjectContext:self.managedObjectContext];
    
    managedPhoto.photoID    = photo.photoID;
    managedPhoto.album_id   = photo.album_id;
    managedPhoto.owner_id   = photo.owner_id;
    managedPhoto.user_id    = photo.user_id;
    managedPhoto.date       = photo.date;
    managedPhoto.width      = photo.width;
    managedPhoto.height     = photo.height;
    managedPhoto.text       = photo.text;
    managedPhoto.latitude   = photo.latitude;
    managedPhoto.longitude  = photo.longitude;
    managedPhoto.photo_75   = photo.photo_75;
    managedPhoto.photo_130  = photo.photo_130;
    managedPhoto.photo_604  = photo.photo_604;
    managedPhoto.photo_807  = photo.photo_807;
    managedPhoto.photo_1280 = photo.photo_1280;
    managedPhoto.photo_2560 = photo.photo_2560;
    
    OSManagedAnnotation *managedAnnotation = [NSEntityDescription insertNewObjectForEntityForName:@"OSManagedAnnotation"
                                                                           inManagedObjectContext:self.managedObjectContext];
    managedAnnotation.title = title;
    managedAnnotation.photo = managedPhoto;
    
}

- (NSArray *)getAllPhotos
{
    NSEntityDescription * description = [NSEntityDescription entityForName:@"OSManagedPhoto"
                                                    inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:description];
    
    NSError * requestError = nil;
    NSArray * photosArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return photosArray;
}

@end
