//
//  PageControl.h
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageControl : UIPageControl

@property (nonatomic, strong) UIImage *imagePageStateNormal;
@property (nonatomic, strong) UIImage *imagePageStateHighlighted;

- (void)updateDots;
- (void)setImagePageStateNormal:(UIImage *)image;
- (void)setImagePageStateHighlighted:(UIImage *)image;

@end
