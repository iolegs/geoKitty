//
//  OSKittyAnnotationView.h
//  geoKitty
//
//  Created by Oleg Suhockiy on 27.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import <MapKit/MapKit.h>

@class OSPhotoAnnotation;

@interface OSKittyAnnotationView : MKAnnotationView

- (instancetype)initWithSize:(CGSize)size
                  annotation:(OSPhotoAnnotation <MKAnnotation> *)annotation
             reuseIdentifier:(NSString *)reuseIdentifier;


- (void)reloadWithAnnotation:(OSPhotoAnnotation <MKAnnotation> *)annotation;
@end
