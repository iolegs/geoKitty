//
//  OSPhotoView.m
//  geoKitty
//
//  Created by Oleg Suhockiy on 31.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import "OSPhotoView.h"

@implementation OSPhotoView
{
    UIImageView             * imageView;
    UIActivityIndicatorView * indicator;
}

// Initialization
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // Добавляем индикатор активности
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [indicator startAnimating];
        [self addSubview:indicator];
        
        // Наблюдаем за изменением картинки чтобы убрать индикатор загрузки
        [imageView addObserver:self forKeyPath:@"image" options:0 context:nil];
        
        /*// Отправляем нотификацию на загрузку картинки
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GKDownloadImageNotification"
                                                            object:self
                                                          userInfo:@{@"imageURL"  : annotation.photo.photo_130,
                                                                     @"imageView" : imageView}];
         */
        
        /* Показываем картинку с задержкой (имитация асинхронной загрузки)
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         imageView.image = [UIImage imageNamed:imageURL];
         });
         */
        
    }
    
    return self;
}

- (void)dealloc
{
    // Убираем наблюдателя
    [imageView removeObserver:self forKeyPath:@"image"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"image"])
    {
        [indicator stopAnimating];
    }
}

@end
