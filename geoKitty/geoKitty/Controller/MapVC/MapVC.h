//
//  MapVC.h
//  geoKitty
//
//  Created by Oleg Suhockiy on 26.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@class CLLocationManager;
@class CLLocation;

@interface MapVC : UIViewController

@property (nonatomic, weak)   IBOutlet MKMapView * mapView;
@property (nonatomic, strong) CLLocationManager  * locationManager;
@property (nonatomic, strong) CLLocation         * location;

@end

