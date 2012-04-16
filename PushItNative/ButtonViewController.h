//
//  ButtonViewController.h
//  PushItNative
//
//  Created by Loïs Di Qual on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonViewController : UIViewController {
  BOOL buttonPressed;
}
@property (retain, nonatomic) IBOutlet UIImageView *buttonImageView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinnerImageView;

@end
