//
//  VoiceRecorderView.m
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import "VoiceRecorderView.h"
#import "KBUtility.h"

#define buttonPressOffset (-50)
#define MIN_RECORD_TIME 1.5f

@interface VoiceRecorderView ()
{
    BOOL shouldCancel;
    BOOL isSendingMessage;
    BOOL isTouchWhileSending;
    BOOL isStillPressing;   //不和其他变量挂钓，只关心是否按着。

    NSTimeInterval touchBeginInterval;
    NSTimeInterval touchEndInterval;
}

@property (nonatomic, assign) BOOL lastShouldCancel;

@end

@implementation VoiceRecorderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        shouldCancel = NO;
        _lastShouldCancel = NO;

        [self setTitleColor:[KBUtility HexColorToRedGreenBlue:@"303030"]
                   forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor grayColor]
                   forState:UIControlStateDisabled];

        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];

        [self setTitle:@"按住 说话"
              forState:UIControlStateNormal];
        [self setTitle:@"松开 结束"
              forState:UIControlStateHighlighted];

        [self updateViewPressingState];
    }

    return self;
}

- (void)updateViewPressingState
{
    if (isStillPressing)
    {
        [self.layer setBorderWidth:0.5];
        [self.layer setBorderColor:[[KBUtility HexColorToRedGreenBlue:@"#a8a8a8"] CGColor]];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:self.frame.size.height/2];
        [self setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2]];
    }
    else
    {
        [self.layer setBorderWidth:0.5];
        [self.layer setBorderColor:[[KBUtility HexColorToRedGreenBlue:@"#a8a8a8"] CGColor]];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:self.frame.size.height/2];
        [self setBackgroundColor:[KBUtility HexColorToRedGreenBlue:@"f9f9f9"]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    isStillPressing = YES;

    [self updateViewPressingState];

    if (isSendingMessage)
    {
        isTouchWhileSending = YES;

        return;
    }
    else
    {
        isTouchWhileSending = NO;
    }

    self.highlighted = YES;

    NSDate *date = [NSDate date];
    touchBeginInterval = [date timeIntervalSinceReferenceDate];

    if (self.delegate && [self.delegate respondsToSelector:@selector(beginRecordChatVoice)])
    {
        [self.delegate beginRecordChatVoice];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    if (isSendingMessage || isTouchWhileSending)
    {
        return;
    }

    self.highlighted = YES;

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    if (point.y < buttonPressOffset)
    {
        shouldCancel = YES;
    }
    else
    {
        shouldCancel = NO;
    }

    if (shouldCancel != _lastShouldCancel)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordChatVoiceSendStatusChange:)])
        {
            [self.delegate recordChatVoiceSendStatusChange:shouldCancel];
        }

        _lastShouldCancel = shouldCancel;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    isStillPressing = NO;

    [self updateViewPressingState];

    if (isTouchWhileSending || isSendingMessage)
    {
        [self stopRecByTimerLate:[NSNumber numberWithBool:YES]];

        return;
    }

    self.highlighted = NO;

    NSDate *date = [NSDate date];
    touchEndInterval = [date timeIntervalSinceReferenceDate];

    NSTimeInterval interval = touchEndInterval - touchBeginInterval;

    if (interval < MIN_RECORD_TIME)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(recordChatVoiceSpeakTimeTooShort)])
        {
            self.enabled = NO;
            [self performSelector:@selector(enableTouchEvent) withObject:nil afterDelay:1.0];

            [self.delegate recordChatVoiceSpeakTimeTooShort];
        }
        else
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopRecByTimerLate:) object:nil];

            [self performSelector:@selector(stopRecByTimerLate:) withObject:[NSNumber numberWithBool:shouldCancel] afterDelay:0.2];
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(endRecordChatVoice:)])
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopRecByTimerLate:) object:nil];

            [self performSelector:@selector(stopRecByTimerLate:) withObject:[NSNumber numberWithBool:shouldCancel] afterDelay:0.2];
        }
    }

    // Reset
    shouldCancel = NO;
    _lastShouldCancel = NO;
}

- (void)stopRecByTimerLate:(NSNumber *)objShouldCancel
{
    BOOL bShouldCancel = [objShouldCancel boolValue];

    if (isStillPressing)
    {
        self.enabled = NO;
        [self performSelector:@selector(enableTouchEvent) withObject:nil afterDelay:1.0];

        [self.delegate recordChatVoiceSpeakTimeTooShort];
        
    }
    else
    {
        [self.delegate endRecordChatVoice:bShouldCancel];
    }

    isSendingMessage = YES;
    self.enabled = NO;

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resetSendingStatus) object:nil];

    [self performSelector:@selector(resetSendingStatus) withObject:nil afterDelay:0.3];
}

- (void)resetSendingStatus
{
    self.enabled = YES;

    isSendingMessage = NO;
}

- (void)enableTouchEvent
{
    self.enabled = YES;
}

@end
