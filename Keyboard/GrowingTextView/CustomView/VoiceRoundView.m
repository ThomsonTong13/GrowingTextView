//
//  VoiceRoundView.m
//  Keyboard
//
//  Created by Thomson on 15/11/25.
//  Copyright © 2015年 Kemi. All rights reserved.
//

#import "VoiceRoundView.h"

#import "Masonry.h"
#import "RACEXTScope.h"
#import "KBUtility.h"

#define dl_voiceRoundViewWidth 150

@interface VoiceRoundView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation VoiceRoundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        self.frame = CGRectMake((kScreenWidth - dl_voiceRoundViewWidth)/2,
                                (kScreenHeight - dl_voiceRoundViewWidth)/2,
                                dl_voiceRoundViewWidth,
                                dl_voiceRoundViewWidth);

        self.backgroundColor = [UIColor clearColor];

        int w = 50;
        int h = 80;

        _imgView = [[UIImageView alloc] init];
        _imgView.frame = CGRectMake(self.frame.size.width/2 - w/2, 20, w, h);
        _imgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imgView];

        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:15];
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_label];

        @weakify(self);
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {

            @strongify(self);
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(-5);
        }];

        self.alpha = 0;
    }

    return self;
}

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    [view addSubview:self];

    @weakify(self);
    [UIView animateWithDuration:animated?0.35:0 animations:^{

        @strongify(self);
        self.alpha = 1.0;
    }];
}

- (void)dismiss:(BOOL)animated
{
    [self dismissAfterSeconds:0 animated:animated];
}

- (void)dismissAfterSeconds:(NSInteger)seconds animated:(BOOL)animated
{
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:animated? 0.35: 0
                         animations:^{

                             @strongify(self);
                             self.alpha = 0.0;
                         }
                         completion:^(BOOL finished){

                             @strongify(self);
                             [self removeFromSuperview];
                         }
         ];
    });
}

- (BOOL)showNextImage
{
    if ([_imageName length] != 14 || ![[_imageName substringToIndex:13] isEqualToString:@"voice_record_"])
    {
        return NO;
    }

    int intRight = [[_imageName substringFromIndex:13] intValue];

    if (intRight == 4)
    {
        intRight = 1;
    }
    else if (intRight > 0 && intRight < 4)
    {
        intRight ++;
    }
    else
    {
        return NO;
    }

    NSString *strNextImage = [NSString stringWithFormat:@"voice_record_%d",intRight];
    self.imageName = strNextImage;

    return YES;
}

- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName)
    {
        _imageName = imageName;

        UIImage *image = [UIImage imageNamed:imageName];
        _imgView.image = image;

        _imgView.frame = CGRectMake(0,
                                    0,
                                    self.frame.size.width,
                                    image.size.height);
    }
}

- (void)setTitle:(NSString *)title
{
    if (_title != title)
    {
        _title = title;

        _label.text = title;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context  = UIGraphicsGetCurrentContext();
    float fw = rect.size.width;
    float fh = rect.size.height;

    float r = 10;
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, r);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, r); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, r); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, r); // Back to lower right
    CGContextClosePath(context);
    CGFloat gray[4] = {0, 0, 0, 0.6f};
    CGContextSetFillColor(context, gray);
    CGContextFillPath(context);
}

@end
