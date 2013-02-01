//
//  FlickrPhotoTVC.h
//  FlickrTopPlaces
//
//  Created by Bob Gardner on 1/24/13.
//  Copyright (c) 2013 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrRecentPhotosInCityTVC : UITableViewController
@property (nonatomic, strong) NSArray *photos; // sent from FlickrPlacesTableViewController
@property (nonatomic, strong) NSString *cityName; // to give the name of the Navigation Controller
@property (nonatomic, readwrite, retain) NSString *segueIdentifier; // so subclasses can change it
@property (nonatomic, readwrite) BOOL shouldStorePhoto; // used in didSelectRowAtIndexPath
@end
