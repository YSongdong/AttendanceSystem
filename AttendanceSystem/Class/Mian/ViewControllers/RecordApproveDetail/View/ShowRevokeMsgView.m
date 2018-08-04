//
//  ShowRevokeMsgView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/2.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowRevokeMsgView.h"

@implementation ShowRevokeMsgView

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
        make.left.equalTo(weakSelf).offset(65);
        make.right.equalTo(weakSelf).offset(-65);
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
    promptSubjLab.text =@"提示";
    [promptSubjLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(subView.mas_centerX);
        make.centerY.equalTo(subView.mas_centerY);
    }];
    
    UIView *concetView = [[UIView alloc]init];
    [samilView addSubview:concetView];
    concetView.backgroundColor =[UIColor colorTextWhiteColor];
    [concetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subView.mas_bottom).offset(1);
        make.left.right.equalTo(samilView);
        make.bottom.equalTo(samilView).offset(-46);
    }];
    
    self.showLab = [[UILabel alloc]init];
    [concetView addSubview:self.showLab];
    self.showLab.text = @"您是否确认撤销该条外出申请?";
    self.showLab.font = Font(14);
    self.showLab.numberOfLines = 0;
    self.showLab.textColor = [UIColor colorTextBg65BlackColor];
    [self.showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(concetView).offset(19);
        make.right.equalTo(concetView).offset(-19);
        make.centerX.equalTo(concetView.mas_centerX);
        make.centerY.equalTo(concetView.mas_centerY);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [samilView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Font(16);
    cancelBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(samilView);
        make.top.equalTo(concetView.mas_bottom).offset(1);
    }];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [samilView addSubview:self.trueBtn];
    [self.trueBtn setTitle:@"确认撤销" forState:UIControlStateNormal];
    [self.trueBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.trueBtn.titleLabel.font = Font(16);
    self.trueBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [self.trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelBtn.mas_right).offset(1);
        make.right.equalTo(samilView);
        make.width.height.equalTo(cancelBtn);
        make.centerY.equalTo(cancelBtn.mas_centerY);
    }];
    [self.trueBtn addTarget:self action:@selector(tureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)selectdTap{
    [self removeFromSuperview];
}
-(void)cancelBtnAction:(UIButton *) sender{
    [self selectdTap];
}
-(void)tureBtnAction:(UIButton *) sender{
    self.trueBlock();
    [self selectdTap];
}

@end
