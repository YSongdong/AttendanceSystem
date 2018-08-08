//
//  ShowPromptMsgView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/7.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowPromptMsgView.h"

@implementation ShowPromptMsgView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    __weak typeof(self) weakSelf = self;
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor =[UIColor blackColor];
    bgView.alpha = 0.35;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    UIView *samilView = [[UIView alloc]init];
    [self addSubview:samilView];
    samilView.backgroundColor = [UIColor blackColor];
    [samilView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(65);
        make.right.equalTo(weakSelf).offset(-65);
        make.height.equalTo(@50);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    samilView.layer.cornerRadius = 8;
    samilView.layer.masksToBounds  = YES;
    
    UILabel *showLab  =[[UILabel alloc]init];
    [samilView addSubview:showLab];
    showLab.text = @"正在获取数据，请稍后";
    showLab.textColor = [UIColor colorTextWhiteColor];
    showLab.font = Font(14);
    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(samilView.mas_centerX);
        make.centerY.equalTo(samilView.mas_centerY);
    }];
}

@end
