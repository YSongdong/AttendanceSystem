//
//  AttendCountTableViewCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/17.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AttendCountTableViewCell.h"

@implementation AttendCountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    self.showTimeLab.text = [NSString stringWithFormat:@"%@ (%@,%@)",dict[@"sureDate"],dict[@"week"],dict[@"sureTime"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
