//
//  FlickrPlacesTableViewController.m
//  FlickrTopPlaces
//
//  Created by Bob Gardner on 1/23/13.
//  Copyright (c) 2013 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import "FlickrPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoTVC.h"

@interface FlickrPlacesTableViewController ()
@property (strong, nonatomic) NSArray *topPlaces; // Top photo locations on Flickr
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
        _topPlaces = [unSortedPlaces sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [(NSDictionary*)a objectForKey:@"_content"];
            NSString *second = [(NSDictionary*)b objectForKey:@"_content"];
            return [first compare:second];
        }];
        
    }
    return _topPlaces;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Location Information";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *place = [self.topPlaces objectAtIndex:indexPath.row];
    NSString *location = [place objectForKey:@"_content"];
    NSUInteger locationTitleSplit = [location rangeOfString:@","].location;
    cell.textLabel.text = [location substringToIndex:locationTitleSplit];
    cell.detailTextLabel.text = [location substringFromIndex:locationTitleSplit + 2];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentPlace = [self.topPlaces objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showPhotosTable" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhotosTable"]) {
        [segue.destinationViewController setPhotos:[FlickrFetcher photosInPlace:self.currentPlace maxResults:50]];
    }
}

@end
