//
//  RootViewControllerViewController.m
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "RootController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"

#define GoogleAPIKey @"AIzaSyDQWO6d3uFsjjeBEllD6C3bGhbX3-11GRM"
#define SearchRadius 2000

NSString *placesTypes[4] = {
  @"restaurant",
  @"cafe",
  @"movie_theater",
  @"shopping"
};

@interface RootController ()
@end

@implementation RootController

@synthesize buttonViewController;
@synthesize mapViewController;
@synthesize categoryViewController;
@synthesize navigationController;

- (id)init {
  NSLog(@"rootcontroller");
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonPressed) name:@"buttonPressed" object:nil];
  
  buttonViewController = [[ButtonViewController alloc] init];
  navigationController = [[UINavigationController alloc] init];
  [navigationController setNavigationBarHidden:YES animated:FALSE];
  //[self.view addSubview:buttonViewController.view];
  [self initWithNibName:nil bundle:nil];
  
  // Location settings
  locationSet = FALSE;
  locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  locationManager.distanceFilter = kCLDistanceFilterNone;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [locationManager startUpdatingLocation];
  
  return self;
}

/*
 * Set the current location using Location Manager
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
  if (locationSet) {
    return;
  }
  locationSet = TRUE;
  latitude = newLocation.coordinate.latitude;
  longitude = newLocation.coordinate.longitude;
  [locationManager stopUpdatingLocation];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"locationSet" object:nil userInfo:nil];
  
  NSLog(@"New location: %f %f", latitude, longitude);
}


- (void)viewDidLoad
{
  NSLog(@"view loaded");
  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
  [navigationController pushViewController:buttonViewController animated:FALSE];
  [self presentViewController:navigationController animated:FALSE completion:nil];
}
  
- (void)buttonPressed {
  
  // If the current location isn't set, wait for it
  if (!locationSet) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonPressed) name:@"locationSet" object:nil];
    return;
  }
  
  [self searchForPlaces];
}

- (void)searchForPlaces {
  // Google places URL
  NSMutableString *types = [NSMutableString string];
  for (int i=0; i<4; i++) {
    [types appendString:placesTypes[i]];
    if (i < 3) {
      [types appendString:@"%7c"]; // Pipe
    }
  }
  NSString *format = @"https://maps.googleapis.com/maps/api/place/search/json?key=%@&location=%f,%f&radius=%d&sensor=false&types=%@";
  NSString *urlString = [NSString stringWithFormat:format,GoogleAPIKey,latitude,longitude,SearchRadius,types];
  NSURL *url = [NSURL URLWithString:urlString];
  
  NSLog(@"%@", urlString);
  
  // Launching the HTTP request
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setDelegate:self];
  [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
  // Use when fetching text data
  NSString *responseString = [request responseString];
  NSLog(@"%@", responseString);
  
  // Use when fetching binary data
  NSData *responseData = [request responseData];
  SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
  NSDictionary *json = [jsonParser objectWithData:responseData];
  NSDictionary *results = [json objectForKey:@"results"];
  
  if (![[json objectForKey:@"status"] isEqualToString:@"OK"]
      || [results count] == 0) {
    NSLog(@"Error in request");
    NSString *message = ([results count] == 0)
                      ? @"Can't find any good places round you, please try again somewhere else !"
                      : @"Can't connect to Google Places";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetButton" object:nil userInfo:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil,nil];
    [alert show];
    return;
  }
  
  [self handleResults:results];
}

- (void) handleResults:(NSDictionary *)results {
  categoryViewController = [[CategoryViewController alloc] init];  
  [navigationController pushViewController:categoryViewController animated:TRUE];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
  NSLog(@"Error");
  NSError *error = [request error];
  NSLog(@"%@", [error localizedDescription]);
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
