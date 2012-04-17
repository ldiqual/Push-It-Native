//
//  RootViewControllerViewController.h
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef _ROOTC_
#define _ROOTC_

#import <UIKit/UIKit.h>
#import "ButtonViewController.h"
#import "MapViewController.h"
#import "CategoryViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface RootController : UIViewController<CLLocationManagerDelegate> {
  CLLocationManager *locationManager;
  float latitude;
  float longitude;
  BOOL locationSet;
  NSMutableDictionary *results;
}

@property (nonatomic, retain) ButtonViewController *buttonViewController;
@property (nonatomic, retain) MapViewController *mapViewController;
@property (nonatomic, retain) CategoryViewController *categoryViewController;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

#endif
