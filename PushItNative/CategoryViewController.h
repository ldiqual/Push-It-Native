//
//  CategoryViewController.h
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate> {
  NSDictionary *results;
  NSString *currentCategory;
  
  NSString *categoriesName[4];
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;

- (id)initWithResults:(NSDictionary *)resultsDic;

@end
