//
//  CardTableViewCell.h
//  HiHome
//
//  Created by 王建成 on 15/9/26.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ZY_ICON_CELL_X   20
#define ZY_ICON_CELL_Y   10
#define ZY_ICON_CELL_WIDTH   60
#define ZY_ICON_CELL_HIGHT   60


#define ZY_NAME_CELL_X   90
#define ZY_NAME_CELL_Y   25
#define ZY_NAME_CELL_WIDTH   100
#define ZY_NAME_CELL_HIGHT   30
@interface CardTableViewCell : UITableViewCell
/**
 *  头像
 */
@property (strong,nonatomic) UIImageView *iconView;
/**
 *  昵称
 */
@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) UIButton * btn_tianjia;

@end
