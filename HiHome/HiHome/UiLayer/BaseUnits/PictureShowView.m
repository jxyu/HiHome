//
//  PictureShowView.m
//  HiHome
//
//  Created by 王建成 on 15/11/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PictureShowView.h"

#define AlertHeight 300
//#define AlertWidth

@interface PictureShowView()
{
    NSString *_title;
    NSString *_message;
    UIView *_coverView;
    UIView *_alertView;
    
    UIImageView *_imgShowView;
    UIImageView *headImg;
    UIButton *delBtn ;
}
@end

@implementation PictureShowView


- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message{
    self = [super init];
    if (self) {
        _title = title;
        _message = message;
        //  _alertType = AlertType_Hint;
        [self buildViews];
    }
    return self;
}

- (CGRect)screenBounds
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGRectMake(0, 0, screenWidth, screenHeight);
}


-(void)buildViews{
    self.frame = [self screenBounds];
    _coverView = [[UIView alloc]initWithFrame:[self topView].bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;
    _coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self topView] addSubview:_coverView];
    
    _imgShowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , AlertHeight)];
    _imgShowView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _imgShowView.backgroundColor = [UIColor blackColor];
    _imgShowView.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:_imgShowView];
    

    delBtn =[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44 -20, 20, 44, 44)];
    [delBtn setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:delBtn];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
    [self addGestureRecognizer:tapGesture];
}
-(void)btnClickAction:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(didClickDelPicBtn:)])
    {
        [self.delegate didClickDelPicBtn:self.picIndex];
    }

}


-(void)tapViewAction:(id)sender
{
    [self dismiss];
}
-(void)setImgUrl:(NSString *)ImgUrl
{
    _ImgUrl = ImgUrl;
    
    [_imgShowView sd_setImageWithURL:[NSURL URLWithString:self.ImgUrl] placeholderImage:[UIImage imageNamed:@"me"]];

}
- (CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}

#pragma mark - add item

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reLayout];
}



#pragma mark - Handle device orientation changes
// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    //    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    self.frame = [self screenBounds];
    //NSLog(@"self.frame%@",NSStringFromCGRect(self.frame));
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         //  [self reLayout];
                     }
                     completion:nil
     ];
    
    
}

-(void)reLayout{
    //   CGFloat plus;
    
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

#pragma mark - notice page  show

-(UIView*)topView{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return  window.subviews[window.subviews.count - 1];
}


- (void)showAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_imgShowView.layer addAnimation:popAnimation forKey:nil];
}


- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
    UIView *tempView = [self topView];
    
    [tempView addSubview:self];
    [tempView bringSubviewToFront:self];
    [self showAnimation];
}

- (void)dismiss {
    [self hideAnimation];
}


- (void)hideAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        _coverView.alpha = 0.0;
        _imgShowView.alpha = 0.0;
        delBtn.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
