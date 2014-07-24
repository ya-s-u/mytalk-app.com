//
//  PagingScrollView.m
//  app
//
//  Created by MasanariKamoshita on 2014/07/18.
//  Copyright (c) 2014年 MasanariKamoshita. All rights reserved.
//

#import "PagingScrollView.h"

@implementation PagingScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (UIView *subview in self.subviews) {
        if (CGRectContainsPoint(subview.frame, point))
            return subview;
    }
    return self;
}

@end
