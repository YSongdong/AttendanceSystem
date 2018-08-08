//
//  SelectLeaveInTimeCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SelectLeaveInTimeCell.h"

@interface SelectLeaveInTimeCell ()




@end



@implementation SelectLeaveInTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    //选择开始时间view
    UITapGestureRecognizer *selectBeginTimeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBeginTimeTap)];
    [self.selectBeginTimeView addGestureRecognizer:selectBeginTimeTap];
    
    //选择结束时间view
    UITapGestureRecognizer *selectEndTimeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectEndTimeTap)];
    [self.SelectEndTimeView addGestureRecognizer:selectEndTimeTap];
    
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
        self.showSelectBeginTimeLab.text = timeStr;
        self.showSelectBeginTimeLab.textColor = [UIColor colorTextBg65BlackColor];
    }else{
        //结束时间
        self.showSelectEndTimeLab.text = timeStr;
        self.showSelectEndTimeLab.textColor = [UIColor colorTextBg65BlackColor];
    }
    if ([self.showSelectBeginTimeLab.text isEqualToString:@"请选择"]) {
        return;
    }
    if ([self.showSelectEndTimeLab.text isEqualToString:@"请选择"]) {
        return;
    }
    if (self.showSelectEndTimeLab.text.length != 0 && self.showSelectBeginTimeLab.text.length != 0) {
        CGFloat timeLong = [SDTool calculateWithStartTime:self.showSelectBeginTimeLab.text endTime:self.showSelectEndTimeLab.text];
        if (timeLong < 0 ) {
            [SDShowSystemPrompView showSystemPrompStr:@"结束时间小于开始时间"];
            return;
        }
        self.showTimeLongLab.text = [NSString stringWithFormat:@"%.2f",timeLong];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
