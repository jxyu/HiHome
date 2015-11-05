//
//  WMMenuViewController.m
//  QQSlideMenu
//
//  Created by wamaker on 15/6/12.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import "WMMenuViewController.h"
#import "WMMenuTableViewCell.h"
#import "WMCommon.h"
#import "UIImage+WM.h"

@interface WMMenuViewController () <UITableViewDelegate, UITableViewDataSource>{
    NSUserDefaults *mUserDefault;
}
@property (strong, nonatomic) WMCommon *common;
@property (strong ,nonatomic) NSArray  *listArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton    *nightModeBtn;
@property (weak, nonatomic) IBOutlet UIButton    *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *headerImageBtn;

- (IBAction)btnClick:(id)sender;

@end

@implementation WMMenuViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.common = [WMCommon getInstance];
    
   // self.listArray = @[@"纪念日总览", @"周任务总览", @"月任务总览", @"相册", @"设置", @"绑定配偶", @"我的文件"];
    self.listArray = @[@"纪念日总览", @"周任务总览", @"月任务总览", @"相册", @"设置", @"绑定配偶"];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight       = 44 * (self.common.screenW / 320);
    // 设置tableFooterView为一个空的View，这样就不会显示多余的空白格子了
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    NSLog(@"set gestureRecognizer");
    
    UISwipeGestureRecognizer *tempSwipLeft = [[UISwipeGestureRecognizer alloc] init];
    tempSwipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [tempSwipLeft addTarget:self action:@selector(swipAction:)];
   // [self.tabBarController.view addGestureRecognizer:tempSwipLeft];
    [self.view addGestureRecognizer:tempSwipLeft];
 //   [pan requireGestureRecognizerToFail:tempSwipLeft];
    tempSwipLeft.delegate = self;
    
    [self getUserInfo];
    [[self headerImageBtn] setImage:[[UIImage imageNamed:@"me"] getRoundImage] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSetNickClick) name:@"setNick" object:nil];
    
}

-(void)didSetNickClick{
    mUserDefault = [NSUserDefaults standardUserDefaults];
    _mName.text = [mUserDefault valueForKey:@"nick"];
}

- (void)btnClick:(id)sender {
//    if (sender == self.nightModeBtn) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"使用提示" message:@"要使用夜间模式需下载主题包，立即下载？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即下载", nil];
//        [alertView show];
//    } else {
//        if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
//            [self.delegate didSelectItem:self.settingBtn.titleLabel.text];
//        }
//    }
}

-(void) swipAction:(id)sender
{
    NSLog(@"swip  left");
    if([self.delegate respondsToSelector:@selector(swipLeftAction)])
    {
        [self.delegate swipLeftAction];
    }
    
}

#pragma mark - 获取个人资料

-(NSString *)getUserID
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary *userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
    NSString *userID = [userInfoWithFile objectForKey:@"id"];//获取userID
    
    return  userID;
}

-(void)getUserInfo{
    DataProvider *dataProvider;
    dataProvider=[[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"GetInfoBackCall:"];
    [dataProvider GetUserInfoWithUid:[self getUserID]];
}

-(void)GetInfoBackCall:(id)dict
{
    DLog(@"%@",dict);
    NSArray *userInfoArray;
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 200) {
        
        if (code == 200) {
            @try {
                
                userInfoArray = (NSArray *)[dict objectForKey:@"datas"];
                NSLog(@"%@",userInfoArray);
                
                NSDictionary *tempDict = [userInfoArray objectAtIndex:0];
                self.nickNameLab.text = [tempDict objectForKey:@"nick"];
                self.signLab.text = [tempDict objectForKey:@"sign"];
                
                if(![[tempDict objectForKey:@"avatar"] isEqual:[NSNull null]])
                {
                    NSString * url=[NSString stringWithFormat:@"%@%@",ZY_IMG_PATH,[tempDict objectForKey:@"avatar"]];
                    UIImageView *tempImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.headerImageBtn.frame.size.width, self.headerImageBtn.frame.size.height)];
                    [tempImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[[UIImage imageNamed:@"me"]getRoundImage ]];
                    
                    self.headerImageBtn.layer.masksToBounds=YES;
                    self.headerImageBtn.layer.cornerRadius=(self.headerImageBtn.frame.size.width)/2;
                    self.headerImageBtn.layer.borderWidth=0.5;
                    self.headerImageBtn.layer.borderColor=ZY_UIBASECOLOR.CGColor;
                    [self.headerImageBtn addSubview:tempImgView];
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }

        }
    }else{
        NSLog(@"访问服务器失败！");
    }
}


#pragma mark - tableView代理方法及数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 没有用系统自带的类而用了自己重新定义的cell，仅仅为了之后扩展方便，无他
    WMMenuTableViewCell *cell = [WMMenuTableViewCell cellWithTableView:tableView];
    [cell setCellText:self.listArray[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        [self.delegate didSelectItem:self.listArray[indexPath.row]];
    }
}

- (IBAction)headerImgClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"headerImgClickName" object:nil];
}
@end
