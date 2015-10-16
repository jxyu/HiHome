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
-(void)Login:(NSString *)mobel andpwd:(NSString *)pwd;
/**
 *  重置密码
 *
 *  @param prm <#prm description#>
 */
-(void)ResetPwd:(id)prm;
/**
 *  修改昵称
 *
 *  @param username 昵称
 *  @param key      登录令牌
 */
-(void)ChangeUserName:(NSString *)username andkey:(NSString *)key;
/**
 *  上传头像
 *
 *  @param imagePath 图片在沙盒的路径
 */
-(void)UpLoadImage:(NSString *)imagePath andkey:(NSString *)key;
/**
 *  保存头像
 *
 *  @param avatarname 上传成功后返回的
 *  @param key        key
 */
-(void)SaveAvatarWithAvatarName:(NSString *)avatarname andkey:(NSString *)key;
/**
 *  签到
 *
 *  @param key key
 */
-(void)signIn:(NSString *)key;
/**
 *  获得兑换奖品
 *
 *  @param key key
 */
-(void)GetProList:(NSString *)key;
/**
 *  获取收货地址列表
 *
 *  @param key key
 */
-(void)GetAddressList:(NSString *)key;
/**
 *  获取地区列表
 *
 *  @param area_id areaid获取第一级列表传空即可
 *  @param key     key
 */
-(void)GetArrayListwithareaid:(NSString *)area_id andkey:(NSString *)key;
/**
 *  添加收货地址
 *
 *  @param prm <#prm description#>
 */
-(void)addAddress:(id)prm;
/**
 *  设置默认收货地址
 *
 *  @param address_id 收货地址的id
 *  @param key        key
 */
-(void)SetDefaultAddressWithaddressid:(NSString *)address_id andkey:(NSString *)key;
/**
 *  删除地址
 *
 *  @param address_id <#address_id description#>
 *  @param key        <#key description#>
 */
-(void)DelAddressWithAddressid:(NSString *)address_id andkey:(NSString *)key;
/**
 *  修改地址
 *
 *  @param prm <#prm description#>
 */
-(void)EditAddressWithPrm:(id)prm;
/**
 *  积分兑换
 *
 *  @param prm <#prm description#>
 */
-(void)DuihuanFunction:(id)prm;
/**
 *  获取积分详情
 *
 *  @param key <#key description#>
 */
-(void)GetjifenDetial:(NSString *)key;

/**
 *  获取商品分类
 */
-(void)GetClassify;
/**
 *  获取商品下一级分类
 *
 *  @param gc_id 分类id
 */
-(void)GetClassifyNext:(NSString *)gc_id;
/**
 *  根据经纬度获取城市信息
 *
 *  @param lng <#lng description#>
 *  @param lat <#lat description#>
 */
-(void)GetcityInfoWithlng:(NSString *)lng andlat:(NSString *)lat;
/**
 *  获取首页数据
 *
 *  @param areaid 城市ID
 *  @param lng    <#lng description#>
 *  @param lat    <#lat description#>
 */
-(void)GetIndexDataWithAreaid:(NSString *)areaid andlng:(NSString *)lng andlat:(NSString *)lat;
/**
 *  获取商品列表
 *
 *  @param prm 参数字典
 */
-(void)GetGoodsListWithKeyWord:(NSDictionary *)prm;
/**
 *  获取店铺分类
 */
-(void)getClassifyForStore;
/**
 *  获取店铺列表
 *
 *  @param prm 参数字典
 */
-(void)GetStoreList:(NSDictionary *)prm;
/**
 *  获取店铺详情
 *
 *  @param key      用户登录的key
 *  @param store_id 店铺ID
 */
-(void)GetStoreDetialInfoWithKey:(NSString *)key andstoreid:(NSString *)store_id;
/**
 *  获取店铺商品列表
 *
 *  @param prm <#prm description#>
 */
-(void)GetStoreGoodList:(id)prm;
/**
 *  获取商品详情
 *
 *  @param goodid 商品id
 */
