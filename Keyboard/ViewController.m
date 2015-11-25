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
    BOOL        _isKeyboardShowing;                     //键盘是否处于弹起状态，当键盘未弹起状态时，需要重置输入框到屏幕最下方，即调用reset方法

    BOOL        _isKeypathObserversAdded;               //kvo是否已经注册，防止二次注册导致事件发次发生的问题以及多次remove导致崩溃的问题

    BOOL        _isKeyboardObserversAdded;              //键盘监听事件是否已经添加，防止二次添加以致事件发生多次的问题

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

    //下边的输入框
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

        [self.view addSubview:_textView];

        _backButton = [[UIButton alloc] initWithFrame:self.view.frame];
        _backButton.backgroundColor = [UIColor clearColor];

        [_backButton addTarget:self
                        action:@selector(removeKeyboard)
              forControlEvents:UIControlEventTouchUpInside];
    }
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

    self.enable = NO;

    if (_isKeyboardShowing)
    {
        _isKeyboardShowing = NO;

        [_textView reset];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [_textView reset];
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

- (void)imGrowingTextView:(GrowingTextView *)textView willChangeHeight:(CGFloat)height
{
}

- (void)imGrowingTextView:(GrowingTextView *)textView hasBeenResetWhetherVoiceButtonWasTapped:(BOOL)tapped
{
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

//发送gif表情
- (void)imGrowingTextView:(GrowingTextView *)textView
             gifImageName:(NSString *)imagename
               andGifType:(NSString *)type
                andENName:(NSString *)ENname
                andZHName:(NSString *)ZHname
{
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

- (void)willRecordingVoiceWithImGrowingTextView
{
    self.enable = YES;
}

//语音发送
- (void)imGrowingTextView:(GrowingTextView *)textView didFinishRecordingVoiceWithDataVO:(id)audioDataVO
{
    //构建语音消息并发送
    self.enable = NO;
}

- (void)imGrowingTextViewWillSendLocation:(GrowingTextView *)textView
{
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

@end
