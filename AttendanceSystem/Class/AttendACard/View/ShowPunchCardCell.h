//
//  ShowPunchCardCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/19.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPunchCardCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dict;

//备注
@property (nonatomic,copy) void(^markBlock)(void);
//请假
@property (nonatomic,copy) void(^askForLeaveBlock)(void);
//补卡通过
@property (nonatomic,copy) void(^leaveInBuCardSucceBlock)(void);
//外勤通过
@property (nonatomic,copy) void(^leaveInWorkSuccesBlock)(void);
//申请补卡
@property (nonatomic,copy) void(^timeUnusualUFaceBuCardBlock)(void);

@end
