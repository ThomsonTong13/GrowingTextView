//
//  Faceboard.m
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import "Faceboard.h"
#import "PageControl.h"
#import "EmojiUtility.h"
#import "KBUtility.h"

#define TSEMOJIVIEW_KEYTOP_WIDTH 50
#define TSEMOJIVIEW_KEYTOP_HEIGHT 50

#define ITEM_COLUMN  7
#define ITEM_ROW  3
#define IMAGE_SIZE  33
#define TWO_SIDE_GAP  10
#define TOP_SIDE_GAP  14
#define ROW_GAP  15

#define dlSpaceWidth 35
#define dlSpaceHeight 25

#define buttonWidth 40

#define faceBoardWidth ((self.frame.size.width - 5 * dlSpaceWidth) / 4)

@interface Faceboard () <UIScrollViewDelegate>

@end

@implementation Faceboard

- (void)initEmojiDataAndUi
{
    [self emojis];

    self.faceScrollView = [[LaunchScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 65)];

    if (_isFromPubSubView)
    {
        _faceScrollView.contentSize = CGSizeMake(1 * self.frame.size.width, self.frame.size.height - 65);
    }
    else
    {
        _faceScrollView.contentSize = CGSizeMake(2 * self.frame.size.width, self.frame.size.height - 65);
    }

    _faceScrollView.delegate = self;
    _faceScrollView.pagingEnabled = YES;
    _faceScrollView.scrollEnabled = YES;
    _faceScrollView.showsHorizontalScrollIndicator = NO;
    _faceScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:_faceScrollView];

    self.sutraScrollView = [[LaunchScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 65)];
    _sutraScrollView.contentSize = CGSizeMake(_page * self.frame.size.width, self.frame.size.height - 65);
    _sutraScrollView.delegate = self;
    _sutraScrollView.pagingEnabled = YES;
    _sutraScrollView.scrollEnabled = YES;
    _sutraScrollView.showsHorizontalScrollIndicator = NO;
    _sutraScrollView.backgroundColor = [UIColor clearColor];
    [_faceScrollView addSubview:_sutraScrollView];

    self.latelyScrollView = [[LaunchScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height - 65)];
    _latelyScrollView.contentSize = CGSizeMake(0, self.frame.size.height - 65);
    _latelyScrollView.delegate = self;
    _latelyScrollView.pagingEnabled = YES;
    _latelyScrollView.scrollEnabled = YES;
    _latelyScrollView.showsHorizontalScrollIndicator = NO;
    _latelyScrollView.backgroundColor = [UIColor clearColor];
    [_faceScrollView addSubview:_latelyScrollView];

    self.zoomImageBackgroudView = [[UIImageView alloc] init];
    [_zoomImageBackgroudView setImage:[UIImage imageNamed:@"keyboard_popup"]];
    _zoomImageView = [[UIImageView alloc] init];
    _zoomImageView.frame = CGRectMake(18, 5, 44, 44);
    [_zoomImageBackgroudView addSubview:_zoomImageView];
    [self addSubview:_zoomImageBackgroudView];

    self.pageControl = [[PageControl alloc] initWithFrame:CGRectMake(0, _faceScrollView.frame.size.height ,self.frame.size.width, 20)];
    _pageControl.imagePageStateNormal = [UIImage imageNamed:@"page_normal"];
    _pageControl.imagePageStateHighlighted = [UIImage imageNamed:@"page_highlight"];
    _pageControl.numberOfPages = _page;
    _pageControl.currentPage = 0;
    _pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:_pageControl];

    [self performSelector:@selector(updatePageControll) withObject:nil afterDelay:0.2];

    self.backgroundColor = [UIColor colorWithRed:(230.0/255.0) green:(230.0/255.0) blue:(230.0/255.0) alpha:1];

    [self setEmojiButton];
    [self setDownLoadEmojiButton];
    [self setBottomButton];
}

