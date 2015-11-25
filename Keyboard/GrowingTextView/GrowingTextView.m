//
//  GrowingTextView.m
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import "GrowingTextView.h"
#import "VoiceRecorderView.h"
#import "VoiceRoundView.h"
#import "KeyboardView.h"
#import "Faceboard.h"
#import "CustomMethod.h"
#import "EmojiUtility.h"

#import "RACEXTScope.h"
#import "KBUtility.h"

#define sendEmojiImageNamesForXMPP  @"sendEmojiImageNamesForXMPP"
#define kTextViewBackgroundViewHeight 31.0

#define kPrefix4GifImageText @"[阿拉兔]"
#define MAX_RECORDING_TIME 15.3

@interface GrowingTextView () <VoiceRecorderViewDelegate, KeyboardViewDelegate, FaceboardDelegate>
{
    IMGrowingTextView *textView;
    BOOL bTimeIsOn;
    float padding;  //最左边和最右边的按钮与self左右的边距
    float fSecondsLeftToRec;

    BOOL _recordingFailed;
}

@property (nonatomic, retain) UIButton *bPlus;
@property (nonatomic, retain) UIButton *bKeyboardLeft;
@property (nonatomic, retain) UIButton *bVoice;
@property (nonatomic, retain) UIButton *bKeyboardRight;
@property (nonatomic, retain) UIButton *bExpression;
@property (nonatomic, retain) UIButton *bPlusBottom;
@property (nonatomic, strong) UIButton *transferMenuButton;//切换菜单栏和输入框view的按钮
@property (nonatomic, strong) UIImageView *ivBackground;
@property (nonatomic, strong) NSDate   *dtRecordTriger;

@property (nonatomic, strong) VoiceRecorderView *vVoice;

///最近使用的emoji表情
@property (nonatomic, strong) NSMutableArray *sendEmojiImageNames;

@property (nonatomic, strong) VoiceRoundView *vRound;
@property (nonatomic, strong) Faceboard *vFaces;
@property (nonatomic, strong) KeyboardView *vPlus;

@end

