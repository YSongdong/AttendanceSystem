//
//  RecordToolView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordToolView : UIView

@property (nonatomic,strong)UIButton *revokeBtn;

@property (nonatomic,strong)UIButton *urgentBtn;
//撤销
@property (nonatomic,copy) void(^RevokeBlock)(void);
//催办
@property (nonatomic,copy) void(^UrgentBlock)(void);
@end
