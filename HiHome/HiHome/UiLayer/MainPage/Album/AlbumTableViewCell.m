//
//  AlbumTableViewCell.m
//  HiHome
//
//  Created by 王建成 on 15/10/10.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AlbumTableViewCell.h"
#import "UIDefine.h"

@implementation AlbumTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)init
{
    self = [super init];
    self.albumPath = [[AlbumPath alloc] init];
    self.picPath = [[PicPath alloc] init];
    [self initViews];

    return  self;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.frame = frame;
    self.albumPath = [[AlbumPath alloc] init];
    self.picPath = [[PicPath alloc] init];
    [self initViews];

    return  self;
}

-(void) setCellType:(CellType)cellType
{
    _cellType = cellType;
    [self layoutViews];
}

-(void) layoutViews
{
    if(_cellType == CellTypeDefault)
    {
        UIImageView *nextIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set"]];
        nextIcon.frame = CGRectMake(self.frame.size.width-20,0,15,self.frame.size.height );
        nextIcon.contentMode = UIViewContentModeCenter;
        
        [self addSubview:nextIcon];
        
        _picView.frame = CGRectMake(0, 2, self.frame.size.height - 4, self.frame.size.height - 4);
        _albumNameLabel.frame = CGRectMake(self.frame.size.height - 4 + 20, self.frame.size.height/4, 200, 30);
        _albumDateLabel.frame = CGRectMake(self.frame.size.height - 4 + 20, self.frame.size.height/3*2, 200, 20);
    }
    else if (_cellType == CellTypePicRecent)
    {
        _albumDateLabel.frame = CGRectMake(10, self.frame.size.height/10*3, self.frame.size.width/10*3, 20);
        _picDescribeLabel.frame =CGRectMake(10, self.frame.size.height/10*3+20+5, self.frame.size.width/10*4, self.frame.size.height -(self.frame.size.height/10*3+20+10)-20);
        
        _picView.frame = CGRectMake(self.frame.size.width/10*4+20, 5, self.frame.size.width/10*6 - 40, self.frame.size.height - 10);
        
    }
}

-(void) setAlbumPath:(AlbumPath *)albumPath
{
    if(albumPath == nil)
        return;
    
    if(_cellType == CellTypeDefault)
    {
        
        _albumNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _albumDateLabel.font = [UIFont boldSystemFontOfSize:12];
        
        _albumNameLabel.textColor = ZY_UIBASECOLOR;
        _albumDateLabel.textColor = [UIColor grayColor];
        
        _albumNameLabel.text = [NSString stringWithFormat:@"%@(%ld)",albumPath.albumName,albumPath.picNum];//[taskPath.endTaskDate month]
        _albumDateLabel.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld",[albumPath.albumChangeDate year],[albumPath.albumChangeDate month],[albumPath.albumChangeDate day]];
        _picView.image = [UIImage imageNamed:albumPath.fristPicName];
        
        _picView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if (_cellType == CellTypePicRecent)
    {
      // do nothing
     
    }
}

-(void)setPicPath:(PicPath *)picPath
{
    if(picPath==nil)
        return;
    _picView.image = [UIImage imageNamed:picPath.picName];
    _picView.contentMode = UIViewContentModeScaleAspectFit;
    
    _albumDateLabel.font = [UIFont boldSystemFontOfSize:18];
    _picDescribeLabel.font = [UIFont boldSystemFontOfSize:14];
    
    _albumDateLabel.textColor = ZY_UIBASECOLOR;
    _picDescribeLabel.textColor = [UIColor grayColor];
    
    _picDescribeLabel.text = picPath.picDescribe;
    _picDescribeLabel.numberOfLines = 0;
    _albumDateLabel.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld",[picPath.picDate year],[picPath.picDate  month],[picPath.picDate  day]];
    
}


-(void)initViews
{
    _picView = [[UIImageView alloc] init];
    _albumDateLabel = [[UILabel alloc] init];
    _albumNameLabel = [[UILabel alloc] init];
    _picDescribeLabel = [[UILabel alloc] init];
    

    [self addSubview:_picView];
    [self addSubview:_albumDateLabel];
    [self addSubview:_albumNameLabel];
    [self addSubview:_picDescribeLabel];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
