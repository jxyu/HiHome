//
//  DataProvider.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject
{
    id CallBackObject;
    NSString * callBackFunctionName;
}

//修改头像
-(void)changeHeadImg:(NSString *)uid andImgsrc:(NSString *)imgsrc;

//反馈信息保存
-(void)HelpAndFeedbackSave:(NSString *)uid andTitle:(NSString *)title andContent:(NSString *)content;

//功能介绍
-(void)getFunctionDesc;

/**
 *  注册
 *
 *  @param prm 参数
 */
-(void)RegisterUserInfo:(id)prm;
/**
 *  登录
 *
 *  @param mobel 手机号
 *  @param pwd   密码
 */
-(void)Login:(NSString *)mobel andpwd:(NSString *)pwd andreferrer:(NSString *)referrer;
/**
 *  重置密码
 *
 *  @param prm <#prm description#>
 */
-(void)ResetPwd:(id)prm;

/**
 *  忘记密码
 *
 *  @param prm
 */
-(void)ForgetPassWord:(id)prm;


//获取天气信息
-(void)getWeatherInfo: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg;

-(void)GetToken:(NSString *)userid;

/**
 *  获取任务
 *
 *  @param userID       用户id
 *  @param state        任务状态
 *  @param my           是否是自己的任务
 *  @param page         当前页码，   default 1
 *  @param perpage          每页显示数量  default  10
 */

-(void)getReceiveTask:(NSString *)userID andState:(NSString*)state andMyOrNot:(NSString *)my andPage:(NSString *)page andPerPage:(NSString *)perpage andDate:(NSString *)date andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate;
/**
 *  获取发布的任务
 *
 *  @param userID       用户id
 *  @param state        任务状态
 *  @param page         当前页码，   default 1
 *  @param perpage          每页显示数量  default  10
 */


-(void)getSendTask:(NSString *)userID andState:(NSString*)state andPage:(NSString *)page andPerPage:(NSString *)perpage andDate:(NSString *)date;

/**
 *  创建任务
 *
 *  @param userID     user id
 *  @param title        任务名称
 *  @param content      任务内容
 *  @param isDay        是否是全天任务
 *  @param stime        开始时间
 *  @param etime        结束时间
 *  @param tip          任务提醒
 *  @param repeat       任务重复
 *  @param tasker       任务执行人数量
 *
 *
 */
-(void) createTask:(NSString *)userID andTitle:(NSString *)title andContent:(NSString *)content andIsDay:(NSString *)isDay andStartTime:(NSString *)stime andEndTime:(NSString *)etime andTip:(NSString *)tip andRepeat:(NSString *)repeat andTasker:(NSString *)tasker andimgsrc1:(NSString *)imgsrc1 andimgsrc2:(NSString *)imgsrc2 andimgsrc3:(NSString *)imgsrc3 andAddress:(NSString *) address andLng:(NSString *) lng andLat:(NSString *) lat;
/**
 *  创建任务
 *
 *  @param taskID       任务 id
 *  @param title        任务名称
 *  @param content      任务内容
 *  @param isDay        是否是全天任务
 *  @param stime        开始时间
 *  @param etime        结束时间
 *  @param tip          任务提醒
 *  @param repeat       任务重复
 *  @param tasker       任务执行人数量
 *
 *
 */

-(void) updateTask:(NSString *)taskID andTitle:(NSString *)title andContent:(NSString *)content andIsDay:(NSString *)isDay andStartTime:(NSString *)stime andEndTime:(NSString *)etime andTip:(NSString *)tip andRepeat:(NSString *)repeat andTasker:(NSString *)tasker andimgsrc1:(NSString *)imgsrc1 andimgsrc2:(NSString *)imgsrc2 andimgsrc3:(NSString *)imgsrc3 andAddress:(NSString *) address andLng:(NSString *) lng andLat:(NSString *) lat;

/**
 *  获取任务详情
 *
 *  @param taskID       任务id
 *
 */

-(void)getTaskInfo:(NSString *)taskID;

/**
 *  获取任务状态
 *
 *  @param taskID       任务id
 *
 */
-(void)getTaskStatus:(NSString *)taskID;

/**
 *  删除任务
 *
 *  @param taskID       任务id
 *
 */
-(void)delTask:(NSString *)taskID;

/**
 *  获取任务日历
 *
 *  @param uid      用户务id
 *
 */

-(void)GetTaskCalender:(NSString *)uid;


/**
 *  创建纪念日
 *
 *  @param userID       用户id
 *  @param img          纪念日头像
 *  @param title        纪念日标题
 *  @param mdate        纪念日日期
 *  @param content      纪念日内容
 *
 */
-(void)createAnniversary:(NSString *)userID andImg:(NSString *)img andTitle:(NSString *)title andMdate:(NSString *)mdate andContent:(NSString *)content andimgsrc1:(NSString *)imgsrc1 andimgsrc2:(NSString *)imgsrc2 andimgsrc3:(NSString *)imgsrc3;


