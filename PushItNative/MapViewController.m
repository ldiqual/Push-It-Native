//
//  MapViewController.m
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView;
@synthesize goButtonItem;
@synthesize previousButtonItem;

#pragma mark -
#pragma mark Custom methods

- (id)init {
  [self initWithNibName:@"MapView" bundle:nil];
  annotations = [[NSMutableArray alloc] init];
  userLocated = TRUE;
  return self;
}

- (void)resetMapAnnotations {
  NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:10];
  for (id annotation in mapView.annotations) {
    if (annotation != mapView.userLocation) {
      [toRemove addObject:annotation];
    }
  }
  [mapView removeAnnotations:toRemove];
  toRemove = nil;
}

- (void)resetInternalAnnotations {
  [annotations removeAllObjects];
}

- (void)addAnnotation:(MapAnnotation *)annotation {
  NSLog(@"addAnnotation: %@", [annotation toString]);
  [annotations addObject:annotation];
  [self refreshMap];
}

- (void)addAnnotations:(NSArray *)annotationsArg {
  [annotations addObjectsFromArray:annotationsArg];
  [self refreshMap];
}

- (void)refreshMap {
  [self resetMapAnnotations];
  [mapView addAnnotations:annotations];
  if (userLocated) {
    [self zoomToFitMapAnnotations];
  }
}

- (void)zoomToFitMapAnnotations { 
  if ([mapView.annotations count] == 0) return; 
  
  CLLocationCoordinate2D topLeftCoord; 
  topLeftCoord.latitude = -90; 
  topLeftCoord.longitude = 180; 
  
  CLLocationCoordinate2D bottomRightCoord; 
  bottomRightCoord.latitude = 90; 
  bottomRightCoord.longitude = -180; 
  
  for (MapAnnotation *annotation in mapView.annotations) { 
    topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude); 
    topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude); 
    bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude); 
    bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude); 
  }
  
  topLeftCoord.longitude = fmin(topLeftCoord.longitude, mapView.userLocation.coordinate.longitude); 
  topLeftCoord.latitude = fmax(topLeftCoord.latitude, mapView.userLocation.coordinate.latitude); 
  bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, mapView.userLocation.coordinate.longitude); 
  bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, mapView.userLocation.coordinate.latitude); 
  
  MKCoordinateRegion region; 
  region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5; 
  region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;      
  region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; 
  
  // Add a little extra space on the sides 
  region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; 
  
  // Add a little extra space on the sides 
  region = [mapView regionThatFits:region]; 
  [mapView setRegion:region animated:YES]; 
}

#pragma mark -
#pragma mark MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  if (userLocated) {
    [self zoomToFitMapAnnotations];
    userLocated = TRUE;
  }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapViewArg viewForAnnotation:(id <MKAnnotation>)annotation {
  if ([annotation isKindOfClass:[MapAnnotation class]]) {
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:((MapAnnotation *)annotation).id];
    if (annotationView == nil) {
      annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:((MapAnnotation *)annotation).id];
    } else {
      annotationView.annotation = annotation;
    }
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    
    return annotationView;
  }
  
  return nil; 
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self refreshMap];
  goButtonItem.target = self;
  goButtonItem.action = @selector(buttonItemPressed);
}

- (void)viewDidUnload
{
  [self setMapView:nil];
  [self setGoButtonItem:nil];
  [self setPreviousButtonItem:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
  [self setMapView:nil];
  [goButtonItem release];
  [previousButtonItem release];
  [super dealloc];
}
                           
@end
