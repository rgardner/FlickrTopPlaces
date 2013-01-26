//
//  FlickrPhotoViewController.m
//  FlickrTopPlaces
//
//  Created by Bob Gardner on 1/25/13.
//  Copyright (c) 2013 edu.stanford.cs193p.rhg259. All rights reserved.
//

#import "FlickrPhotoViewController.h"

@interface FlickrPhotoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation FlickrPhotoViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize image = _image;
@synthesize imageTitle = _imageTitle;

// TODO: Perform geometry calculations on the scrollView's bounds and the image's size
// FIX: UIScrollView doesn't scroll when initialized
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.imageTitle;
    self.imageView.image = self.image;
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
