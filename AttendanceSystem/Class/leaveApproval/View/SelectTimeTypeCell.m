//
//  SelectTimeTypeCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SelectTimeTypeCell.h"

@implementation SelectTimeTypeCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    //选择请假类型
    UITapGestureRecognizer *leaveTypeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectLeaveTypeTap)];
    [self.selectLeaveTypeView addGestureRecognizer:leaveTypeTap];
    
    //选择开始时间view
    UITapGestureRecognizer *selectBeginTimeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBeginTimeTap)];
    [self.selectBeginTimeView addGestureRecognizer:selectBeginTimeTap];
    
    //选择结束时间view
    UITapGestureRecognizer *selectEndTimeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectEndTimeTap)];
    [self.selectEndTimeView addGestureRecognizer:selectEndTimeTap];
    
}

//选择请假类型
-(void)selectLeaveTypeTap{
    self.leaveTypeBlock();
}

//选择开始时间
-(void)selectBeginTimeTap{
    self.beginTimeBlock();
}
//选择结束时间
-(void)selectEndTimeTap{
    self.endTimeBlock();
}

-(void)updateTimeType:(NSString *)timeType andTimeStr:(NSString *)timeStr{
    if ([timeType isEqualToString:@"1"]) {
        //开始时间
        self.showBeginTimeLab.text = timeStr;
    }else{
        //结束时间
        self.showEndTimeLab.text = timeStr;
    }
    if ([self.showBeginTimeLab.text isEqualToString:@"请选择"]) {
        return;
    }
    if ([self.showEndTimeLab.text isEqualToString:@"请选择"]) {
        return;
    }
    if (self.showBeginTimeLab.text.length != 0 && self.showEndTimeLab.text.length != 0) {
        NSInteger timeLong = [SDTool calculateWithStartTime:self.showBeginTimeLab.text endTime:self.showEndTimeLab.text];
        if (timeLong < 0 ) {
            [SDShowSystemPrompView showSystemPrompStr:@"结束时间小于开始时间"];
            return;
        }
        self.showTimeLongLab.text = [NSString stringWithFormat:@"%ld",(long)timeLong];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
