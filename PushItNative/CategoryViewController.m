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
@synthesize tabBar;

#pragma mark -
#pragma mark Custom methods

- (id)initWithResults:(NSDictionary *)resultsDic
{
  results = resultsDic;
  currentCategory = @"restaurant";
  NSLog(@"CategoryViewController init");
  [self initWithNibName:@"CategoryView" bundle:nil];
  
  categoriesName[0] = @"restaurant";
  categoriesName[1] = @"movie_theater";
  categoriesName[2] = @"shopping";
  categoriesName[3] = @"cafe";
  
  return self;
}

- (void)updateBadges {
  for (int i=0; i<[tabBar.items count]; i++) {
    UITabBarItem *item = [tabBar.items objectAtIndex:i];
    int count = [[results objectForKey:categoriesName[i]] count];
    [item setBadgeValue:[NSString stringWithFormat:@"%d", count]];
  }
}

#pragma mark -
#pragma mark UITabBarDelegate methods

- (void)tabBar:(UITabBar *)tabBarArg didSelectItem:(UITabBarItem *)item 
{ 
  [tabBar setSelectedItem:[tabBar.items objectAtIndex:item.tag]];
  currentCategory = categoriesName[item.tag];
  [tableView reloadData];
  NSLog(@"Tab selected: %@", currentCategory);
} 


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [[results objectForKey:currentCategory] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableViewArg 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSDictionary *place = [[results objectForKey:currentCategory] objectAtIndex:[indexPath indexAtPosition:1]];

  NSString *cellIdentifier = [place objectForKey:@"id"];  
  UITableViewCell *cell = [tableViewArg dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:cellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [place objectForKey:@"name"];
  }
  
  // Set the text of the cell to the row index.
  //= [NSString stringWithFormat:@"%d", [indexPath indexAtPosition:0]];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *place = [[results objectForKey:currentCategory] objectAtIndex:[indexPath indexAtPosition:1]];
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:place,@"place", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"placeChosen"
                                                      object:nil
                                                    userInfo:userInfo];
}

#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad
{
  [super viewDidLoad];
  [tabBar setSelectedItem:[tabBar.items objectAtIndex:0]];
  [self updateBadges];
}

- (void)viewDidUnload
{
  [self setTableView:nil];
  [self setTabBar:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tableView release];
  [tabBar release];
    [super dealloc];
}
@end
