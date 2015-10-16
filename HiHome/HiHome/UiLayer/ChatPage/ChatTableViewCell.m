//
//  ChatTableViewCell.m
//  HiHome
//
//  Created by 王建成 on 15/9/23.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "ChatTableViewCell.h"
//
//#define ZYNameFont [UIFont systemFontOfSize:15]
//#define ZYTextFont [UIFont systemFontOfSize:16]
//#define <#macro#>

@implementation ChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    NSLog(@"init cell");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

 - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.frame = frame;
        // 让自定义Cell和系统的cell一样, 一创建出来就拥有一些子控件提供给我们使用
       // 1.创建头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        self.iconView.frame = CGRectMake(ZY_ICON_CELL_X, ZY_ICON_CELL_Y, ZY_ICON_CELL_WIDTH, ZY_ICON_CELL_HIGHT);

                 // 2.创建昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        self.nameLabel.frame = CGRectMake(ZY_NAME_CELL_X, ZY_NAME_CELL_Y, ZY_NAME_CELL_WIDTH, ZY_NAME_CELL_HIGHT);
        
                // 4.创建正文
        UILabel *introLabel = [[UILabel alloc] init];
        introLabel.numberOfLines = 0;
        [self.contentView addSubview:introLabel];
        self.introLabel = introLabel;
        self.introLabel.frame = CGRectMake(ZY_TEXT_CELL_X, ZY_TEXT_CELL_Y, ZY_TEXT_CELL_WIDTH, ZY_TEXT_CELL_HIGHT);
        
        UILabel *timetempLabel = [[UILabel alloc] init];
        timetempLabel.numberOfLines = 0;
        [self.contentView addSubview:timetempLabel];
        self.timeLabel = timetempLabel;
        self.timeLabel.frame = CGRectMake(ZY_TIME_CELL_X, ZY_TIME_CELL_Y, ZY_TIME_CELL_WIDTH, ZY_TIME_CELL_HIGHT);
//
//        self.iconView.backgroundColor = [UIColor blueColor];
//        nameLabel.backgroundColor = [UIColor redColor];
//        introLabel.backgroundColor = [UIColor greenColor];
//        timetempLabel.backgroundColor = [UIColor yellowColor];
//        
        }
    
    return self;
}



@end
