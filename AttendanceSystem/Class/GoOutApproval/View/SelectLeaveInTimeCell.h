//
//  SelectLeaveInTimeCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectLeaveInTimeCell : UITableViewCell
//开始选择时间
@property (weak, nonatomic) IBOutlet UIView *selectBeginTimeView;
//选择结束时间view
@property (weak, nonatomic) IBOutlet UIView *SelectEndTimeView;
//显示选择开始时间
@property (weak, nonatomic) IBOutlet UILabel *showSelectBeginTimeLab;
//显示选择结束时间
@property (weak, nonatomic) IBOutlet UILabel *showSelectEndTimeLab;
//显示选择时长
@property (weak, nonatomic) IBOutlet UILabel *showTimeLongLab;
//开始时间
@property (nonatomic,copy) void(^beginTimeBlock)(void);
//结束时间
@property (nonatomic,copy) void(^endTimeBlock)(void);
//更新时间UI
-(void) updateTimeType:(NSString *)timeType andTimeStr:(NSString *)timeStr;

@end