/**
 *  获取纪念日列表
 *
 *  @param userID       用户id
 *  @param nowpage      非必需  当前页     default 1
 *  @param perpage      非必需  每页显示数量  default 10
 *
 */
-(void)getAnniversaryList:(NSString *)userID andNowPage:(NSString *) nowpage andPerPage : (NSString *)perpage;

/**
 *  获取纪念日详情
 *
 *  @param anniversaryID       纪念日id
 *
 */
-(void)getAnniversaryInfo:(NSString *)anniversaryID;

/**
 *  删除纪念日
 *
 *  @param anniversaryID       纪念日id
 *
 */
-(void)delAnniversary:(NSString *)anniversaryID;

/**
 *  修改任务状态
 *
 *  @param taskID       任务id
 *  @param state        状态
 *
 */

-(void)ChangeTaskState:(NSString *)taskID andState:(NSString *)state;

#pragma mark - 相册

/**
 *  创建相册
 *
 *  @param uid       用户id
 *  @param title     相册名
 *  @param pm        权限
 *  @param intro       描述
 *
 */

-(void)CreateAlbum:(NSString *)uid andTitle:(NSString *)title andPm:(NSString *)pm andIntro:(NSString *)intro;

/**
 *  删除相册
 *
 *  @param Albumid       相册id
 *
 */

-(void)DelAlbum:(NSString *)Albumid;

/**
 *  获取相册列表
 *
 *  @param fid       好友id
 *  @param uid       用户id
 *  @param nowpage   当前页码
 *  @param perPage   每页显示数量
 *
 */

-(void)GetAlbumList:(NSString *)fid andUid:(NSString *)uid andNowPage:(NSString *)nowpage andPerPage:(NSString *)perPage;


/**
 *  获取相册信息
 *
 *  @param Albumid       相册id
 *
 */
-(void) GetAlbumInfo:(NSString *)Albumid;
/**
 *  上传图片
 *
 *  @param aId       相册id
 *  @param uid       用户id
 *  @param imgSrc        图片地址
 *  @param intro       描述
 *
 */
-(void)UploadPicture:(NSString *)uid andAlbumID:(NSString *)aId andImgSrc:(NSString *)imgSrc andIntro:(NSString *)intro;
/**
 *  删除图片
 *
 *  @param Picid       图片id
 *
 */
-(void)DelPicture:(NSString *)Picid;
/**
 *  获取图片列表
 *
 *  @param aid       相册id
 *  @param uid       用户id
 *  @param nowpage   当前页码
 *  @param perPage   每页显示数量
 *
 */

-(void)GetPictureList:(NSString *)uid andAid:(NSString *)aid andNowPage:(NSString *)nowpage andPerPage:(NSString *)perPage;

/**
 *  获取最近s图片列表
 *
 *
 *  @param uid       用户id
 *  @param nowpage   当前页码
 *  @param perPage   每页显示数量
 *
 */
-(void)GetResentPic:(NSString *)uid andNowPage:(NSString *)nowpage andPerPage:(NSString *)perPage;
/**
 *  获取图片详情
 *
 *  @param Picid       图片id
 *
 */
-(void) GetPictureInfo:(NSString *)Picid;

//接受或拒绝任务 －－ sid：任务状态ID  state：1、接受 2、拒绝
-(void)acceptOrReject:(NSString *) sid andState:(NSString *) state;

//根据路径上传图片
-(void)UploadImgWithImgdata:(NSString *)imagePath;

//根据手机号搜索联系人
-(void)getContacterByPhone:(NSString *)phone;

//添加好友
//FID 好友ID
//userID 用户ID
//remark 备注信息
-(void)addFriend:(NSString *)FID andUserID:(NSString *) userID andRemark:(NSString *) remark;

//获取好友申请列表
-(void)getFriendApplyList:(NSString *)userID;

//删除申请好友 －－ FID：申请好友列表ID
-(void)delApplyFriend:(NSString *)FID;

//通过/拒绝好友申请
-(void)accessApplyFriend:(NSString *)FID andStatus:(NSString *) status;

//获取好友列表--  userID：用户ID －－带分组
-(void)getFriendList:(NSString *)userID;

//获取好友列表－－不带分组
-(void)getFriendInfo:(NSString *)userID;

//改变好友的关系
-(void)changeFriendType:(NSString *)friendID andUserID:(NSString *) userID andType:(NSString *) type;

//删除好友 －－ FID：好友ID   userID：自己的ID
-(void)delFriend:(NSString *)FID andUserID:(NSString *) userID;

//匹配通讯录好友
-(void)matchAddress:(NSString *)userID andMob:(NSString *) mob;

//获取用户资料
-(void)GetUserInfoWithUid:(NSString *)fid anduid:(NSString *)uid;

//保存用户资料
-(void)SaveUserInfo:(NSString *)userID andNick:(NSString *) nick andSex:(NSString *) sex andAge:(NSString *)age andSign:(NSString *) sign;

//上传图片
-(void)UploadImgWithImgdataSlider:(NSData *)imagedata;







/**
 *  设置回调函数
 *
 *  @param cbobject     回调对象
 *  @param selectorName 回调函数
 */
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;


@end
