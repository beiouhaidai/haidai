//
//  PHDWallPostsTableViewController.m
//  Haidai
//
//  Copyright (c) 2014 Parse Inc. All rights reserved.
//

#import "PHDWallPostsTableViewController.h"

#import "PHDConstants.h"
#import "PHDPost.h"
#import "PHDPostTableViewCell.h"

static NSUInteger const PHDWallPostsTableViewMainSection = 0;

@interface PHDWallPostsTableViewController ()

@property (nonatomic, strong) UIButton *noDataButton;

@end

@implementation PHDWallPostsTableViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // The className to query on
        self.parseClassName = PHDParsePostsClassName;

        // The key of the PFObject to display in the label of the default cell style
        self.textKey = PHDParsePostTextKey;

        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;

        // The number of objects to show per page
        self.objectsPerPage = PHDWallPostsSearchDefaultLimit;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(distanceFilterDidChange:) name:PHDFilterDistanceDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:PHDCurrentLocationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postWasCreated:) name:PHDPostCreatedNotification object:nil];
    }
    return self;
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PHDFilterDistanceDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PHDCurrentLocationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PHDPostCreatedNotification object:nil];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorColor = self.view.backgroundColor;
    self.refreshControl.tintColor = [UIColor colorWithRed:118.0f/255.0f green:117.0f/255.0f blue:117.0f/255.0f alpha:1.0f];

    // Set up a view for empty content
    self.noDataButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.noDataButton setTintColor:[UIColor colorWithRed:43.0f/255.0f green:181.0f/255.0f blue:46.0f/255.0f alpha:1.0f]];
    [self.noDataButton setTitle:@"Be the first to post in this area." forState:UIControlStateNormal];
    [self.noDataButton addTarget:self.parentViewController
                          action:@selector(postButtonSelected:)
                forControlEvents:UIControlEventTouchUpInside];
    self.noDataButton.hidden = YES;
    [self.view addSubview:self.noDataButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    const CGRect bounds = self.view.bounds;

    CGRect noDataButtonFrame = CGRectZero;
    noDataButtonFrame.size = [self.noDataButton sizeThatFits:bounds.size];
    noDataButtonFrame.origin.x = CGRectGetMidX(bounds) - CGRectGetMidX(noDataButtonFrame);
    noDataButtonFrame.origin.y = 20.0f;
    self.noDataButton.frame = noDataButtonFrame;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark -
#pragma mark PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];

    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];

    self.noDataButton.hidden = ([self.objects count] != 0);
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    // Query for posts near our current location.

    // Get our current location:
    CLLocation *currentLocation = [self.dataSource currentLocationForWallPostsTableViewController:self];
    CLLocationAccuracy filterDistance = [[NSUserDefaults standardUserDefaults] doubleForKey:PHDUserDefaultsFilterDistanceKey];

    // And set the query to look by location
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude
                                               longitude:currentLocation.coordinate.longitude];
    [query whereKey:PHDParsePostLocationKey nearGeoPoint:point withinKilometers:PHDMetersToKilometers(filterDistance)];
    [query includeKey:PHDParsePostUserKey];

    return query;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    PHDPostTableViewCellStyle cellStyle = PHDPostTableViewCellStyleLeft;
    if ([object[PHDParsePostUserKey][PHDParsePostUsernameKey] isEqualToString:[[PFUser currentUser] username]]) {
        cellStyle = PHDPostTableViewCellStyleRight;
    }

    NSString *reuseIdentifier = nil;
    switch (cellStyle) {
        case PHDPostTableViewCellStyleLeft:
        {
            static NSString *leftCellIdentifier = @"left";
            reuseIdentifier = leftCellIdentifier;
        }
            break;
        case PHDPostTableViewCellStyleRight:
        {
            static NSString *rightCellIdentifier = @"right";
            reuseIdentifier = rightCellIdentifier;
        }
            break;
    }

    PHDPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[PHDPostTableViewCell alloc] initWithPostTableViewCellStyle:cellStyle
                                                            reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    PHDPost *post = [[PHDPost alloc] initWithPFObject:object];
    [cell updateFromPost:post];

    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForNextPageAtIndexPath:indexPath];
    cell.textLabel.font = [cell.textLabel.font fontWithSize:PHDPostTableViewCellLabelsFontSize];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // call super because we're a custom subclass.
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Account for the load more cell at the bottom of the tableview if we hit the pagination limit:
    if (indexPath.row >= [self.objects count]) {
        return [tableView rowHeight];
    }

    // Retrieve the text and username for this row:
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    PHDPost *post = [[PHDPost alloc] initWithPFObject:object];

    return [PHDPostTableViewCell sizeThatFits:tableView.bounds.size forPost:post].height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = self.view.backgroundColor;
}

#pragma mark -
#pragma mark PHDWallViewControllerSelection

- (void)highlightCellForPost:(PHDPost *)post {
    // Find the cell matching this object.
    NSUInteger index = 0;
    for (PFObject *object in [self objects]) {
        PHDPost *postFromObject = [[PHDPost alloc] initWithPFObject:object];
        if ([post isEqual:postFromObject]) {
            // We found the object, scroll to the cell position where this object is.
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:PHDWallPostsTableViewMainSection];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

            return;
        }
        index++;
    }

    // Don't scroll for posts outside the search radius.
    if (![post.title isEqualToString:kPHDWallCantViewPost]) {
        // We couldn't find the post, so scroll down to the load more cell.
        NSUInteger rows = [self.tableView numberOfRowsInSection:PHDWallPostsTableViewMainSection];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(rows - 1) inSection:PHDWallPostsTableViewMainSection];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)unhighlightCellForPost:(PHDPost *)post {
    // Deselect the post's row.
    NSUInteger index = 0;
    for (PFObject *object in [self objects]) {
        PHDPost *postFromObject = [[PHDPost alloc] initWithPFObject:object];
        if ([post isEqual:postFromObject]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

            return;
        }
        index++;
    }
}

#pragma mark -
#pragma mark Notifications

- (void)distanceFilterDidChange:(NSNotification *)note {
    [self loadObjects];
}

- (void)locationDidChange:(NSNotification *)note {
    [self loadObjects];
}

- (void)postWasCreated:(NSNotification *)note {
    [self loadObjects];
}

@end
