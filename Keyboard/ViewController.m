//
//  ViewController.m
//  Keyboard
//
//  Created by Thomson on 15/11/24.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import "ViewController.h"
#import "GrowingTextView.h"

#import "RACEXTScope.h"
#import "KBUtility.h"

@interface ViewController () <IMGrowingTextViewDelegate>
{
    BOOL        _isKeyboardShowing;
    BOOL        _isKeypathObserversAdded;
    BOOL        _isKeyboardObserversAdded;

    UIButton    *_backButton;

    BOOL        _cancelKey;
}

@property (nonatomic, strong) GrowingTextView *textView;

@end

@implementation ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.textView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self addKeyboardObservers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self removeKeyboardObservers];

    if (_isKeyboardShowing)
    {
        _isKeyboardShowing = NO;

        [_textView reset];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    _textView.delegate = nil;
    _textView.targetView = nil;

    _textView = nil;
}

#pragma mark - IMGrowingTextViewDelegate

- (BOOL)imGrowingTextViewShouldBeginEditing:(GrowingTextView *)textView
{
    [self addKeyboardObservers];

    _isKeyboardShowing = YES;

    return YES;
}

- (void)imGrowingTextViewWillStandWithoutKeyboardPoppingUp:(GrowingTextView *)textView
{
    [self cancelKeyboardWithButton];
}

- (BOOL)imGrowingTextViewShouldReturn:(GrowingTextView *)textView
{
    NSString *text = textView.text;

    if (0 == [text length])
    {
        __block UIView *keyBoardView = nil;

        [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:NSClassFromString(@"UITextEffectsWindow")])
            {
                keyBoardView = obj;

                *stop = YES;
            }
        }];
    }
    else
    {
        _textView.text = @"";
    }

    return NO;
}

- (void)imGrowingTextView:(GrowingTextView *)textView
 needsBelongingController:(UIViewController *)controller
toAddOrRemoveKeyboardObservers:(BOOL)shouldAdd
{
    _isKeyboardShowing = shouldAdd;

    [self cancelKeyboardWithButton];

    if (shouldAdd)
    {
        [self addKeyboardObservers];
    }
    else
    {
        [self removeKeyboardObservers];
    }
}

- (void)cancelKeyboardWithButton
{
    __block BOOL isHave = NO;

    [[self.view subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            isHave = YES;
        }
    }];

    if (!isHave)
    {
        [self.view insertSubview:_backButton belowSubview:_textView];

        _cancelKey = YES;
    }
}

- (void)pushImageView:(GrowingTextView *)textView
{
}

#pragma mark - Private Methods

/**
 *  添加键盘监听事件
 */
- (void)addKeyboardObservers
{
    if (!_isKeyboardObserversAdded)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowOrNot:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowOrNot:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowOrNot:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }

    _isKeyboardObserversAdded = YES;
}

/**
 *  移除键盘监听事件
 */
- (void)removeKeyboardObservers
{
    _isKeyboardObserversAdded = NO;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 *  处理键盘弹出隐藏以及大小变化的方法
 */
- (void)keyboardWillShowOrNot:(NSNotification *)notification
{
    CGRect frame4Keyboard = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    if (fabs(frame4Keyboard.origin.x) == kScreenWidth)
    {
        return;
    }

    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat y4Keyboard = [self.view convertRect:frame4Keyboard fromView:nil].origin.y;

    CGRect frame4TextView = _textView.frame;

    CGFloat y4TextView = y4Keyboard - frame4TextView.size.height;

    // for ipad modal form presentations

    CGFloat messageViewFrameBottom = self.view.frame.size.height - kHeight4GrowingInputView;

    y4TextView = MIN(messageViewFrameBottom, y4TextView);

    //如果状态将是弹起，insets高度要加上键盘高度
    BOOL willPopup = roundf(y4Keyboard+frame4Keyboard.size.height) == self.view.frame.size.height;

    if (willPopup)
    {
        _isKeyboardShowing = YES;

        [self.view insertSubview:_backButton belowSubview:_textView];
    }
    else
    {
        _isKeyboardShowing = NO;

        [_backButton removeFromSuperview];

        [_textView reset];
    }

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{

                         CGRect frame = _textView.frame;
                         frame.origin.y = y4TextView;
                         _textView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

/**
 *  移除键盘
 */
- (void)removeKeyboard
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];

    if (_textView.standing)
    {
        if (!_isKeyboardShowing)
        {
            [_backButton removeFromSuperview];

            [_textView reset];

            _cancelKey = NO;
        }
    }

    if (_cancelKey)
    {
        _cancelKey = NO;

        [_backButton removeFromSuperview];

        [_textView reset];
    }
}

#pragma mark - Getters and Setters

- (GrowingTextView *)textView
{
    if (!_textView)
    {
        CGRect rect4TextView = CGRectMake(0,
                                          self.view.frame.size.height - kHeight4GrowingInputView,
                                          self.view.frame.size.width,
                                          kHeight4GrowingInputView);

        _isKeyboardObserversAdded = NO;

        _textView = [[GrowingTextView alloc] initWithFrame:rect4TextView];

        _textView.delegate = self;
        _textView.targetView = self.view;
        _textView.placeholder = @"";
        _textView.clipsToBounds = YES;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.isNoShowVoiceBtn = NO;

        _backButton = [[UIButton alloc] initWithFrame:self.view.frame];
        _backButton.backgroundColor = [UIColor clearColor];

        [_backButton addTarget:self
                        action:@selector(removeKeyboard)
              forControlEvents:UIControlEventTouchUpInside];
    }

    return _textView;
}

@end
