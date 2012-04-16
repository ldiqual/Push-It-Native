//
//  ButtonViewController.m
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ButtonViewController.h"

@interface ButtonViewController ()

@end

@implementation ButtonViewController
@synthesize buttonImageView;
@synthesize spinnerImageView;

- (id)init
{
  NSLog(@"ButtonViewController init");
  [self initWithNibName:@"ButtonView" bundle:nil];
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  // Button is pressed
  if ([[touches anyObject] view] == buttonImageView && !buttonPressed) {
    buttonImageView.image = [UIImage imageNamed:@"button_pressed.png"];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  // Button is pressed
  if ([[touches anyObject] view] == buttonImageView) {
    buttonImageView.image = [UIImage imageNamed:@"button_active.png"];
    [spinnerImageView startAnimating];
    spinnerImageView.hidden = FALSE;
    buttonPressed = TRUE;
  }
}

- (void)viewDidLoad
{
  NSLog(@"ButtonViewController viewDidLoad");
  [super viewDidLoad];
  spinnerImageView.hidden = YES;
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonPressed" object:nil userInfo:nil];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
  [self setButtonImageView:nil];
  [self setSpinnerImageView:nil];
  [self setSpinnerImageView:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
  [buttonImageView release];
  [spinnerImageView release];
  [spinnerImageView release];
  [super dealloc];
}
@end
