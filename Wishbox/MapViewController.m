//
//  MapViewController.m
//  Wishbox
//
//  Created by Albert Villanueva on 20/11/14.
//  Copyright (c) 2014 Albert Villanueva. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];

    
    [self.locationManager requestWhenInUseAuthorization];
    self.mapView.delegate = self;
    
    [self.mapView showsUserLocation];
    
    [[MKMapView appearance]setTintColor:[UIColor greenColor]];
    
    [self.locationManager startUpdatingLocation];
    
    if (self.annotation != nil) {
        [self.mapView addAnnotation:self.annotation];
    }
}


#pragma mark MKMapView Delegate



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    
    
    if (self.annotation == nil) {
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        CLLocationCoordinate2D location;
        location.latitude = self.mapView.userLocation.coordinate.latitude;
        location.longitude = self.mapView.userLocation.coordinate.longitude;
        region.span = span;
        region.center = location;
        [self.mapView setRegion:region animated:YES];
        
    }
    else {
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        CLLocationCoordinate2D location;
        location.latitude = self.annotation.coordinate.latitude;
        location.longitude = self.annotation.coordinate.longitude;
        region.span = span;
        region.center = location;
        [self.mapView setRegion:region animated:YES];
    }
    
}

- (IBAction)mapViewLongPress:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        
    }
    
    else if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        
        if (self.annotation != nil) {
            [self.mapView removeAnnotation:self.annotation];
        }
        
        
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D locationInMap = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        NSLog(@"anotation point: %f, %f", locationInMap.latitude, locationInMap.longitude);
        
        self.annotation = [[MapAnnotation alloc]init];
        
        
        self.annotation.coordinate = locationInMap;
        
        [self.mapView addAnnotation:self.annotation];
        
        [self.mapView setCenterCoordinate:self.annotation.coordinate animated:YES];
        
        
    }

}
- (IBAction)useCurrentLocationPressed:(id)sender {
    
    
    if (self.annotation != nil) {
        [self.mapView removeAnnotation:self.annotation];
        
    }
    
    self.annotation = [[MapAnnotation alloc]init];
    
    
    self.annotation.coordinate = self.mapView.userLocation.coordinate;
    
    [self.mapView addAnnotation:self.annotation];
    [self.mapView setCenterCoordinate:self.annotation.coordinate animated:YES];
    
}

- (IBAction)removeLocationPressed:(id)sender {
    
    [self.mapView removeAnnotation:self.annotation];
    self.annotation = nil;
}


- (IBAction)cancelButtonPressed:(id)sender {
    
    self.annotation = nil;
    [self.delegate didUpdateLocationWithAnnotation:self.annotation];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)doneButtonPressed:(id)sender {
    
    if (self.annotation != nil) {
        
        [self.delegate didUpdateLocationWithAnnotation:self.annotation];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.delegate didUpdateLocationWithAnnotation:self.annotation];
    }

}

@end
