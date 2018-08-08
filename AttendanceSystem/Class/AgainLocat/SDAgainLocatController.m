//
//  SDAgainLocatController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/19.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SDAgainLocatController.h"

#import "LocatToolView.h"
#import "ShowAtttendScopeView.h"
#import "CustomAnnotationView.h"
#import "SDIdentityTestView.h"
#import "ShowTureSignInView.h"
#import "ShowLocatErrorView.h"

#import "FVAppSdk.h"


#import "ShowUnkownPhotoPromtView.h"
#import "SDPhotoCollectController.h"

#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3
@interface SDAgainLocatController ()
<
MAMapViewDelegate,
AMapLocationManagerDelegate,
AMapGeoFenceManagerDelegate,
AMapSearchDelegate,
FVAppSdkControllerDelegate,
UIGestureRecognizerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
//toolview
@property (nonatomic,strong) LocatToolView *toolView;
//打卡确认view
@property (nonatomic,strong)ShowTureSignInView *showTureSingInView;
//定位失败view
@property (nonatomic,strong)ShowLocatErrorView *showLocatErrorView;
//验证view
@property (nonatomic,strong) SDIdentityTestView *testView;
//打卡范围view
@property (nonatomic,strong) ShowAtttendScopeView *showScopeView;
//地图管理器
@property (nonatomic,strong)MAMapView *mapView;
//定位管理器
@property (nonatomic,strong)AMapLocationManager *locationManager;
//围栏管理器
@property (nonatomic,strong)AMapGeoFenceManager *geoFenceManager;
//自定义标注点view
@property (nonatomic,strong) CustomAnnotationView *annotationView;
//没有留底照片
@property (nonatomic,strong) ShowUnkownPhotoPromtView *showPhotoView;
//回到当前位置
@property (nonatomic,strong) UIButton *presentLocateBtn;
//存储位置信息
@property (nonatomic,strong) AMapLocationReGeocode *reGeocode;

@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

//图片
@property (nonatomic,strong) UIImage *faceImage;
//
@property (nonatomic,strong) NSMutableArray *scopeDataArr;
//当前位置的index
@property (nonatomic,assign) NSInteger nowLocatIndex;
//获得自己的位置，方便demo添加围栏进行测试，
@property (nonatomic, strong) CLLocation *userLocation;
//---------------打卡请求数据---------//
@property (nonatomic,strong) NSMutableDictionary *cardDataDict;
//确认信息重新验证人脸
@property (nonatomic,assign) BOOL isTureAgainFace;

@end

