//
//  AppDelegate.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/10.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AppDelegate.h"

#import <REFrostedViewController.h>
#import "FVAppSdk.h"
#import "WRNavigationBar.h"

#import "SDLoginController.h"
#import "LeftUserController.h"
#import "SDRootNavigationController.h"
#import "HomeViewController.h"
#import "SDPhotoCollectController.h"

#import "RecordApproveDetaController.h"

#import "MessageCentreController.h"
#import "RecordApproveDetaController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()<REFrostedViewControllerDelegate,JPUSHRegisterDelegate,AVAudioPlayerDelegate>
// 播放器palyer
@property(nonatomic,strong)AVAudioPlayer *avAudioPlayer ;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //默认开启提示语音
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.cqlanhui.AttendanceSystem"];
    if (![sharedDefaults boolForKey:@"SpeechRemdin"]) {
        [sharedDefaults setBool:YES forKey:@"SpeechRemdin"];
        [sharedDefaults synchronize];
    }
    
    //地图sdk
    [AMapServices sharedServices].apiKey = @"c3045b1ac30bcfd4bc7ee178ce826e55";
    //定位
    [[GDLocationManager shareManager] startUpdateLocation];
    [[GDLocationManager shareManager] startReportLocation];
   
    //人脸识别
    [[FVAppSdk sharedManager] initWithAppID:@"43645806" appKey:@"d39eba36386e3034ae4cc68d0fae3c303459e85b"];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self startRootView];
    //极光推送
    [self registerJPUHSerVice:launchOptions];
    
    //开启崩溃收集
    [JPUSHService crashLogON];
    //自定义消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //当程序未启动时， 接受到通知方法
    if (launchOptions) {
        NSDictionary *dicUserInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //判断是否开启提示语音
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.cqlanhui.AttendanceSystem"];
        if ([sharedDefaults boolForKey:@"SpeechRemdin"]) {
            //语音播报
            [self playLocalMusic:dicUserInfo];
        }
    }
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    //更新考勤组
    NSDictionary *userInfoDict = notification.userInfo;
    NSDictionary *extrasDict = userInfoDict[@"extras"];
    NSString *allTypeStr = [NSString stringWithFormat:@"%@",extrasDict[@"allType"]];
    if ([allTypeStr isEqualToString:@"4"]) {
        //更新考勤组
        NSString *agIdStr = extrasDict[@"agId"];
        [SDUserInfo alterProGroupId:agIdStr];
        
    }else   if ([allTypeStr isEqualToString:@"1"]) {
        //插入消息
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        mutableDict[@"allType"] =  extrasDict[@"allType"];
        mutableDict[@"approvalId"] = extrasDict[@"approvalId"];
        mutableDict[@"approvalId"] = extrasDict[@"approvalId"];
        mutableDict[@"title"] = extrasDict[@"msg"];
        mutableDict[@"msgId"] = extrasDict[@"msgId"];
        mutableDict[@"recordId"] = extrasDict[@"recordId"];
        mutableDict[@"type"] = extrasDict[@"type"];
        mutableDict[@"userName"] = extrasDict[@"userName"];
        [self requestMsg:mutableDict.copy];
    }
}
-(void) startRootView{
    if ([SDUserInfo passLoginData]) {
        SDRootNavigationController *leftVC = [[SDRootNavigationController alloc]initWithRootViewController:[LeftUserController new]];
        SDRootNavigationController *rootVC = [[SDRootNavigationController alloc]initWithRootViewController:[HomeViewController new]];
        UITabBarController *tarBarCtr=[[UITabBarController alloc]init];
        [tarBarCtr setViewControllers:[NSArray arrayWithObjects:rootVC, nil]];
        self.rootTabbarCtrV = tarBarCtr;
        //侧边栏
        REFrostedViewController *rostedViewController = [[REFrostedViewController alloc] initWithContentViewController:tarBarCtr menuViewController:leftVC];
        rostedViewController.direction = REFrostedViewControllerDirectionLeft;
        rostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;
        rostedViewController.liveBlur = YES;
        rostedViewController.limitMenuViewSize = YES;
        rostedViewController.backgroundFadeAmount=0.5;
        rostedViewController.delegate = self;
        rostedViewController.menuViewSize=CGSizeMake(leftSideMeunWidth, ScreenHeight);
        
        self.window.rootViewController=rostedViewController;
    }else{
         SDRootNavigationController *loginVC = [[SDRootNavigationController alloc]initWithRootViewController:[SDLoginController new]];
        self.window.rootViewController=loginVC;
    }
}
-(void)registerJPUHSerVice:(NSDictionary *)launchOptions {
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"7c73b76abb1ef04b7d11942a"
                          channel:@"Publish channel"
                 apsForProduction:1
            advertisingIdentifier:nil];
}
#pragma mark- JPUSHRegisterDelegate
// 注册
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}
//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
// iOS7及以上系统
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
   //application.applicationState > 0
//    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0) {
//
//        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
//            //在通知栏发送本地通知
//            //[AppDelegate registerLocalNotificationInOldWay:userInfo];
//
//        }
        //判断是否开启提示语音
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.cqlanhui.AttendanceSystem"];
        if ([sharedDefaults boolForKey:@"SpeechRemdin"]) {
            //语音播报
            [self playLocalMusic:userInfo];
        }
//    }
    completionHandler(UIBackgroundFetchResultNewData);
}
//  iOS 10之前前台没有通知栏
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
   
