//
//  AlterPassNumberController.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/14.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDBaseController.h"
@interface AlterPassNumberController : SDBaseController
//判断是否从个人中心跳转
@property (nonatomic,assign) BOOL isMine;
//手机号
@property (nonatomic,copy) void(^passBlock)(NSString *passStr);

@end
