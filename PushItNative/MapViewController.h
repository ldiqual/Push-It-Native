//
//  MapViewController.h
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"

@interface MapViewController : UIViewController<MKMapViewDelegate> {
  NSMutableArray *annotations;
  BOOL userLocated;
}
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *goButtonItem;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *previousButtonItem;

- (id)init;
- (void)resetInternalAnnotations;
- (void)addAnnotation:(MapAnnotation *)annotation;
- (void)addAnnotations:(NSArray *)annotationsArg;
- (void)refreshMap;

@end
