//
//  PictureShowView.h
//  HiHome
//
//  Created by 王建成 on 15/11/12.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@protocol PictureShowViewDelegate <NSObject>

-(void)didClickDelPicBtn:(NSInteger)index;

@end

@interface PictureShowView : UIView

@property(assign,nonatomic)NSString *ImgUrl;
@property(assign,nonatomic)NSInteger picIndex;

@property(nonatomic) id<PictureShowViewDelegate> delegate;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
- (void)show;
- (void)dismiss;
@end
