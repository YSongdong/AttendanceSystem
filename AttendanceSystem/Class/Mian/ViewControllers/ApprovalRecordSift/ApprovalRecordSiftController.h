//
//  ApprovalRecordSiftController.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDBaseController.h"

typedef  enum{
    RecordApproveSiftType = 0, //审批
    RecordApplyForSiftType   //申请
}RecordSiftType;

// 代理传值方法
@protocol ApprovalRecordSiftControllerDelegate <NSObject>

- (void)selectSiftArr:(NSArray *)arr;

@end

@interface ApprovalRecordSiftController : SDBaseController

@property (nonatomic,weak) id<ApprovalRecordSiftControllerDelegate> delegate;

//筛选类型
@property (nonatomic,assign)RecordSiftType siftType;



@end
