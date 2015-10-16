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
//#import "HttpRequest.h"
#import "SVProgressHUD.h"
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
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=login&op=register",Url];
        [self PostRequest:url andpram:prm];
    }
}
-(void)Login:(NSString *)mobel andpwd:(NSString *)pwd
{
    if (mobel&&pwd) {//http://hihome.zhongyangjituan.com/api.php?c=user&a=reg
        NSString * url=[NSString stringWithFormat:@"%@api.php?c=user&a=reg",Url];
        NSDictionary * prm=@{@"mobile":mobel,@"password":pwd,@"client":@"ios"};
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

-(void)signIn:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_index&op=signin",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)UpLoadImage:(NSString *)imagePath andkey:(NSString *)key
{
    if (imagePath&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url];
        NSDictionary * prm=@{@"key":key,@"name":@"avatar"};
        [self uploadImageWithImage:imagePath andurl:url andprm:prm andkey:key];
    }
}
-(void)SaveAvatarWithAvatarName:(NSString *)avatarname andkey:(NSString *)key
{
    if (avatarname&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_save",Url];
        NSDictionary * prm=@{@"key":key,@"avatar":avatarname};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetProList:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_points&op=goods_list",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetAddressList:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=address_list",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }

}

-(void)GetArrayListwithareaid:(NSString *)area_id andkey:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=area_list",Url];
        NSDictionary * prm=@{@"key":key,@"area_id":area_id};
        [self PostRequest:url andpram:prm];
    }
}
-(void)addAddress:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=address_add",Url];
        [self PostRequest:url andpram:prm];
    }
}
-(void)SetDefaultAddressWithaddressid:(NSString *)address_id andkey:(NSString *)key
{
    if (key&&address_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=address_default",Url];
        NSDictionary * prm=@{@"key":key,@"address_id":address_id};
        [self PostRequest:url andpram:prm];
    }
}

-(void)DelAddressWithAddressid:(NSString *)address_id andkey:(NSString *)key
{
    if (key&&address_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=address_del",Url];
        NSDictionary * prm=@{@"key":key,@"address_id":address_id};
        [self PostRequest:url andpram:prm];
    }
}

-(void)EditAddressWithPrm:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_address&op=address_edit",Url];
        [self PostRequest:url andpram:prm];
    }
}

-(void)DuihuanFunction:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_points&op=exchange",Url];
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetjifenDetial:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_points&op=points_log",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetClassify
{
    NSString * url=[NSString stringWithFormat:@"%@index.php?act=goods_class",Url];
    [self PostRequest:url andpram:nil];
}

-(void)GetClassifyNext:(NSString *)gc_id
{
    NSString * url=[NSString stringWithFormat:@"%@index.php?act=goods_class&gc_id=%@",Url,gc_id];
    [self PostRequest:url andpram:nil];
}

-(void)GetcityInfoWithlng:(NSString *)lng andlat:(NSString *)lat
{
    if (lng&&lat) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=area&op=location",Url];
        NSDictionary * prm=@{@"lng":lng,@"lat":lat};
        [self GetRequest:url andpram:prm];
    }
}

-(void)GetIndexDataWithAreaid:(NSString *)areaid andlng:(NSString *)lng andlat:(NSString *)lat
{
    if (areaid&&lng&&lat) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=index",Url];
        NSDictionary * prm=@{@"lng":lng,@"lat":lat,@"city_id":areaid};
        [self GetRequest:url andpram:prm];
    }
}

-(void)GetGoodsListWithKeyWord:(NSDictionary *)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=goods&op=goods_list",Url];
        [self GetRequest:url andpram:prm];
    }
}

-(void)getClassifyForStore
{
    NSString * url=[NSString stringWithFormat:@"%@index.php?act=store&op=store_class",Url];
    [self GetRequest:url andpram:nil];
}

-(void)GetStoreList:(NSDictionary *)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=store&op=store_list",Url];
        [self GetRequest:url andpram:prm];
    }
}

-(void)GetStoreDetialInfoWithKey:(NSString *)key andstoreid:(NSString *)store_id
{
    if (key&&store_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=store&op=store_info",Url];
        NSDictionary * prm=@{@"key":key,@"store_id":store_id};
        [self GetRequest:url andpram:prm];
    }
}

-(void)GetStoreGoodList:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=store&op=store_goods",Url];
        [self GetRequest:url andpram:prm];
    }
}
-(void)GetGoodDetialInfoWithid:(NSString *)goodid
{
    if (goodid) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=goods&op=goods_detail",Url];
        NSDictionary * prm=@{@"goods_id":goodid};
        [self GetRequest:url andpram:prm];
    }
}

