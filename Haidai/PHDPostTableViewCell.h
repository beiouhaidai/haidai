//
//  PHDPostTableViewCell.h
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const PHDPostTableViewCellLabelsFontSize;

typedef NS_ENUM(uint8_t, PHDPostTableViewCellStyle)
{
    PHDPostTableViewCellStyleLeft = 1,
    PHDPostTableViewCellStyleRight
};

@class PHDPost;

@interface PHDPostTableViewCell : UITableViewCell

@property (nonatomic, assign, readonly) PHDPostTableViewCellStyle postTableViewCellStyle;

+ (CGSize)sizeThatFits:(CGSize)boundingSize forPost:(PHDPost *)post;

- (instancetype)initWithPostTableViewCellStyle:(PHDPostTableViewCellStyle)style
                               reuseIdentifier:(NSString *)reuseIdentifier;

- (void)updateFromPost:(PHDPost *)post;

@end
