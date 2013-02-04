//
//  FlickrPlacesTableViewController.m
//  FlickrTopPlaces
//
//  Created by Bob Gardner on 1/23/13.
//  Copyright (c) 2013 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import "FlickrPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrRecentPhotosInCityTVC.h"

@interface FlickrPlacesTableViewController ()
@property (strong, nonatomic) NSArray *topPlaces;
@property (strong, nonatomic) NSDictionary *currentPlace;
@end

@implementation FlickrPlacesTableViewController

@synthesize topPlaces = _topPlaces;
@synthesize currentPlace = _currentPlace;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSArray *)topPlaces {
    if (!_topPlaces) {
        NSArray *unSortedPlaces = [FlickrFetcher topPlaces];
        NSArray *sortedPlaces = [unSortedPlaces sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(NSDictionary*)a objectForKey:FLICKR_PLACE_NAME];
            NSString *second = [(NSDictionary*)b objectForKey:FLICKR_PLACE_NAME];
            return [first compare:second];
        }];
        
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (int i = 0; i < sortedPlaces.count; i++) {
            NSDictionary *place = [sortedPlaces objectAtIndex:i];
            
            NSString *country  = [self getCountryNameForPlace:place];
            NSLog(@"%@", country);
            NSMutableArray *placesInCountry;
            for (int j = 0; j < result.count; j++) {
                NSArray *currentArray = [result objectAtIndex:j];
                if ([country isEqualToString:[self getCountryNameForPlace:[currentArray objectAtIndex:0]]]) {
                    placesInCountry = [[result objectAtIndex:j] mutableCopy];
                    [result removeObjectAtIndex:j];
                }
            }
            if (!placesInCountry) placesInCountry = [[NSMutableArray alloc] init];
            [placesInCountry addObject:place];
            [result addObject:placesInCountry];
        }
        
        NSArray *sortedResult = [result sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [self getCountryNameForPlace:(NSDictionary*)[(NSArray*)a objectAtIndex:0]];
            NSString *second = [self getCountryNameForPlace:(NSDictionary*)[(NSArray*)b objectAtIndex:0]];
            return [first compare:second];
        }];
        
        NSLog(@"%@",sortedResult);
        _topPlaces = sortedResult;

    }
    return _topPlaces;
}

- (NSString *)getCountryNameForPlace:(NSDictionary *)place {
    NSString *location = [place objectForKey:FLICKR_PLACE_NAME];
    NSUInteger locationTitleSplit = [location rangeOfString:@"," options:NSBackwardsSearch].location;
    return [location substringFromIndex:locationTitleSplit + 2];
}

- (NSString *)getStateForPlace:(NSDictionary *)place {
    NSString *location = [place objectForKey:FLICKR_PLACE_NAME];
    
    // determine number of commas, if fewer than three, return "", else return state
    NSUInteger count = 0, length = [location length];
    NSRange range = NSMakeRange(0, length);
    while (range.location != NSNotFound) {
        range = [location rangeOfString:@"," options:0 range:range];
        if (range.location != NSNotFound) {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++;
        }
    }
    if (count == 1) return @"";
    NSUInteger startIndex = [location rangeOfString:@","].location;
    NSUInteger endIndex = [location rangeOfString:@"," options:NSBackwardsSearch].location;
    
    return [location substringWithRange:NSMakeRange(startIndex + 2, endIndex - startIndex - 2)];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.topPlaces.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *currentArray = [self.topPlaces objectAtIndex:section];
    return currentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Location Information";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSArray *currentCountry = [self.topPlaces objectAtIndex:indexPath.section];
    NSDictionary *place = [currentCountry objectAtIndex:indexPath.row];
    
    NSString *location = [place objectForKey:FLICKR_PLACE_NAME];
    NSUInteger startIndex = [location rangeOfString:@","].location;
    
    cell.textLabel.text = [location substringToIndex:startIndex];
    cell.detailTextLabel.text = [self getStateForPlace:place];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *currentCountry = [self.topPlaces objectAtIndex:section];
    return [self getCountryNameForPlace:[currentCountry objectAtIndex:0]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *currentCountry = [self.topPlaces objectAtIndex:indexPath.section];
    self.currentPlace = [currentCountry objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showPhotosTable" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhotosTable"]) {
        [segue.destinationViewController setPhotos:[FlickrFetcher photosInPlace:self.currentPlace maxResults:50]];
        
        // get the name of the city
        NSString *location =[self.currentPlace objectForKey:FLICKR_PLACE_NAME];
        NSUInteger locationTitleSplit = [location rangeOfString:@","].location;
        [segue.destinationViewController setCityName:[location substringToIndex:locationTitleSplit]];

    }
}

@end
