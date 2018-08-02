//
//  AppDelegate.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/10.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <REFrostedViewController.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,REFrostedViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UITabBarController *rootTabbarCtrV;

@end

