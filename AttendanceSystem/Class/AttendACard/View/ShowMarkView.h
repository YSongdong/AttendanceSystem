//
//  ShowMarkView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/25.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMarkView : UIView

@property (nonatomic,strong) NSDictionary *dict;

//添加mark
@property (nonatomic,copy) void(^addMarkBlock)(NSString *markStr);



@end
