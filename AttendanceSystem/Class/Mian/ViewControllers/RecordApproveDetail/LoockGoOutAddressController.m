//
//  LoockGoOutAddressController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/2.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "LoockGoOutAddressController.h"

@interface LoockGoOutAddressController ()
<
MAMapViewDelegate,
AMapLocationManagerDelegate
>
@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UILabel *addressLab;

@property (nonatomic,strong) UIButton *lookBtn;

//地图管理器
@property (nonatomic,strong)MAMapView *mapView;
//定位管理器
@property (nonatomic,strong)AMapLocationManager *locationManager;
//显示位置
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;
@end

@implementation LoockGoOutAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createMapView];
}

#pragma mark ---地图Delegate-----
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    MAPinAnnotationView *annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapSample"];
    annotationView.canShowCallout = NO;
   // annotationView.image = [UIImage imageNamed:@"ico_dw03"];
    return annotationView;
}
-(void) createMapView{
    __weak typeof(self) weakSelf = self;
    UIView *toolView = [[UIView alloc]init];
    [self.view addSubview:toolView];
    toolView.backgroundColor =[UIColor colorTextWhiteColor];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.height.equalTo(@162);
    }];
    
    self.nameLab  = [[UILabel alloc]init];
    [toolView addSubview:self.nameLab];
    self.nameLab.textColor = [UIColor colorTextBg28BlackColor];
    self.nameLab.font = BFont(18);
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toolView).offset(12);
        make.top.equalTo(toolView).offset(18);
    }];
    
    UILabel *showRadiusLab = [[UILabel alloc]init];
    [toolView addSubview:showRadiusLab];
    showRadiusLab.text =@"(打卡翻盖半径： 1Km内)";
    showRadiusLab.textColor = [UIColor colorTextBg98BlackColor];
    showRadiusLab.font = Font(12);
    [showRadiusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.nameLab.mas_centerY);
//        make.right.equalTo(weakSelf.view).offset(-12);
    }];
    
    self.addressLab = [[UILabel alloc]init];
    [toolView addSubview:self.addressLab];
    self.addressLab.textColor = [UIColor colorTextBg65BlackColor];
    self.addressLab.font = Font(12);
    self.addressLab.numberOfLines =2;
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab.mas_left);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).offset(10);
        make.right.equalTo(weakSelf.view).offset(12);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [toolView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(toolView);
        make.height.equalTo(@1);
        make.bottom.equalTo(toolView.mas_bottom).offset(-74);
    }];
    
    self.lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolView addSubview:self.lookBtn];
    [self.lookBtn setTitle:@"查看路线" forState:UIControlStateNormal];
    [self.lookBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.lookBtn.titleLabel.font = Font(14);
    [self.lookBtn setBackgroundImage:[UIImage imageNamed:@"btn_01"] forState:UIControlStateNormal];
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toolView).offset(25);
        make.top.equalTo(lineView.mas_bottom).offset(16);
        make.right.equalTo(toolView).offset(-25);
        make.height.equalTo(@44);
    }];
    
    ///初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-162)];
    self.mapView.delegate = self;
    //设置显示大小
    [self.mapView setZoomLevel:17.1 animated:NO];
    self.mapView.showsCompass = NO;
    self.mapView.distanceFilter = 10.f;
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    //置定位最小更新距离
    self.locationManager.distanceFilter= 10.f;
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //设置定位超时时间
    [self.locationManager setLocationTimeout:6];
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:3];
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //返回逆地理编码信息
    [self.locationManager setLocatingWithReGeocode:YES];
}
//创建Navi
-(void) createNavi{
    self.customNavBar.title = @"外出地点";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[dict[@"lat"]floatValue]longitude:[dict[@"log"]floatValue]];
    [self.pointAnnotaiton setCoordinate:location.coordinate];
    
    self.addressLab.text = dict[@"address"];
}



@end
