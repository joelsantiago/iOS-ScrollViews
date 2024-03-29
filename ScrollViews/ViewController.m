//
//  ViewController.m
//  ScrollViews
//
//  Created by Joel Santiago on 3/19/14.
//  Copyright (c) 2014 Joel Santiago. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;
@end

@implementation ViewController

@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;

// Keeps scrollView contents centered even when user zooms in
- (void)centerScrollViewContents {
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;

    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

// Detects double tap and zooms into location
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer {
    
    // Detect location tapped on image
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    // Calculate a zoom scale at 150% yet is capped at max zoom scale in viewDidLoad
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    // Using location tapped, create a CGRect that gets zoomed in on
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // Zoom into CGRect and animate the zoom transition
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

// Detects two finger tap and zooms out to minimum zoom scale
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recognizer {
    
    // Zoom out slightly, capped at minimum zoom specified by the scrollView
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

// Tell view that imageView will be zoomed in and out when pinched
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    // Return the view that you want to zoom
    return self.imageView;
}

// Re-centers the view so zoom appears natural
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    // The scroll view has zoomed, so re-center the contents
    [self centerScrollViewContents];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Create imageView, set imageView frame size and origin, and add imageView to scrollView
    UIImage *image = [UIImage imageNamed:@"photo1.png"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    [self.scrollView addSubview:self.imageView];
    
    // Set size of scrollView to the size of its content - image
    self.scrollView.contentSize = image.size;
    
    // Set up the two gesture recognizers
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Set zoom scale variables for the image applied, set minScale for scrollView
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    
    // Set max scrollView zoom scale and set initial zoom to minScale
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    // Center the image within the scrollView
    [self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
