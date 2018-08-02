//
//  SameDayHaveRestCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/26.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SameDayHaveRestCell : UITableViewCell

//申请补卡
@property (nonatomic,copy) void(^timeUnusualUFaceBuCardBlock)(void);

@end
