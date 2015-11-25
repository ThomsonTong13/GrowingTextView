//
//  VoiceRecorderView.h
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoiceRecorderViewDelegate;

@interface VoiceRecorderView : UIButton

@property (nonatomic, weak) id<VoiceRecorderViewDelegate> delegate;

@end

@protocol VoiceRecorderViewDelegate <NSObject>

- (void)beginRecordChatVoice;
- (void)endRecordChatVoice:(BOOL)willCancelSendVoice;
- (void)recordChatVoiceSendStatusChange:(BOOL)willCancelSendVoice;
- (void)recordChatVoiceSpeakTimeTooShort;

@end