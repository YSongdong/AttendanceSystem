//
//  UpdateVersionView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/8/10.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateVersionView : UIView

//判断是否是强制更新  YES  是强制更新  NO 非强制
@property (nonatomic,assign) BOOL isForceUpdate;

@property (nonatomic,copy) void(^updateBlock)(void);


@end
