//
//  RootViewControllerViewController.m
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootController.h"
#import "ASIHTTPRequest.h"

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
  
  return self;
}
- (void)viewDidLoad
{
  NSLog(@"view loaded");
  [super viewDidLoad];
  //[self addChildViewController:buttonViewController];
  //[self presentViewController:buttonViewController animated:FALSE completion:nil];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
  [navigationController pushViewController:buttonViewController animated:FALSE];
  [self presentViewController:navigationController animated:FALSE completion:nil];
}
  
- (void)buttonPressed {
  NSURL *url = [NSURL URLWithString:@"http://pastebin.com/raw.php?i=sZvM9Kj0"];
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setDelegate:self];
  [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
  return;
  // Use when fetching text data
  NSString *responseString = [request responseString];
  NSLog(responseString);
  
  // Use when fetching binary data
  NSData *responseData = [request responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
  return;
  NSLog(@"Error");
  NSError *error = [request error];
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
