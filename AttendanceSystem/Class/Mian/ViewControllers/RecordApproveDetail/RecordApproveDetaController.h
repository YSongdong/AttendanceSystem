//
//  RecordApproveDetaController.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDBaseController.h"

typedef  enum{
    RecordApproveGoOutDetaType = 0, //外出
    RecordApproveLeaveDetaType      //请假
    
}RecordApproveDetaType;

@interface RecordApproveDetaController : SDBaseController

//类型
@property (nonatomic,assign)RecordApproveDetaType detaType;

//
@property (nonatomic,strong)NSString *titleStr;

//是否是ApplyFor
@property (nonatomic,assign)BOOL isApplyFor;

//type 1请假流程 2外出流程 3补卡流程
@property (nonatomic,strong)NSString  *typeStr;
//外出记录id
@property (nonatomic,strong)NSString *recordIdStr;
//审批列表
@property (nonatomic,strong)NSString *cardIdStr;
@end
