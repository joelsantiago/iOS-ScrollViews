//
//  ScrollViewContainer.m
//  ScrollViews
//
//  Created by Joel Santiago on 3/20/14.
//  Copyright (c) 2014 Joel Santiago. All rights reserved.
//

#import "ScrollViewContainer.h"

@implementation ScrollViewContainer

@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return _scrollView;
    }
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
