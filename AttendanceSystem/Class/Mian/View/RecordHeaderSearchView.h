//
//  RecordHeaderSearchView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordHeaderSearchView : UIView

//搜索
@property (nonatomic,strong) UITextField *searchTextField;

//点击搜索按钮
@property (nonatomic,copy) void(^searchBlock)(NSString *searchStr);

@end
