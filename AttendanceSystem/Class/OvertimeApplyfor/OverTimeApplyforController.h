//
//  OverTimeApplyforController.h
//  AttendanceSystem
//
//  Created by tiao on 2018/8/23.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDBaseController.h"
@interface OverTimeApplyforController : SDBaseController

//判断是不是修改 YES 是 NO不是
@property (nonatomic,assign) BOOL isAlter;
//修改数据源
@property (nonatomic,strong) NSDictionary *alterDataDict;

@end
