//
//  VoiceRoundView.h
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceRoundView : UIView

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)dismiss:(BOOL)animated;
- (void)dismissAfterSeconds:(NSInteger)seconds animated:(BOOL)animated;
- (void)setTitle:(NSString *)title;
- (BOOL)showNextImage;

@end
