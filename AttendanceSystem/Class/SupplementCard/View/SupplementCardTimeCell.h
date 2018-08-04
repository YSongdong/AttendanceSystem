//
//  SupplementCardTimeCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SupplementCardTimeCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *selectCardTimeView;
//显示
@property (weak, nonatomic) IBOutlet UILabel *showCardTimeLab;
//补卡时间
@property (weak, nonatomic) IBOutlet UILabel *showSupplenCardTimeLab;
//开始时间
@property (nonatomic,copy) void(^cardTimeBlock)(void);
//更新时间UI
-(void) updateTimeType:(NSDictionary *)dict;

@end
