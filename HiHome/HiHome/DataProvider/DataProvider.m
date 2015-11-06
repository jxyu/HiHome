//
//  DataProvider.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "DataProvider.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import "SVProgressHUD.h"
//#import "HttpRequest.h"
//#define Url @"http://115.28.21.137/mobile/"
#define Url @"http://hihome.zhongyangjituan.com/"

#define DEBUG       1

@implementation DataProvider

#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}

-(void)changeHeadImg:(NSString *)uid andImgsrc:(NSString *)imgsrc{
    if(uid && imgsrc){
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=user&a=modAvatar",Url];
        NSDictionary *prm = @{@"id":uid,@"imgsrc":imgsrc};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}


/**
 *  注册
 *
 *  @param prm
 */
-(void)RegisterUserInfo:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=user&a=reg",Url];
        [self PostRequest:url andpram:prm];
    }
}

/**
 *  忘记密码
 *
 *  @param prm
 */
-(void)ForgetPassWord:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=user&a=resetPassword",Url];
        [self GetRequest:url andpram:prm];
    }
}

-(void)Login:(NSString *)mobel andpwd:(NSString *)pwd andreferrer:(NSString *)referrer
{
    if (mobel&&pwd) {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=user&a=login",Url];
        NSDictionary * prm=@{@"mob":mobel,@"pass":pwd};
        [self PostRequest:url andpram:prm];
    }
}

-(void)ResetPwd:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=login&op=restpasswd",Url];
        [self PostRequest:url andpram:prm];
    }
}
-(void)ChangeUserName:(NSString *)username andkey:(NSString *)key
{
    if (username&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_index&op=editname",Url];
        NSDictionary * prm=@{@"user_name":username,@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

//获取天气信息
-(void)getWeatherInfo: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg {
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, [HttpArg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"POST"];
    [request addValue: @"4e01ff24cadf672086df1d5f654f4785" forHTTPHeaderField: @"apikey"];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"error:%@",error);
                                   [SVProgressHUD dismiss];
                               } else {
                                   id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   SEL func_selector = NSSelectorFromString(callBackFunctionName);
                                   if ([CallBackObject respondsToSelector:func_selector]) {
                                       NSLog(@"回调成功...");
                                       [CallBackObject performSelector:func_selector withObject:dict];
                                   }else{
                                       NSLog(@"回调失败...");
                                       [SVProgressHUD dismiss];
                                   }
                               }
                           }];
}


-(void)getReceiveTask:(NSString *)userID andState:(NSString*)state andMyOrNot:(NSString *)my andPage:(NSString *)page andPerPage:(NSString *)perpage andDate:(NSString *)date andStartDate:(NSString *)startDate andEndDate:(NSString *)endDate
{
    NSMutableDictionary * prm = [NSMutableDictionary dictionary];
    
    if (userID) {
        NSLog(@"userId = [%@]-----",userID);
        
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=getMyTask",Url];
//        if(page == nil && num == nil)
//            prm=@{@"uid":userID};
//        else if (page == nil && num != nil)
//            prm=@{@"uid":userID,@"perpage":num};
//        else if (page != nil && num == nil)
//            prm=@{@"uid":userID,@"nowpage":page};
//        else
//        prm=@{@"uid":userID,@"state":state,@"nowpage":page,@"perpage":num};
        [prm setObject:userID forKey:@"uid"];
        if(my!=nil)
             [prm setObject:my forKey:@"my"];
        if(state!=nil)
            [prm setObject:state forKey:@"state"];
        if(page!=nil)
            [prm setObject:page forKey:@"nowpage"];
        if(perpage!=nil)
            [prm setObject:perpage forKey:@"perpage"];
        if(date!=nil)
            [prm setObject:date forKey:@"addtime"];
        if(startDate!=nil)
            [prm setObject:startDate forKey:@"sdate"];
        if(endDate!=nil)
            [prm setObject:endDate forKey:@"edate"];
        NSLog(@"send prm = [%@]",prm);
        
        [self PostRequest:url andpram:prm];
    }
}


