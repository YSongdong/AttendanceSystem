//
//  LoockGoOutAddressController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/2.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "LoockGoOutAddressController.h"

#import "POIAnnotation.h"

@interface LoockGoOutAddressController ()
<
MAMapViewDelegate,
AMapGeoFenceManagerDelegate,
AMapSearchDelegate
>
@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UILabel *addressLab;

@property (nonatomic,strong) UIButton *lookBtn;

//地图管理器
@property (nonatomic,strong)MAMapView *mapView;
//搜索管理器
@property (nonatomic,strong) AMapSearchAPI *search;
//定位管理器
@property (nonatomic,strong)AMapLocationManager *locationManager;
//显示位置
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;
//围栏管理器
@property (nonatomic,strong)AMapGeoFenceManager *geoFenceManager;
@end

@implementation LoockGoOutAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    [self createNavi];
    [self createMapView];
}
#pragma mark -----创建围栏 -----
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"创建失败 %@",error);
    } else {
        NSLog(@"创建成功");
    }
}
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth    = 1.f;
        circleRenderer.strokeColor  = [UIColor colorCommonGreenColor];
        circleRenderer.fillColor    = [UIColor colorWithHexString:@"#01d397" alpha:0.1f];
        return circleRenderer;
    }
    return nil;
}
#pragma mark ----- AMapSearchDelegate-----
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: - %@", error);
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
    }];
    if (poiAnnotations.count == 0) {
        return;
    }
    for (POIAnnotation *tation in poiAnnotations) {
        self.addressLab.text = tation.title;
    }
}
//查看路线
-(void) selectLockAction:(UIButton *) sender{
    [self showAlterView];
}
#pragma mark ---地图Delegate-----
- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    self.mapView.showsUserLocation = YES;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    MAPinAnnotationView *annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapSample"];
    annotationView.canShowCallout = NO;
    annotationView.image = [UIImage imageNamed:@"ico_dw03"];
    return annotationView;
}
-(void) createMapView{
    __weak typeof(self) weakSelf = self;
    UIView *toolView = [[UIView alloc]init];
    [self.view addSubview:toolView];
    toolView.backgroundColor =[UIColor colorTextWhiteColor];
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-KSTabbarH);
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
        make.width.equalTo(@140);
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
    [self.lookBtn addTarget:self action:@selector(selectLockAction:) forControlEvents:UIControlEventTouchUpInside];
    
    ///初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-162-KSTabbarH)];
    self.mapView.delegate = self;
    //设置显示大小
    [self.mapView setZoomLevel:14.1 animated:NO];
    self.mapView.showsCompass = NO;
    self.mapView.distanceFilter = 10.f;
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapView.showsUserLocation = NO;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    
    self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
    self.geoFenceManager.delegate = self;
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed;
    
    //赋值
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[self.dict[@"lat"]floatValue]longitude:[self.dict[@"lng"]floatValue]];
    [self.pointAnnotaiton setCoordinate:location.coordinate];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
    
    self.nameLab.text = self.dict[@"address"];
    CGFloat w = [SDTool calStrWith:self.nameLab.text andFontSize:18].width;
    if (w+24+140 > KScreenW) {
        [showRadiusLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLab.mas_right).offset(7);
            make.centerY.equalTo(weakSelf.nameLab.mas_centerY);
            make.width.equalTo(@140);
            make.right.equalTo(weakSelf.view).offset(-12);
        }];
    }
    //创建围栏
    [self.geoFenceManager addCircleRegionForMonitoringWithCenter:location.coordinate radius:[self.dict[@"radius"] doubleValue] customID:[NSString stringWithFormat:@"circle_1"]];
    //显示围栏
    MACircle *circle = [MACircle circleWithCenterCoordinate:location.coordinate radius:[self.dict[@"radius"] doubleValue]];
    _mapView.delegate = self;
    //在地图上添加圆
    [_mapView addOverlay: circle];
    
#pragma  mark ------搜索POI --------
    //搜索管理器
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    request.keywords            = self.dict[@"address"];
    /* 按照距离排序. */
 //   request.sortrule            = [self.dict[@"radius"] floatValue];
    request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:request];
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
}

-(MAPointAnnotation *)pointAnnotaiton{
    if (!_pointAnnotaiton) {
        _pointAnnotaiton  =[[MAPointAnnotation alloc]init];
    }
    return _pointAnnotaiton;
}
#pragma mark ----跳转第三方应用-----
-(void) showAlterView {
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:@"请选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alterVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
   
    NSArray *arr = [self getInstalledMapAppWithEndLocation:CLLocationCoordinate2DMake([self.dict[@"lat"]floatValue], [self.dict[@"log"]floatValue])];
    
    for (NSDictionary *dict in arr) {
        NSString *titleStr = dict[@"title"];
        if ([titleStr isEqualToString:@"苹果地图"]) {
            [alterVC addAction:[UIAlertAction actionWithTitle:titleStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self navAppleMap];
            }]];
        }else{
            [alterVC addAction:[UIAlertAction actionWithTitle:titleStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *urlString = dict[@"url"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }]];
        }
    }
    [self presentViewController:alterVC animated:YES completion:nil];
}
#pragma mark - 导航方法
- (NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
{
    NSMutableArray *maps = [NSMutableArray array];
    
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"nav123456",endLocation.latitude,endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"导航测试",@"nav123456",endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    return maps;
}

//苹果地图
- (void)navAppleMap
{
    CLLocationCoordinate2D gps = CLLocationCoordinate2DMake([self.dict[@"lat"]floatValue], [self.dict[@"lng"]floatValue]);
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil]];
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}



@end
