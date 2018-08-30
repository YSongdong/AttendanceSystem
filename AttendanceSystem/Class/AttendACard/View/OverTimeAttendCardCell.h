//
//  OverTimeAttendCardCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/8/24.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverTimeAttendCardCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dict;


//备注
@property (nonatomic,copy) void(^markBlock)(void);
//请假
@property (nonatomic,copy) void(^askForLeaveBlock)(void);



@end
