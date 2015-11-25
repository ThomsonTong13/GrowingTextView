//
//  KeyboardView.m
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import "KeyboardView.h"
#import "PageControl.h"

#define dlColNum 4

#define dlSpaceWidth 25
#define dlSpaceHeight 20
#define dlLabelHeight 20

@interface KeyboardView () <UIScrollViewDelegate>
{
    NSArray *_titles;
    NSArray *_buttons;
    NSArray *_highLightedButtons;
}

@end

@implementation KeyboardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self initWithButtons];
    }

    return self;
}

- (void)initWithButtons
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;

    [self addSubview:_scrollView];

    _pageControl = [[PageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.imagePageStateNormal = [UIImage imageNamed:@"page_normal"];
    _pageControl.imagePageStateHighlighted = [UIImage imageNamed:@"page_highlight"];
    [_pageControl addTarget:self
                     action:@selector(pageControlValueChanged)
           forControlEvents:UIControlEventValueChanged];

    [self addSubview:_pageControl];

    _titles = @[@"照片",
                @"拍照",
                @"位置",
                @"群通知",
                @"集合点"
                ];

    _buttons = [NSArray arrayWithObjects:
                @"chat_photo",
                @"chat_camera",
                @"chat_position",
                @"chat_notification",
                @"chat_assembly",
                nil];

    _highLightedButtons = [NSArray arrayWithObjects:
                           @"chat_photo_press",
                           @"chat_camera_press",
                           @"chat_position_press",
                           @"chat_notification_press",
                           @"chat_assembly_press",
                           nil];

    _scrollView.contentSize = CGSizeMake(self.frame.size.width * (_buttons.count / 9 + 1), self.frame.size.height);
    _pageControl.numberOfPages = _buttons.count / 9 + 1;

    int w = (self.frame.size.width - 5*dlSpaceWidth) / 4;
    int w1 = 10;

    for (int i = 0; i < _buttons.count; i ++)
    {
        int y = i % 8;

        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];

        but.backgroundColor = [UIColor clearColor];
        but.frame = CGRectMake(self.frame.size.width * (i/8) + dlSpaceWidth * (i%4 + 1) + w*(i%4), dlSpaceHeight*(y/4 + 1) + w*(y/4) + dlLabelHeight*(y/4), w, w);
        but.tag = i + 1;
        [but setImage:[UIImage imageNamed:[_buttons objectAtIndex:i]]
             forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:[_highLightedButtons objectAtIndex:i]]
             forState:UIControlStateHighlighted];
        [but addTarget:self
                action:@selector(buttonSelectedAtIndex:)
      forControlEvents:UIControlEventTouchUpInside];

        [_scrollView addSubview:but];

        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(but.frame.origin.x - w1, but.frame.origin.y + but.frame.size.height + 5, w + 2*w1, 20)];
        l.backgroundColor = [UIColor clearColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:13];
        l.text = [_titles objectAtIndex:i];

        [_scrollView addSubview:l];
    }

    [self performSelector:@selector(updatePageControll) withObject:nil afterDelay:0.2];
}

- (void)pageControlValueChanged
{
    NSInteger page = _pageControl.currentPage;
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;

    [_scrollView scrollRectToVisible:frame animated:YES];

    [_pageControl updateDots];
}

- (void)updatePageControll
{
    [_pageControl updateDots];
}

- (void)buttonSelectedAtIndex:(id)sender
{
    UIButton *but = (UIButton *)sender;

    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedKeyBoardViewButtonIndex:)])
    {
        [self.delegate didSelectedKeyBoardViewButtonIndex:but.tag - 1];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    currentIndex = scrollView.contentOffset.x / self.frame.size.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = currentIndex;

    [_pageControl updateDots];
}

@end
