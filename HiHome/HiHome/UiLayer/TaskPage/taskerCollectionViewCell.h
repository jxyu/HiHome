//
//  taskerCollectionViewCell.h
//  HiHome
//
//  Created by 王建成 on 15/10/28.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface taskerCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic)UIImageView *headView;
@property(strong,nonatomic)UILabel *nameLab;
@property(strong,nonatomic)UILabel *stateLab;
-(void)initViews;
@end