-(void)GetMorePinglun:(NSString *)goodid
{
    if (goodid) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=goods&op=more_evaluate",Url];
        NSDictionary * prm=@{@"goods_id":goodid};
        [self GetRequest:url andpram:prm];
    }
}

-(void)GetCityList
{
    NSString * url=[NSString stringWithFormat:@"%@index.php?act=area&op=city_list",Url];
    [self GetRequest:url andpram:nil];
}

-(void)GetPurseInfo:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_predeposit&op=view",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetChargeObject:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_predeposit&op=recharge_add",Url];
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetShopCarList:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_cart&op=cart_list",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }
}

-(void)EditGoodsNumWithKey:(NSString *)key andCartid:(NSString *)cartid andnum:(NSString *)num
{
    if (key&&cartid&&num) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_cart&op=cart_edit_quantity",Url];
        NSDictionary * prm=@{@"key":key,@"cart_id":cartid,@"quantity":num};
        [self PostRequest:url andpram:prm];
    }
}

-(void)DelGoodsWithKey:(NSString *)key andcartid:(NSString *)cartid
{
    if (key&&cartid) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_cart&op=cart_del",Url];
        NSDictionary * prm=@{@"key":key,@"cart_id":cartid};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetOrderListWithKey:(NSString *)key andcurpage:(NSString *)curpage andorder_state:(NSString *)order_state
{
    if (key&&curpage&&order_state) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_order&op=order_list",Url];
        NSDictionary * prm=@{@"key":key,@"curpage":curpage,@"order_state":order_state};
        [self PostRequest:url andpram:prm];
    }
}

-(void)CancalOrderWithOutPay:(NSString *)order_id andkey:(NSString *)key
{
    if (key&&order_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_order&op=order_cancel",Url];
        NSDictionary * prm=@{@"key":key,@"order_id":order_id};
        [self PostRequest:url andpram:prm];
    }
}
-(void)CancalOrderPayAlready:(NSString *)order_id andkey:(NSString *)key
{
    if (key&&order_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_order&op=order_cancel_refund",Url];
        NSDictionary * prm=@{@"key":key,@"order_id":order_id};
        [self PostRequest:url andpram:prm];
    }
}

-(void)OrderForSure:(NSString *)order_id andkey:(NSString *)key
{
    if (key&&order_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_order&op=order_receive",Url];
        NSDictionary * prm=@{@"key":key,@"order_id":order_id};
        [self PostRequest:url andpram:prm];
    }
}

-(void)DelOrder:(NSString *)order_id andkey:(NSString *)key
{
    if (key&&order_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_order&op=order_delete",Url];
        NSDictionary * prm=@{@"key":key,@"order_id":order_id};
        [self PostRequest:url andpram:prm];
    }
}

-(void)AddToShoppingCar:(NSString *)key andgoods_id:(NSString *)goods_id andquantity:(NSString *)quantity
{
    if (key&&goods_id&&quantity) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_cart&op=cart_add",Url];
        NSDictionary * prm=@{@"key":key,@"goods_id":goods_id,@"quantity":quantity};
        [self PostRequest:url andpram:prm];
    }
}

-(void)Buy_Stepone:(NSString *)key andcart_id:(NSString *)cart_id andifcart:(NSString *)ifcart
{
    if (key&&cart_id&&ifcart) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_buy&op=buy_step1",Url];
        NSDictionary * prm=@{@"key":key,@"cart_id":cart_id,@"ifcart":ifcart};
        [self PostRequest:url andpram:prm];
    }
}
-(void)Buy_StepTwo:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_buy&op=buy_step2",Url];
        [self PostRequest:url andpram:prm];
    }
}

-(void)OrderPayWithKey:(NSString *)key andpay_sn:(NSString *)pay_sn andchannel:(NSString *)channel
{
    if (key&&pay_sn&&channel) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_payment&op=pay",Url];
        NSDictionary * prm=@{@"key":key,@"pay_sn":pay_sn,@"channel":channel};
        [self GetRequest:url andpram:prm];
    }
}
-(void)GetShowOrderForMySendWithKey:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_circle&op=my_publish",Url];
        NSDictionary * prm=@{@"key":key};
        [self GetRequest:url andpram:prm];
    }
}
-(void)GetShowOrderForMyJuageWithKey:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_circle&op=my_quote",Url];
        NSDictionary * prm=@{@"key":key};
        [self GetRequest:url andpram:prm];
    }
}
-(void)zanClickWithKey:(NSString* )key andcircle_id:(NSString *)circle_id
{
    if (key&&circle_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_circle&op=praise",Url];
        NSDictionary * prm=@{@"key":key,@"circle_id":circle_id};
        [self PostRequest:url andpram:prm];
    }
}

-(void)ShowOrderPinglun:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_circle&op=quote",Url];
        [self PostRequest:url andpram:prm];
    }
}


