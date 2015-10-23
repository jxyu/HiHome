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




//获取天气信息
-(void)getWeatherInfo: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg;

-(void)GetToken:(NSString *)userid;

/**
 *  获取任务
 *
 *  @param userID       用户id
 *  @param state        任务状态
 *  @param page         当前页码，   default 1
 *  @param perpage          每页显示数量  default  10
 */

-(void)getReceiveTask:(NSString *)userID andState:(NSString*)state andPage:(NSString *)page andPerPage:(NSString *)perpage;



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
-(void) createTask:(NSString *)userID andTitle:(NSString *)title andContent:(NSString *)content andIsDay:(NSString *)isDay andStartTime:(NSString *)stime andEndTime:(NSString *)etime andTip:(NSString *)tip andRepeat:(NSString *)repeat andTasker:(NSString *)tasker;


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
 *  创建纪念日
 *
 *  @param userID       用户id
 *  @param img          纪念日头像
 *  @param title        纪念日标题
 *  @param mdate        纪念日日期
 *  @param content      纪念日内容
 *
 */
-(void)createAnniversary:(NSString *)userID andImg:(NSString *)img andTitle:(NSString *)title andMdate:(NSString *)mdate andContent:(NSString *)content;


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

//根据路径上传图片
-(void)UploadImgWithImgdata:(NSString *)imagePath;











/**
 *  设置回调函数
 *
 *  @param cbobject     回调对象
 *  @param selectorName 回调函数
 */
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;


@end
