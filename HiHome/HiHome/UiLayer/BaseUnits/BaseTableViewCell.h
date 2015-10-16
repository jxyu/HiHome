//
//  BaseTableViewCell.h
//  HiHome
//
//  Created by 王建成 on 15/10/6.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface BaseTableViewCell : UITableViewCell
{
    NSMutableArray *_imgs;
    NSMutableArray *_labels;
    NSMutableArray *_btns;
}




@property(strong,nonatomic) NSMutableArray *contentImgs;
@property(strong,nonatomic) NSMutableArray *contentLabels;
@property(strong,nonatomic) NSMutableArray *contentBtns;
@property(strong,nonatomic) NSMutableArray *contentOtherViews;
@end