-(void)GetShowOrderOrderListWithKey:(NSString *)key andorder:(NSString *)order
{
    if (key&&order) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_circle&op=list",Url];
        NSDictionary * prm=@{@"key":key,@"order":order};
        [self GetRequest:url andpram:prm];
    }
}

-(void)ShowOrderUpLoadImg:(NSData *)imagedata andkey:(NSString *)key
{
    if (imagedata&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_circle&op=image_upload",Url];
        NSDictionary * prm=@{@"key":key,@"name":@"showorder_img"};
        [self ShowOrderuploadImageWithImage:imagedata andurl:url andprm:prm andkey:key];
    }
}

-(void)ShowOrderSendWithKey:(NSString *)key anddescription:(NSString *)description andimage:(NSString *)image
{
    if (key&&description&&image) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_circle&op=publish",Url];
        NSDictionary * prm=@{@"key":key,@"description":description,@"image":image};
        [self PostRequest:url andpram:prm];
    }
}
-(void)CollectShopWithKey:(NSString *)key andstore_id:(NSString *)store_id
{
    if (key&&store_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_favorites_store&op=favorites_add",Url];
        NSDictionary * prm=@{@"key":key,@"store_id":store_id};
        [self PostRequest:url andpram:prm];
    }
}

-(void)CollectGoodWithKey:(NSString *)key andgoods_id:(NSString *)goods_id
{
    if (key&&goods_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_favorites&op=favorites_add",Url];
        NSDictionary * prm=@{@"key":key,@"goods_id":goods_id};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetGoodCollectList:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_favorites&op=favorites_list",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetStoreCollectList:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_favorites_store&op=favorites_list",Url];
        NSDictionary * prm=@{@"key":key};
        [self PostRequest:url andpram:prm];
    }
}
-(void)DelGoodsCollectWithKey:(NSString *)key andfav_id:(NSString *)fav_id
{
    if (key&&fav_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_favorites&op=favorites_del",Url];
        NSDictionary * prm=@{@"key":key,@"fav_id":fav_id};
        [self PostRequest:url andpram:prm];
    }
}
-(void)DelStoreCollectWithKey:(NSString *)key andstore_id:(NSString *)store_id
{
    if (key&&store_id) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_favorites_store&op=favorites_del",Url];
        NSDictionary * prm=@{@"key":key,@"store_id":store_id};
        [self PostRequest:url andpram:prm];
    }
}

-(void)UpLoadIDCardImg:(NSData *)imagedata andkey:(NSString *)key
{
    if (imagedata&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_index&op=idcard_upload",Url];
        NSDictionary * prm=@{@"key":key,@"name":@"showorder_img"};
        [self ShowOrderuploadImageWithImage:imagedata andurl:url andprm:prm andkey:key];
    }
}
-(void)RealNameSubmit:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_index&op=identification",Url];
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetOrderDetialWithKey:(NSString *)key andorder_id:(NSString *)order_id
{
    if (order_id&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_order&op=show_order",Url];
        NSDictionary * prm=@{@"key":key,@"order_id":order_id};
        [self GetRequest:url andpram:prm];
    }
}

-(void)UploadPingJiaImg:(NSData *)imagedata andkey:(NSString *)key
{
    if (imagedata&&key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_evaluate&op=image_upload",Url];
        NSDictionary * prm=@{@"key":key,@"name":@"showorder_img"};
        [self ShowOrderuploadImageWithImage:imagedata andurl:url andprm:prm andkey:key];
    }
}

-(void)SubmitPingjia:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_evaluate&op=save",Url];
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetSpecGoodsList:(NSDictionary *)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=goods&op=day_special",Url];
        [self PostRequest:url andpram:prm];
    }
}
-(void)GessYouLike:(NSDictionary *)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=goods&op=goods_like_list",Url];
        [self PostRequest:url andpram:prm];
    }
}

-(void)LoginForQQWithopenid:(NSString *)openid andusername:(NSString * )username
{
    if (openid&&username) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=login&op=qq",Url];
        NSDictionary * prm=@{@"openid":openid,@"username":username,@"client":@"ios"};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetPolicatandjifenWithKey:(NSString *)key
{
    if (key) {
        NSString * url=[NSString stringWithFormat:@"%@index.php?act=member_predeposit&op=view",Url];
        NSDictionary * prm=@{@"key":key};
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

- (void)uploadImageWithImage:(NSString *)imagePath andurl:(NSString *)url andprm:(NSDictionary *)prm andkey:(NSString *)key
{
    NSData *data=[NSData dataWithContentsOfFile:imagePath];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpg"];
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

- (void)ShowOrderuploadImageWithImage:(NSData *)imagedata andurl:(NSString *)url andprm:(NSDictionary *)prm andkey:(NSString *)key
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
