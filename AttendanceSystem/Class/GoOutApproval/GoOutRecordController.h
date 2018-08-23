//
//  GoOutRecordController.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDBaseController.h"

typedef  enum{
    ApporvalRecordOutType = 0, //外出
    ApporvalRecordLeaveType,  //请假
    ApporvalRecordCardType,    //补卡
    ApporvalRecordOverTimeType  //加班
}ApporvalRecordType;

@interface GoOutRecordController : SDBaseController
//类型
@property (nonatomic,assign)ApporvalRecordType recordType;
//titleLab
@property (nonatomic,strong) NSString *titleStr;
@end
