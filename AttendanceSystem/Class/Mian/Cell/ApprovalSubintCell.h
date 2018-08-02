//
//  ApprovalSubintCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApprovalSubintCell : UITableViewCell

//提交按钮点击事件
@property (nonatomic,copy) void(^subimtBlock)(void);

@end
