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

@implementation DataProvider

#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}
/**
 *  注册
 *
 *  @param prm <#prm description#>
 */
-(void)RegisterUserInfo:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=user&a=reg",Url];
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


-(void)getMyTask:(NSString *)userID andPage:(NSString *)page andPerPage:(NSString *)num
{
    NSDictionary * prm;
    
    if (userID) {
        NSLog(@"userId = [%@]-----",userID);
        
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=getMyTask",Url];
        if(page == nil && num == nil)
            prm=@{@"uid":userID};
        else if (page == nil && num != nil)
            prm=@{@"uid":userID,@"perpage":num};
        else if (page != nil && num == nil)
            prm=@{@"uid":userID,@"nowpage":page};
        else
            prm=@{@"uid":userID,@"nowpage":page,@"perpage":num};
        
        [self PostRequest:url andpram:prm];
    }
}

-(void) createTask:(NSString *)userID andTitle:(NSString *)title andContent:(NSString *)content andIsDay:(NSString *)isDay andStartTime:(NSString *)stime andEndTime:(NSString *)etime andTip:(NSString *)tip andRepeat:(NSString *)repeat andTasker:(NSString *)tasker
{
    if (userID && title && content
        && isDay &&stime && etime
        && tip &&repeat && tasker
        ) {
    
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=addInfo",Url];
        
        NSDictionary * prm = @{@"uid":userID,@"title":title,@"content":content,@"isday":isDay,@"start":stime,@"end":etime,@"tip":tip,@"repeat":repeat,@"tasker":tasker};
        
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

-(void)delTask:(NSString *)taskID
{
    if(taskID)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=task&a=delInfo",Url];
        NSDictionary * prm=@{@"id":taskID};
        [self PostRequest:url andpram:prm];
    }
}


-(void)createAnniversary:(NSString *)userID andImg:(NSString *)img andTitle:(NSString *)title andMdate:(NSString *)mdate andContent:(NSString *)content
{
    if(userID && img && title && mdate && content)
    {
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=memorial&a=addInfo",Url];
        
        NSDictionary * prm = @{@"uid":userID,@"title":title,@"content":content,@"imgsrc":img,@"mdate":mdate};
        
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
        NSDictionary * prm=@{@"name":@"avatar"};
        [self uploadImageWithImage:imagePath andurl:url andprm:prm];
//        [self ShowOrderuploadImageWithImage:imagePath andurl:url andprm:prm];
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
        [SVProgressHUD dismiss];
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
        [SVProgressHUD dismiss];
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
        [SVProgressHUD dismiss];
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
        [formData appendPartWithFileData:imagedata name:@"showorder_img" fileName:@"showorder_img.jpg" mimeType:@"image/jpg"];
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
        [SVProgressHUD dismiss];
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