- (void)updatePageControll
{
    [_pageControl updateDots];
}

- (void)emojis
{
    self.emojiArray = [EmojiUtility EmojiNewIamges];
    self.symbolArray = [EmojiUtility EmojiNewNames];

    self.alatoyimages = [EmojiUtility alatoy_emoji];
    self.alatoyZHnames = [EmojiUtility alatoy_ZH_names];
    self.alatoyENnames = [EmojiUtility alatoy_EN_names];

    self.emojiImageViewArray = [NSMutableArray array];
    self.frame = _rect;

    _isFromGif = NO;

    if ([_emojiArray count] > 0)
    {
        _page = ([_emojiArray count] - 1) / (ITEM_COLUMN * ITEM_ROW) + 1;
    }
}

- (void)setEmojiButton
{
    float COLUNM_GAP = (self.frame.size.width - TWO_SIDE_GAP * 2 - ITEM_COLUMN * IMAGE_SIZE) / (ITEM_COLUMN + 1);
    if (COLUNM_GAP < 0) COLUNM_GAP = 0;

    for (int i = 0; i < [_emojiArray count]; i++)
    {
        int page = i / (ITEM_COLUMN * ITEM_ROW);
        float imageX = (i % ITEM_COLUMN) * IMAGE_SIZE + ((i % ITEM_COLUMN) + 1) * COLUNM_GAP + page * self.frame.size.width + TWO_SIDE_GAP;
        float imageY = ((i / ITEM_COLUMN) % ITEM_ROW) * (IMAGE_SIZE + ROW_GAP) + TOP_SIDE_GAP;

        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.backgroundColor = [UIColor clearColor];
        imgV.frame = CGRectMake(imageX, imageY, IMAGE_SIZE, IMAGE_SIZE);
        imgV.image = [UIImage imageNamed:[_emojiArray objectAtIndex:i]];

        [self.emojiImageViewArray addObject:imgV];
        [_sutraScrollView addSubview:imgV];
    }
}

- (void)setDownLoadEmojiButton
{
    int css =(self.frame.size.width -68*4)/5;

    for (int i = 0; i < [_alatoyimages count]; i++)
    {
        int page = i/(4*2);
        float x = css*(i%4+1)+68*(i%4) + page * self.frame.size.width;
        float y = ((i/4)%2)*(68+5)+10;
        UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, 68, 68);
        [button setImage:[UIImage imageNamed:[_alatoyimages objectAtIndex:i]]
                forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i+999;
        [button addTarget:self action:@selector(gifemoji:) forControlEvents:UIControlEventTouchUpInside];

        [_latelyScrollView addSubview:button];
    }
}

- (void)setBottomButton
{
    int sendButtonWidth = 60;

    self.buttomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - buttonWidth, self.frame.size.width - sendButtonWidth, buttonWidth)];
    _buttomView.backgroundColor = [UIColor whiteColor];
    _buttomView.pagingEnabled = YES;
    _buttomView.contentSize = CGSizeMake(self.frame.size.width - sendButtonWidth + 1, buttonWidth);
    _buttomView.showsHorizontalScrollIndicator = NO;
    _buttomView.showsVerticalScrollIndicator = NO;
    [self addSubview:_buttomView];

    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _buttomView.frame.origin.y, self.frame.size.width, 1)];
    lineImageView.backgroundColor = [UIColor lightGrayColor];

    float staraBtnOriginX = 0.0;

    self.sutraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sutraButton.frame = CGRectMake(0,0, 50, 40);
    _sutraButton.tag = 2;
    _sutraButton.backgroundColor = self.backgroundColor;
    [_sutraButton setImage:[UIImage imageNamed:@"emoji_cover"]
                  forState:UIControlStateNormal];
    [_sutraButton setTitleColor:[KBUtility HexColorToRedGreenBlue:@"#007aff"]
                       forState:UIControlStateNormal];
    [_sutraButton addTarget:self
                     action:@selector(sutraButtonPress:)
           forControlEvents:UIControlEventTouchUpInside];
    [_buttomView addSubview:_sutraButton];
    _sutraButton.imageEdgeInsets = UIEdgeInsetsMake(8,13,8,13);

    staraBtnOriginX = _sutraButton.frame.origin.x + _sutraButton.frame.size.width;

    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(self.frame.size.width - sendButtonWidth,
                                   _buttomView.frame.origin.y,
                                   sendButtonWidth,
                                   40);
    _sendButton.backgroundColor = [KBUtility HexColorToRedGreenBlue:@"#007aff"];
    [_sendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [_sendButton setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor lightGrayColor]
                      forState:UIControlStateHighlighted];
    [_sendButton setTitle:@"发送"
                 forState:UIControlStateNormal];
    [_sendButton addTarget:self
                    action:@selector(sendEmoji:)
          forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];
}

