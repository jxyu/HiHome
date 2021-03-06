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
    _albumPath = [[AlbumPath alloc] init];
    _picPath = [[PicPath alloc] init];
    [self initViews];

    return  self;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.frame = frame;
    _albumPath = [[AlbumPath alloc] init];
    _picPath = [[PicPath alloc] init];
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
        if(albumPath.picNum != 0)
        {
            _albumNameLabel.text = [NSString stringWithFormat:@"%@ %ld张",albumPath.albumName,(long)albumPath.picNum];//[taskPath.endTaskDate month]
            //_albumDateLabel.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)[albumPath.albumChangeDate year],(long)[albumPath.albumChangeDate month],(long)[albumPath.albumChangeDate day]];
        }
        else
        {
             _albumNameLabel.text = [NSString stringWithFormat:@"%@",albumPath.albumName];
        }
        _albumDateLabel.text = albumPath.albumChangeDateStr;
       // _picView.image = [UIImage imageNamed:albumPath.fristPicName];
        NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,albumPath.fristPicName];
        NSLog(@"img url = [%@]",url);
        [_picView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"fristPic"]];
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
 //   _picView.image = [UIImage imageNamed:picPath.picName];
    
//    NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,picPath.picName];
//    NSLog(@"img url = [%@]",url);
//    [_picView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"fristPic"]];
   // _picView.image = [UIImage imageNamed:@"fristPic"];
    _picView.contentMode = UIViewContentModeScaleAspectFit;
    
    _albumDateLabel.font = [UIFont boldSystemFontOfSize:18];
    _picDescribeLabel.font = [UIFont boldSystemFontOfSize:14];
    
    _albumDateLabel.textColor = ZY_UIBASECOLOR;
    _picDescribeLabel.textColor = [UIColor grayColor];
    
    _picDescribeLabel.text = picPath.picDescribe;
    _picDescribeLabel.numberOfLines = 0;
    //_albumDateLabel.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)[picPath.picDate year],(long)[picPath.picDate  month],(long)[picPath.picDate  day]];
    _albumDateLabel.text = picPath.picDateStr;
    
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
