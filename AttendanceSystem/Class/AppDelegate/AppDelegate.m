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

#import "MessageCentreController.h"
#import "RecordApproveDetaController.h"
@interface AppDelegate ()<REFrostedViewControllerDelegate,JPUSHRegisterDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    //地图sdk
    [AMapServices sharedServices].apiKey = @"f28046f76f4bace772fb4daa312b1bf7";
    //人脸识别
    [[FVAppSdk sharedManager] initWithAppID:@"43645806" appKey:@"d39eba36386e3034ae4cc68d0fae3c303459e85b"];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self startRootView];
    [self.window makeKeyAndVisible];
  
    //极光推送
    [self registerJPUHSerVice:launchOptions];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    return YES;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSDictionary *extrasDict = userInfo[@"extras"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChenkMessage" object:nil userInfo:extrasDict];
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
    [JPUSHService setupWithOption:launchOptions appKey:@"c9a63a1d618e84efc78a6e5f"
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
  
    
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
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^__strong)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"-----%@----",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
  
}


- (void)applicationWillTerminate:(UIApplication *)application {
  
}


@end
