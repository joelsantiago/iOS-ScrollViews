//
//  PeekPagedScrollViewController.h
//  ScrollViews
//
//  Created by Joel Santiago on 3/20/14.
//  Copyright (c) 2014 Joel Santiago. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeekPagedScrollViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@end
