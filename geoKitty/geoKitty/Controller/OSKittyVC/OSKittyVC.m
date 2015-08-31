//
//  OSKittyVC.m
//  geoKitty
//
//  Created by Oleg Suhockiy on 31.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import "OSKittyVC.h"
#import "OSPhoto.h"
#import "OSPhotoView.h"

@interface OSKittyVC ()

@property (weak, nonatomic) IBOutlet OSPhotoView *photoView;

@end

@implementation OSKittyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Грузим картинку
    [self loadUserImage];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

- (void)loadUserImage
{
    NSString *imageURL;
    
    if (self.photo.photo_807) {
        imageURL = self.photo.photo_807;
    } else if (self.photo.photo_604) {
        imageURL = self.photo.photo_604;
    } else if (self.photo.photo_130) {
        imageURL = self.photo.photo_130;
    } else if (self.photo.photo_75) {
        imageURL = self.photo.photo_75;
    }
    
    if (!imageURL)
        return;
    
    // Отправляем нотификацию на загрузку картинки
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GKDownloadImageNotification"
                                                        object:self
                                                      userInfo:@{@"imageURL"  : imageURL,
                                                                 @"imageView" : self.photoView}];
}

#pragma mark - Actions
- (IBAction)showProfileAction:(id)sender
{
    NSString *profileURL = [NSString stringWithFormat:@"http://vk.com/id%li", (long)[self.photo.owner_id integerValue]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:profileURL]];
}

@end
