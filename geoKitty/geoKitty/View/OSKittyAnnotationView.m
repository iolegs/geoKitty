//
//  OSKittyAnnotationView.m
//  geoKitty
//
//  Created by Oleg Suhockiy on 27.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import "OSKittyAnnotationView.h"
#import "OSPhotoAnnotation.h"

@implementation OSKittyAnnotationView
{
    UIImageView             * imageView;
    UIActivityIndicatorView * indicator;
    OSPhotoAnnotation <MKAnnotation> * currentAnnotation;
}

// Initialization
- (instancetype)initWithSize:(CGSize)size
                  annotation:(OSPhotoAnnotation <MKAnnotation> *)annotation
             reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGRect frame = self.frame;
        frame.size   = size;
        self.frame   = frame;
        self.backgroundColor = [UIColor clearColor];
        
        currentAnnotation = annotation;
        
        // Создаём лого и придаём нужный вид
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        imageView.layer.borderWidth   = 2.0f;
        imageView.layer.borderColor   = [UIColor whiteColor].CGColor;
        imageView.layer.cornerRadius  = imageView.frame.size.width / 2;
        imageView.layer.masksToBounds = YES;
        
        // Тень
        self.layer.shadowColor   = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.7;
        self.layer.shadowRadius = 5;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        
        [self addSubview:imageView];
        
        // Добавляем индикатор активности
        indicator = [[UIActivityIndicatorView alloc] init];
        indicator.center = self.center;
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [indicator startAnimating];
        [self addSubview:indicator];
        
        // Наблюдаем за изменением картинки чтобы убрать индикатор загрузки
        [imageView addObserver:self forKeyPath:@"image" options:0 context:nil];
        
        // Отправляем нотификацию на загрузку картинки
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GKDownloadImageNotification"
                                                            object:self
                                                          userInfo:@{@"imageURL"  : currentAnnotation.photo.photo_130,
                                                                     @"imageView" : imageView}];
        
    }
    
    return self;
}

- (void)dealloc
{
    // Убираем наблюдателя
    [imageView removeObserver:self forKeyPath:@"image"];
}

- (void)reloadWithAnnotation:(OSPhotoAnnotation <MKAnnotation> *)annotation
{
    [indicator startAnimating];
    
    currentAnnotation = annotation;
    
    // Отправляем нотификацию на загрузку картинки
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GKDownloadImageNotification"
                                                        object:self
                                                      userInfo:@{@"imageURL"  : currentAnnotation.photo.photo_130,
                                                                 @"imageView" : imageView}];
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
