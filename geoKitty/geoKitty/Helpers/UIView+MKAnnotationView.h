//
//  UIView+MKAnnotationView.h
//  geoKitty
//
//  Created by Oleg Suhockiy on 29.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKAnnotationView;

@interface UIView (MKAnnotationView)

- (MKAnnotationView *)superAnnotationView;

@end
