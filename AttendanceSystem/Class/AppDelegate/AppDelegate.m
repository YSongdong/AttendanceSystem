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


@interface AppDelegate ()<REFrostedViewControllerDelegate>

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
    
    return YES;
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
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
