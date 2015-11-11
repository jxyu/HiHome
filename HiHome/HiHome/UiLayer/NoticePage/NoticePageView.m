//
//  NoticePageView.m
//  HiHome
//
//  Created by 王建成 on 15/11/7.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "NoticePageView.h"


#define AlertHeight 450
#define AlertWidth 200

@interface NoticePageView()
{
    NSString *_title;
    NSString *_message;
    UIView *_coverView;
    UIView *_alertView;
    UIImageView *headImg;
}
@end

@implementation NoticePageItem
{
    
}



@end
@implementation NoticePageView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message{
    self = [super init];
    if (self) {
        _title = title;
        _message = message;
        _items = [[NSMutableArray alloc] init];
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
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AlertWidth, AlertHeight)];
    _alertView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    //    _alertView.layer.cornerRadius = 5;
    _alertView.layer.masksToBounds = YES;
    _alertView.layer.cornerRadius = 5;
    _alertView.backgroundColor = [UIColor whiteColor];
    
    _alertView.layer.shadowColor = [[UIColor grayColor] CGColor];
    _alertView.layer.shadowRadius = 0.5;
    _alertView.layer.shadowOpacity = 2;
    _alertView.layer.shadowOffset = CGSizeZero;
    _alertView.layer.masksToBounds = NO;
    
    [self addSubview:_alertView];
    
    
    CGFloat labelHeigh = [self heightWithString:_title fontSize:18 width:AlertWidth-2*AlertPadding];
    _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, AlertPadding, AlertWidth, labelHeigh)];
    _labelTitle.font = [UIFont boldSystemFontOfSize:18];
    _labelTitle.textColor = ZY_UIBASECOLOR;
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.numberOfLines = 0;
    _labelTitle.text = _title;
    _labelTitle.lineBreakMode = NSLineBreakByCharWrapping;
    [_alertView addSubview:_labelTitle];
    
    
    _messageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(AlertPadding/2,_labelTitle.frame.origin.y+_labelTitle.frame.size.height+5 , AlertWidth-AlertPadding, [self heightWithString:@"你"/*一行字的高低*/ fontSize:16 width:AlertWidth-2*AlertPadding]*7)];
    
    headImg =[ [UIImageView alloc] initWithFrame:CGRectMake(_messageScrollView.frame.size.width/2- 20, 0, 40, 40)];
    
   // NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,strAvatar];
    
    
   // headImg.image = [UIImage imageNamed:@"me"];
    
    headImg.layer.cornerRadius = headImg.frame.size.width * 0.5;
    headImg.layer.borderWidth = 1;
    headImg.layer.borderColor = [ZY_UIBASECOLOR CGColor];
    headImg.layer.masksToBounds = YES;
    
    [_messageScrollView addSubview:headImg];
    
    [_alertView addSubview:_messageScrollView];
    _messageScrollView.contentSize = CGSizeMake(_messageScrollView.frame.size.width, _messageScrollView.frame.size.height*2);
    
     CGFloat messageHeigh = [self heightWithString:_message fontSize:14 width:AlertWidth-2*AlertPadding];
    //message
    _labelmessage =  [[UILabel alloc]initWithFrame:CGRectMake(0, headImg.frame.size.height, _messageScrollView.frame.size.width, messageHeigh)];
    _labelmessage.font = [UIFont systemFontOfSize:14];
    _labelmessage.textColor = [UIColor grayColor];
    _labelmessage.textAlignment = NSTextAlignmentLeft;
    _labelmessage.text = _message;
    _labelmessage.numberOfLines = 0;
//    _labelmessage.lineBreakMode = NSLineBreakByCharWrapping;
    [_messageScrollView addSubview:_labelmessage];
    _messageScrollView.contentSize = CGSizeMake(_messageScrollView.frame.size.width,headImg.frame.size.height + _labelmessage.frame.size.height );
    
    
   // _messageScrollView.backgroundColor = [UIColor blueColor];
    //_labelmessage.backgroundColor = [UIColor redColor];
    
    checkTaskBtn = [[UIButton alloc] initWithFrame:CGRectMake(AlertWidth/2-50,(_messageScrollView.frame.size.height + _messageScrollView.frame.origin.y + 5), 100, 20)];
    checkTaskBtn.titleLabel.font =[UIFont systemFontOfSize:14];
    checkTaskBtn.backgroundColor = ZY_UIBASECOLOR;
    [checkTaskBtn setTitle:@"查看任务详情" forState:UIControlStateNormal];
    [checkTaskBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_alertView addSubview:checkTaskBtn];
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    [_alertView addSubview:_contentScrollView];
    
}


-(void)setHeadImgUrl:(NSString *)HeadImgUrl
{
    _HeadImgUrl = HeadImgUrl;
    
    [headImg sd_setImageWithURL:[NSURL URLWithString:self.HeadImgUrl] placeholderImage:[UIImage imageNamed:@"me"]];
}

-(void)btnAction
{
    if([self.delegate respondsToSelector:@selector(clickTaskDetailBtnAction)])
    {
        [self.delegate clickTaskDetailBtnAction];
    }
}

- (CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}

#pragma mark - add item