@implementation GrowingTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _plussable = YES;
        _recordingFailed = NO;

        self.backgroundColor = [KBUtility HexColorToRedGreenBlue:@"#fafafa"];

        padding = 8;
        float height4Button = 28;  //按钮的大小

        //音频按钮
        {
            UIImage *iPicture = [UIImage imageNamed:@"chat_voice_icon"];
            _bVoice = [UIButton buttonWithType:UIButtonTypeCustom];
            _bVoice.frame = CGRectMake(padding, (self.frame.size.height-height4Button)/2, height4Button, height4Button);
            [_bVoice setBackgroundImage:iPicture forState:UIControlStateNormal];
            [_bVoice addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_bVoice];
        }

        //音频按钮下边的键盘按钮
        {
            UIImage *iPicture = [UIImage imageNamed:@"chat_bcg_keyboard"];
            _bKeyboardLeft = [UIButton buttonWithType:UIButtonTypeCustom];
            _bKeyboardLeft.frame = _bVoice.frame;
            _bKeyboardLeft.alpha = 0;
            [_bKeyboardLeft setBackgroundImage:iPicture forState:UIControlStateNormal];
            [_bKeyboardLeft addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self insertSubview:_bKeyboardLeft belowSubview:_bVoice];
        }

        //+号
        {
            UIImage *image = [UIImage imageNamed:@"chat_more_options"];
            _bPlus = [UIButton buttonWithType:UIButtonTypeCustom];
            _bPlus.frame = CGRectMake(self.frame.size.width-padding-height4Button, _bVoice.frame.origin.y, height4Button, height4Button);
            [_bPlus setBackgroundImage:image forState:UIControlStateNormal];
            [_bPlus addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_bPlus];
        }

        //+号下边的按钮
        {
            UIImage *image = [UIImage imageNamed:@"chat_more_options"];
            _bPlusBottom = [UIButton buttonWithType:UIButtonTypeCustom];
            _bPlusBottom.frame = _bPlus.frame;
            [_bPlusBottom setBackgroundImage:image forState:UIControlStateNormal];
            [_bPlusBottom addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self insertSubview:_bPlusBottom belowSubview:_bPlus];
        }

        //表情按钮
        {
            UIImage *image = [UIImage imageNamed:@"chat_expression"];
            _bExpression = [UIButton buttonWithType:UIButtonTypeCustom];
            _bExpression.titleLabel.textColor = [UIColor clearColor];
            _bExpression.frame = CGRectMake(_bPlus.frame.origin.x-padding-height4Button, _bPlus.frame.origin.y, height4Button, height4Button);
            [_bExpression setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [_bExpression setBackgroundImage:image forState:UIControlStateNormal];
            [_bExpression addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_bExpression];
        }

        //表情按钮下边的键盘按钮
        {
            UIImage *iPicture = [UIImage imageNamed:@"chat_bcg_keyboard"];
            _bKeyboardRight = [UIButton buttonWithType:UIButtonTypeCustom];
            _bKeyboardRight.frame = _bExpression.frame;
            _bKeyboardRight.alpha = 0;
            [_bKeyboardRight setBackgroundImage:iPicture forState:UIControlStateNormal];
            [_bKeyboardRight addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self insertSubview:_bKeyboardRight belowSubview:_bExpression];
        }

        //输入框
        {
            float height = 20;
            float paddingY = (frame.size.height-height)/2-6;
            
            textView = [[IMGrowingTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_bVoice.frame)+ (padding),
                                                                           paddingY,
                                                                           _bExpression.frame.origin.x - padding*2 - CGRectGetMaxX(_bVoice.frame),
                                                                           height)];
            textView.contentInset = UIEdgeInsetsMake(0, 3, 4, 5);
            textView.minNumberOfLines = 1;
            textView.maxNumberOfLines = 3;
            textView.font = [UIFont systemFontOfSize:15.0f];
            textView.delegate = self;
            textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
            textView.backgroundColor = [UIColor clearColor];
            textView.enablesReturnKeyAutomatically = YES;
            [self addSubview:textView];

            //输入框背景
            _ivBackground = [[UIImageView alloc] init];
            _ivBackground.frame = CGRectInset(textView.frame, -1, -4);
            _ivBackground.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y+1, textView.frame.size.width, kTextViewBackgroundViewHeight);
            [_ivBackground.layer setMasksToBounds:YES];
            [_ivBackground.layer setCornerRadius:5.0];
            [_ivBackground.layer setBorderWidth:0.5];
            [_ivBackground.layer setBorderColor:[[KBUtility HexColorToRedGreenBlue:@"#a8a8a8"] CGColor]];
            [self insertSubview:_ivBackground belowSubview:textView];
        }

        //输入框下面的视图
        {
            _vVoice = [[VoiceRecorderView alloc] initWithFrame:CGRectMake(_ivBackground.frame.origin.x, textView.frame.origin.y , _ivBackground.frame.size.width, kTextViewBackgroundViewHeight)];
            _vVoice.delegate = self;
            _vVoice.backgroundColor = [UIColor clearColor];
            _vVoice.hidden = YES;
            [self insertSubview:_vVoice belowSubview:_ivBackground];
        }

        //增加一条灰线以分隔输入框和消息列表
        {
            UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
            vLine.backgroundColor = [UIColor lightGrayColor];
            vLine.alpha = .35;
            [self addSubview:vLine];
        }

        _delegate = nil;

        NSArray *emojies = [[NSUserDefaults standardUserDefaults] objectForKey:sendEmojiImageNamesForXMPP];
        _sendEmojiImageNames = [[NSMutableArray alloc] initWithArray:emojies];
    }

    return self;
}

- (void)dealloc
{
    self.targetView = nil;

    textView.delegate = nil;
    _vFaces.delegate = nil;
    _vPlus.delegate = nil;
    _delegate = nil;
}

- (void)setPlussable:(BOOL)plussable
{
    if (_plussable != plussable)
    {
        _plussable = plussable;
    }

    _bPlus.alpha = _bPlus.userInteractionEnabled = _bPlusBottom.alpha = _bPlusBottom.userInteractionEnabled = plussable;

    CGRect rect4TextView = textView.frame;

    if (plussable)
    {
        _bExpression.frame = CGRectMake(_bPlus.frame.origin.x - padding - _bPlus.frame.size.width,
                                        _bPlus.frame.origin.y,
                                        _bPlus.frame.size.width,
                                        _bPlus.frame.size.height);

        rect4TextView.size.width = _bExpression.frame.origin.x - padding - textView.frame.origin.x;
    }
    else
    {
        _bExpression.frame = _bPlus.frame;

        rect4TextView.size.width = _bPlus.frame.origin.x - padding - textView.frame.origin.x;
    }

    textView.frame = rect4TextView;
    _ivBackground.frame = CGRectMake(textView.frame.origin.x,
                                     textView.frame.origin.y,
                                     textView.frame.size.width,
                                     _ivBackground.frame.size.height);
    _vVoice.frame = _ivBackground.frame;
    _bKeyboardRight.frame = _bExpression.frame;
}

