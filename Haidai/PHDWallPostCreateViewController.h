//
//  PHDWallPostCreateViewController.h
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHDWallPostCreateViewController;

@protocol PHDWallPostCreateViewControllerDataSource <NSObject>

- (CLLocation *)currentLocationForWallPostCrateViewController:(PHDWallPostCreateViewController *)controller;

@end

@interface PHDWallPostCreateViewController : UIViewController

@property (nonatomic, weak) id<PHDWallPostCreateViewControllerDataSource> dataSource;

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *characterCountLabel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *postButton;

- (IBAction)cancelPost:(id)sender;
- (IBAction)postPost:(id)sender;

@end