-(void)getSendTask:(NSString *)userID andState:(NSString*)state andPage:(NSString *)page andPerPage:(NSString *)perpage andDate:(NSString *)date
{
    NSMutableDictionary * prm = [NSMutableDictionary dictionary];
    
    if (userID) {
        NSLog(@"userId = [%@]-----",userID);
        
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=getList",Url];

        [prm setObject:userID forKey:@"uid"];

        if(state!=nil)
            [prm setObject:state forKey:@"state"];
        if(page!=nil)
            [prm setObject:page forKey:@"nowpage"];
        if(perpage!=nil)
            [prm setObject:perpage forKey:@"perpage"];
        if(date !=nil)
            [prm setObject:date forKey:@"addtime"];
        
        
        NSLog(@"send prm = [%@]",prm);
        
        [self PostRequest:url andpram:prm];
    }
}





-(void) createTask:(NSString *)userID andTitle:(NSString *)title andContent:(NSString *)content andIsDay:(NSString *)isDay andStartTime:(NSString *)stime andEndTime:(NSString *)etime andTip:(NSString *)tip andRepeat:(NSString *)repeat andTasker:(NSString *)tasker andimgsrc1:(NSString *)imgsrc1 andimgsrc2:(NSString *)imgsrc2 andimgsrc3:(NSString *)imgsrc3 andAddress:(NSString *) address andLng:(NSString *) lng andLat:(NSString *) lat
{
    if (userID && title && content
        && isDay &&stime && etime
        && tip &&repeat && tasker
        ) {
    
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=addInfo",Url];
        
        NSDictionary * prm = @{@"uid":userID,@"title":title,@"content":content,@"isday":isDay,@"start":stime,@"end":etime,@"tip":tip,@"repeat":repeat,@"tasker":tasker,@"imgsrc1":imgsrc1,@"imgsrc2":imgsrc2,@"imgsrc3":imgsrc3,@"address":address,@"lng":lng,@"lat":lat};
        DLog(@"prm = %@",prm);
        [self PostRequest:url andpram:prm];
    }

}



-(void) updateTask:(NSString *)taskID andTitle:(NSString *)title andContent:(NSString *)content andIsDay:(NSString *)isDay andStartTime:(NSString *)stime andEndTime:(NSString *)etime andTip:(NSString *)tip andRepeat:(NSString *)repeat andTasker:(NSString *)tasker andimgsrc1:(NSString *)imgsrc1 andimgsrc2:(NSString *)imgsrc2 andimgsrc3:(NSString *)imgsrc3 andAddress:(NSString *) address andLng:(NSString *) lng andLat:(NSString *) lat
{
    if (taskID && title && content
        && isDay &&stime && etime
        && tip &&repeat && tasker
        ) {
        
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=editInfo",Url];
        
        NSDictionary * prm = @{@"id":taskID,@"title":title,@"content":content,@"isday":isDay,@"start":stime,@"end":etime,@"tip":tip,@"repeat":repeat,@"tasker":tasker,@"imgsrc1":imgsrc1,@"imgsrc2":imgsrc2,@"imgsrc3":imgsrc3,@"address":address,@"lng":lng,@"lat":lat};
        
        NSLog(@"updateTask prm = %@",prm);
        
        [self PostRequest:url andpram:prm];
    }
    
}

-(void)getTaskInfo:(NSString *)taskID
{
    if(taskID)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=getInfo",Url];
        NSDictionary * prm=@{@"id":taskID};
        [self PostRequest:url andpram:prm];
    }
}


-(void)getTaskStatus:(NSString *)taskID
{
    if(taskID)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=getTaskState",Url];
        NSDictionary * prm=@{@"id":taskID};
        [self PostRequest:url andpram:prm];
    }
}

-(void)acceptOrReject:(NSString *) sid andState:(NSString *) state{
    if (sid) {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=applyTask",Url];
        NSDictionary *prm = @{@"sid":sid,@"state":state};
        [self PostRequest:url andpram:prm];
    }
}

-(void)delTask:(NSString *)taskID
{
    if(taskID)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=delInfo",Url];
        NSDictionary * prm=@{@"id":taskID};
        [self PostRequest:url andpram:prm];
    }
}


-(void)createAnniversary:(NSString *)userID andImg:(NSString *)img andTitle:(NSString *)title andMdate:(NSString *)mdate andContent:(NSString *)content andimgsrc1:(NSString *)imgsrc1 andimgsrc2:(NSString *)imgsrc2 andimgsrc3:(NSString *)imgsrc3
{
    if(userID && img && title && mdate && content)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=memorial&a=addInfo",Url];
        
        NSDictionary * prm = @{@"uid":userID,@"title":title,@"content":content,@"imgsrc":img,@"mdate":mdate,@"imgsrc1":imgsrc1,@"imgsrc2":imgsrc2,@"imgsrc3":imgsrc3};
        
        [self PostRequest:url andpram:prm];
    }
    
}

