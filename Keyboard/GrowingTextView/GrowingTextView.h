//
//  GrowingTextView.h
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMGrowingTextView.h"

#define kHeight4GrowingInputView                44
#define kDuration4Animation                     .25
#define kHeight4SubkeyboardView                 216

@protocol IMGrowingTextViewDelegate;

@interface GrowingTextView : UIView <HPGrowingTextViewDelegate>

/**
 *  输入框内的内容
 */
@property (nonatomic, copy) NSString *text;

@property (nonatomic, weak) id<IMGrowingTextViewDelegate> delegate;

/**
 *  键盘的确认按钮类型
 */
@property (nonatomic, assign) UIReturnKeyType returnKeyType;

/**
 *  当前输入控件是不是处于弹出状态
 */
@property (nonatomic, assign) BOOL standing;

/**
 *  是否显示+
 */
@property (nonatomic, assign) BOOL plussable;

/**
 *  输入的字符里被选的范围
 */
@property (nonatomic, assign) NSRange selectedRange;

/**
 *  输入框的占位符
 */
@property (nonatomic, retain) NSString *placeholder;

/**
 * 输入框占位符颜色
 * 默认：[UIColor lightGrayColor]`.
 */
@property (nonatomic, retain) UIColor *placeholderColor;

@property (nonatomic, assign) int maxNumberOfLines;

/**
 *  此视图将把controller里的视图携带进来，因为服务号聊天界面和普通的聊天界面对于键盘的展示方式不一样，所以
 *  要传带这个containerView，所有键盘子控件将在这个targetView里来进行显隐操作，当然有些事件还是要传给
 *  targetView.controller的
 *
 *  不然如果有不同的消息列表界面，就要复制大量类似的代码。
 */
@property (nonatomic, strong) UIView *targetView;

/**
 *  隐藏语音按钮，重新布局输入框
 */
@property (nonatomic,assign) BOOL isNoShowVoiceBtn;

/**
 *  隐藏+按钮，重新布局输入框
 */
@property (nonatomic,assign) BOOL isShowPlusBtn;

/**
 *  是否显示菜单栏
 */
@property (nonatomic,assign) BOOL isShowMenuListButton;

/**
 *   菜单栏是否存在
 */
@property (nonatomic,assign) BOOL isMenuViewExist;

- (void)setIsShowMenuListButton:(BOOL)isShowMenuListButton;

/*
 *  还原所有的子视图，如果文本输入框里有文字不会还原为初始高度
 *
 */
- (void)reset;

@end

@protocol IMGrowingTextViewDelegate <NSObject>

@optional

/**
 *  点击键盘上的发送按钮的回调事件
 *
 *  @param _textView <#_textView description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)imGrowingTextViewShouldReturn:(GrowingTextView *)textView;

/**
 *  激活文本输入控件的回调事件
 *
 *  @param _textView <#_textView description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)imGrowingTextViewShouldBeginEditing:(GrowingTextView *)textView;

/**
 *  当前输入控件整个高度发生变化的回调事件
 *
 *  @param _textView <#_textView description#>
 *  @param height    <#height description#>
 */
- (void)imGrowingTextView:(GrowingTextView *)textView willChangeHeight:(CGFloat)height;

/**
 *  即将输入或替换文本的回调事件
 *
 *  @param _textView <#_textView description#>
 *  @param range     <#range description#>
 *  @param text      <#text description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)imGrowingTextView:(GrowingTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

/**
 *  输入控件复位到屏幕下方的时候的回调事件，这时要对应着触发主视图内容的调整
 *
 *  @param _textView <#_textView description#>
 *  @param tapped    <#tapped description#>
 */
- (void)imGrowingTextView:(GrowingTextView *)textView hasBeenResetWhetherVoiceButtonWasTapped:(BOOL)tapped;

/**
 *  弹起输入控件但键盘不弹起时，要触发targetView里的视图发生移动或其它操作，不然输入控件会挡住主视图
 *
 *  @param _textView <#_textView description#>
 */
- (void)imGrowingTextViewWillStandWithoutKeyboardPoppingUp:(GrowingTextView *)textView;

//TODO: 在这里添加其它委托事件，比如录完语音要发送出去
/**
 *  已经选好图片或拍好照片并存储到本地后的回调事件
 *
 *  @param _textView <#_textView description#>
 *  @param image     <#image description#>
 *  @param path      <#path description#>
 */
- (void)imGrowingTextView:(GrowingTextView *)textView didSelectImage:(UIImage *)image atPath:(NSString *)path;

- (void)willRecordingVoiceWithImGrowingTextView;

- (void)imGrowingTextView:(GrowingTextView *)textView didFinishRecordingVoiceWithDataVO:(id)audioDataVO;

/**
 *  选择了+功能里的发送位置
 *
 *  @param _textView <#_textView description#>
 */
- (void)imGrowingTextViewWillSendLocation:(GrowingTextView *)textView;

/**
 *  选择了+功能里的群通知
 *
 *  @param _textView <#_textView description#>
 */
- (void)imGrowingTextViewWillShareGroupNotify:(GrowingTextView *)textView;

/**
 *  选择了+功能里的集合点
 *
 *  @param _textView <#_textView description#>
 */
- (void)imGrowingTextViewWillShareAssembly:(GrowingTextView *)textView;

@required
/**
 *  因为表情和+按钮及对应下方的按钮的点击涉及到键盘的显隐的比较复杂操作，要即时地移除或添加键盘监听事件
 */
- (void)imGrowingTextView:(GrowingTextView *)textView needsBelongingController:(UIViewController *)controller toAddOrRemoveKeyboardObservers:(BOOL)shouldAdd;

/*
 *跳到图片页面方法
 */
-(void)pushImageView:(GrowingTextView *)textView;

/*
 *gif表情格式的图片直接发送
 */
@optional
-(void)imGrowingTextView:(GrowingTextView *)textView gifImageName:(NSString*)imagename
              andGifType:(NSString*)type andENName:(NSString*)ENname andZHName:(NSString*)ZHname;

@optional

- (void)touchToTransferMenuViewAndInputView;

@end