- (void)gifEmoji
{
    _isFromGif = YES;
    _page = ([_alatoyimages count]-1)/(4*2) + 1;
    _pageControl.numberOfPages = _page;
    _pageControl.currentPage = 0;
    _latelyScrollView.contentSize  = CGSizeMake(_page*self.frame.size.width, self.frame.size.height - 65);
    _latelyScrollView.contentOffset = CGPointMake(0, _latelyScrollView.frame.origin.y);
    _faceScrollView.contentOffset = CGPointMake(_faceScrollView.frame.size.width,_faceScrollView.frame.origin.y);

    [_sutraButton setBackgroundColor:[UIColor clearColor]];
}

- (void)gifemoji:(UIButton*)gif
{
    if ([self.delegate respondsToSelector:@selector(emojiView:didTouchEmojiWithImagename:andENname:andZHName:)])
    {
        [self.delegate emojiView:self
      didTouchEmojiWithImagename:_alatoyimages [gif.tag - 999]
                       andENname:_alatoyENnames[gif.tag - 999]
                       andZHName:_alatoyZHnames[gif.tag - 999]];
    }
}

- (void)sutraButtonPress:(id)sender
{
    [self sutraEmoji:NO];
}

- (void)sutraEmoji:(BOOL)ispage
{
    _isFromGif = NO;
    _page = ([_emojiArray count]-1) / (ITEM_COLUMN *ITEM_ROW) + 1;
    _pageControl.numberOfPages = _page;
    _pageControl.currentPage = ispage?_page:0;
    _sutraScrollView.contentOffset = CGPointMake(ispage?(_page-1)*_sutraScrollView.frame.size.width:0, _sutraScrollView.frame.origin.y);
    _faceScrollView.contentOffset = CGPointMake(0,_faceScrollView.frame.origin.y);

    [_sutraButton setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)latelyButtonPress:(id)sender
{
    [self gifEmoji];
}

- (void)sendEmoji:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiView:didTouchSendingButton:)])
    {
        [self.delegate emojiView:self didTouchSendingButton:button];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (_faceScrollView.contentOffset.x < 0.0 ||
        _faceScrollView.contentOffset.x > _faceScrollView.frame.size.width)
    {
        _faceScrollView.scrollEnabled = NO;
    }
    else
    {
        _faceScrollView.scrollEnabled = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _sutraScrollView)
    {
        _touchedIndex = 1000;
        _zoomImageBackgroudView.frame = CGRectZero;
        _zoomImageView.image = nil;
        int page = _sutraScrollView.contentOffset.x / _sutraScrollView.frame.size.width;
        _pageControl.currentPage = page;  //pagecontroll响应值的变化
    }
    else if (scrollView == _latelyScrollView)
    {
        int page = _latelyScrollView.contentOffset.x / _latelyScrollView.frame.size.width;
        _pageControl.currentPage = page;
    }
    else if (scrollView == _faceScrollView)
    {
        int page = _faceScrollView.contentOffset.x / _faceScrollView.frame.size.width;
        if (page == 0)
        {
            if (_isFromGif)
            {
                _isFromGif = NO;
                [self sutraEmoji:YES];
            }
        }
        else if (page == 1)
        {
            if (!_isFromGif)
            {
                _isFromGif = YES;
                [self gifEmoji];
            }
        }
    }

    [_pageControl updateDots];
}

