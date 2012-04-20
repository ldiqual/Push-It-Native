//
//  MapAnnotation.m
//  PushItNative
//
//  Created by Loïs Di Qual on 17/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord {
  coordinate = coord;
  return self;
}

- (NSString *)toString {  
  // Look at that bug !!! - Should be StackOverflow'd
  // NSString *string = [[NSString alloc] initWithFormat:@"lat:%@ long:%@ title:%@ subtitle:%@",coordinate.latitude, coordinate.longitude, self.title, subtitle];
  
  NSString *string = [[NSString alloc] initWithFormat:@"lat:%f long:%f title:%@ subtitle:%@",coordinate.latitude, coordinate.longitude, self.title, subtitle];
  return string;
}

@end