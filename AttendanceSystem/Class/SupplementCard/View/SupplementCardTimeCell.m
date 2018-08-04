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

- (NSDateFormatter *)requestDateFormatter{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"YYYY.MM.dd HH:mm";
    }
    return dateFormatter;
}

-(void)selectCardTimeTap{
    self.cardTimeBlock();
}

//更新时间UI
-(void) updateTimeType:(NSDictionary *)dict{
    NSString *typeStr ;
    if ([dict[@"type"] isEqualToString:@"1"]) {
        typeStr = @"上班时间";
    }else{
       typeStr = @"下班时间";
    }
    self.showSupplenCardTimeLab.text = [NSString stringWithFormat:@"补卡班次: %@,%@,%@%@",dict[@"sureDate"],dict[@"today"],typeStr,dict[@"endTime"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