- (void)setIsNoShowVoiceBtn:(BOOL)isNoShowVoiceBtn
{
    CGRect rect4TextView = textView.frame;
    CGRect rect4Background = _ivBackground.frame;

    if (_isNoShowVoiceBtn != isNoShowVoiceBtn)
    {
        _isNoShowVoiceBtn = isNoShowVoiceBtn;
    }

    if (isNoShowVoiceBtn)
    {
        rect4TextView.origin.x = _bVoice.frame.origin.x;
        rect4TextView.size.width += _bVoice.frame.size.width;

        rect4Background.origin.x = _bVoice.frame.origin.x;
        rect4Background.size.width += _bVoice.frame.size.width;

        _bVoice.hidden = YES;
    }

    _ivBackground.frame = rect4Background;
    textView.frame = rect4TextView;
}

- (void)setIsShowPlusBtn:(BOOL)isShowPlusBtn
{
    CGRect rect4TextView = textView.frame;
    CGRect rect4Background = _ivBackground.frame;
    CGRect rect4Expression = _bExpression.frame;

    if (_isShowPlusBtn != isShowPlusBtn)
    {
        _isShowPlusBtn = isShowPlusBtn;
    }

    if (!isShowPlusBtn)
    {
        rect4Expression.origin.x += (_bPlus.frame.size.width + 4);
        rect4TextView.size.width += (_bPlus.frame.size.width + padding);
        rect4Background.size.width += (_bPlus.frame.size.width + padding);

        _bPlus.hidden = YES;
        _bPlusBottom.hidden = YES;
    }

    _ivBackground.frame = rect4Background;
    textView.frame = rect4TextView;
    _bExpression.frame = rect4Expression;
    _bKeyboardRight.frame = rect4Expression;
}

- (void)setIsShowMenuListButton:(BOOL)isShowMenuListButton
{
    CGRect rect4TextView = textView.frame;

    if (isShowMenuListButton && self.isMenuViewExist)
    {
        _transferMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _transferMenuButton.frame = CGRectMake(padding, 0, 40, 40);
        [_transferMenuButton setBackgroundImage:[UIImage imageNamed:@"pb_keyboard"]
                                       forState:UIControlStateNormal];
        [_transferMenuButton setBackgroundImage:[UIImage imageNamed:@"pb_keyboard"]
                                       forState:UIControlStateHighlighted];
        [_transferMenuButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_transferMenuButton];

        rect4TextView.origin.x = _transferMenuButton.frame.origin.x +45;
        rect4TextView.size.width = _bExpression.frame.origin.x - padding * 2 - CGRectGetMaxX(_transferMenuButton.frame);
    }
    else
    {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];

        [self reset];

        rect4TextView.origin.x = _bVoice.frame.origin.x;
        rect4TextView.size.width = _bExpression.frame.origin.x - padding * 2;
    }

    _ivBackground.frame = rect4TextView;
    textView.frame = rect4TextView;
}

- (void)setMaxNumberOfLines:(int)maxNumberOfLines
{
    if(_maxNumberOfLines != maxNumberOfLines)
    {
        _maxNumberOfLines = maxNumberOfLines;
    }

    textView.maxNumberOfLines = maxNumberOfLines;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    if (_returnKeyType != returnKeyType)
    {
        _returnKeyType = returnKeyType;
    }

    textView.returnKeyType = UIReturnKeySend;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (_placeholder != placeholder)
    {
        _placeholder = placeholder;
    }

    textView.placeholder = _placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    if (_placeholderColor != placeholderColor)
    {
        _placeholderColor  = placeholderColor;
    }

    textView.placeholderColor = _placeholderColor;
}

#pragma mark - HPGrowingTextViewDelegate

- (void)growingTextViewDidBeginEditing:(IMGrowingTextView *)growingTextView
{
}

- (void)growingTextView:(IMGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(imGrowingTextView:willChangeHeight:)])
    {
        [_delegate imGrowingTextView:self willChangeHeight:height+5];
    }

    @weakify(self);
    [UIView animateWithDuration:kDuration4Animation
                     animations:^{

                         @strongify(self);

                         float diff = (growingTextView.frame.size.height - height);

                         CGRect r = self.frame;
                         r.size.height -= diff;
                         r.origin.y += diff;
                         self.frame = r;

                         _ivBackground.frame = CGRectMake(_ivBackground.frame.origin.x,
                                                          _ivBackground.frame.origin.y,
                                                          _ivBackground.frame.size.width,
                                                          r.size.height-_ivBackground.frame.origin.y * 2);
                     }];
}

