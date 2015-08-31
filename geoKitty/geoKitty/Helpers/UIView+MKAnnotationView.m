//
//  UIView+MKAnnotationView.m
//  geoKitty
//
//  Created by Oleg Suhockiy on 29.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import "UIView+MKAnnotationView.h"
#import <MapKit/MapKit.h>

@implementation UIView (MKAnnotationView)

- (MKAnnotationView *)superAnnotationView
{
    if ([self isKindOfClass:[MKAnnotationView class]]) {
        return (MKAnnotationView *)self;
    }
    
    if (!self.superview) {
        return nil;
    }
    
    return [self.superview superAnnotationView];
}

@end