//    if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 && [UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //判断是否开启提示语音
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.cqlanhui.AttendanceSystem"];
        if ([sharedDefaults boolForKey:@"SpeechRemdin"]) {
            //语音播报
            [self playLocalMusic:userInfo];
        }
//    }
}
// iOS 10 前台得到的的通知对象
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
   
    //清除角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
        //判断是否开启提示语音
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.cqlanhui.AttendanceSystem"];
        if ([sharedDefaults boolForKey:@"SpeechRemdin"]) {
            //语音播报
            [self playLocalMusic:userInfo];
        }
        
        NSString *allTypeStr = [NSString stringWithFormat:@"%@",userInfo[@"allType"]];
        if([allTypeStr isEqualToString:@"1"]){
            NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
            mutableDict[@"allType"] =  userInfo[@"allType"];
            mutableDict[@"approvalId"] = userInfo[@"approvalId"];
            mutableDict[@"approvalId"] = userInfo[@"approvalId"];
            mutableDict[@"title"] = userInfo[@"msg"];
            mutableDict[@"msgId"] = userInfo[@"msgId"];
            mutableDict[@"recordId"] = userInfo[@"recordId"];
            mutableDict[@"type"] = userInfo[@"type"];
            mutableDict[@"userName"] = userInfo[@"userName"];
            
            [self requestMsg:mutableDict.copy];
        }
    }else{
        //应用处于前台的本地接受通知
        
    }
    
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
      // completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 后台得到的的通知对象(当用户点击通知栏的时候)
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^__strong)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    //清除角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        //处理通知
        [self handleNotification:userInfo];

        [JPUSHService handleRemoteNotification:userInfo];
    }else{
        
        
    }
    completionHandler();  // 系统要求执行这个方法
}
//添加推送消息
-(void) requestMsg:(NSDictionary *)dict{
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTPUSHMESSAGEGROUP_URL params:dict withModel:nil waitView:nil complateHandle:^(id showdata, NSString *error) {
        
    }];
}
#pragma mark --------本地通知-----------
+ (void)registerLocalNotificationInOldWay:(NSDictionary *)userInfo {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
//    // 设置重复的间隔
//    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody =userInfo[@"aps"][@"alert"];
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    notification.userInfo = userInfo;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    }
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
//点击横幅会接收
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    //处理通知
    [self handleNotification:userInfo];
}
// IOS9.0 前台通知view

#pragma mark ----播放本地音频--------
-(void) playLocalMusic:(NSDictionary *)dict{
    // 2.播放本地音频文件
    NSString *patyName ;
    NSString *allTypeStr = [NSString stringWithFormat:@"%@",dict[@"allType"]];
    if ([allTypeStr isEqualToString:@"1"]) {
        //1：考勤打卡
        NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"type"]];
        patyName = [typeStr isEqualToString:@"1"] ? @"music_goToWork" : @"music_getOffWork";
    }else if ([allTypeStr isEqualToString:@"2"]){
        // 2：照片审核
        NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"type"]];
        patyName = [typeStr isEqualToString:@"1"] ? @"music_succeePhoto" : @"music_unPhoto";
    }else if ([allTypeStr isEqualToString:@"3"]){
        //3申请提交
        NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"type"]];
        if ([typeStr integerValue] > 0 && [typeStr integerValue] < 5 ) {
            patyName = @"music_newApplyOf";
        }
        if ([typeStr integerValue] > 8 && [typeStr integerValue] < 13 ) {
            patyName = @"music_yourSuccessApply";
        }
    }
    if (patyName == nil) {
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:patyName ofType:@"mp3"];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    
    AudioServicesPlaySystemSound(soundID);
    // 震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//接受和处理通知
-(void) handleNotification:(NSDictionary*)userInfo{
    NSString *allTypeStr = [NSString stringWithFormat:@"%@",userInfo[@"allType"]];
    if([allTypeStr isEqualToString:@"1"]){
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        mutableDict[@"allType"] =  userInfo[@"allType"];
        mutableDict[@"approvalId"] = userInfo[@"approvalId"];
        mutableDict[@"approvalId"] = userInfo[@"approvalId"];
        mutableDict[@"title"] = userInfo[@"msg"];
        mutableDict[@"msgId"] = userInfo[@"msgId"];
        mutableDict[@"recordId"] = userInfo[@"recordId"];
        mutableDict[@"type"] = userInfo[@"type"];
        mutableDict[@"userName"] = userInfo[@"userName"];
        mutableDict[@"userId"] = [SDUserInfo obtainWithUserId];
        [self requestMsg:mutableDict.copy];
        
        MessageCentreController *msgVC = [[MessageCentreController alloc]init];
        msgVC.isAppDelegate = YES;
        SDRootNavigationController *msgtNavi = [[SDRootNavigationController alloc]initWithRootViewController:msgVC];
        self.window.rootViewController = msgtNavi;
        
    }else{
        MessageCentreController *msgVC = [[MessageCentreController alloc]init];
        msgVC.isAppDelegate = YES;
        SDRootNavigationController *msgtNavi = [[SDRootNavigationController alloc]initWithRootViewController:msgVC];
        self.window.rootViewController = msgtNavi;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
  
}
// 后台，
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    //清除角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    //清除角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
  
}


- (void)applicationWillTerminate:(UIApplication *)application {
  
}


@end
