//
//  SDShowSystemPrompView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/16.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SDShowSystemPrompView.h"

@implementation SDShowSystemPrompView

+(void)showSystemPrompStr:(NSString *)str{
    //当前视图
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgView =[[UIView alloc] initWithFrame:CGRectMake(25, KScreenH-166, KScreenW-50, 65)];
    bgView.backgroundColor =[UIColor blackColor];
    bgView.alpha = 0.75;
    bgView.layer.cornerRadius = 4;
    bgView.layer.masksToBounds = YES;

    UILabel *lab = [[UILabel alloc]init];
    [bgView addSubview:lab];
    lab.text = str;
    lab.textColor = [UIColor whiteColor];
    lab.font = Font(16);
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.centerY.equalTo(bgView.mas_centerY);
    }];

    //将原始视图添加到背景视图中
    [window addSubview:bgView];
    
    // 自动延迟3秒执行
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //移除
        [bgView removeFromSuperview];
    });
}

@end
