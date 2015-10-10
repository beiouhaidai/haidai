//
//  PHDWallViewController.h
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class PHDWallViewController;

@protocol PHDWallViewControllerDelegate <NSObject>

- (void)wallViewControllerWantsToPresentSettings:(PHDWallViewController *)controller;

@end

@class PHDPost;

@interface PHDWallViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) id<PHDWallViewControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

- (IBAction)postButtonSelected:(id)sender;

@end

@protocol PHDWallViewControllerHighlight <NSObject>

- (void)highlightCellForPost:(PHDPost *)post;
- (void)unhighlightCellForPost:(PHDPost *)post;

@end
