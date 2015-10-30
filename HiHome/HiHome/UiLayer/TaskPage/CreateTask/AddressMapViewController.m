//
//  AddressMapViewController.m
//  HiHome
//
//  Created by Rain on 15/10/29.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "AddressMapViewController.h"
#import <MAMapKit/MAPointAnnotation.h>
#import "CCLocationManager.h"

#define APIKey @"a81752d9e80e1eeb5d3eaf8fca9b4338"

@interface AddressMapViewController ()<MAMapViewDelegate>{
    MAPointAnnotation *pointAnnotation;
    CGFloat _lat;
    CGFloat _long;
    NSString * address;
    NSUserDefaults *mUserDefault;
}

@property (nonatomic,strong) MAMapView *mapView;

@end

@implementation AddressMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mUserDefault = [NSUserDefaults standardUserDefaults];

    [self.mBtnRight setTitle:@"保存" forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //配置用户Key
    [MAMapServices sharedServices].apiKey = APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64)];
    _mapView.delegate = self;
    _mapView.centerCoordinate=CLLocationCoordinate2DMake([[mUserDefault valueForKey:@"lat"] floatValue], [[mUserDefault valueForKey:@"long"] floatValue]);
    pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.title = @"任务位置";
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([[mUserDefault valueForKey:@"lat"] floatValue], [[mUserDefault valueForKey:@"long"] floatValue]);
    [_mapView addAnnotation:pointAnnotation];
    [self.view addSubview:_mapView];
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        
    } withAddress:^(NSString *addressString) {
        address=addressString;
    }];
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image=[UIImage imageNamed:@"shoppingcar_select_icon@2x.png"];
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view didChangeDragState:(MAAnnotationViewDragState)newState fromOldState:(MAAnnotationViewDragState)oldState
{
    _lat=pointAnnotation.coordinate.latitude;
    _long=pointAnnotation.coordinate.longitude;
    
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        
    } withAddress:^(NSString *addressString) {
        address=addressString;
        NSLog(@"%@",address);
    }];
    
    NSLog(@"%f",pointAnnotation.coordinate.latitude);
}

-(void)btnRightClick:(id)sender{
    _mLag = [NSString stringWithFormat:@"%f",_lat];
    _mLong = [NSString stringWithFormat:@"%f",_long];
    _mAddress = address;
}

-(void)quitView{
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        [self popoverPresentationController];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
