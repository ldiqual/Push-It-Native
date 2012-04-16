//
//  AppDelegate.h
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootController.h"

#define GoogleAPIKey

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
  RootController *rootController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) RootController *rootController;

@end
