//
//  ChenkHeaderView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChenkHeaderView : UIView



//type 1 待我审批的  2我已审批的
@property (nonatomic,copy) void(^typeBlock)(NSString *typeStr);

//更新UI
-(void) updateHeaderViewUI:(NSString *) countStr;

@end