-(void)GetGoodDetialInfoWithid:(NSString *)goodid;
/**
 *  获取更多评论
 *
 *  @param goodid <#goodid description#>
 */
-(void)GetMorePinglun:(NSString *)goodid;
/**
 *  获取城市列表
 */
-(void)GetCityList;
/**
 *  获取钱包余额
 *
 *  @param key key
 */
-(void)GetPurseInfo:(NSString *)key;
/**
 *  获取支付charge对象
 *
 *  @param prm <#prm description#>
 */
-(void)GetChargeObject:(id)prm;
/**
 *  获取购物车列表
 *
 *  @param key key
 */
-(void)GetShopCarList:(NSString *)key;
/**
 *  修改购物车货物数量
 *
 *  @param key    key
 *  @param cartid 购物车id
 *  @param num    修改后的货物数量
 */
-(void)EditGoodsNumWithKey:(NSString *)key andCartid:(NSString *)cartid andnum:(NSString *)num;
/**
 *  删除购物车货物
 *
 *  @param key  <#key description#>
 *  @param gcid <#gcid description#>
 */
-(void)DelGoodsWithKey:(NSString *)key andcartid:(NSString *)cartid;
/**
 *  获取订单列表
 *
 *  @param key         key
 *  @param curpage     页码
 *  @param order_state 订单状态
 */
-(void)GetOrderListWithKey:(NSString *)key andcurpage:(NSString *)curpage andorder_state:(NSString *)order_state;
/**
 *  取消订单（未付款）
 *
 *  @param order_id <#order_id description#>
 *  @param key      <#key description#>
 */
-(void)CancalOrderWithOutPay:(NSString *)order_id andkey:(NSString *)key;
/**
 *  取消订单（已付款）
 *
 *  @param order_id <#order_id description#>
 *  @param key      <#key description#>
 */
-(void)CancalOrderPayAlready:(NSString *)order_id andkey:(NSString *)key;
/**
 *  确认收货
 *
 *  @param order_id <#order_id description#>
 *  @param key      <#key description#>
 */
-(void)OrderForSure:(NSString *)order_id andkey:(NSString *)key;
/**
 *  删除订单
 *
 *  @param order_id <#order_id description#>
 *  @param key      <#key description#>
 */
-(void)DelOrder:(NSString *)order_id andkey:(NSString *)key;
/**
 *  加入购物车
 *
 *  @param key      <#key description#>
 *  @param goods_id 商品ID
 *  @param quantity 商品数量
 */
-(void)AddToShoppingCar:(NSString *)key andgoods_id:(NSString *)goods_id andquantity:(NSString *)quantity;
/**
 *  购买第一步
 *
 *  @param key      <#key description#>
 *  @param goods_id <#goods_id description#>
 *  @param ifcart   是否在购物车中购买的
 */
-(void)Buy_Stepone:(NSString *)key andcart_id:(NSString *)cart_id andifcart:(NSString *)ifcart;
/**
 *  购买第二步
 *
 *  @param prm <#prm description#>
 */
-(void)Buy_StepTwo:(id)prm;
/**
 *  订单支付
 *
 *  @param key     <#key description#>
 *  @param pay_sn  支付订单号
 *  @param channel 支付宝:alipay 微信:wx
 */
-(void)OrderPayWithKey:(NSString *)key andpay_sn:(NSString *)pay_sn andchannel:(NSString *)channel;
/**
 *  晒单圈，我发布的
 *
 *  @param key <#key description#>
 */
-(void)GetShowOrderForMySendWithKey:(NSString *)key;
/**
 *  晒单圈，我评论的
 *
 *  @param key <#key description#>
 */
-(void)GetShowOrderForMyJuageWithKey:(NSString *)key;
/**
 *  晒单圈点赞
 *
 *  @param key       <#key description#>
 *  @param circle_id <#circle_id description#>
 */
-(void)zanClickWithKey:(NSString* )key andcircle_id:(NSString *)circle_id;
/**
 *  晒单圈评论
 *
 *  @param prm <#prm description#>
 */
