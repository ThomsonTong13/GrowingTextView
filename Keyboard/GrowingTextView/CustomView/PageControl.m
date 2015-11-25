//
//  PageControl.m
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import "PageControl.h"

@implementation PageControl

- (void)setImagePageStateNormal:(UIImage *)image
{
    _imagePageStateNormal = image;

    [self updateDots];
}

- (void)setImagePageStateHighlighted:(UIImage *)image
{
    _imagePageStateHighlighted = image;

    [self updateDots];
}

- (void)updateDots
{
    NSArray *subview = self.subviews;

    for (NSInteger i = 0; i < [subview count]; i++)
    {
        self.pageIndicatorTintColor = [UIColor colorWithRed:(197.0f / 255.0f) green:(199.0f / 255.0f) blue:(205.0f / 255.0f) alpha:1.0f];
        self.currentPageIndicatorTintColor = [UIColor colorWithRed:(254.0f/ 255.0f) green:(12.0f / 255.0f) blue:(0.0f / 255.0f) alpha:1.0f];
    }
}

@end
