//
//  PHDAppDelegate.m
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import "PHDAppDelegate.h"

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "PHDConstants.h"
#import "PHDConfigManager.h"
#import "PHDLoginViewController.h"
#import "PHDSettingsViewController.h"
#import "PHDWallViewController.h"

#define APPLICATION_ID @"EuhW31pLOtYoSUGVYXfeMQII57AbQ1hVlz3szVxE"
#define CLIENT_KEY @"J5UmUpWbgkpGOSazgCojurkGs4xj7GZpLtDA1ogX"

@interface PHDAppDelegate ()
<PHDLoginViewControllerDelegate,
PHDWallViewControllerDelegate,
PHDSettingsViewControllerDelegate>

@end

@implementation PHDAppDelegate

#pragma mark -
#pragma mark UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // ****************************************************************************
    // Parse initialization
    [Parse setApplicationId:APPLICATION_ID clientKey:CLIENT_KEY];
    // ****************************************************************************

    // Set the global tint on the navigation bar
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:43.0f/255.0f green:181.0f/255.0f blue:46.0f/255.0f alpha:1.0f]];

    // Setup default NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:PHDUserDefaultsFilterDistanceKey] == nil) {
        // If we have no accuracy in defaults, set it to 1000 feet.
        [userDefaults setDouble:PHDFeetToMeters(PHDDefaultFilterDistance) forKey:PHDUserDefaultsFilterDistanceKey];
    }

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];

    if ([PFUser currentUser]) {
        // Present wall straight-away
        [self presentWallViewControllerAnimated:NO];
    } else {
        // Go to the welcome screen and have them log in or create an account.
        [self presentLoginViewController];
    }

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

	[[PHDConfigManager sharedManager] fetchConfigIfNeeded];

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark LoginViewController

- (void)presentLoginViewController {
    // Go to the welcome screen and have them log in or create an account.
    PHDLoginViewController *viewController = [[PHDLoginViewController alloc] initWithNibName:nil bundle:nil];
    viewController.delegate = self;
    [self.navigationController setViewControllers:@[ viewController ] animated:NO];
}

#pragma mark Delegate

- (void)loginViewControllerDidLogin:(PHDLoginViewController *)controller {
    [self presentWallViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark WallViewController

- (void)presentWallViewControllerAnimated:(BOOL)animated {
    PHDWallViewController *wallViewController = [[PHDWallViewController alloc] initWithNibName:nil bundle:nil];
    wallViewController.delegate = self;
    [self.navigationController setViewControllers:@[ wallViewController ] animated:animated];
}

#pragma mark Delegate

- (void)wallViewControllerWantsToPresentSettings:(PHDWallViewController *)controller {
    [self presentSettingsViewController];
}

#pragma mark -
#pragma mark SettingsViewController

- (void)presentSettingsViewController {
    PHDSettingsViewController *settingsViewController = [[PHDSettingsViewController alloc] initWithNibName:nil bundle:nil];
    settingsViewController.delegate = self;
    settingsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController presentViewController:settingsViewController animated:YES completion:nil];
}

#pragma mark Delegate

- (void)settingsViewControllerDidLogout:(PHDSettingsViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self presentLoginViewController];
}

@end
