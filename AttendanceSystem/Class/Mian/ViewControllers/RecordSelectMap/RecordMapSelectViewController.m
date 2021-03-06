//
//  RecordMapSelectViewController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "RecordMapSelectViewController.h"

#import "MapSearchHeaderView.h"
#import "POIAnnotation.h"
#import "SearchSpaceView.h"
#import "ShowLocatPromentView.h"

#import "SearchTableViewCell.h"
#define SEARCHTABLEVIEW_CELL @"SearchTableViewCell"

@interface RecordMapSelectViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
MAMapViewDelegate,
UIGestureRecognizerDelegate,
AMapLocationManagerDelegate,
AMapSearchDelegate
>
//搜索view
@property (nonatomic,strong) MapSearchHeaderView *searchHeaderView;
//提示权限view
@property (nonatomic,strong) ShowLocatPromentView *showLocatView;
//
@property (nonatomic,strong) UITableView *searchTableView;
//数据源
@property (nonatomic,strong) NSMutableArray *dataArr;
//地图管理器
@property (nonatomic,strong)MAMapView *mapView;
//定位管理器
@property (nonatomic,strong)AMapLocationManager *locationManager;
//搜索管理器
@property (nonatomic,strong) AMapSearchAPI *search;
//显示位置
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;
//存储位置信息
@property (nonatomic,strong) AMapLocationReGeocode *reGeocode;
//获得自己的位置，方便demo添加围栏进行测试，
@property (nonatomic, strong) CLLocation *userLocation;
//空白页
@property (nonatomic,strong)SearchSpaceView *searchSpaceView;
//搜索Str
@property (nonatomic,strong) NSString *searchStr;
//选中当前定位
@property (nonatomic,strong) NSIndexPath *selectIndexPtah;
//执行一次
@property (nonatomic,assign) BOOL isOne;

//是不是搜索选择
@property (nonatomic,assign) BOOL isSearchSelect;

@end

