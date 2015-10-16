//
//  AlbumPath.h
//  HiHome
//
//  Created by 王建成 on 15/10/10.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PicPath : NSObject
{

    
}
@property(nonatomic)NSString *picName;
@property(nonatomic)NSDateComponents *picDate;
@property(nonatomic)NSString *picDescribe;
@end

@interface AlbumPath : NSObject
{

}
@property(nonatomic)NSString *fristPicName;
@property(nonatomic)NSString *albumName;
@property(nonatomic)NSInteger picNum;
@property(nonatomic)NSDateComponents *albumChangeDate;
@property(nonatomic)NSMutableArray *albumPhotos;//PicPath 数组
@end
