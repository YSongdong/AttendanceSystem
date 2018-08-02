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
    RecordCellCardType     //补卡
//    RecordCellApplyForType, //我的申请
//    RecordCellChenkApplyType //我审批的
}RecordCellType;

@interface ApprovalRecordCell : UITableViewCell

//名字
@property (weak, nonatomic) IBOutlet UILabel *showNameLab;

//类型
@property (nonatomic,assign) RecordCellType cellType;

@property (nonatomic,strong) NSDictionary *dict;


@end
