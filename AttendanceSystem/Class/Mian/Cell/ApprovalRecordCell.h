//
//  ApprovalRecordCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  enum{
    RecordCellOutType = 0, //外出
    RecordCellLeaveType,   //请假
    RecordCellCardType,     //补卡
    RecordCellOverTimeType     //加班
//    RecordCellApplyForType, //我的申请
//    RecordCellChenkApplyType //我审批的
}RecordCellType;

@interface ApprovalRecordCell : UITableViewCell

//名字
@property (weak, nonatomic) IBOutlet UILabel *showNameLab;
//类型
@property (nonatomic,assign) RecordCellType cellType;

// 1 我的申请 我的审批 2 其他
@property (nonatomic,strong) NSString *reasonTypeStr;

@property (nonatomic,strong) NSDictionary *dict;

//
@property (nonatomic,strong) NSString  *cutTypeStr;

@end
