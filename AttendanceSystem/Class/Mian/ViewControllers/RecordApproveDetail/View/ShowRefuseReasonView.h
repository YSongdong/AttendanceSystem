//
//  ShowRefuseReasonView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/8/2.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowRefuseReasonView : UIView <UITextViewDelegate>

@property (nonatomic,strong) UITextView *refuesTextView;

@property (nonatomic,strong) UILabel *showPlaceLab;

@property (nonatomic,strong) UILabel  *showLab;

@property (nonatomic,copy) void(^trueBlock)(void);
@end
