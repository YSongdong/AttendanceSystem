//
//  SelectTimeTypeCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTimeTypeCell : UITableViewCell

//选择请假类型
@property (weak, nonatomic) IBOutlet UIView *selectLeaveTypeView;
//显示请假类型
@property (weak, nonatomic) IBOutlet UILabel *showLeaveTypeLab;
//选择开始时间
@property (weak, nonatomic) IBOutlet UIView *selectBeginTimeView;
//显示开始时间
@property (weak, nonatomic) IBOutlet UILabel *showBeginTimeLab;
//选择结束时间
@property (weak, nonatomic) IBOutlet UIView *selectEndTimeView;
//显示结束时间
@property (weak, nonatomic) IBOutlet UILabel *showEndTimeLab;
//显示时长
@property (weak, nonatomic) IBOutlet UILabel *showTimeLongLab;
//请假类型
@property (nonatomic,copy) void(^leaveTypeBlock)(void);
//开始时间
@property (nonatomic,copy) void(^beginTimeBlock)(void);
//结束时间
@property (nonatomic,copy) void(^endTimeBlock)(void);
//更新时间UI
-(void) updateTimeType:(NSString *)timeType andTimeStr:(NSString *)timeStr;
@end