@implementation SDAgainLocatController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createLocatView];
}
-(void)createLocatView{
    __weak typeof(self) weakSelf = self;
    //添加toolview
    [self.view addSubview:self.toolView];
    self.toolView.dict = self.dict;
    //打卡范围
    self.toolView.selectLocatBlock = ^{
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showScopeView];
        weakSelf.showScopeView.coordinateArr = weakSelf.dict[@"coordinate"];
        weakSelf.showScopeView.coordinateDict = weakSelf.dict;
        weakSelf.showScopeView.userLocation = weakSelf.userLocation;
    };
    //打卡
    self.toolView.cardBtnBlock = ^{
        //判断是否开启人脸识别
        if ([weakSelf.dict[@"faceStatus"] isEqualToString:@"1"]) {
            //判断是否有留底
            if ([[SDUserInfo obtainWithPotoStatus] isEqualToString:@"4"]) {
                [weakSelf.view addSubview:weakSelf.showPhotoView];
                [weakSelf.showPhotoView.selectBtn addTarget:weakSelf action:@selector(selectUPdataPhoto:) forControlEvents:UIControlEventTouchUpInside];
                return ;
            }
        }
        weakSelf.cardDataDict = [NSMutableDictionary dictionary];
        weakSelf.cardDataDict[@"agId"] =[SDUserInfo obtainWithProGroupId];
        weakSelf.cardDataDict[@"agName"] =[SDUserInfo obtainWithProGroupName];
        weakSelf.cardDataDict[@"plaformId"] =[SDUserInfo obtainWithPlafrmId];
        weakSelf.cardDataDict[@"unitId"] =[SDUserInfo obtainWithUniId];
        weakSelf.cardDataDict[@"userId"] =[SDUserInfo obtainWithUserId];
        weakSelf.cardDataDict[@"clockinNum"] =weakSelf.dict[@"clockinNum"];
        weakSelf.cardDataDict[@"clockinType"] =weakSelf.dict[@"clockinType"];
        weakSelf.cardDataDict[@"isRest"] =weakSelf.dict[@"isRest"];
        weakSelf.cardDataDict[@"remark"] =@"";
        weakSelf.cardDataDict[@"sureTime"] =weakSelf.dict[@"sureTime"];
        weakSelf.cardDataDict[@"token"] =[SDTool getNewToken];
        weakSelf.cardDataDict[@"coordinateSure"] = [SDTool convertToJsonData:weakSelf.dict[@"coordinate"]];
        //找到当前位置的
        NSDictionary *nowDict =  weakSelf.scopeDataArr[weakSelf.nowLocatIndex];
        NSString *abnormalCoordinateIsStr = nowDict[@"isScope"];
        //判断是否开启人脸
        if ([weakSelf.dict[@"faceStatus"] isEqualToString:@"1"]) {
            //开启
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.testView];
            [weakSelf.testView.beginTestBtn addTarget:weakSelf action:@selector(selectFaceAction:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            if (![weakSelf.dict[@"abnormalCoordinateIs"] isEqualToString:@"1"] ||[abnormalCoordinateIsStr isEqualToString:@"2"] ) {
                weakSelf.cardDataDict[@"abnormalIdentityIs"] =[NSNumber numberWithInteger:3];
                [weakSelf showTureSingView:nil];
                return ;
            }
            //请求数据
            [weakSelf requsetAttendSignIn];
        }
    };
    
    //mapview
    ///初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-CGRectGetHeight(self.toolView.frame))];
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.distanceFilter = 10.f;
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    ///把地图添加至view
    [self.view addSubview:self.mapView];
   
   //回到当前位置
    self.presentLocateBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.presentLocateBtn];
    self.presentLocateBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [self.presentLocateBtn setTitle:@"重新定位" forState:UIControlStateNormal];
    [self.presentLocateBtn setTitleColor:[UIColor colorTextBg28BlackColor] forState:UIControlStateNormal];
    [self.presentLocateBtn setImage:[UIImage imageNamed:@"dqdw_ico_cxdw"] forState:UIControlStateNormal];
    self.presentLocateBtn.titleLabel.font = Font(14);
    [self.presentLocateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(12);
        make.width.equalTo(@93);
        make.height.equalTo(@30);
        make.bottom.equalTo(weakSelf.toolView.mas_top).offset(-10);
    }];
    self.presentLocateBtn.layer.cornerRadius =4;
    self.presentLocateBtn.layer.masksToBounds = YES;
    [self.presentLocateBtn addTarget:self action:@selector(selectPresentAction:) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark ---- 定位----
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    //置定位最小更新距离
    self.locationManager.distanceFilter= 10.f;
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//    //设置允许在后台定位
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    //返回逆地理编码信息
    [self.locationManager setLocatingWithReGeocode:YES];
    //开始持续定位
    [self.locationManager startUpdatingLocation];
#pragma mark ----设置围栏----
    self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
    self.geoFenceManager.delegate = self;
    self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //设置希望侦测的围栏触发行为，默认是侦测用户进入围栏的行为，即AMapGeoFenceActiveActionInside，这边设置为进入，离开，停留（在围栏内10分钟以上），都触发回调
   // self.geoFenceManager.allowsBackgroundLocationUpdates = YES;  //允许后台定位
#pragma mark ------ 显示围栏--------
    //移除围栏
    [self removAllGeoFence];
    
    NSArray *coordinateArr = self.dict[@"coordinate"];
    for (int i=0; i<coordinateArr.count; i++) {
        NSDictionary *coorDict = coordinateArr[i];
        NSDictionary *coordinateDict = coorDict[@"coordinate"];
        double lat = [coordinateDict[@"lat"] floatValue];
        CLLocationCoordinate2D  coordinate = CLLocationCoordinate2DMake(lat,
        [coordinateDict[@"lng"]doubleValue ]);
        
        [self.geoFenceManager addCircleRegionForMonitoringWithCenter:coordinate radius:[coorDict[@"deviation"] doubleValue] customID:[NSString stringWithFormat:@"circle_%d",i+1]];
        //显示围栏
        MACircle *circle = [MACircle circleWithCenterCoordinate:coordinate radius:[coorDict[@"deviation"] doubleValue]];
        _mapView.delegate = self;
        //在地图上添加圆
        [_mapView addOverlay: circle];
    }

}
#pragma mark - MAMapViewDelegate
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
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        self.annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (_annotationView == nil)
        {
            self.annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        self.annotationView.image = [UIImage imageNamed:@"ico_dw"];
        
        // 设置为NO，用以调用自定义的calloutView
        self.annotationView.canShowCallout = NO;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        self.annotationView.centerOffset = CGPointMake(0, -18);
        return self.annotationView;
    }
    return nil;
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
}
#pragma mark ---定位Delegte----
//返回地理位置
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    if (reGeocode)
    {
        self.reGeocode = reGeocode;
        //更新tooview
        [self.toolView updateAddress:reGeocode.formattedAddress];
        
    }
    self.userLocation = location;
    
    [self.mapView setCenterCoordinate:location.coordinate];
    
    [self.mapView setZoomLevel:16.1 animated:NO];
    
    //移除所以数据
    [self.scopeDataArr removeAllObjects];
    //测量距离
    //获取系统返回的经纬度
    [self getLocat:location];
}
//定位失败时
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [self.view addSubview:self.showLocatErrorView];
}
//输入位置 返回一个位置信息
-(void) getLocat:(CLLocation *)location{

    NSArray *arr = [SDTool getData:self.dict Locat:location];
    self.scopeDataArr = [NSMutableArray arrayWithArray:arr];
    //取出半径
    NSMutableArray *minArr = [NSMutableArray array];
    BOOL isScope = NO;
    for (NSDictionary *dict in arr) {
        NSString *isScopeStr = dict[@"isScope"];
        if ([isScopeStr isEqualToString:@"1"]) {
            isScope = YES;
            self.nowLocatIndex = [dict[@"index"]integerValue];
        }
        NSString *minStr = dict[@"distance"];
        [minArr addObject:minStr];
    }
    
    if (isScope) {
      //  [SDShowSystemPrompView showSystemPrompStr:@"在范围内"];
        [self.toolView updateAddressStatu:@"1" address:self.reGeocode.formattedAddress];
    }else{
        //计算最近离打卡距离
        CGFloat min =[[minArr valueForKeyPath:@"@min.floatValue"] floatValue];
       // [SDShowSystemPrompView showSystemPrompStr:@"在范围外"];
        self.toolView.minDistance = min;
        [self.toolView updateAddressStatu:@"2" address:self.reGeocode.formattedAddress];
        //地图上标注点view
        self.annotationView.calloutView.concetLab.text = @"未进入考勤范围";
    }
}
#pragma mark ---添加围栏----
//清除所有围栏
-(void) removAllGeoFence{
    [self.mapView removeOverlays:self.mapView.overlays];  //把之前添加的Overlay都移除掉
    [self.geoFenceManager removeAllGeoFenceRegions];  //移除所有已经添加的围栏，如果有正在请求的围栏也会丢弃
}
//围栏是否成功
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"创建失败 %@",error);
    } else {
        NSLog(@"创建成功");
    }
}
#pragma mark ----按钮点击事件------
-(void)selectFaceAction:(UIButton *) sender{
    //移除人脸提示view
    [self.testView removeFromSuperview];
    
    if ([self.faceTypeStr isEqualToString:@"2"]) {
        //隐藏textview
        [self.testView removeFromSuperview];
        //获取照片
        [[FVAppSdk sharedManager]gatherWithParentController:self];
    }else{
        //眨眼
        [[FVAppSdk sharedManager]livingWithParentController:self mode:FVAppLivingFastMode level:FVAppLivingSafeMiddleMode];
    }
}
#pragma mark -----人脸-----
/*
 * 活体结束时的委托方法：返回结果及正脸照。
 */
