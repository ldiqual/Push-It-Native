//
//  CategoryViewController.m
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController
@synthesize tableView;

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableViewArg 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // Identifier for retrieving reusable cells.
  static NSString *cellIdentifier = @"MyCellIdentifier";
  
  // Attempt to request the reusable cell.
  UITableViewCell *cell = [tableViewArg dequeueReusableCellWithIdentifier:cellIdentifier];
  
  // No cell available - create one.
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:cellIdentifier];
  }
  
  // Set the text of the cell to the row index.
  cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
  
  return cell;
}


#pragma mark -
#pragma mark UIViewController methods

- (id)init
{
  NSLog(@"CategoryViewController init");
  [self initWithNibName:@"CategoryView" bundle:nil];
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc {
    [tableView release];
    [super dealloc];
}
@end
