//
//  AttendCardTableViewCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/18.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendCardTableViewCell : UITableViewCell

@property (nonatomic,weak) NSTimer *timer;

@property (nonatomic,strong) NSDictionary *dict;

@property (nonatomic,strong) NSDictionary *dataDict;



//判断是否回到前台
-(void)getWillEnter;

//更新地点 和显示状态
-(void)updateAddress:(NSString *)addressStr location:(CLLocation *)location;

//点击打卡
@property (nonatomic,copy) void(^selectCardBlcok)(NSDictionary *addressDict);
//重新定位按钮
@property (nonatomic,copy) void(^againLocationBlcok)(NSDictionary *dict);
//更新地址
@property (nonatomic,copy) void(^addressBlock)(NSString *addreeStr);



@end
