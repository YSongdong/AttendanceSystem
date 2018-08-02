//
//  LocatToolView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/19.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocatToolView : UIView

@property (nonatomic,weak) NSTimer *timer;
//点击打卡范围
@property (nonatomic,copy) void(^selectLocatBlock)(void);
//打卡
@property (nonatomic,copy) void(^cardBtnBlock)(void);
//异常时，最小打卡距离
@property (nonatomic,assign) CGFloat minDistance;

//数据源
@property (nonatomic,strong) NSDictionary *dict;

//更新位置信息
-(void)updateAddress:(NSString *) address;

// 更新显示状态 1/正常 2异常
-(void) updateAddressStatu:(NSString *) statu address:(NSString *)address;



@end
