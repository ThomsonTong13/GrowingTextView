//
//  Faceboard.h
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LaunchScrollView.h"

@class PageControl;
@protocol FaceboardDelegate;

@interface Faceboard : UIView
{
    CGRect touchBeginFrame;
@private
    BOOL _isFromGif;
}

@property (nonatomic, assign) BOOL isFromPubSubView;
@property (nonatomic, strong) NSArray *emojiArray;
@property (nonatomic, strong) NSArray *symbolArray;
@property (nonatomic, strong) NSArray *alatoyimages;
@property (nonatomic, strong) NSArray *alatoyZHnames;
@property (nonatomic, strong) NSArray *alatoyENnames;
@property (nonatomic, strong) NSMutableArray *emojiImageViewArray;
@property (nonatomic, assign) NSInteger touchedIndex;
@property (nonatomic, strong) LaunchScrollView *sutraScrollView;
@property (nonatomic, strong) LaunchScrollView *latelyScrollView;
@property (nonatomic, strong) LaunchScrollView *faceScrollView;
@property (nonatomic, strong) UIImageView *zoomImageBackgroudView;
@property (nonatomic, strong) UIImageView *nextZoomImageBackgroudView;
@property (nonatomic, strong) UIImageView *zoomImageView;
@property (nonatomic, strong) UIImageView *nextZoomImageView;
@property (nonatomic, assign) id<FaceboardDelegate> delegate;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, strong) PageControl *pageControl;
@property (nonatomic, strong) UIScrollView *buttomView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIButton *sutraButton;

- (void)initEmojiDataAndUi;

@end

@protocol FaceboardDelegate <NSObject>

- (void)emojiView:(Faceboard *)emojiView didTouchEmojiWithSignature:(NSString*)signature andName:(NSString *)name;
- (void)emojiView:(Faceboard *)emojiView didTouchSendingButton:(UIButton *)sendButton;
- (void)emojiView:(Faceboard *)emojiView didTouchEmojiWithImagename:(NSString *)ImageName andENname:(NSString*)ENname andZHName:(NSString*)ZHname;

@end
