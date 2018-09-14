//
//  GDLocationManager.m
//  LocationDemo
//
//  Created by 刘甲奇 on 2018/1/5.
//  Copyright © 2018年 刘甲奇. All rights reserved.
//

#import "GDLocationManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "ShowLocatPromentView.h"

@interface GDLocationManager()<AMapLocationManagerDelegate>
//提示权限view
@property (nonatomic,strong) ShowLocatPromentView *showLocatView;
/**
 * 高德定位管理者
 */
@property(nonatomic, strong) AMapLocationManager *GLocationManager;
/**
 * CLLocationManager
 */
@property(nonatomic, strong) CLLocationManager *locationManager;
/**
 经纬度
 */
@property (nonatomic, strong) CLLocation  *cllocation;
// 地址
@property (nonatomic,strong) AMapLocationReGeocode *reGeocode;
/**
 * 守护线程
 */
@property(nonatomic, strong) NSThread *daemonThread;
/**
 * 计时器
 */
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation GDLocationManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
       [AMapServices sharedServices].apiKey =@"c3045b1ac30bcfd4bc7ee178ce826e55";
    }
    return self;
}

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static GDLocationManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[GDLocationManager alloc]init];
    });
    return manager;
}

#pragma mark- Public
- (void)startUpdateLocation
{
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestAlwaysAuthorization];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.GLocationManager startUpdatingLocation];
    });
}

- (void)startReportLocation
{
    if (_daemonThread)
    {
        return;
    }
    [self.daemonThread start];
}

- (void)stopUpdateLocation
{
    [self.GLocationManager stopUpdatingLocation];
    [self.timer invalidate];
    self.timer = nil;
    self.daemonThread = nil;
}

- (void)run
{
    @autoreleasepool
    {
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(reportLocation) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}
- (void)reportLocation
{
   // NSLog(@"%s---%d---",__func__,__LINE__);
    if (self.locationBlock)
    {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"location"]= self.cllocation;
        param[@"reGeocode"] =self.reGeocode;
        self.locationBlock(param.copy);
    }
}
#pragma mark- AMapLocationDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    _cllocation = location;
    _reGeocode = reGeocode;
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
                [[UIApplication sharedApplication].keyWindow addSubview:self.showLocatView];
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
#pragma mark- getter
- (AMapLocationManager *)GLocationManager
{
    if (_GLocationManager == nil)
    {
        _GLocationManager = [[AMapLocationManager alloc] init];
        _GLocationManager.distanceFilter = kCLDistanceFilterNone;
        _GLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _GLocationManager.pausesLocationUpdatesAutomatically = NO;
        _GLocationManager.locatingWithReGeocode = YES;
       // _GLocationManager.allowsBackgroundLocationUpdates = YES;
        _GLocationManager.delegate = self;
        [_GLocationManager startUpdatingLocation];
    }
    return _GLocationManager;
}

- (NSThread *)daemonThread
{
    if (_daemonThread == nil)
    {
        _daemonThread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    }
    return _daemonThread;
}

-(ShowLocatPromentView *)showLocatView{
    if (!_showLocatView) {
        _showLocatView  = [[ShowLocatPromentView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showLocatView;
}

@end



