//
//  MapVC.m
//  geoKitty
//
//  Created by Oleg Suhockiy on 26.08.15.
//  Copyright (c) 2015 Oleg Suhockiy. All rights reserved.
//

#import "MapVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OSGlobalManager.h"
#import "OSPhoto.h"
#import "OSPhotoAnnotation.h"
#import "OSKittyAnnotationView.h"
#import "OSKittyVC.h"
#import "UIView+MKAnnotationView.h"

static NSString * const kAnnotationTitle = @"Kitty";

@interface MapVC () <MKMapViewDelegate, CLLocationManagerDelegate>

@end

@implementation MapVC
{
    OSPhoto *selectedPhoto;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    // Init LocationManager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
    // Init Buttons
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(actionAdd:)];
    
    UIBarButtonItem *zoomButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                target:self
                                                                                action:@selector(actionShowAll:)];
    self.navigationItem.rightBarButtonItems = @[zoomButton, addButton];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
}

#pragma mark - Actions
- (void)actionAdd:(UIBarButtonItem *)sender
{
    [[OSGlobalManager sharedInstance] getPhotosByCoordinate:self.mapView.region.center
                                                  withLimit:10
                                                  onSuccess:^(NSArray *photosArray) {
                                                      
                                                      NSMutableArray *annotationsArray = [NSMutableArray array];
                                                      
                                                      [self.mapView removeAnnotations:self.mapView.annotations];
                                                      
                                                      for (OSPhoto * photo in photosArray)
                                                      {
                                                          OSPhotoAnnotation * annotation = [[OSPhotoAnnotation alloc] init];
                                                          annotation.title      = kAnnotationTitle;
                                                          annotation.photo      = photo;
                                                          annotation.coordinate = CLLocationCoordinate2DMake([photo.latitude doubleValue], [photo.longitude doubleValue]);
                                                          
                                                          [annotationsArray addObject:annotation];
                                                      }
                                                      
                                                      if ([annotationsArray count] > 0)
                                                          [self.mapView addAnnotations:annotationsArray];
                                                      
                                                  }
                                                  onFailure:^(NSError *error, NSInteger statusCode) {
                                                      // Показываем окно с описанием ошибки
                                                      NSString *message = [NSString stringWithFormat:@"%@, status code = %li", [error localizedDescription], (long)statusCode];
                                                      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                          message:message
                                                                                                         delegate:nil
                                                                                                cancelButtonTitle:@"OK"
                                                                                                otherButtonTitles:nil];
                                                      [alertView show];
                                                  }];
    
}

- (void)actionShowAll:(UIBarButtonItem *)sender
{
    [[OSGlobalManager sharedInstance] printToLogAllSavedPhotos];
    /*
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        CLLocationCoordinate2D coordinate = annotation.coordinate;
        MKMapPoint center = MKMapPointForCoordinate(coordinate);
        
        static double delta = 500;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
     */
}

- (void)descriptionAction:(UIButton *)sender
{
    // Записываем выбранную фотографию
    OSKittyAnnotationView * annotationView = (OSKittyAnnotationView *)[sender superAnnotationView];
    
    if (!annotationView)
        return;

    OSPhotoAnnotation * photoAnnotation = annotationView.annotation;
    selectedPhoto = photoAnnotation.photo;
    
    //Переходим на экран Kitty
    [self performSegueWithIdentifier:@"kittySegue" sender:sender];
    
}


#pragma mark - <MKMapViewDelegate>
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"regionWillChangeAnimated");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"regionDidChangeAnimated");
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    NSLog(@"mapViewWillStartLoadingMap");
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    NSLog(@"mapViewDidFinishLoadingMap");
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"mapViewDidFailLoadingMap");
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView
{
    NSLog(@"mapViewWillStartRenderingMap");
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    NSLog(@"mapViewDidFinishRenderingMap fullyRendered - %d", fullyRendered);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Перемещаемся в регион текущей геолокации
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.location.coordinate, 500, 500);
    region = [self.mapView regionThatFits:region];
    
    [self.mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *annotationIdentifier = @"customViewAnnotation";
    
    OSKittyAnnotationView *kittyAnnotationView = (OSKittyAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    if (!kittyAnnotationView)
    {
        CGSize viewSize = CGSizeMake(40, 40);
        kittyAnnotationView = [[OSKittyAnnotationView alloc] initWithSize:viewSize
                                                               annotation:annotation
                                                          reuseIdentifier:annotationIdentifier];
        kittyAnnotationView.canShowCallout = YES;
        
        // Прикручиваем кнопку
        UIButton *descriptionButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [descriptionButton addTarget:self action:@selector(descriptionAction:) forControlEvents:UIControlEventTouchUpInside];
        
        kittyAnnotationView.rightCalloutAccessoryView = descriptionButton;
    } else {
        [kittyAnnotationView reloadWithAnnotation:annotation];
    }
    
    return kittyAnnotationView;
    
}


#pragma mark - <CLLocationManagerDelegate>
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.location = locations.lastObject;
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"kittySegue"])
    {
        OSKittyVC *vc = [segue destinationViewController];
        [vc setPhoto:selectedPhoto];
    }
    
}
@end