- (void)growingTextView:(IMGrowingTextView *)growingTextView didChangeHeight:(float)height
{
}

- (BOOL)growingTextViewShouldReturn:(IMGrowingTextView *)growingTextView
{
    if ([self containsDictationView:growingTextView])
    {
        return NO;
    }

    //保存最近发送图片历史记录
    [self saveLatestEmojiWithText:self.text];

    if (_delegate!=nil && [_delegate respondsToSelector:@selector(imGrowingTextViewShouldReturn:)])
    {
        return [_delegate imGrowingTextViewShouldReturn:self];
    }

    return YES;
}

- (void)setText:(NSString *)text
{
    textView.text = text;
}

- (NSString *)text
{
    return textView.text;
}

- (void)setSelectedRange:(NSRange)selectedRange
{
    textView.selectedRange = selectedRange;
}

- (NSRange)selectedRange
{
    return textView.selectedRange;
}

- (BOOL)resignFirstResponder
{
    [textView resignFirstResponder];
    
    return [super resignFirstResponder];
}

- (void)buttonClicked:(UIButton *)button
{
    //音频按钮
    if(button == _bVoice)
    {
        textView.hidden = YES;
        _ivBackground.hidden = YES;
        _vVoice.hidden = NO;

        [self showButton:_bKeyboardLeft];
        [self showButton:_bExpression];

        if (_plussable)
        {
            [self showButton:_bPlus];
        }

        [self setFacesViewHided:YES];
        [self setPlusViewHided:YES];

        [[UIApplication sharedApplication].keyWindow endEditing:YES];

        [self resetTextViewWhetherVoiceButtonWasTapped:YES];
    }
    else if (button == _transferMenuButton)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(touchToTransferMenuViewAndInputView)])
        {
            [self.delegate touchToTransferMenuViewAndInputView];
        }
    }
    else if(button == _bKeyboardLeft)
    {
        textView.hidden = NO;
        _ivBackground.hidden = NO;
        _vVoice.hidden = YES;

        [self showButton:_bVoice];
        [self showButton:_bExpression];

        if (_plussable)
        {
            [self showButton:_bPlus];
        }

        [textView becomeFirstResponder];
    }
    else if (button == _bKeyboardRight)
    {
        textView.hidden = NO;
        _ivBackground.hidden = NO;
        _vVoice.hidden = YES;

        [self showButton:_bExpression];
        [self showButton:_bVoice];

        if (_plussable)
        {
            [self showButton:_bPlus];
        }

        [self setFacesViewHided:YES];
        [self setPlusViewHided:YES];

        if (self.delegate && [_delegate respondsToSelector:@selector(imGrowingTextView:needsBelongingController:toAddOrRemoveKeyboardObservers:)])
        {
            [self.delegate imGrowingTextView:self needsBelongingController:[self viewController] toAddOrRemoveKeyboardObservers:YES];
        }

        [textView becomeFirstResponder];
    }
    else if (button == _bExpression)
    {
        textView.hidden = NO;
        _ivBackground.hidden = NO;
        _vVoice.hidden = YES;

        [self showButton:_bKeyboardRight];
        [self showButton:_bVoice];

        if (_plussable)
        {
            [self showButton:_bPlus];
        }

        [self setTextViewStanded:button];
        [self setFacesViewHided:NO];

        if (self.standing)
        {
            if (self.delegate && [_delegate respondsToSelector:@selector(imGrowingTextView:needsBelongingController:toAddOrRemoveKeyboardObservers:)])
            {
                [_delegate imGrowingTextView:self needsBelongingController:[self viewController] toAddOrRemoveKeyboardObservers:NO];
            }

            [textView resignFirstResponder];
        }
    }
    else if (button == _bPlus)
    {
        [self showButton:_bVoice];
        [self showButton:_bExpression];

        if (_plussable)
        {
            [self showButton:_bPlusBottom];
        }

        textView.hidden = NO;
        _ivBackground.hidden = NO;
        _vVoice.hidden = YES;

        [self setPlusViewHided:NO];
        [self setFacesViewHided:YES];

        if (self.standing)
        {
            if (self.delegate && [_delegate respondsToSelector:@selector(imGrowingTextView:needsBelongingController:toAddOrRemoveKeyboardObservers:)])
            {
                [_delegate imGrowingTextView:self needsBelongingController:[self viewController] toAddOrRemoveKeyboardObservers:NO];
            }

            [textView resignFirstResponder];
        }

        [self setTextViewStanded:button];
    }
    else if (button == _bPlusBottom)
    {
        [self showButton:_bVoice];
        [self showButton:_bExpression];

        if (_plussable)
        {
            [self showButton:_bPlus];
        }

        [self setFacesViewHided:YES];
        [self setPlusViewHided:YES];

        if (self.standing)
        {
            if(self.delegate && [_delegate respondsToSelector:@selector(imGrowingTextView:needsBelongingController:toAddOrRemoveKeyboardObservers:)])
            {
                [_delegate imGrowingTextView:self needsBelongingController:[self viewController] toAddOrRemoveKeyboardObservers:YES];
            }

            [textView becomeFirstResponder];
        }
    }
}

