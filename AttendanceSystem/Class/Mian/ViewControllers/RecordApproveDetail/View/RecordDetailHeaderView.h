//
//  RecordDetailHeaderView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  enum{
    RecordDetailHeaderGoOutType = 0, //外出
    RecordDetailHeaderLeaveType,     //请假
    RecordDetailHeaderCardType      //请假
    
}RecordDetailHeaderType;

@interface RecordDetailHeaderView : UIView
//类型
@property (nonatomic,assign) RecordDetailHeaderType headerType;


@property (nonatomic,strong) NSDictionary *dict;

@property (nonatomic,copy) void(^selectAddressBlock)(void);
//计算高度  
+(CGFloat) getWithTextHeaderViewHeight:(NSDictionary *)dict headerType:(NSString *)headerType;
@end
