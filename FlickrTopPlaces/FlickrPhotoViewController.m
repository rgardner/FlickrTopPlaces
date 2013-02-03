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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.image;

    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    
    self.navigationItem.title = self.imageTitle;
}

- (void)viewWillLayoutSubviews {
    float widthRatio = self.view.bounds.size.width / self.imageView.image.size.width;
    
    float heightRatio = self.view.bounds.size.height / self.imageView.image.size.height;
    
    self.scrollView.zoomScale = MAX(widthRatio, heightRatio);
}

- (void)viewDidAppear:(BOOL)animated {
    [self.scrollView flashScrollIndicators];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
