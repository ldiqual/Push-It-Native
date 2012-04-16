//
//  RootViewControllerViewController.h
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonViewController.h"
#import "MapViewController.h"
#import "CategoryViewController.h"

@interface RootController : UIViewController {
  /*
  ButtonViewController *buttonViewController;
  MapViewController *mapViewController;
  CategoryViewController *categoryViewController;
  
  UINavigationController *navigationController;
   */
}

@property (nonatomic, retain) ButtonViewController *buttonViewController;
@property (nonatomic, retain) MapViewController *mapViewController;
@property (nonatomic, retain) CategoryViewController *categoryViewController;
@property (nonatomic, retain) UINavigationController *navigationController;

@end
