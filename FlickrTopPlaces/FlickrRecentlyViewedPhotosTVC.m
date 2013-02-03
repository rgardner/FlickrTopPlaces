//
//  FlickrRecentlyViewedPhotosTVC.m
//  FlickrTopPlaces
//
//  Created by Bob Gardner on 1/27/13.
//  Copyright (c) 2013 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import "FlickrRecentlyViewedPhotosTVC.h"

@interface FlickrRecentlyViewedPhotosTVC ()

@end

@implementation FlickrRecentlyViewedPhotosTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self clearNSUserDefaults];
    [self setPhotos:[[NSUserDefaults standardUserDefaults] arrayForKey:@"history"]];
    [self setSegueIdentifier:@"Show photo from Recently Viewed"];
    [self setShouldStorePhoto:NO];
    self.navigationItem.title = @"Recently Viewed";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *newPhotos = [[NSUserDefaults standardUserDefaults] arrayForKey:@"history"];
    if ([newPhotos isEqualToArray:self.photos]) return;
    [self setPhotos:newPhotos];
    [self.tableView reloadData];
}

- (void)clearNSUserDefaults {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Photo Information";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    NSDictionary *photoTitleAndDescription = [self formatTitleAndDescriptionOfPhoto:photo];
    cell.textLabel.text = [photoTitleAndDescription objectForKey:@"title"];
    cell.detailTextLabel.text = [photoTitleAndDescription objectForKey:@"description"];
    return cell;
}

- (NSDictionary *)formatTitleAndDescriptionOfPhoto:(NSDictionary *)photo {
    NSString *title = [photo objectForKey:@"title"];
    NSString *description = [photo objectForKey:@"description"];
    if ([title isEqualToString:@""]) {
        if ([description isEqualToString:@""]) {
            title = @"Unknown";
        } else {
            title = description;
            description = @"";
        }
    }
    return [NSDictionary dictionaryWithObjects:@[title, description] forKeys:@[@"title", @"description"]];
}

@end
