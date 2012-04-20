//
//  MapAnnotation.h
//  PushItNative
//
//  Created by Loïs Di Qual on 17/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface MapAnnotation : NSObject<MKAnnotation> {
  CLLocationCoordinate2D coordinate;
  NSString *title;
  NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord;
- (NSString *)toString;

@end