- (void)showButton:(UIButton *)button
{
    button.alpha = button.userInteractionEnabled = YES;

    [self bringSubviewToFront:button];

    if (button == _bPlus)
    {
        _bPlusBottom.alpha = _bPlusBottom.userInteractionEnabled = NO;
    }
    else if (button == _bExpression)
    {
        _bKeyboardRight.alpha = _bKeyboardRight.userInteractionEnabled = NO;
    }
    else if (button == _bVoice)
    {
        _bKeyboardLeft.alpha = _bKeyboardLeft.userInteractionEnabled = NO;
    }
    else if (button == _bPlusBottom)
    {
        _bPlus.alpha = _bPlus.userInteractionEnabled = NO;
    }
    else if (button == _bKeyboardRight)
    {
        _bExpression.alpha = _bExpression.userInteractionEnabled = NO;
    }
    else if (button == _bKeyboardLeft)
    {
        _bVoice.alpha = _bVoice.userInteractionEnabled = NO;
    }
}

- (void)saveLatestEmojiWithText:(NSString *)txt
{
    NSMutableArray *sendEmojies = [CustomMethod transformString:txt withEmojis:[EmojiUtility EmojiNewNames]];

    for (NSNumber *str in sendEmojies)
    {
        if (_sendEmojiImageNames.count == 0)
        {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [[EmojiUtility EmojiNewNames] objectAtIndex:[str intValue]],
                                 @"message",
                                 [[EmojiUtility EmojiNewIamges] objectAtIndex:[str intValue]],
                                 @"image",
                                 nil];

            [_sendEmojiImageNames insertObject:dic atIndex:0];
        }
        else
        {
            BOOL isFound = NO;

            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [[EmojiUtility EmojiNewNames] objectAtIndex:[str intValue]],
                                 @"message",
                                 [[EmojiUtility EmojiNewIamges] objectAtIndex:[str intValue]],
                                 @"image",
                                 nil];

            for (NSDictionary *dict in _sendEmojiImageNames)
            {
                if ([[dict objectForKey:@"image"] isEqualToString:[[EmojiUtility EmojiNewIamges] objectAtIndex:[str intValue]]])
                {
                    isFound = YES;

                    break;
                }
            }

            if (!isFound)
            {
                [_sendEmojiImageNames insertObject:dic atIndex:0];
            }
            else
            {
                [_sendEmojiImageNames removeObject:dic];
                [_sendEmojiImageNames insertObject:dic atIndex:0];
            }
        }
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_sendEmojiImageNames forKey:sendEmojiImageNamesForXMPP];
    [defaults synchronize];
}

