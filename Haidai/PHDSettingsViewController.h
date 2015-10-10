//
//  PHDSettingsViewController.h
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHDSettingsViewController;

@protocol PHDSettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidLogout:(PHDSettingsViewController *)controller;

@end

@interface PHDSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) id<PHDSettingsViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
