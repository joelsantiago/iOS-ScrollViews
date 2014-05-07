//
//  PagedScrollViewController.m
//  ScrollViews
//
//  Created by Joel Santiago on 3/19/14.
//  Copyright (c) 2014 Joel Santiago. All rights reserved.
//

#import "PagedScrollViewController.h"

@interface PagedScrollViewController ()
@property (nonatomic, strong) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end

@implementation PagedScrollViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

@synthesize pageImages = _pageImages;
@synthesize pageViews = _pageViews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadPage:(NSInteger)page {
    
    if (page < 0 || page >= self.pageImages.count) {
        // If outside of the range of image array, return
        return;
    }
    
    // Check if view is already loaded
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull *)pageView == [NSNull null]) {
        
        // Create page bounds
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        // Create UIImageView and add to scroll view
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.pageImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        
        // Replace null object in array with pageView with image
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)purgePage:(NSInteger)page {
    
    if (page < 0 || page >= self.pageImages.count) {
        // If outside of the range of image array, return
        return;
    }
    
    // Remove a page from the scrollView and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull *)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadVisiblePages {
    
    // Determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update page control
    self.pageControl.currentPage = page;
    
    // Figure out which pages are loading
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i = 0; i < firstPage; i++) {
        [self purgePage:i];
    }
    
    // Load pages in range
    for (NSInteger i = firstPage; i < lastPage; i++) {
        [self loadPage:i];
    }
    
    // Purge anything after the last page
    for (NSInteger i = lastPage + 1; i < self.pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // Load pages that are visible on screen
    [self loadVisiblePages];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Set page images and page count variable
    self.pageImages = [NSArray arrayWithObjects:
                        [UIImage imageNamed:@"photo1.png"],
                        [UIImage imageNamed:@"photo2.png"],
                        [UIImage imageNamed:@"photo3.png"],
                        [UIImage imageNamed:@"photo4.png"],
                        [UIImage imageNamed:@"photo5.png"],
                        nil];
    
    NSInteger pageCount = self.pageImages.count;
    
    // Set current page and total number of pages for page controls
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // Init pageViews array and fill with null objects
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // set scrollView content size to horizontal width of scrollView width * image count and height to scrollView height
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // method call to load pages
    [self loadVisiblePages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
