//
//  ShowLocatPromentView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/18.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowLocatPromentView.h"

@implementation ShowLocatPromentView

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectdTap)];
    [bgView addGestureRecognizer:tap];
    
    
    UIView *samilView = [[UIView alloc]init];
    [self addSubview:samilView];
    samilView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    [samilView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(75);
        make.right.equalTo(weakSelf).offset(-75);
        make.height.equalTo(@165);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    samilView.layer.cornerRadius = 8;
    samilView.layer.masksToBounds  = YES;
    
    UIView *subView = [[UIView alloc]init];
    [samilView addSubview:subView];
    subView.backgroundColor = [UIColor colorTextWhiteColor];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(samilView);
        make.height.equalTo(@40);
        make.centerX.equalTo(samilView.mas_centerX);
    }];
    
    UILabel *promptSubjLab = [[UILabel alloc]init];
    [subView addSubview:promptSubjLab];
    promptSubjLab.font = [UIFont boldSystemFontOfSize:17];
    promptSubjLab.textColor =[UIColor colorTextBg28BlackColor];
    promptSubjLab.text =@"未开启定位权限";
    [promptSubjLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(subView.mas_centerX);
        make.centerY.equalTo(subView.mas_centerY);
    }];

    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [samilView addSubview:self.selectBtn];
    [self.selectBtn setTitle:@"去设置" forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.selectBtn.titleLabel.font = Font(16);
    self.selectBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(samilView);
        make.height.equalTo(@45);
    }];
    [self.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];

    UIView *concetView = [[UIView alloc]init];
    [samilView addSubview:concetView];
    concetView.backgroundColor =[UIColor colorTextWhiteColor];
    [concetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subView.mas_bottom).offset(1);
        make.left.right.equalTo(samilView);
        make.bottom.equalTo(weakSelf.selectBtn.mas_top).offset(-1);
    }];

    UILabel *showLab = [[UILabel alloc]init];
    [concetView addSubview:showLab];
    showLab.text = @"请去系统设置里开启“考勤管理系统”的定位权限";
    showLab.font = Font(14);
    showLab.numberOfLines = 0;
    showLab.textColor = [UIColor colorTextBg65BlackColor];
    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(concetView).offset(19);
        make.right.equalTo(concetView).offset(-19);
        make.centerX.equalTo(concetView.mas_centerX);
        make.centerY.equalTo(concetView.mas_centerY);
    }];
}
-(void)selectAction:(UIButton *) sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.000000) {
        //跳转到定位权限页面
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }else {
        //跳转到定位开关界面
        NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
        if( [[UIApplication sharedApplication]canOpenURL:url] ) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

-(void)selectdTap{
    [self removeFromSuperview];
}



@end
