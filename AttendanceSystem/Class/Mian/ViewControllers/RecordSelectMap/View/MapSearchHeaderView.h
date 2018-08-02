//
//  MapSearchHeaderView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapSearchHeaderView : UIView
//搜索textField
@property (nonatomic,strong) UITextField *searchTextField;

@property (nonatomic,copy) void(^searchBlock)(NSString *searchStr);

@end