-(void)getAnniversaryList:(NSString *)userID andNowPage:(NSString *) nowpage andPerPage : (NSString *)perpage
{
    NSDictionary * prm;
    
    if (userID) {
        
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=memorial&a=getList",Url];
        if(nowpage == nil && perpage == nil)
            prm=@{@"uid":userID};
        else if (nowpage == nil && perpage != nil)
            prm=@{@"uid":userID,@"perpage":perpage};
        else if (nowpage != nil && perpage == nil)
            prm=@{@"uid":userID,@"nowpage":nowpage};
        else
            prm=@{@"uid":userID,@"nowpage":nowpage,@"perpage":perpage};
        
        [self PostRequest:url andpram:prm];
    }
}

-(void)getAnniversaryInfo:(NSString *)anniversaryID
{
    if(anniversaryID)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=memorial&a=getInfo",Url];
        NSDictionary * prm=@{@"id":anniversaryID};
        [self PostRequest:url andpram:prm];
    }
}

-(void)delAnniversary:(NSString *)anniversaryID
{
    if(anniversaryID)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=memorial&a=delInfo",Url];
        NSDictionary * prm=@{@"id":anniversaryID};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetToken:(NSString *)userid
{
    if (userid) {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=chat&a=getToken",Url];
        NSDictionary * prm=@{@"uid":userid};
        [self GetRequest:url andpram:prm];
    }
}

-(void)UploadImgWithImgdata:(NSString *)imagePath
{
    if (imagePath) {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=public&a=upload",Url];
        NSDictionary * prm=@{@"name":@"imgsrc"};
        [self uploadImageWithImage:imagePath andurl:url andprm:prm];
//        [self ShowOrderuploadImageWithImage:imagePath andurl:url andprm:prm];
    }

}

-(void)UploadImgWithImgdataSlider:(NSData *)imagedata
{
    if (imagedata) {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=public&a=upload",Url];
        NSDictionary * prm=@{@"name":@"imgsrc"};
        [self ShowOrderuploadImageWithImage:imagedata andurl:url andprm:prm];
    }else{
        [SVProgressHUD dismiss];
    }
    
}

-(void)getContacterByPhone:(NSString *)phone{
    if (phone) {
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=user&a=getSearchUser&keys=%@",Url,phone];
        [self GetRequest:url andpram:nil];
    }
}

-(void)addFriend:(NSString *)FID andUserID:(NSString *) userID andRemark:(NSString *) remark{
    if (FID) {
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=friend&a=addFriend",Url];
        NSDictionary *prm = @{@"fid":FID,@"uid":userID,@"intro":remark};
        [self PostRequest:url andpram:prm];
    }
}

-(void)getFriendApplyList:(NSString *)userID{
    if (userID) {
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=friend&a=getApplyList&uid=%@",Url,userID];
        [self GetRequest:url andpram:nil];
    }
}

-(void)delApplyFriend:(NSString *)FID{
    if (FID) {
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=friend&a=delApplyInfo",Url];
        NSDictionary *prm = @{@"id":FID};
        [self PostRequest:url andpram:prm];
    }
}

-(void)accessApplyFriend:(NSString *)FID andStatus:(NSString *) status{
    if (FID) {
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=friend&a=applyFriend&id=%@&state=%@",Url,FID,status];
        [self GetRequest:url andpram:nil];
    }
}

-(void)getFriendList:(NSString *)userID{
    if (userID) {
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=friend&a=getListGroup",Url];
        NSDictionary *prm = @{@"uid":userID,@"nowpage":@"1",@"perpage":@"9999"};
        [self PostRequest:url andpram:prm];
    }
}

-(void)getFriendInfo:(NSString *)userID{
    if (userID) {
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=friend&a=getList",Url];
        NSDictionary *prm = @{@"uid":userID,@"nowpage":@"1",@"perpage":@"9999"};
        [self PostRequest:url andpram:prm];
    }
}

-(void)matchAddress:(NSString *)userID andMob:(NSString *) mob{
    if (userID) {
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=friend&a=mobFriend",Url];
        NSDictionary *prm = @{@"uid":userID,@"mob":mob};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)changeFriendType:(NSString *)friendID andUserID:(NSString *) userID andType:(NSString *) type{
    if (friendID && userID) {
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=friend&a=groupFriend",Url];
        NSDictionary *prm = @{@"fid":friendID,@"uid":userID,@"type":type};
        [self PostRequest:url andpram:prm];
    }
}

-(void)delFriend:(NSString *)FID andUserID:(NSString *) userID{
    if (userID) {
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=friend&a=delInfo",Url];
        NSDictionary *prm = @{@"fid":FID,@"uid":userID};
        [self PostRequest:url andpram:prm];
    }
}

-(void)ChangeTaskState:(NSString *)taskID andState:(NSString *)state
{

    if (taskID&&state) {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=applyTask",Url];
        NSDictionary * prm=@{@"sid":taskID,@"state":state};
#if DEBUG
        NSLog(@"[%s] prm = %@",__FUNCTION__,prm);
#endif
        
       [self PostRequest:url andpram:prm];
       
    }
    
}

-(void)GetUserInfoWithUid:(NSString *)uid
{
    if (uid) {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=user&a=getInfo",Url];
        NSDictionary * prm=@{@"id":uid};
        [self GetRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SaveUserInfo:(NSString *)userID andNick:(NSString *) nick andSex:(NSString *) sex andAge:(NSString *)age andSign:(NSString *) sign{
    if (userID) {
        NSString *url = [NSString stringWithFormat:@"%@api.php?c=user&a=modInfo",Url];
        NSDictionary *prm = @{@"id":userID,@"nick":nick,@"sex":sex,@"age":age,@"sign":sign};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetTaskCalender:(NSString *)uid
{
    if (uid) {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=getDateTaskList",Url];
        NSDictionary * prm=@{@"uid":uid};
        [self PostRequest:url andpram:prm];
    }

}



#pragma mark - album api

-(void)CreateAlbum:(NSString *)uid andTitle:(NSString *)title andPm:(NSString *)pm andIntro:(NSString *)intro
{
    if(title&&uid&&pm &&intro)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=album&a=addInfo",Url];
        NSDictionary *prm = @{@"uid":uid,@"title":title,@"pm":pm,@"intro":intro};
#if DEBUG
        NSLog(@"[%s] prm = %@",__FUNCTION__,prm);
#endif
        [self PostRequest:url andpram:prm];
    }
}

-(void)DelAlbum:(NSString *)Albumid
{
    if(Albumid)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=album&a=delInfo",Url];
        NSDictionary *prm = @{@"id":Albumid};
#if DEBUG
        NSLog(@"[%s] prm = %@",__FUNCTION__,prm);
#endif
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetAlbumList:(NSString *)fid andUid:(NSString *)uid andNowPage:(NSString *)nowpage andPerPage:(NSString *)perPage
{
    NSMutableDictionary * prm = [NSMutableDictionary dictionary];
    
    if(fid&&uid)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=album&a=getList",Url];

            
        [prm setObject:uid forKey:@"uid"];
        [prm setObject:fid forKey:@"fid"];
        
        if(nowpage!=nil)
            [prm setObject:nowpage forKey:@"nowpage"];
        if(perPage)
            [prm setObject:perPage forKey:@"perpage"];
        
#if DEBUG
        NSLog(@"[%s] prm = %@",__FUNCTION__,prm);
#endif
        [self PostRequest:url andpram:prm];
    }
    
}

-(void) GetAlbumInfo:(NSString *)Albumid
{
    if(Albumid)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=album&a=getInfo",Url];
        NSDictionary *prm = @{@"id":Albumid};
#if DEBUG
        NSLog(@"[%s] prm = %@",__FUNCTION__,prm);
#endif
        [self PostRequest:url andpram:prm];
    }
}

-(void)UploadPicture:(NSString *)uid andAlbumID:(NSString *)aId andImgSrc:(NSString *)imgSrc andIntro:(NSString *)intro
{
    NSMutableDictionary * prm = [NSMutableDictionary dictionary];
    
    if(uid&&aId&&imgSrc&&intro)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=photo&a=addInfo",Url];
        
        
        [prm setObject:uid forKey:@"uid"];
        [prm setObject:aId forKey:@"aid"];
        
        [prm setObject:imgSrc forKey:@"imgsrc"];
        [prm setObject:intro forKey:@"intro"];
        
#if DEBUG
        NSLog(@"[%s] prm = %@",__FUNCTION__,prm);
#endif
        [self PostRequest:url andpram:prm];
    }

}

-(void)DelPicture:(NSString *)Picid
{
    if(Picid)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=photo&a=delInfo",Url];
        NSDictionary *prm = @{@"id":Picid};
#if DEBUG
        NSLog(@"[%s] prm = %@",__FUNCTION__,prm);
#endif
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetPictureList:(NSString *)uid andAid:(NSString *)aid andNowPage:(NSString *)nowpage andPerPage:(NSString *)perPage
{
     NSMutableDictionary * prm = [NSMutableDictionary dictionary];
    if(aid&&uid)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=photo&a=getList",Url];
        
        
        [prm setObject:uid forKey:@"uid"];
        [prm setObject:aid forKey:@"aid"];
        
        if(nowpage!=nil)
            [prm setObject:nowpage forKey:@"nowpage"];
        if(perPage)
            [prm setObject:perPage forKey:@"perpage"];
        
#if DEBUG
        NSLog(@"[%s] prm = %@",__FUNCTION__,prm);
#endif
        [self PostRequest:url andpram:prm];
    }
}




-(void) GetPictureInfo:(NSString *)Picid
{
    if(Picid)
    {
        
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=photo&a=getInfo",Url];
        NSDictionary *prm = @{@"id":Picid};
#if DEBUG
        NSLog(@"[%s] prm = %@",__FUNCTION__,prm);
#endif
        [self PostRequest:url andpram:prm];
    }
}


-(void)GetResentPic:(NSString *)uid andNowPage:(NSString *)nowpage andPerPage:(NSString *)perPage
{
    NSMutableDictionary * prm = [NSMutableDictionary dictionary];
    if(uid)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=photo&a=getLatelyList",Url];
        
        
        [prm setObject:uid forKey:@"uid"];
        
        if(nowpage!=nil)
            [prm setObject:nowpage forKey:@"nowpage"];
        if(perPage)
            [prm setObject:perPage forKey:@"perpage"];
        
#if DEBUG
        NSLog(@"[%s] prm = %@",__FUNCTION__,prm);
#endif
        [self PostRequest:url andpram:prm];
    }
}

-(void)PostRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=10;//设置请求时限
    NSDictionary * prm =[[NSDictionary alloc] init];
    if (pram!=nil) {
        prm=pram;
    }
    [manage POST:url parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict =responseObject;
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"请检查网络或防火墙" maskType:SVProgressHUDMaskTypeBlack];
    }];
}




