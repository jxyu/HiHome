//
//  CreateAlbumViewController.m
//  HiHome
//
//  Created by 王建成 on 15/10/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "CreateAlbumViewController.h"
#import "DataProvider.h"
#import "JKAlertDialog.h"

@interface CreateAlbumViewController ()
{
    CGFloat _rowHeight;
    
    UITextField *nameField;
    UITextField *introField;
    UITextField *limitField;
    
    NSString *limit;
}
@end

@implementation CreateAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZY_UIBASE_BACKGROUND_COLOR;
    _rowHeight = SCREEN_HEIGHT/11;
    [self initViews];
    // Do any additional setup after loading the view from its nib.
}


-(void)initViews
{
    self.mBtnRight.hidden = NO;
    [self.mBtnRight setTitle:@"新建" forState:UIControlStateNormal];
    limit = [NSString stringWithFormat:@"0"];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, ZY_HEADVIEW_HEIGHT+50, SCREEN_WIDTH - 20*2, _rowHeight)];
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, _rowHeight)];
    leftLab.text = @"   相册名字:";
    leftLab.font = [UIFont systemFontOfSize:14];
    nameField.leftView = leftLab;
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.borderStyle  = UITextBorderStyleRoundedRect;
    nameField.backgroundColor = [UIColor whiteColor];
    
    introField = [[UITextField alloc] initWithFrame:CGRectMake(20, ZY_HEADVIEW_HEIGHT+50+_rowHeight, SCREEN_WIDTH - 20*2, _rowHeight)];
    UILabel *leftLab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, _rowHeight)];
    leftLab1.text = @"  相册描述:";
    leftLab1.font = [UIFont systemFontOfSize:14];
    introField.leftView = leftLab1;
    introField.leftViewMode = UITextFieldViewModeAlways;
    introField.borderStyle  = UITextBorderStyleRoundedRect;
    introField.backgroundColor = [UIColor whiteColor];
    
    limitField = [[UITextField alloc] initWithFrame:CGRectMake(20, ZY_HEADVIEW_HEIGHT+50+2*_rowHeight+30, SCREEN_WIDTH - 20*2, _rowHeight)];
    UILabel *leftLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, _rowHeight)];
    leftLab2.text = @"   谁能看见:";
    leftLab2.font = [UIFont systemFontOfSize:14];
    limitField.leftView = leftLab2;
    limitField.leftViewMode = UITextFieldViewModeAlways;
    limitField.borderStyle  = UITextBorderStyleRoundedRect;
    limitField.backgroundColor = [UIColor whiteColor];
    limitField.font = [UIFont systemFontOfSize:14];
    TempCustomButton *rightBtn = [[TempCustomButton alloc] initWithFrame:CGRectMake(limitField.frame.size.width/4*3, 0, limitField.frame.size.width/4, _rowHeight)];
    [rightBtn setTitle:@"所有人" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(selectLimit:) forControlEvents:UIControlEventTouchUpInside];
  //  [limitField addSubview:rightBtn];
    limitField.rightView = rightBtn;
    limitField.rightViewMode = UITextFieldViewModeAlways ;
   // limitField.enabled = NO;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
    [self.view addSubview:nameField];
    [self.view addSubview:introField];
    [self.view addSubview:limitField];
}
-(void)selectLimit:(UIButton *)sender
{
    SelectLimitViewController *seclectLimitViewCtl = [[SelectLimitViewController alloc] init];
    seclectLimitViewCtl.delegate = self;
    [self presentViewController:seclectLimitViewCtl animated:YES completion:^{}];
    DLog(@"Click limit btn");
}

-(void)tapViewAction:(id)sender
{
    [self.view endEditing:NO];
}

-(void)btnRightClick:(UIButton *)sender
{
    
    if((nameField.text && introField.text)&&(![nameField.text isEqualToString:@""] && ![introField.text isEqualToString:@""])&&limit)
    {
        [self CreateAlbum:nameField.text andLimit:limit andIntro:introField.text];
    }
    else
    {
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"请完善信息"]];
        
        alert.alertType = AlertType_Hint;
        [alert addButtonWithTitle:@"确定"];
        [alert show];

    }
    
}

-(void)CreateAlbum:(NSString *)title andLimit:(NSString *)pm andIntro:(NSString *)intro
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"createAlbumCallBack:"];
    
    NSString *userID = [self getUserID];//获取userID
    
    NSLog(@"id = [%@]",userID);
    
    [dataprovider CreateAlbum:userID andTitle:title andPm:pm andIntro:intro];
    
}

#pragma mark - limit delegate
-(void)setLimitDict:(NSDictionary *)dict
{
    if(dict!=nil)
    {
        @try {
            switch ([[dict objectForKey:@"mode"] integerValue]) {
                case Mode_mine:
                    limit = [NSString stringWithFormat:@"-1"];
                    //limitField.text = @"自己";
                    [(UIButton *)(limitField.rightView) setTitle:@"仅自己" forState:UIControlStateNormal];
                    break;
                case Mode_all:
                    limit = [NSString stringWithFormat:@"0"];
                    [(UIButton *)(limitField.rightView) setTitle:@"所有人" forState:UIControlStateNormal];
                    break;
                case Mode_friends:
                    //limitField.text = @"自己";
                    {
                        [(UIButton *)(limitField.rightView) setTitle:@"好友" forState:UIControlStateNormal];
                        NSArray *tempArr = [dict objectForKey:@"userName"];
                
                        NSString *str = @"";
                        
                        for (int i = 0; i < tempArr.count; i++) {
                            str = [NSString stringWithFormat:@"%@ %@",str,[tempArr objectAtIndex:i]];
                            
                        }
                        limitField.text = str;
                        
                        tempArr = [dict objectForKey:@"userID"];
                        limit = [tempArr objectAtIndex:0];
                        for (int i = 1;i< tempArr.count; i++) {
                            limit = [NSString stringWithFormat:@"%@,%@",limit,[tempArr objectAtIndex:i]];
                        }
                        NSLog(@"limit = %@",limit);
                    }
                    break;
                default:
                    break;
            }

        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}

-(void)createAlbumCallBack:(id)dict
{
    
    NSInteger code;

    DLog(@" dict = %@",dict);

    code = [(NSString *)[dict objectForKey:@"code"] integerValue];
    
    if(code!=200)
    {
        NSLog(@"%@",[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]);
        
        if(code!=400)  //= 400 不弹框
        {
            JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"失败" message:[NSString stringWithFormat:@"任务获取失败:%ld",(long)code]];
            
            alert.alertType = AlertType_Hint;
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        }

        return;
    }
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"成功" message:[NSString stringWithFormat:@"新建成功"]];
    
    alert.alertType = AlertType_Alert;
  //  [alert addButtonWithTitle:@"确定"];
    
    
    
    [alert addButton:Button_OK withTitle:@"确定" handler:^(JKAlertDialogItem *item){
        [self quitView];
        
    }];
    
    [alert show];

    
}


-(NSString *)getUserID
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary *userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
    NSString *userID = [userInfoWithFile objectForKey:@"id"];//获取userID
    
    return  userID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
