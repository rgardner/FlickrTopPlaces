//
//  FlickrPhotoTVC.m
//  FlickrTopPlaces
//
//  Created by Bob Gardner on 1/24/13.
//  Copyright (c) 2013 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import "FlickrRecentPhotosInCity.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoViewController.h"

@interface FlickrRecentPhotosInCity ()
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSString *selectedImageTitle;
@property (nonatomic, strong) NSString *segueIdentifier;
@property (nonatomic, strong) NSString *cellIdentifier;
@end

@implementation FlickrRecentPhotosInCity

@synthesize photos = _photos;
@synthesize cityName = _cityName;
@synthesize selectedImage = _selectedImage;
@synthesize selectedImageTitle = _selectedImageTitle;
@synthesize segueIdentifier = _segueIdentifier;
@synthesize cellIdentifier = _cellIdentifier;

- (NSString *)cellIdentifier {
    if (!_cellIdentifier) _cellIdentifier = @"City Photo Information";
    return _cellIdentifier;
}

- (NSString *)segueIdentifier {
    if (!_segueIdentifier) _segueIdentifier = @"Show photo from city";
    return _segueIdentifier;
}

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
    self.navigationItem.title = self.cityName;
}

- (void)storePhotoInNSUserDefaults:(NSDictionary *)photo {
    // store id, title, description, and url in NSUserDefaults
    // create dict with photo info
    NSArray *keys = @[@"id", @"title", @"description"];
    NSArray *values = @[[photo objectForKey:@"id"], [photo objectForKey:@"title"], [photo objectForKey:@"description"]];
    NSDictionary *photoInfo = [NSDictionary dictionaryWithObjects:keys forKeys:values];
    
    NSMutableArray *history = [[[NSUserDefaults standardUserDefaults] objectForKey:@"history"] mutableCopy];
    
    // removes photo from recent if previously seen
    for (int i = 0;  i < history.count; i++) {
        NSDictionary *recentPhoto = [history objectAtIndex:i];
        if (![[recentPhoto objectForKey:@"id"] isEqualToString:[photoInfo objectForKey:@"id"]]) continue;
        [history removeObjectAtIndex:i];
        break;
    }
    
    // add photo dictionary to the zero index of the array
    [history insertObject:photoInfo atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:[history copy] forKey:@"history"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = self.cellIdentifier;
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
    NSString *description = [photo valueForKeyPath:@"description._content"];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get title and image
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    self.selectedImageTitle = [[self formatTitleAndDescriptionOfPhoto:photo] objectForKey:@"title"];
    self.selectedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatOriginal]]];
    
    [self storePhotoInNSUserDefaults:photo];
    
    [self performSegueWithIdentifier:self.segueIdentifier sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:self.segueIdentifier]) {
        [segue.destinationViewController setImageTitle:self.selectedImageTitle];
        [segue.destinationViewController setImage:self.selectedImage];
    }
}

@end