- (void)handleEmojiViewDidTouchEmojiWithSignature:(NSString *)signature andFileName:(NSString *)fileName
{
    if ([signature isEqualToString:@"[wbdelete]"])
    {
        NSString *string = textView.text;
        NSString *sBefore;
        NSString *sAfter;
        NSUInteger location = textView.selectedRange.location;

        if(location != NSNotFound)
        {
            sBefore = [textView.text substringToIndex:location];

            string = sBefore;
            sAfter = [textView.text substringFromIndex:location];
        }

        if (string.length == 0)
        {
            return;
        }

        NSString *subStr;
        if ([string hasSuffix:@"]"])
        {
            NSRange range = [string rangeOfString:@"[" options:NSBackwardsSearch];
            if (range.location != NSNotFound)
            {
                NSString *str2 = [string substringToIndex:(string.length - 1)];
                NSRange rang2 = [str2 rangeOfString:@"]" options:NSBackwardsSearch];
                if (rang2.location != NSNotFound)
                {
                    if (rang2.location > range.location)
                    {
                        subStr = [string substringToIndex:(string.length - 1)];
                    }
                    else
                    {
                        subStr = [string substringToIndex:range.location];
                    }
                }
                else
                {
                    subStr = [string substringToIndex:range.location];
                }
            }
            else
            {
                subStr = [string substringToIndex:(string.length - 1)];
            }
        }
        else
        {
            subStr = [string substringToIndex:([string length] - 1)];
        }

        textView.text = [NSString stringWithFormat:@"%@%@", subStr, sAfter];

        NSRange lightRange = NSMakeRange([subStr length],0);

        textView.selectedRange = lightRange;
    }
    else
    {
        NSUInteger location = textView.selectedRange.location;

        if (location != NSNotFound)
        {
            NSString *preLightStr = [textView.text substringToIndex:location];
            NSString *sufLightStr = [textView.text substringFromIndex:location];

            textView.text = [NSString stringWithFormat:@"%@%@%@",preLightStr,signature,sufLightStr];

            NSRange range = NSMakeRange([[NSString stringWithFormat:@"%@%@",preLightStr,signature] length], 0);

            textView.selectedRange = range;
        }
        else
        {
            textView.text = [NSString stringWithFormat:@"%@%@",textView.text,signature];
        }
    }
}

- (void)setTextViewStanded:(UIButton *)button
{
    self.standing = YES;

    CGRect rect = self.frame;

    rect.origin.y = _targetView.frame.size.height - kHeight4SubkeyboardView - self.frame.size.height;

    @weakify(self);
    [UIView animateWithDuration:kDuration4Animation animations:^{

        @strongify(self);
        self.frame = rect;
    }];

    if (self.delegate && [_delegate respondsToSelector:@selector(imGrowingTextViewWillStandWithoutKeyboardPoppingUp:)])
    {
        [_delegate imGrowingTextViewWillStandWithoutKeyboardPoppingUp:self];
    }
}

- (void)setFacesViewHided:(BOOL)hided
{
    if (!_vFaces)
    {
        _vFaces = [[Faceboard alloc] init];
        _vFaces.isFromPubSubView = _isNoShowVoiceBtn;
        _vFaces.rect = CGRectMake(0, _targetView.frame.size.height, _targetView.frame.size.width, kHeight4SubkeyboardView);
        _vFaces.delegate = self;
        [_vFaces initEmojiDataAndUi];

        [_targetView addSubview:_vFaces];
    }

    if (!hided)
    {
        [_targetView bringSubviewToFront:_vFaces];
    }

    CGRect rect = _vFaces.frame;
    rect.origin.y = _targetView.frame.size.height - (hided ? 0: kHeight4SubkeyboardView);

    [UIView animateWithDuration:kDuration4Animation animations:^{

        _vFaces.frame = rect;
    }];
}

- (void)setPlusViewHided:(BOOL)hided
{
    if (!_vPlus)
    {
        _vPlus = [[KeyboardView alloc] initWithFrame:CGRectMake(0, _targetView.frame.size.height, _targetView.frame.size.width, kHeight4SubkeyboardView)];
        _vPlus.backgroundColor = [KBUtility HexColorToRedGreenBlue:@"#f5f0ec"];
        _vPlus.delegate = self;
        [_targetView addSubview:_vPlus];
    }

    if (!hided)
    {
        [_targetView bringSubviewToFront:_vPlus];
    }

    CGRect rect = _vPlus.frame;
    rect.origin.y = _targetView.frame.size.height - (hided ? 0: kHeight4SubkeyboardView);

    [UIView animateWithDuration:kDuration4Animation animations:^{

        _vPlus.frame = rect;
    }];
}

//还原所有操作
- (void)reset
{
    [self setFacesViewHided:YES];
    [self setPlusViewHided:YES];

    if (self.standing)
    {
        [self resetTextViewWhetherVoiceButtonWasTapped:NO];
    }

    [self showButton:_bExpression];
    [self showButton:_bVoice];

    if (_plussable)
    {
        [self showButton:_bPlus];
    }
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];

    return [textView becomeFirstResponder];
}

- (void)resetTextViewWhetherVoiceButtonWasTapped:(BOOL)tapped
{
    self.standing = NO;

    CGFloat textViewHeight = self.frame.size.height;

    if (tapped)
    {
        textViewHeight = kHeight4GrowingInputView;

        [self showButton:_bKeyboardLeft];
    }

    CGRect rect = self.frame;
    rect.origin.y = _targetView.frame.size.height - textViewHeight;

    @weakify(self);
    [UIView animateWithDuration:kDuration4Animation animations:^{

        @strongify(self);
        self.frame = rect;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imGrowingTextView:hasBeenResetWhetherVoiceButtonWasTapped:)])
    {
        [self.delegate imGrowingTextView:self hasBeenResetWhetherVoiceButtonWasTapped:tapped];
    }
}

