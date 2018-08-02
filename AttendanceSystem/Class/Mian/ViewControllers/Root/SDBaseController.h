//
//  SDBaseController.h
//  AttendanceManager
//
//  Created by tiao on 2018/7/10.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRCustomNavigationBar.h"
@interface SDBaseController : UIViewController

@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;

- (void)customNaviItemTitle:(NSString *)title titleColor:(UIColor *)color;


- (void)customTabBarButtonimage:(NSString *)imageName target:(id)target action:(SEL)selector isLeft:(BOOL)isLeft;


@end
