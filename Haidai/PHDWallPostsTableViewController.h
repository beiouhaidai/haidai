//
//  PHDWallPostsTableViewController.h
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

#import "PHDWallViewController.h"

@class PHDWallPostsTableViewController;

@protocol PHDWallPostsTableViewControllerDataSource <NSObject>

- (CLLocation *)currentLocationForWallPostsTableViewController:(PHDWallPostsTableViewController *)controller;

@end

@interface PHDWallPostsTableViewController : PFQueryTableViewController <PHDWallViewControllerHighlight>

@property (nonatomic, weak) id<PHDWallPostsTableViewControllerDataSource> dataSource;

@end