- (void)emojiView:(Faceboard *)emojiView didTouchEmojiWithSignature:(NSString *)signature andName:(NSString *)name
{
    [self handleEmojiViewDidTouchEmojiWithSignature:signature andFileName:name];
}

- (void)emojiView:(Faceboard *)emojiView didTouchEmojiWithImagename:(NSString *)ImageName andENname:(NSString *)ENname andZHName:(NSString *)ZHname
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imGrowingTextView:
                                                                     gifImageName:
                                                                     andGifType:
                                                                     andENName:
                                                                     andZHName:)])
    {
        [self.delegate imGrowingTextView:self
                            gifImageName:ImageName
                              andGifType:(NSString *)kPrefix4GifImageText
                               andENName:ENname
                               andZHName:ZHname];
    }
}

- (void)emojiView:(Faceboard *)emojiView didTouchSendingButton:(UIButton *)sendButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imGrowingTextViewShouldReturn:)])
    {
        [self.delegate imGrowingTextViewShouldReturn:self];
    }
}

- (BOOL)containsDictationView:(UIView *)view
{
    if ([view isKindOfClass:NSClassFromString(@"UIDictationLandingView")])
    {
        return YES;
    }

    for (UIView *subview in view.subviews)
    {
        if ([self containsDictationView:subview]) return YES;
    }

    return NO;
}

- (BOOL)growingTextView:(IMGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self containsDictationView:growingTextView])
    {
        return  NO;
    }

    if (_delegate != nil && [_delegate respondsToSelector:@selector(imGrowingTextView:shouldChangeTextInRange:replacementText:)])
    {
        return [_delegate imGrowingTextView:self shouldChangeTextInRange:range replacementText:text];
    }

    return YES;
}

- (void)growingTextViewDidChangeSelection:(IMGrowingTextView *)growingTextView
{
    if (textView.text.length > 1000)
    {
        if (!growingTextView.internalTextView.markedTextRange.empty)
        {
            [growingTextView.internalTextView unmarkText];
        }

        textView.text = [growingTextView.internalTextView.text substringToIndex:1000];
    }
}

- (int)convertchineseToint:(NSString*)strtemp
{
    int strlength = 0 ;
    char *p = (char *)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++)
    {
        if (*p)
        {
            p++;
            strlength++;
        }
        else
        {
            p++;
        }
    }

    return (strlength + 1) / 2;
}

- (BOOL)growingTextViewShouldBeginEditing:(IMGrowingTextView *)growingTextView
{
    self.standing = YES;

    [self showButton:_bVoice];
    [self showButton:_bExpression];
    [self setFacesViewHided:YES];
    [self setPlusViewHided:YES];
    if (_plussable)
    {
        [self showButton:_bPlus];
    }

    if (_delegate != nil && [_delegate respondsToSelector:@selector(imGrowingTextViewShouldBeginEditing:)])
    {
        return [_delegate imGrowingTextViewShouldBeginEditing:self];
    }
    else
    {
        return YES;
    }
}

#pragma mark - IMVoiceRecorderViewDelegate

- (void)beginRecordChatVoice
{
    if (_vRound)
    {
        [_vRound dismiss:NO];
        _vRound = nil;
    }

    _vRound = [[VoiceRoundView alloc] initWithFrame:CGRectZero];
    _vRound.imageName = @"voice_record_1";
    _vRound.title = @"手指上滑，取消发送";

    [_vRound showInView:self.targetView animated:YES];

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopRecByTimer) object:nil];
    bTimeIsOn = NO;
    self.dtRecordTriger = [NSDate date];
    [self performSelector:@selector(stopRecByTimer) withObject:nil afterDelay:MAX_RECORDING_TIME];
    bTimeIsOn = YES;

    fSecondsLeftToRec = 15.0f;

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startRecordingAnimation) object:nil];
    [self performSelector:@selector(startRecordingAnimation) withObject:nil afterDelay:0.1];

    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    __unused NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];

    if (self.delegate && [self.delegate respondsToSelector:@selector(willRecordingVoiceWithImGrowingTextView)])
    {
        [self.delegate willRecordingVoiceWithImGrowingTextView];
    }

    //开始录音
}

