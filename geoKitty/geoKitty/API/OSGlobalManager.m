//
//  OSGlobalManager.m
//  geoKitty
//
//  Created by Oleg Suhockiy on 28.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import "OSGlobalManager.h"
#import "OSHTTPClient.h"
#import "OSCoreDataManager.h"
#import "OSPhoto.h"
#import "OSManagedPhoto.h"
#import "OSMappingProvider.h"
#import "UIImageView+AFNetworking.h"

static NSString * const kAnnotationTitle = @"Kitty";

@implementation OSGlobalManager
{
    OSHTTPClient      * httpClient;
    OSCoreDataManager * coreDataManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        httpClient = [[OSHTTPClient alloc] init];
        coreDataManager = [[OSCoreDataManager alloc] init];
        
        //GKDownloadImageNotification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(downloadImage:)
                                                     name:@"GKDownloadImageNotification"
                                                   object:nil];
    }
    return self;
}

// Main Initialization (Singleton)
+ (OSGlobalManager *)sharedInstance
{
    static OSGlobalManager * _sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[OSGlobalManager alloc] init];
    });
    
    return _sharedInstance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getPhotosByCoordinate:(CLLocationCoordinate2D)coordinate
                    withLimit:(NSUInteger)limit
                    onSuccess:(void(^)(NSArray *osPhotosArray))success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode))failure
{
    [httpClient getPhotosByCoordinate:coordinate
                            withLimit:limit
                            onSuccess:^(NSArray *photosArray) {
                                NSMutableArray *osPhotosArray = [NSMutableArray array];
                                for (id item in photosArray)
                                {
                                    OSPhoto *photo = [EKMapper objectFromExternalRepresentation:item
                                                                                    withMapping:[OSMappingProvider photoMapping]];
                                    
                                    [osPhotosArray addObject:photo];
                                    
                                    // Записываем в БД
                                    [coreDataManager createManagedAnnotationWithTitle:kAnnotationTitle
                                                                             andPhoto:photo];
                                }
                                
                                [coreDataManager saveContext];
                                
                                if (success)
                                    success(osPhotosArray);
                            }
                            onFailure:^(NSError *error, NSInteger statusCode) {
                                if (failure)
                                    failure(error,statusCode);
                            }];
}

- (void)downloadImage:(NSNotification *)notification
{
    NSString    * imageURL  = notification.userInfo[@"imageURL"];
    UIImageView * imageView = notification.userInfo[@"imageView"];

    [imageView setImageWithURL:[NSURL URLWithString:imageURL]];
    
}

- (void)printToLogAllSavedPhotos
{
    NSArray *managedPhotosArray = [coreDataManager getAllPhotos];
    
    if ([managedPhotosArray count] > 0)
    {
        for (OSManagedPhoto * managedPhoto in managedPhotosArray)
        {
            NSLog(@"Photo ownerID: %li and location: {%f, %f}",
                  (long)[managedPhoto.owner_id integerValue],
                  [managedPhoto.latitude doubleValue],
                  [managedPhoto.longitude doubleValue]);
        }
    }
    else
    {
        NSLog(@"В БД пока нет сохранённых Фото");
    }
}

@end