@implementation RecordMapSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchStr =@"";
    self.isOne = YES;
    self.isSearchSelect = NO;
    [self createNavi];
    [self createSearchView];
    [self createTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createLocationManager];
}
-(void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        if (self.selectIndexPtah == nil) {
            return;
        }
        NSDictionary *dict = self.dataArr[self.selectIndexPtah.row];
        if ([self.delegate respondsToSelector:@selector(selectAddressDict:)]) {
            [self.delegate selectAddressDict:dict];
        }
    }
}
#pragma mark ----搜索Pol -----
-(void) searchStr:(NSString *) str{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords            = str;
  //  request.city                = self.reGeocode.city;
  //  request.types               = @"高等院校";
    request.requireExtension    = YES;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    
    [self.search AMapPOIKeywordsSearch:request];

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
        self.searchSpaceView.hidden = NO;
        return;
    }
    [self.dataArr removeAllObjects];
    
    self.searchSpaceView.hidden = YES;
    
    for (int i=0; i<poiAnnotations.count; i++) {
        POIAnnotation *tation = poiAnnotations[i];
        if (self.isSearchSelect) {
            if (i==0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"title"] = tation.title;
                dict[@"subTitle"] =  tation.subtitle;
                CLLocation *location = [[CLLocation alloc]initWithLatitude:tation.coordinate.latitude longitude:tation.coordinate.longitude];
                dict[@"location"] =location;
                dict[@"isSelect"] = @"1"; //1 选中 2没有选中
                [self.dataArr addObject:dict];
                
                [self.mapView addAnnotation:self.pointAnnotaiton];
                CLLocation *loca = dict[@"location"];
                [self.mapView setCenterCoordinate:loca.coordinate];
                [self.pointAnnotaiton setCoordinate:loca.coordinate];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                self.selectIndexPtah = indexPath;
            }else{
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"title"] = tation.title;
                dict[@"subTitle"] =  tation.subtitle;
                CLLocation *location = [[CLLocation alloc]initWithLatitude:tation.coordinate.latitude longitude:tation.coordinate.longitude];
                dict[@"location"] =location;
                dict[@"isSelect"] = @"2"; //1 选中 2没有选中
                [self.dataArr addObject:dict];
            }
        }else{
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"title"] = tation.title;
            dict[@"subTitle"] =  tation.subtitle;
            CLLocation *location = [[CLLocation alloc]initWithLatitude:tation.coordinate.latitude longitude:tation.coordinate.longitude];
            dict[@"location"] =location;
            dict[@"isSelect"] = @"2"; //1 选中 2没有选中
            [self.dataArr addObject:dict];
        }
    }

    [self.searchTableView reloadData];
}
#pragma mark ---地图Delegate-----
- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    self.mapView.showsUserLocation = NO;
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    MAPinAnnotationView *annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapSample"];
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"ico_dw03"];
    return annotationView;
}
#pragma mark --- 定位Delegate---
//返回地理位置
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    if (reGeocode)
    {
        self.reGeocode = reGeocode;
        if ([self.searchStr isEqualToString:@""]) {
            self.searchStr = reGeocode.POIName;
            [self searchStr:reGeocode.POIName];
        }
        self.userLocation = location;
        [self.mapView addAnnotation:_pointAnnotaiton];
    }
    if (self.isOne) {
        [self.mapView setCenterCoordinate:location.coordinate];
        self.isOne = NO;
    }
}
//监控用户会否授权
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            //  NSLog(@"用户还未决定授权");
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            //   NSLog(@"访问受限");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                //   NSLog(@"定位服务开启，被拒绝");
                //用户拒绝开启用户权限
                [self.view addSubview:self.showLocatView];
            } else {
                //  NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            //NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}
#pragma mark  -----点击事件------
-(void)tap:(UITapGestureRecognizer *) sender{
    //回滚到表的最顶端
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        if (self.dataArr.count > 0) {
            NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.searchTableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
    //默认是搜索选择
    self.isSearchSelect = YES;
    
    CLLocationCoordinate2D  location = [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];
    
    CLLocation *loca = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
    
//    [self.pointAnnotaiton setCoordinate:loca.coordinate];
    [self.mapView setCenterCoordinate:loca.coordinate];
    
    //搜索
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = [AMapGeoPoint locationWithLatitude:loca.coordinate.latitude longitude:loca.coordinate.longitude];
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    [self.search AMapPOIAroundSearch:request];
}
//重新定位
-(void)selectPresentAction:(UIButton *)sender{
    //判断有没有开启定位权限
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //不可用
        //用户拒绝开启用户权限
        [self.view addSubview:self.showLocatView];
        return ;
    }
    self.mapView.showsUserLocation = YES;
    [self.mapView setCenterCoordinate:self.userLocation.coordinate animated:YES];
    [self.mapView removeAnnotation:_pointAnnotaiton];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SEARCHTABLEVIEW_CELL forIndexPath:indexPath];
    cell.dict = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.mapView.showsUserLocation = NO;
    [self.mapView addAnnotation:self.pointAnnotaiton];
    
    if (self.selectIndexPtah == nil) {
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.row]];
        mutableDict[@"isSelect"] = @"1";
        [self.dataArr replaceObjectAtIndex:indexPath.row withObject:mutableDict];
        [self.searchTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        self.selectIndexPtah = indexPath;
        
        //重新标点
        NSDictionary *dict = self.dataArr[indexPath.row];
        CLLocation *location = dict[@"location"];
        [self.mapView setCenterCoordinate:location.coordinate];
        [self.pointAnnotaiton setCoordinate:location.coordinate];
        return ;
    }
    
    NSMutableDictionary *oldDict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[self.selectIndexPtah.row]];
    oldDict[@"isSelect"] = @"2";
    [self.dataArr replaceObjectAtIndex:self.selectIndexPtah.row withObject:oldDict];
    [self.searchTableView reloadRowAtIndexPath:self.selectIndexPtah withRowAnimation:UITableViewRowAnimationNone];
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[indexPath.row]];
    mutableDict[@"isSelect"] = @"1";
    [self.dataArr replaceObjectAtIndex:indexPath.row withObject:mutableDict];
    [self.searchTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    self.selectIndexPtah = indexPath;
    
    //重新定位
    NSDictionary *dict = self.dataArr[indexPath.row];
    CLLocation *location = dict[@"location"];
    [self.mapView setCenterCoordinate:location.coordinate];
    [self.pointAnnotaiton setCoordinate:location.coordinate];
}
-(void) createSearchView{
    self.searchHeaderView = [[MapSearchHeaderView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, 53)];
    [self.view addSubview:self.searchHeaderView];
     __weak typeof(self) weakSelf = self;
    self.searchHeaderView.searchBlock = ^(NSString *searchStr) {
        //回滚到表的最顶端
        [weakSelf.searchTableView setContentOffset:CGPointMake(0,0) animated:NO];
        //默认是搜索选择
        weakSelf.isSearchSelect = YES;
        
        weakSelf.searchStr = searchStr;
        [weakSelf searchStr:searchStr];
       
    };
}
-(void) createTableView{
    __weak typeof(self) weakSelf = self;
    UIView *searchView = [[UIView alloc]init];
    [self.view addSubview:searchView];
    searchView.backgroundColor = [UIColor colorTextWhiteColor];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(weakSelf.view);
        make.height.equalTo(@265);
    }];
    
    UIView *headerView = [[UIView alloc]init];
    [searchView addSubview:headerView];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(searchView);
        make.height.equalTo(@45);
    }];
    
    UILabel *showSettingLab = [[UILabel alloc]init];
    [headerView addSubview:showSettingLab];
    showSettingLab.textColor = [UIColor colorTextBg28BlackColor];
    showSettingLab.font = Font(14);
    [showSettingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(12);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    
    double rang = [self.rangeStr doubleValue];
    NSString *searchStr = [NSString stringWithFormat:@"设置外出地点 (打卡覆盖半径 %.1fkm内)",rang/1000];
    
    NSMutableAttributedString *attribuStr = [[NSMutableAttributedString alloc]initWithString:searchStr];
    [attribuStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorTextBg98BlackColor]
                    range:NSMakeRange(7, searchStr.length-7)];
    showSettingLab.attributedText = attribuStr;
    
    self.searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, KScreenW, 265-45-KSTabbarH)];
    [searchView addSubview:self.searchTableView];
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.searchTableView registerNib:[UINib nibWithNibName:SEARCHTABLEVIEW_CELL bundle:nil] forCellReuseIdentifier:SEARCHTABLEVIEW_CELL];
    
    //空白页
    self.searchSpaceView = [[SearchSpaceView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSNaviTopHeight-CGRectGetHeight(self.searchHeaderView.frame)-265-45)];
    [self.searchTableView addSubview:self.searchSpaceView];
    self.searchSpaceView.hidden = YES;
    
    ///初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, KSNaviTopHeight+CGRectGetHeight(self.searchHeaderView.frame), KScreenW, KScreenH-KSNaviTopHeight-CGRectGetHeight(self.searchHeaderView.frame)-265)];
    self.mapView.delegate = self;
    //设置显示大小
    [self.mapView setZoomLevel:14.1 animated:NO];
    self.mapView.distanceFilter = 10.f;
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
//    self.mapView.showsUserLocation = YES;
//    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    //关闭指南针
    self.mapView.showsCompass = NO;
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self; //一定要记得设置代理
    [self.mapView addGestureRecognizer:tap];
   
    [self.mapView addAnnotation:self.pointAnnotaiton];
    
    //搜索管理器
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    //回到当前位置
    UIButton * presentLocateBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:presentLocateBtn];
    [presentLocateBtn setImage:[UIImage imageNamed:@"ico_cxdw"] forState:UIControlStateNormal];
    presentLocateBtn.titleLabel.font = Font(14);
    [presentLocateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-13);
        make.bottom.equalTo(searchView.mas_top).offset(-5);
    }];
    [presentLocateBtn addTarget:self action:@selector(selectPresentAction:) forControlEvents:UIControlEventTouchUpInside];
}
//创建定位
-(void) createLocationManager{
    //定位
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
    [self.locationManager setPausesLocationUpdatesAutomatically:YES];
    //返回逆地理编码信息
    [self.locationManager setLocatingWithReGeocode:YES];
    //开始持续定位
    [self.locationManager startUpdatingLocation];
}
-(MAPointAnnotation *)pointAnnotaiton{
    if (!_pointAnnotaiton) {
        _pointAnnotaiton  =[[MAPointAnnotation alloc]init];
    }
    return _pointAnnotaiton;
}
-(ShowLocatPromentView *)showLocatView{
    if (!_showLocatView) {
        _showLocatView  = [[ShowLocatPromentView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showLocatView;
}
//创建Navi
-(void) createNavi{
    self.customNavBar.title = @"地图选点";
    self.customNavBar.rightButton.hidden= YES;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        if (weakSelf.selectIndexPtah != nil) {
            NSDictionary *dict = weakSelf.dataArr[weakSelf.selectIndexPtah.row];
            if ([weakSelf.delegate respondsToSelector:@selector(selectAddressDict:)]) {
                [weakSelf.delegate selectAddressDict:dict];
            }
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(void)setRangeStr:(NSString *)rangeStr{
    _rangeStr = rangeStr;
}
@end
