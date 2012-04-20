//
//  RootViewControllerViewController.m
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
 * TODO: valueForKeypath
 */


#import <CoreLocation/CoreLocation.h>
#import "RootController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "MapAnnotation.h"

#define GOOGLE_API_KEY @"AIzaSyDQWO6d3uFsjjeBEllD6C3bGhbX3-11GRM"
#define SEARCH_RADIUS 2000
#define CATEGORIES_NUMBER 4

@interface RootController ()
@end

@implementation RootController

@synthesize buttonViewController;
@synthesize mapViewController;
@synthesize categoryViewController;
@synthesize navigationController;

# pragma mark -
# pragma mark Program methods

- (id)init {
  [self initWithNibName:nil bundle:nil];
  
  // Button pressure event
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonPressed) name:@"buttonPressed" object:nil];
  
  // Place selection event
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placeChosen:) name:@"placeChosen" object:nil];

  
  // Categories
  results = [[NSMutableDictionary alloc] init];
  [results setObject:[[NSMutableArray alloc] init] forKey:@"movie_theater"];
  [results setObject:[[NSMutableArray alloc] init] forKey:@"cafe"];
  [results setObject:[[NSMutableArray alloc] init] forKey:@"shopping"];
  [results setObject:[[NSMutableArray alloc] init] forKey:@"restaurant"];
  
  buttonViewController = [[ButtonViewController alloc] init];
  mapViewController = [[MapViewController alloc] init];
  mapViewController.title = @"Push It";
  
  // Navigation controller
  navigationController = [[UINavigationController alloc] init];
  [navigationController setNavigationBarHidden:YES animated:FALSE];
  navigationController.delegate = self;
  
  // Location settings
  locationSet = FALSE;
  locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  locationManager.distanceFilter = kCLDistanceFilterNone;
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  [locationManager startUpdatingLocation];
  
  return self;
}

- (void)searchForPlaces {
  
  // Google places URL
  int i = 0;
  NSMutableString *types = [NSMutableString stringWithString:@""];
  for (NSString *category in [results allKeys]) {
    [types appendString:category];
    if (i < [results count] - 1) {
      [types appendString:@"%7c"]; // Pipe
    }
  }
  
  NSString *format = @"https://maps.googleapis.com/maps/api/place/search/json?key=%@&location=%f,%f&radius=%d&sensor=false&types=%@";
  NSString *urlString = [NSString stringWithFormat:format,GOOGLE_API_KEY,latitude,longitude,SEARCH_RADIUS,types];
  NSURL *url = [NSURL URLWithString:urlString];
  
  // Launching the HTTP request
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setDelegate:self];
  [request startAsynchronous];
}

- (void) handlePlaceResults:(NSDictionary *)data {
  [self setResultsByCategories:data];
  categoryViewController = [[CategoryViewController alloc] initWithResults:results];
  [navigationController pushViewController:categoryViewController animated:TRUE];
}

- (void) setResultsByCategories:(NSDictionary *)data {
  for (NSDictionary *place in data) {
    for (NSString *category in [results allKeys]) {
      if ([[place objectForKey:@"types"] containsObject:category]) {
        [[results objectForKey:category] addObject:place];
      }
    }
  }
}

- (void) placeChosen:(NSNotification *)notification {
  // Get selected place
  NSDictionary *place = [[notification userInfo] objectForKey:@"place"];
  NSDictionary *location = [[place objectForKey:@"geometry"] objectForKey:@"location"];
  
  // Create annotation
  CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([[location objectForKey:@"lat"] floatValue], [[location objectForKey:@"lng"] floatValue]);
  MapAnnotation *annotation = [[MapAnnotation alloc] initWithCoordinate:coords];
  [annotation setTitle:[place objectForKey:@"name"]];
  [annotation setSubtitle:[place objectForKey:@"vicinity"]];
  
  [mapViewController resetInternalAnnotations];
  [mapViewController addAnnotation:annotation];
  
  [navigationController pushViewController:mapViewController animated:TRUE];
  [navigationController setNavigationBarHidden:FALSE animated:TRUE];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate methods

- (void)navigationController:(UINavigationController *)navigationControllerArg
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
  if (viewController == categoryViewController) {
    [navigationController setNavigationBarHidden:TRUE animated:TRUE];
  }
}

#pragma mark -
#pragma mark CLLocationManager methods

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
}
  
- (void)buttonPressed {
  
  // If the current location isn't set, wait for it
  if (!locationSet) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonPressed) name:@"locationSet" object:nil];
    return;
  }
  
  [self searchForPlaces];
}

# pragma mark -
# pragma mark ASIHttpRequest methods

- (void)requestFinished:(ASIHTTPRequest *)request
{   
  // Use when fetching binary data
  NSData *responseData = [request responseData];
  SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
  NSDictionary *json = [jsonParser objectWithData:responseData];
  NSDictionary *data = [json objectForKey:@"results"];
  
  if (![[json objectForKey:@"status"] isEqualToString:@"OK"]
      || [data count] == 0) {
    NSLog(@"Error in request");
    NSString *message = ([data count] == 0)
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
  
  [self handlePlaceResults:data];
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
  NSLog(@"Error in request");
  NSError *error = [request error];
  NSLog(@"%@", [error localizedDescription]);
}

# pragma mark -
# pragma mark UIViewController methods

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
  [navigationController pushViewController:buttonViewController animated:FALSE];
  [self presentViewController:navigationController animated:FALSE completion:nil];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