- (NSInteger)addButtonWithTitle:(NSString *)title{
    NoticePageItem *item = [[NoticePageItem alloc] init];
    item.title = title;
    item.action =  ^(NoticePageItem *item) {
        NSLog(@"no action");
    };
    item.type = NoticeButton_OK;
    [_items addObject:item];
    return [_items indexOfObject:title];
}
- (void)addButton:(NoticeButtonType)type withTitle:(NSString *)title handler:(NoticePageHandler)handler{
    NoticePageItem *item = [[NoticePageItem alloc] init];
    item.title = title;
    item.action = handler;
    item.type = type;
    [_items addObject:item];
    item.tag = [_items indexOfObject:item];
}
- (void)addButtonItem {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    //        button.translatesAutoresizingMaskIntoConstraints = NO;
    button.frame = CGRectMake(_alertView.frame.size.width/3, _alertView.frame.size.height/3*2, _alertView.frame.size.width/3, _alertView.frame.size.height/6);
    //seperator
    button.backgroundColor = ZY_UIBASECOLOR;
    //        button.layer.shadowColor = [[UIColor grayColor] CGColor];
    //        button.layer.shadowRadius = 0.5;
    //        button.layer.shadowOpacity = 1;
    //        button.layer.shadowOffset = CGSizeZero;
    //        button.layer.masksToBounds = NO;
    button.tag = 90000;
    // title
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:button.titleLabel.font.pointSize];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    // action
    [button addTarget:self
               action:@selector(buttonTouched:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [_alertView addSubview:button];
    
    
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{

    [self addButtonItems];
    [_contentScrollView addSubview:self.contentView];
    [self reLayout];
}


- (void)addButtonItems {
    _buttonScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,AlertPadding + checkTaskBtn.frame.size.height + checkTaskBtn.frame.origin.y,AlertWidth, AlertHeight- (checkTaskBtn.frame.size.height + checkTaskBtn.frame.origin.y+AlertPadding))];
    //_buttonScrollView.layer.borderWidth = 0.5;
    _buttonScrollView.contentSize = CGSizeMake(AlertWidth, _buttonScrollView.frame.size.height*2);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AlertWidth, 1)];
    lineView.backgroundColor = ZY_UIBASE_FONT_COLOR;
    //lineView.alpha = 0.5;
    lineView.layer.shadowRadius = 4;
    lineView.layer.shadowOffset = CGSizeMake(4,4);
    [_buttonScrollView addSubview:lineView];
    
    _buttonScrollView.bounces = NO;
    _buttonScrollView.showsHorizontalScrollIndicator = NO;
    _buttonScrollView.showsVerticalScrollIndicator =  NO;
    CGFloat  height;
    CGFloat  padding;
    if(self.buttonHeight){
        if(self.buttonPaddingH == 0)
        {
            self.buttonPaddingH = 20;
        }
        padding = self.buttonPaddingH;
        height = self.buttonHeight;
        _buttonScrollView.contentSize = CGSizeMake(height*[_items count], MenuHeight);
        
        _buttonScrollView.frame = CGRectMake(0, _buttonScrollView.frame.origin.y,_buttonScrollView.frame.size.width , height*(([_items count])>4?4:[_items count])+ 40);
        
        _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, _alertView.frame.size.width, _buttonScrollView.frame.origin.y + height*(([_items count])>4?4:[_items count]) + 40);
        _alertView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        
    }else
    {
        height = (_buttonScrollView.frame.size.height - 10)/[_items count];
    }
    [_items enumerateObjectsUsingBlock:^(NoticePageItem *item, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        //        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.frame = CGRectMake(20 , idx*(height) + padding, AlertWidth - 20*2, height - 10);
        //seperator
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = button.frame.size.height/2;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [ZY_UIBASECOLOR CGColor];
     //   button.layer.masksToBounds = YES;
        
        button.layer.shadowColor = [ZY_UIBASECOLOR CGColor];
        button.layer.shadowRadius = 0.5;
        button.layer.shadowOpacity = 1;
        button.layer.shadowOffset = CGSizeZero;
        button.layer.masksToBounds = NO;
        button.tag = 90000+ idx;
        // title
        [button setTitle:item.title forState:UIControlStateNormal];
        [button setTitle:item.title forState:UIControlStateSelected];
        [button setTitleColor:ZY_UIBASECOLOR forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:button.titleLabel.font.pointSize];
        
        // action
        [button addTarget:self
                   action:@selector(buttonTouched:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonScrollView addSubview:button];
    }];
    [_alertView addSubview:_buttonScrollView];
    
}

- (void)buttonTouched:(UIButton*)button{
    
    if(_items.count == 0)
    {
        [self dismiss];
        return;
    }
    NoticePageItem *item = _items[button.tag-90000];
    if (item.action) {
        item.action(item);
    }
    [self dismiss];
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
    return  window.subviews[0];
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
    [_alertView.layer addAnimation:popAnimation forKey:nil];
}


- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 0.5;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [[self topView] addSubview:self];
    [self showAnimation];
}

- (void)dismiss {
    [self hideAnimation];
}


- (void)hideAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        _coverView.alpha = 0.0;
        _alertView.alpha = 0.0;
        
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
