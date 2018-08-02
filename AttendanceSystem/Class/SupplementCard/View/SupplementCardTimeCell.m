//
//  SupplementCardTimeCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SupplementCardTimeCell.h"

@implementation SupplementCardTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //选择结束时间view
    UITapGestureRecognizer *selectCradTimeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCardTimeTap)];
    [self.selectCardTimeView addGestureRecognizer:selectCradTimeTap];
}

-(void)selectCardTimeTap{
    self.cardTimeBlock();
}

-(void)updateTimeType:(NSString *)timeType andTimeStr:(NSString *)timeStr{
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