- (void)stopRecByTimer
{
    [self endRecordChatVoice:NO];
}

- (void)startRecordingAnimation
{
    if (nil == _vRound || nil == _vRound.superview)
    {
        return;
    }

    NSTimeInterval tiAfterTriger = [[NSDate date] timeIntervalSinceDate:self.dtRecordTriger];
    if (tiAfterTriger > (MAX_RECORDING_TIME - 5.0))
    {
        fSecondsLeftToRec = MAX_RECORDING_TIME - tiAfterTriger;//5.0;
    }

    if (fSecondsLeftToRec < 0)
    {
        fSecondsLeftToRec = 0.5;
    }
    else if (fSecondsLeftToRec > 4.5 && fSecondsLeftToRec < 5.0f)
    {
        fSecondsLeftToRec = 5.0f;
    }

    if (fSecondsLeftToRec <= 5.0)
    {
        int intSeconds = (int)fSecondsLeftToRec;
        _vRound.title =[NSString stringWithFormat:@"%d seconds left",intSeconds];
    }

    if (_vRound)
    {
        BOOL isOK = [_vRound showNextImage];
        if (isOK)
        {
            [self performSelector:@selector(startRecordingAnimation) withObject:nil afterDelay:0.5];
        }
    }
}

- (void)endRecordChatVoice:(BOOL)willCancelSendVoice
{
    if (bTimeIsOn)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopRecByTimer) object:nil];
        bTimeIsOn = NO;
    }

    if (willCancelSendVoice)
    {
        // 取消录音
    }
    else
    {
        //结束录音
        if (self.delegate && [self.delegate respondsToSelector:@selector(imGrowingTextView:didFinishRecordingVoiceWithDataVO:)])
        {
            [self.delegate imGrowingTextView:self didFinishRecordingVoiceWithDataVO:nil];
        }
    }

    [_vRound dismiss:YES];
}

- (void)recordChatVoiceSendStatusChange:(BOOL)willCancelSendVoice
{
    if (willCancelSendVoice)
    {
        _vRound.imageName = @"voice_deleteing";
        _vRound.title = @"松开手指，取消发送";
    }
    else
    {
        _vRound.imageName = @"voice_record_1";
        _vRound.title = @"手指上滑，取消发送";

        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startRecordingAnimation) object:nil];
        [self performSelector:@selector(startRecordingAnimation) withObject:nil afterDelay:0.5];
    }
}

- (void)recordChatVoiceSpeakTimeTooShort
{
    if (_recordingFailed)
    {
        _recordingFailed = NO;

        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopRecByTimer) object:nil];
    // 取消录音

    bTimeIsOn = NO;

    if (_vRound)
    {
        [_vRound dismiss:NO];
        _vRound = nil;
    }

    _vRound = [[VoiceRoundView alloc] initWithFrame:CGRectZero];
    _vRound.imageName = @"chat_voice_tooshort";
    _vRound.title = @"Too short";
    [_vRound showInView:_targetView animated:YES];
    [_vRound dismissAfterSeconds:1 animated:YES];
}

#pragma mark --------------------------------------------------
#pragma mark IMKeyBoardDelegate 实现
- (void)didSelectedKeyBoardViewButtonIndex:(NSInteger)index
{
    switch(index)
    {
        case 0:
        {
            //从相册中选择照片
            if (_delegate != nil && [_delegate respondsToSelector:@selector(pushImageView:)])
            {
                [self.delegate pushImageView:self];
            }

            break;
        }
        case 1:
        {
            //发送位置
            if (_delegate != nil && [_delegate respondsToSelector:@selector(imGrowingTextViewWillSendLocation:)])
            {
                [_delegate imGrowingTextViewWillSendLocation:self];
            }

            break;
        }
        case 2:
        {
            //群通知
            if (_delegate != nil && [_delegate respondsToSelector:@selector(imGrowingTextViewWillShareGroupNotify:)])
            {
                [_delegate imGrowingTextViewWillShareGroupNotify:self];
            }

            break;
        }
        case 3:
        {
            //集合点
            if (_delegate != nil && [_delegate respondsToSelector:@selector(imGrowingTextViewWillShareAssembly:)])
            {
                [_delegate imGrowingTextViewWillShareAssembly:self];
            }

            break;
        }

        default:
        {
            break;
        }
    }
}

- (UIViewController *)viewController
{
    for (UIView *next = self.superview; next; next=next.superview)
    {
        UIResponder *responder = [next nextResponder];
        if([responder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)responder;
        }
    }

    return nil;
}

@end
