//
//  ShowAtttendScopeView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/19.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowAtttendScopeView : UIView

//打卡范围
@property (nonatomic,strong)NSArray *coordinateArr;

@property (nonatomic,strong)NSDictionary *coordinateDict;

//获得自己的位置，方便demo添加围栏进行测试，
@property (nonatomic, strong) CLLocation *userLocation;


@end
