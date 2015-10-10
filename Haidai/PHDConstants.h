//
//  PHDConstants.h
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#ifndef Haidai_PHDConstants_h
#define Haidai_PHDConstants_h

static double PHDFeetToMeters(double feet) {
    return feet * 0.3048;
}

static double PHDMetersToFeet(double meters) {
    return meters * 3.281;
}

static double PHDMetersToKilometers(double meters) {
    return meters / 1000.0;
}

static double const PHDDefaultFilterDistance = 1000.0;
static double const PHDWallPostMaximumSearchDistance = 100.0; // Value in kilometers

static NSUInteger const PHDWallPostsSearchDefaultLimit = 20; // Query limit for pins and tableviewcells

// Parse API key constants:
static NSString * const PHDParsePostsClassName = @"Posts";
static NSString * const PHDParsePostUserKey = @"user";
static NSString * const PHDParsePostUsernameKey = @"username";
static NSString * const PHDParsePostTextKey = @"text";
static NSString * const PHDParsePostLocationKey = @"location";
static NSString * const PHDParsePostNameKey = @"name";

// NSNotification userInfo keys:
static NSString * const kPHDFilterDistanceKey = @"filterDistance";
static NSString * const kPHDLocationKey = @"location";

// Notification names:
static NSString * const PHDFilterDistanceDidChangeNotification = @"PHDFilterDistanceDidChangeNotification";
static NSString * const PHDCurrentLocationDidChangeNotification = @"PHDCurrentLocationDidChangeNotification";
static NSString * const PHDPostCreatedNotification = @"PHDPostCreatedNotification";

// UI strings:
static NSString * const kPHDWallCantViewPost = @"Can’t view post! Get closer.";

// NSUserDefaults
static NSString * const PHDUserDefaultsFilterDistanceKey = @"filterDistance";

typedef double PHDLocationAccuracy;

#endif // Haidai_PHDConstants_h