-(void)GetRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=10;//设置请求时限
    NSDictionary * prm =[[NSDictionary alloc] init];
    if (pram!=nil) {
        prm=pram;
    }
    [manage GET:url parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        [SVProgressHUD showErrorWithStatus:@"请检查网络或防火墙" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

- (void)uploadImageWithImage:(NSString *)imagePath andurl:(NSString *)url andprm:(NSDictionary *)prm
{
    NSData *data=[NSData dataWithContentsOfFile:imagePath];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"imgsrc" fileName:@"avatar.jpg" mimeType:@"image/jpg"];
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
        NSLog(@"上传完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败->%@", error);
        [SVProgressHUD showErrorWithStatus:@"请检查网络或防火墙" maskType:SVProgressHUDMaskTypeBlack];
    }];
    
    //执行
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:op];
//    FileDetail *file = [FileDetail fileWithName:@"avatar.jpg" data:data];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            file,@"FILES",
//                            @"avatar",@"name",
//                            key, @"key", nil];
//    NSDictionary *result = [HttpRequest upload:[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url] widthParams:params];
//    NSLog(@"%@",result);
}

- (void)ShowOrderuploadImageWithImage:(NSData *)imagedata andurl:(NSString *)url andprm:(NSDictionary *)prm
{
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imagedata name:@"imgsrc" fileName:@"showorder_img.jpg" mimeType:@"image/jpg"];
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
        NSLog(@"上传完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败->%@", error);
        [SVProgressHUD showErrorWithStatus:@"请检查网络或防火墙" maskType:SVProgressHUDMaskTypeBlack];
    }];
    
    //执行
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:op];
    //    FileDetail *file = [FileDetail fileWithName:@"avatar.jpg" data:data];
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
    //                            file,@"FILES",
    //                            @"avatar",@"name",
    //                            key, @"key", nil];
    //    NSDictionary *result = [HttpRequest upload:[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url] widthParams:params];
    //    NSLog(@"%@",result);
}



@end
