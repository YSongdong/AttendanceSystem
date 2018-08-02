//
//  ChenkHeaderView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ChenkHeaderView.h"

@interface ChenkHeaderView ()

@property (nonatomic,strong) UIButton *stayChenkBtn;
//我已审批
@property (nonatomic,strong) UIButton *chenkPassBtn;
//线条
@property (nonatomic,strong) UIView *lineView;
//角标数
@property (nonatomic,strong) UILabel *hornNumberLab;

@property (nonatomic,assign) NSInteger pageTag;

@end

@implementation ChenkHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       [self createView];
    }
    return self;
}
-(void) createView{
    
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorTextWhiteColor];
    
    self.stayChenkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.stayChenkBtn];
    self.stayChenkBtn.tag =200;
    [self.stayChenkBtn setTitle:@"待我审批的" forState:UIControlStateNormal];
    [self.stayChenkBtn setTitleColor:[UIColor colorTextBg28BlackColor] forState:UIControlStateNormal];
    self.stayChenkBtn.titleLabel.font = Font(16);
    self.stayChenkBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [self.stayChenkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(weakSelf);
    }];
    [self.stayChenkBtn addTarget:self action:@selector(selectStayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.pageTag =  self.stayChenkBtn.tag;
    
    UIView *showView = [[UIView alloc]init];
    [self addSubview:showView];
    showView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.stayChenkBtn.mas_right);
        make.height.equalTo(@19);
        make.width.equalTo(@1);
        make.centerY.equalTo(weakSelf.stayChenkBtn.mas_centerY);
    }];
    
    self.chenkPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.chenkPassBtn];
    self.stayChenkBtn.tag = 201;
    [self.chenkPassBtn setTitle:@"我已审批的" forState:UIControlStateNormal];
    [self.chenkPassBtn setTitleColor:[UIColor colorTextBg28BlackColor] forState:UIControlStateNormal];
    self.chenkPassBtn.titleLabel.font = Font(16);
    self.chenkPassBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [self.chenkPassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf.stayChenkBtn.mas_right).offset(1);
        make.width.height.equalTo(weakSelf.stayChenkBtn);
        make.centerY.equalTo(weakSelf.stayChenkBtn.mas_centerY);
    }];
    
    [self.chenkPassBtn addTarget:self action:@selector(selectChenkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorCommonGreenColor];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@2);
        make.centerX.equalTo(weakSelf.stayChenkBtn.mas_centerX);
        make.bottom.equalTo(weakSelf.stayChenkBtn);
    }];
}
-(void)selectStayBtnAction:(UIButton *) sender{
    if (self.pageTag == sender.tag) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@2);
        make.centerX.equalTo(weakSelf.stayChenkBtn.mas_centerX);
        make.bottom.equalTo(weakSelf.stayChenkBtn.mas_bottom);
    }];
    self.pageTag = sender.tag;
    //type 1 待我审批的  2我已审批的
    self.typeBlock(@"1");
    
}
-(void)selectChenkBtnAction:(UIButton *) sender{
    if (self.pageTag == sender.tag) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@2);
        make.centerX.equalTo(weakSelf.chenkPassBtn.mas_centerX);
        make.bottom.equalTo(weakSelf.chenkPassBtn.mas_bottom);
    }];
    self.pageTag = sender.tag;
    //type 1 待我审批的  2我已审批的
    self.typeBlock(@"2");
}


@end
