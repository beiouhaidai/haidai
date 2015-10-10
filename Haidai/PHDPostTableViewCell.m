//
//  PHDPostTableViewCell.m
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import "PHDPostTableViewCell.h"

#import "PHDPost.h"

CGFloat const PHDPostTableViewCellLabelsFontSize = 15.0f;

static CGFloat const PHDPostTableViewCellBackgroundImageLeadingSideInset = 5.5f;

static UIEdgeInsets const PHDPostTableViewCellContentInset = {.top = 5.0f, .left = 0.0f, .bottom = 1.0f, .right = 0.0f};
static UIEdgeInsets const PHDPostTableViewCellTextContentInset = {.top = 6.0f, .left = 10.5f, .bottom = 5.0f, .right = 10.5f};

static CGFloat const PHDPostTableViewCellDetailTextLabelTopInset = 3.0f;

@interface PHDPostTableViewCell ()
{
    UIImageView *_backgroundImageView;
}

@property (nonatomic, assign, readwrite) PHDPostTableViewCellStyle postTableViewCellStyle;

@end

@implementation PHDPostTableViewCell

#pragma mark -
#pragma mark Class

+ (CGSize)sizeThatFits:(CGSize)boundingSize forPost:(PHDPost *)post {
    CGRect bounds = CGRectMake(0.0f, 0.0f, boundingSize.width, boundingSize.height);
    bounds = UIEdgeInsetsInsetRect(bounds, PHDPostTableViewCellContentInset);
    bounds = UIEdgeInsetsInsetRect(bounds, PHDPostTableViewCellTextContentInset);
    boundingSize = bounds.size;

    NSString *text = post.title;
    NSString *username = post.subtitle;

    NSDictionary *textAttributes = @{ NSFontAttributeName : [self postTableViewCellStyleLabelsFont] };

    // Calculate what the frame to fit the post text and the username
    CGRect textRect = [text boundingRectWithSize:boundingSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:textAttributes
                                         context:nil];

    CGRect nameRect = [username boundingRectWithSize:boundingSize
                                             options:NSStringDrawingTruncatesLastVisibleLine
                                          attributes:textAttributes
                                             context:nil];

    CGSize size = CGSizeZero;
    size.width = ceilf(boundingSize.width +
                       PHDPostTableViewCellContentInset.left +
                       PHDPostTableViewCellContentInset.right +
                       PHDPostTableViewCellTextContentInset.left +
                       PHDPostTableViewCellTextContentInset.right);
    size.height = ceilf(CGRectGetHeight(textRect) +
                        CGRectGetHeight(nameRect) +
                        PHDPostTableViewCellContentInset.top +
                        PHDPostTableViewCellContentInset.bottom +
                        PHDPostTableViewCellDetailTextLabelTopInset +
                        PHDPostTableViewCellTextContentInset.top +
                        PHDPostTableViewCellTextContentInset.bottom);
    return size;
}

#pragma mark Private

+ (UIFont *)postTableViewCellStyleLabelsFont {
    return [UIFont systemFontOfSize:PHDPostTableViewCellLabelsFontSize];
}

+ (UIImage *)backgroundImageForPostTableViewCellStyle:(PHDPostTableViewCellStyle)style {
    switch (style) {
        case PHDPostTableViewCellStyleLeft:
            return [UIImage imageNamed:@"bubble_grey"];
            break;
        case PHDPostTableViewCellStyleRight:
            return [UIImage imageNamed:@"bubble_green"];
            break;
    }
    return nil;
}

+ (UIColor *)textLabelColorForPostTableViewCellStyle:(PHDPostTableViewCellStyle)style {
    switch (style) {
        case PHDPostTableViewCellStyleLeft:
            return [UIColor blackColor];
            break;
        case PHDPostTableViewCellStyleRight:
            return [UIColor whiteColor];
            break;
    }

    return nil;
}

+ (UIColor *)detailTextLabelColorForPostTableViewCellStyle:(PHDPostTableViewCellStyle)style {
    switch (style) {
        case PHDPostTableViewCellStyleLeft:
            return [UIColor colorWithRed:43.0f/255.0f green:181.0f/255.0f blue:46.0f/255.0f alpha:1.0f];
            break;
        case PHDPostTableViewCellStyleRight:
            return [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
            break;
    }

    return nil;
}

#pragma mark -
#pragma mark Init

- (instancetype)initWithPostTableViewCellStyle:(PHDPostTableViewCellStyle)style
                               reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        _postTableViewCellStyle = style;

        _backgroundImageView = [[UIImageView alloc] initWithImage:[[self class] backgroundImageForPostTableViewCellStyle:style]];
        [self.contentView addSubview:_backgroundImageView];

        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [[self class] postTableViewCellStyleLabelsFont];
        self.textLabel.textColor = [[self class] textLabelColorForPostTableViewCellStyle:style];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;

        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.font = [[self class] postTableViewCellStyleLabelsFont];
        self.detailTextLabel.textColor = [[self class] detailTextLabelColorForPostTableViewCellStyle:style];
    }
    return self;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];

    const CGRect bounds = UIEdgeInsetsInsetRect(self.contentView.bounds, PHDPostTableViewCellContentInset);
    CGRect textBounds = UIEdgeInsetsInsetRect(bounds, PHDPostTableViewCellTextContentInset);

    NSDictionary *textAttributes = @{ NSFontAttributeName : self.textLabel.font };

    // Set the cell element content sizes
    CGRect textLabelFrame = [self.textLabel.text boundingRectWithSize:textBounds.size
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:textAttributes
                                                              context:nil];
    textLabelFrame.origin.x += textBounds.origin.x;
    textLabelFrame.origin.y += textBounds.origin.y;
    self.textLabel.frame = CGRectIntegral(textLabelFrame);

    CGRect detailTextLabelFrame = [self.detailTextLabel.text boundingRectWithSize:textBounds.size
                                                                          options:NSStringDrawingTruncatesLastVisibleLine
                                                                       attributes:textAttributes
                                                                          context:nil];
    detailTextLabelFrame.origin.x += textBounds.origin.x;
    detailTextLabelFrame.origin.y += CGRectGetMaxY(textLabelFrame) + PHDPostTableViewCellDetailTextLabelTopInset;
    self.detailTextLabel.frame = CGRectIntegral(detailTextLabelFrame);

    CGRect backgroundImageViewFrame = bounds;
    backgroundImageViewFrame.origin.x += (self.postTableViewCellStyle == PHDPostTableViewCellStyleLeft ?
                                          0.0f :
                                          PHDPostTableViewCellBackgroundImageLeadingSideInset);
	backgroundImageViewFrame.size.width -= PHDPostTableViewCellBackgroundImageLeadingSideInset;
    _backgroundImageView.frame = backgroundImageViewFrame;
}

#pragma mark -
#pragma mark Update

- (void)updateFromPost:(PHDPost *)post {
    self.textLabel.text = post.title;
    self.detailTextLabel.text = post.subtitle;
    [self setNeedsLayout];
}

@end
