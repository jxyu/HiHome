//
//  PullDownButtons.m
//  HiHome
//
//  Created by 王建成 on 15/10/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "PullDownButtonsTab.h"
#import "UIDefine.h"
#import "SegmentedButton.h"

#define PullDownWidth   (self.frame.size.width)
#define PullDownHeight 64

@implementation PullDownButtonsTab

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


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



-(id)init
{
    self = [super init];
    if (self) {
        NSLog(@"run here [%d]",__LINE__);
        _btnNum = 3;
        [self buildViews];
        
    }
    return self;
}



-(void)buildViews{
    self.frame = CGRectMake(0, ZY_HEADVIEW_HEIGHT, [self screenBounds].size.width, [self screenBounds].size.height-ZY_HEADVIEW_HEIGHT);
    
//    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [[self topView].bounds].frame.size.width, [[self topView].bounds].frame.size.height)];
//    
    
    
    _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [self topView].bounds.size.width, [self topView].bounds.size.height - 64)];
    
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;
    _coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  //  [[self topView] addSubview:_coverView];
    [self addSubview:_coverView];
    
    _pullBtnsTab = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PullDownWidth, PullDownHeight)];
   // _pullBtnsTab.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    //    _alertView.layer.cornerRadius = 5;
    _pullBtnsTab.layer.masksToBounds = YES;
    _pullBtnsTab.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pullBtnsTab];
 //   [self addSubview:_pullBtnsTab];
    
    [self setBtns];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [_coverView addGestureRecognizer:tapGesture];
    
    
//    屏幕旋转操作
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}


-(void)tapViewAction:(id)sender
{
    [self dismiss];
}

-(void) setBtns
{
    SegmentedButton *upLoadBtn = [[SegmentedButton alloc] init];
    upLoadBtn.frame = CGRectMake(20, 0, self.frame.size.width/3-20-10, _pullBtnsTab.frame.size.height);
    [upLoadBtn setTitle:@"上传照片" forState:UIControlStateNormal];
    upLoadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    upLoadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    upLoadBtn.imageView.contentMode = UIViewContentModeCenter;
    [upLoadBtn setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
    [upLoadBtn setImage:[UIImage imageNamed:@"uploadPic"] forState:UIControlStateNormal];
    upLoadBtn.tag = ZY_UIBUTTON_TAG_BASE +1;
    [upLoadBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_pullBtnsTab addSubview:upLoadBtn];
    
    
    
    SegmentedButton *takePic = [[SegmentedButton alloc] init];
    takePic.frame = CGRectMake(self.frame.size.width/3 + 10, 0, self.frame.size.width/3-20-10, _pullBtnsTab.frame.size.height);
    [takePic setTitle:@"拍照上传" forState:UIControlStateNormal];
    takePic.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    takePic.titleLabel.textAlignment = NSTextAlignmentCenter;
    takePic.imageView.contentMode = UIViewContentModeCenter;
    [takePic setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
    [takePic setImage:[UIImage imageNamed:@"takePic"] forState:UIControlStateNormal];
    takePic.tag = ZY_UIBUTTON_TAG_BASE +2;
    [takePic addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_pullBtnsTab addSubview:takePic];
    
    
    
    SegmentedButton *createAlbum = [[SegmentedButton alloc] init];
    createAlbum.frame = CGRectMake(self.frame.size.width/3*2 + 10, 0, self.frame.size.width/3-20-10, _pullBtnsTab.frame.size.height);
    
    createAlbum.titleLabel.textAlignment = NSTextAlignmentCenter;
    createAlbum.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    createAlbum.imageView.contentMode = UIViewContentModeCenter;
    createAlbum.tag = ZY_UIBUTTON_TAG_BASE +3;
    [createAlbum setTitle:@"新建相册" forState:UIControlStateNormal];
    [createAlbum setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
    [createAlbum setImage:[UIImage imageNamed:@"newAlbum"] forState:UIControlStateNormal];
    [createAlbum addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_pullBtnsTab addSubview:createAlbum];
}

-(void) btnClick:(SegmentedButton *)sender
{
    
    if([self.delegate respondsToSelector:@selector(respondBtns:)])
    {
        [self.delegate respondBtns:sender.tag];
    }
    
}


-(UIView*)topView{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return  window.subviews[0];
}


- (void)show {
    _coverView.alpha = 0.5;
    _pullBtnsTab.alpha = 1;
//    [UIView animateWithDuration:0.5 animations:^{
//        _coverView.alpha = 0.5;
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
   // [_coverView addSubview:self];
    
    [[self topView] addSubview:self];
  //  [self showAnimation];
}
- (void)dismiss {
    [self hideAnimation];
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
    [_pullBtnsTab.layer addAnimation:popAnimation forKey:nil];
}


- (void)hideAnimation{
    
    _coverView.alpha = 0.0;
    _pullBtnsTab.alpha = 0.0;
    [self removeFromSuperview];
//    [UIView animateWithDuration:0.4 animations:^{
//       
//        
//    } completion:^(BOOL finished) {
//        [
//    }];

}




@end
