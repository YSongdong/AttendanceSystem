//
//  ShowSiftMessageTypeView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/8/9.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowSiftMessageTypeView : UIView

//类型
@property (nonatomic,copy) void(^selectType)(NSString *typeStr);

@end
