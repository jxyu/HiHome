//
//  AlbumTableViewCell.h
//  HiHome
//
//  Created by 王建成 on 15/10/10.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumPath.h"
#import "UIImageView+WebCache.h"
typedef enum _CellType
{
    CellTypeDefault = 0,
    CellTypePicRecent,
    
    CellTypeReserve = 0xffffffff

}CellType;

@interface AlbumTableViewCell : UITableViewCell
{
    @private
    UIImageView *_picView;
    UILabel *_albumNameLabel;
    UILabel *_albumDateLabel;
    UILabel *_picDescribeLabel;
}
@property(nonatomic)CellType cellType;
@property(strong,nonatomic)AlbumPath *albumPath;
@property(strong,nonatomic)PicPath  *picPath;
@property(strong,nonatomic)NSMutableArray *customViews;
@end
