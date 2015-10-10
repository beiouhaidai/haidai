//
//  PHDPost.m
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import "PHDPost.h"

#import "PHDConstants.h"

@interface PHDPost ()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, assign) MKPinAnnotationColor pinColor;

@end

@implementation PHDPost

#pragma mark -
#pragma mark Init

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                          andTitle:(NSString *)title
                       andSubtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

- (instancetype)initWithPFObject:(PFObject *)object {
    PFGeoPoint *geoPoint = object[PHDParsePostLocationKey];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    NSString *title = object[PHDParsePostTextKey];
    NSString *subtitle = object[PHDParsePostUserKey][PHDParsePostNameKey] ?: object[PHDParsePostUserKey][PHDParsePostUsernameKey];

    self = [self initWithCoordinate:coordinate andTitle:title andSubtitle:subtitle];
    if (self) {
        self.object = object;
        self.user = object[PHDParsePostUserKey];
    }
    return self;
}

#pragma mark -
#pragma mark Equal

- (BOOL)isEqual:(id)other {
    if (![other isKindOfClass:[PHDPost class]]) {
        return NO;
    }

    PHDPost *post = (PHDPost *)other;

    if (post.object && self.object) {
        // We have a PFObject inside the PHDPost, use that instead.
        return [post.object.objectId isEqualToString:self.object.objectId];
    }

    // Fallback to properties
    return ([post.title isEqualToString:self.title] &&
            [post.subtitle isEqualToString:self.subtitle] &&
            post.coordinate.latitude == self.coordinate.latitude &&
            post.coordinate.longitude == self.coordinate.longitude);
}

#pragma mark -
#pragma mark Accessors

- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside {
    if (outside) {
        self.title = kPHDWallCantViewPost;
        self.subtitle = nil;
        self.pinColor = MKPinAnnotationColorRed;
    } else {
        self.title = self.object[PHDParsePostTextKey];
        self.subtitle = self.object[PHDParsePostUserKey][PHDParsePostNameKey] ?:
        self.object[PHDParsePostUserKey][PHDParsePostUsernameKey];
        self.pinColor = MKPinAnnotationColorGreen;
    }
}

@end
