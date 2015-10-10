//
//  PHDLoginViewController.h
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHDLoginViewController;

@protocol PHDLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(PHDLoginViewController *)controller;

@end

@interface PHDLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id<PHDLoginViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@end
