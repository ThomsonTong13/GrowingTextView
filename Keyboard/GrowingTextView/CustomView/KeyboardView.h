//
//  KeyboardView.h
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageControl;
@protocol KeyboardViewDelegate;

@interface KeyboardView : UIView
{
    NSInteger currentIndex;
}

@property (nonatomic, strong) PageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) id<KeyboardViewDelegate> delegate;

@end


@protocol KeyboardViewDelegate <NSObject>
- (void)didSelectedKeyBoardViewButtonIndex:(NSInteger)index;
@end