-(void)ShowOrderPinglun:(id)prm;
/**
 *  获取排序列表
 *
 *  @param key   key
 *  @param order 排序(1默认,2本周,3评论数,4点赞)
 */
-(void)GetShowOrderOrderListWithKey:(NSString *)key andorder:(NSString *)order;
/**
 *  上传晒单圈照片
 *
 *  @param imagedata <#imagedata description#>
 *  @param key       <#key description#>
 */
-(void)ShowOrderUpLoadImg:(NSData *)imagedata andkey:(NSString *)key;
/**
 *  晒单圈，发布
 *
 *  @param key         <#key description#>
 *  @param description <#description description#>
 *  @param image       (上传图片时返回图片名称 多个用逗号分隔)
 */
-(void)ShowOrderSendWithKey:(NSString *)key anddescription:(NSString *)description andimage:(NSString *)image;
/**
 *  店铺收藏
 *
 *  @param key      <#key description#>
 *  @param store_id <#store_id description#>
 */
-(void)CollectShopWithKey:(NSString *)key andstore_id:(NSString *)store_id;
/**
 *  货物收藏
 *
 *  @param key      <#key description#>
 *  @param goods_id <#goods_id description#>
 */
-(void)CollectGoodWithKey:(NSString *)key andgoods_id:(NSString *)goods_id;
/**
 *  获取收藏货物列表
 *
 *  @param key <#key description#>
 */
-(void)GetGoodCollectList:(NSString *)key;
/**
 *  获取收藏店铺列表
 *
 *  @param key <#key description#>
 */
-(void)GetStoreCollectList:(NSString *)key;
/**
 *  删除收藏的货物
 *
 *  @param key    <#key description#>
 *  @param fav_id <#fav_id description#>
 */
-(void)DelGoodsCollectWithKey:(NSString *)key andfav_id:(NSString *)fav_id;
/**
 *  删除收藏的店铺
 *
 *  @param key      <#key description#>
 *  @param store_id <#store_id description#>
 */
-(void)DelStoreCollectWithKey:(NSString *)key andstore_id:(NSString *)store_id;
/**
 *  上传身份证扫描件
 *
 *  @param imagedata <#imagedata description#>
 *  @param key       <#key description#>
 */
-(void)UpLoadIDCardImg:(NSData *)imagedata andkey:(NSString *)key;
/**
 *  实名认证提交
 *
 *  @param prm <#prm description#>
 */
-(void)RealNameSubmit:(id)prm;
/**
 *  获取订单详情
 *
 *  @param key      <#key description#>
 *  @param order_id <#order_id description#>
 */
-(void)GetOrderDetialWithKey:(NSString *)key andorder_id:(NSString *)order_id;
/**
 *  上传商品评价图片
 *
 *  @param imagedata <#imagedata description#>
 *  @param key       <#key description#>
 */
-(void)UploadPingJiaImg:(NSData *)imagedata andkey:(NSString *)key;
/**
 *  提交评论
 *
 *  @param prm <#prm description#>
 */
-(void)SubmitPingjia:(id)prm;
/**
 *  获取天天特价货物列表
 *
 *  @param prm <#prm description#>
 */
-(void)GetSpecGoodsList:(NSDictionary *)prm;
/**
 *  获取猜你喜欢货物列表
 *
 *  @param prm <#prm description#>
 */
-(void)GessYouLike:(NSDictionary *)prm;
/**
 *  QQ登录
 *
 *  @param openid   <#openid description#>
 *  @param username <#username description#>
 */
-(void)LoginForQQWithopenid:(NSString *)openid andusername:(NSString * )username;
/**
 *  获取钱包余额和积分
 *
 *  @param key <#key description#>
 */
-(void)GetPolicatandjifenWithKey:(NSString *)key;







/**
 *  设置回调函数
 *
 *  @param cbobject     回调对象
 *  @param selectorName 回调函数
 */
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

@end