-(void)FVLivingDetect:(FVAppSdk *)detector didFinishLiving:(FVAppLivingResult)result FrontalFace:(UIImage*)image{
    if (image) {
        [self dismissViewControllerAnimated:YES completion:nil];
        //显示验证view
        self.faceImage = image;
        [self  requestFacePhotoLoad];
    }
}
/*
 * 活体取消时的委托方法。
 */
-(void)FVLivingDetectDidCancel:(FVAppSdk*)detector{
    //确认信息重新验证
    if (self.isTureAgainFace) {
        self.showTureSingInView.hidden= NO;
    }
}
/*
 * 采集结束时的委托方法：返回结果照片。
 */
-(void)FVFaceGatherView:(FVAppSdk *)gather didGatherImage:(UIImage*)image{
    if (image) {
        [self dismissViewControllerAnimated:YES completion:nil];
        self.faceImage = image;
        [self  requestFacePhotoLoad];
    }
}
/*
 * 采集取消时的委托方法。
 */
-(void)FVFaceGatherViewDidCancel:(FVAppSdk*)gather{
    //确认信息重新验证
    if (self.isTureAgainFace) {
        self.showTureSingInView.hidden= NO;
    }
}
//打卡确认信息
-(void)showTureSingView:(NSString*)faceStatusStr{
    __weak typeof(self) weakSelf = self;
    weakSelf.showTureSingInView = [[ShowTureSignInView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showTureSingInView];
    if (self.reGeocode != nil) {
        weakSelf.showTureSingInView.addressStr = self.reGeocode.formattedAddress;
    }
    weakSelf.showTureSingInView.faceStatusStr = faceStatusStr;
    weakSelf.showTureSingInView.selectPhotoBlock = ^{
        //隐藏
        weakSelf.showTureSingInView.hidden = YES;
        
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = weakSelf;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设定图像缩放比例
        picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, 1.0, 1.0);
        
        //打开摄像画面作为背景
        [weakSelf presentViewController:picker animated:YES completion:nil];
    };
    
    //确认打卡
    weakSelf.showTureSingInView.trueInfoBlock = ^(NSDictionary *dict) {
        weakSelf.cardDataDict[@"abnormalIdentityIs"] =dict[@"abnormalIdentityIs"];
        weakSelf.cardDataDict[@"remark"] =dict[@"remark"];
        //请求数据
        [weakSelf requsetAttendSignIn];
    };
    
    //重新验证人脸
    weakSelf.showTureSingInView.againFaceBlock = ^{
        //重新验证
        weakSelf.isTureAgainFace = YES;
        //隐藏
        weakSelf.showTureSingInView.hidden = YES;
        
        [weakSelf selectFaceAction:nil];
    };
}
-(void)selectUPdataPhoto:(UIButton *)sender{
    //用户头像
    SDPhotoCollectController *photoVC = [[SDPhotoCollectController alloc]init];
    photoVC.chenkStatu = [SDUserInfo obtainWithPotoStatus];
    photoVC.isMine = YES;
    [self.navigationController pushViewController:photoVC animated:YES];
}
#pragma mark -----拍照照片处理----
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //显示
    _showTureSingInView.hidden = NO;
    [self.showTureSingInView.imageArr insertObject:image atIndex:0];
    //更新UI
    [self.showTureSingInView updateUI];
    return;
}
//相机或相册的取消代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //显示确认信息view
    self.showTureSingInView.hidden = NO;
}
#pragma mark --- 按钮点击事件-----
-(void)selectPresentAction:(UIButton *) sender{
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    }
}
#pragma mark ----创建Navi-----
-(void) createNavi{
    self.customNavBar.title = @"当前定位";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark ----懒加载------
-(NSMutableArray *)scopeDataArr{
    if (!_scopeDataArr) {
        _scopeDataArr  =[NSMutableArray array];
    }
    return _scopeDataArr;
}
-(void)setFaceTypeStr:(NSString *)faceTypeStr {
    _faceTypeStr = faceTypeStr;
}
-(LocatToolView *)toolView{
    if (!_toolView) {
        _toolView = [[LocatToolView alloc]initWithFrame:CGRectMake(0, KScreenH-162, KScreenW, 162)];
    }
    return _toolView;
}
-(ShowLocatErrorView *)showLocatErrorView{
    if (!_showLocatErrorView) {
        _showLocatErrorView = [[ShowLocatErrorView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showLocatErrorView;
}
-(ShowAtttendScopeView *)showScopeView{
    if (!_showScopeView) {
        _showScopeView = [[ShowAtttendScopeView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showScopeView;
}
-(ShowUnkownPhotoPromtView *)showPhotoView{
    if (!_showPhotoView) {
        _showPhotoView = [[ShowUnkownPhotoPromtView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showPhotoView;
}
-(SDIdentityTestView *)testView{
    if (!_testView) {
        _testView = [[SDIdentityTestView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _testView;
}
-(void)dealloc{
    [self.toolView.timer invalidate];
    self.toolView.timer = nil;
}
#pragma mark ------数据相关----
//图片对比接口
-(void)requestFacePhotoLoad{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    param[@"userName"] = [SDUserInfo obtainWithidcard];
    param[@"userIdcard"] = [SDUserInfo obtainWithUserName];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"truename"] =[SDUserInfo obtainWithRealName];
    param[@"token"] =[SDTool getNewToken];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"photoStatus"] = [SDUserInfo obtainWithPotoStatus];
    param[@"photo"] = [SDUserInfo obtainWithPhoto];
    param[@"agName"] = [SDUserInfo obtainWithPositionName];
    param[@"agId"] = [SDUserInfo obtainWithProGroupId];
    NSMutableArray *dataArr= [NSMutableArray array];
    //图片旋转90度
    [dataArr addObject:[self.faceImage fixOrientation]];
   
    [[KRMainNetTool sharedKRMainNetTool] upLoadData:HTTP_APPATTENDFACERECOGNITION_URL params:param.copy andData:dataArr waitView:self.view complateHandle:^(id showdata, NSString *error) {
       
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            NSString *succStr = [NSString stringWithFormat:@"%@",showdata[@"succ"]];
            // 1人脸验证通过 0未通过
            if ([succStr isEqualToString:@"1"]) {
                //确认信息重新验证
                if (self.isTureAgainFace) {
                    self.showTureSingInView.againFaceStr = succStr;
                }else{
                    self.cardDataDict[@"abnormalIdentityIs"] = [NSNumber numberWithInteger:1];
                    self.cardDataDict[@"vioLationId"] = showdata[@"id"];
                    //请求数据
                    [self requsetAttendSignIn];
                }
            }else{
                //确认信息重新验证
                if (!self.isTureAgainFace) {
                    self.cardDataDict[@"abnormalIdentityIs"] = [NSNumber numberWithInteger:1];
                    self.cardDataDict[@"vioLationId"] = showdata[@"id"];
                    [self showTureSingView:@"2"];
                }else{
                    self.showTureSingInView.faceStatusStr = @"2";
                }
            }
        }
    }];
}
//打卡
-(void) requsetAttendSignIn{
    //照片数据源
    NSMutableArray *imageArr = self.showTureSingInView.imageArr;
    //移除最后一个
    [imageArr removeLastObject];
    //找到当前位置的
    NSDictionary *nowDict =  self.scopeDataArr[self.nowLocatIndex];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *coordinateDict = [NSMutableDictionary dictionary];
    coordinateDict[@"lat"] =[NSString stringWithFormat:@"%f",self.userLocation.coordinate.latitude];
    coordinateDict[@"lng"] =[NSString stringWithFormat:@"%f",self.userLocation.coordinate.longitude];
    mutableDict[@"Childcoordinate"] =coordinateDict;
    mutableDict[@"deviation"] = nowDict[@"coordinate"][@"deviation"];
    mutableDict[@"title"] = self.reGeocode.formattedAddress;
    self.cardDataDict[@"coordinate"] = [SDTool convertToJsonData:mutableDict];
    if ([nowDict[@"isScope"] isEqualToString:@"1"]) {
         self.cardDataDict[@"abnormalCoordinateIs"] = [NSNumber numberWithInteger:1];
    }else{
        self.cardDataDict[@"abnormalCoordinateIs"] = [NSNumber numberWithInteger:2];
    }
    self.cardDataDict[@"isGo"] =nowDict[@"isGo"];
    
    [[KRMainNetTool sharedKRMainNetTool]upLoadData:HTTP_APPATTENDANCEAPPDOSIGNIN_URL params:self.cardDataDict andData:imageArr.copy waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        [SDShowSystemPrompView showSystemPrompStr:@"打卡成功"];
        [self.showTureSingInView removeFromSuperview];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
 
}

@end