- (void)updateWithIndex:(NSInteger)index
{
    if (index < _emojiArray.count)
    {
        _touchedIndex = index;
        NSInteger ind = index - _pageControl.currentPage * ITEM_COLUMN *ITEM_ROW;
        if (ind >= 0)
        {
            UIImageView *imgV = [_emojiImageViewArray objectAtIndex:ind];
            _zoomImageBackgroudView.frame = CGRectMake(imgV.center.x - 40 ,imgV.center.y - 80 , 40 * 2, 80);
            _zoomImageView.image = [UIImage imageNamed:[_emojiArray objectAtIndex:index]];
        }
    }
}

- (NSInteger)indexWithEvent:(UIEvent*)event
{
    UITouch* touch = [[event allTouches] anyObject];
    if (touch.view==_latelyScrollView)
    {
        return 1000;
    }

    float x = [touch locationInView:self].x;
    float y = [touch locationInView:self].y;

    BOOL isImage = NO;
    UIImageView *imgV = nil;
    if ([_emojiImageViewArray count] > 0)
    {
        for (int i = 0; i < [_emojiImageViewArray count]; i++)
        {
            imgV = [_emojiImageViewArray objectAtIndex:i];
            if (x > imgV.frame.origin.x &&
                x < (imgV.frame.origin.x + IMAGE_SIZE) &&
                y > imgV.frame.origin.y && y < (imgV.frame.origin.y + IMAGE_SIZE))
            {
                isImage = YES;
                if((i + _pageControl.currentPage * ITEM_COLUMN * ITEM_ROW) >= [_emojiArray count])
                {
                    return 1000;
                }
                else
                {
                    return i + _pageControl.currentPage * ITEM_COLUMN * ITEM_ROW;
                }
            }
        }
    }

    return 1000;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _faceScrollView.scrollEnabled = NO;
    _touchedIndex = 1000;
    _zoomImageBackgroudView.frame = CGRectZero;
    _zoomImageView.image = nil;

    NSInteger index = [self indexWithEvent:event];

    if ((-1 < index) && (index < 999))
    {
        _sutraScrollView.scrollEnabled = NO;
    }
    else
    {
        _sutraScrollView.scrollEnabled = YES;
    }

    if((index > -1) && (index < _emojiArray.count))
    {
        [self updateWithIndex:index];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _sutraScrollView.scrollEnabled = YES;

    NSInteger index = [self indexWithEvent:event];

    if (_touchedIndex > -1 && index != _touchedIndex && index < _emojiArray.count)
    {
        [self updateWithIndex:index];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _sutraScrollView.scrollEnabled = YES;
    _faceScrollView.scrollEnabled = YES;
    _zoomImageBackgroudView.frame = CGRectZero;
    _zoomImageView.image = nil;

    UITouch *touch = [[event allTouches] anyObject];

    float x = [touch locationInView:self].x;
    float y = [touch locationInView:self].y;

    if (x < 2 || (x > (self.frame.size.width - 2)) || y < 2 || (y > (self.frame.size.height - 2)))
    {
        return;
    }

    if (self.delegate && _touchedIndex > -1 && _touchedIndex < 999)
    {
        if ([self.delegate respondsToSelector:@selector(emojiView:didTouchEmojiWithSignature:andName:)])
        {
            [self.delegate emojiView:self
          didTouchEmojiWithSignature:_symbolArray[_touchedIndex]
                             andName:_emojiArray[_touchedIndex]];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _zoomImageBackgroudView.frame = CGRectZero;
    _zoomImageView.image = nil;
    _touchedIndex = 1000;
    _sutraScrollView.scrollEnabled = YES;
}

@end
