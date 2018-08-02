//
//  BindingPhoneController.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/13.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDBaseController.h"
@interface BindingPhoneController : SDBaseController

//记录UserID
@property (nonatomic,strong) NSString *userID;
//判断是否从个人中心跳转
@property (nonatomic,assign) BOOL isMine;
//手机号
@property (nonatomic,copy) void(^numberBlock)(NSString *numberStr);

@end
