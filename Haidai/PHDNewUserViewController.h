//
//  PHDNewUserViewController.h
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHDNewUserViewController;

@protocol PHDNewUserViewControllerDelegate <NSObject>

- (void)newUserViewControllerDidSignup:(PHDNewUserViewController *)controller;

@end

@interface PHDNewUserViewController : UIViewController

@property (nonatomic, weak) id<PHDNewUserViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *passwordAgainField;

@end
