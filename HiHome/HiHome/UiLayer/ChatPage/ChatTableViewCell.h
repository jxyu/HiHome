//
//  ChatTableViewCell.h
//  HiHome
//
//  Created by 王建成 on 15/9/23.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZY_ICON_CELL_X   5
#define ZY_ICON_CELL_Y   5
#define ZY_ICON_CELL_WIDTH   40
#define ZY_ICON_CELL_HIGHT   40


#define ZY_NAME_CELL_X   50
#define ZY_NAME_CELL_Y   5
#define ZY_NAME_CELL_WIDTH   40
#define ZY_NAME_CELL_HIGHT   20


#define ZY_TIME_CELL_WIDTH   50
#define ZY_TIME_CELL_X      (self.frame.size.width - 10 - ZY_TIME_CELL_WIDTH)
#define ZY_TIME_CELL_Y   5
#define ZY_TIME_CELL_HIGHT   20


#define ZY_TEXT_CELL_WIDTH   (self.frame.size.width - 10 - ZY_TIME_CELL_WIDTH - 20 - ZY_TEXT_CELL_X)
#define ZY_TEXT_CELL_X   50
#define ZY_TEXT_CELL_Y   30
#define ZY_TEXT_CELL_HIGHT   20




@interface ChatTableViewCell : UITableViewCell


@property(nonatomic) NSString *icon;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *text;
@property(nonatomic) NSString *time;

/**
  *  头像
  */
@property (strong,nonatomic) UIImageView *iconView;
/**
*  昵称
*/
@property (strong,nonatomic) UILabel *nameLabel;

/**
 *  时间
 */
@property (strong,nonatomic) UILabel *timeLabel;

/**
*  正文
*/
@property (strong,nonatomic) UILabel *introLabel;



@end
