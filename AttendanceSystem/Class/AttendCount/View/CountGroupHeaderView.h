//
//  CountGroupHeaderView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/8/17.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountGroupHeaderView : UIView

@property (nonatomic,strong)NSDictionary *dict;

@property (nonatomic,copy) void(^selectGroupBlcok)(void);

@end
