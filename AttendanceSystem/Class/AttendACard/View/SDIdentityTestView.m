//
//  SDIdentityTestView.m
//  SDSafetyManageControl
//
//  Created by tiao on 2018/5/24.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "SDIdentityTestView.h"

@implementation SDIdentityTestView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createIdentTest];
    }
    return self;
}

-(void) createIdentTest{
    
    __weak typeof(self) weakSelf = self;
    
    UIView *bigBgView = [[UIView alloc]init];
    [self addSubview:bigBgView];
    bigBgView.alpha = 0.35;
    bigBgView.backgroundColor = [UIColor blackColor];
    [bigBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [bigBgView addGestureRecognizer:tap];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor  =[UIColor colorTextWhiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.height.equalTo(@337);
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(42));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(42));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    bgView.layer.cornerRadius =4;
    bgView.layer.masksToBounds = YES;
    
    UILabel * subLab = [[UILabel alloc]init];
    [bgView addSubview:subLab];
    subLab.text = @"身份验证";
    subLab.textColor = [UIColor colorTextBg28BlackColor];
    subLab.font = [UIFont systemFontOfSize:19];
    [subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(KSIphonScreenH(21));
        make.centerX.equalTo(bgView.mas_centerX);
    }];
 
    self.testImageV = [[UIImageView alloc]init];
    [bgView addSubview:self.testImageV];
    self.testImageV.image = [UIImage imageNamed:@"ico_sfyz"];
    [self.testImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subLab.mas_bottom).offset(KSIphonScreenH(24));
        make.centerX.equalTo(subLab.mas_centerX);
    }];
    
    self.beginTestLab = [[UILabel alloc]init];
    [bgView addSubview:self.beginTestLab];
    self.beginTestLab.text = @"点击开始验证后将进入身份验证";
    self.beginTestLab.font = [UIFont systemFontOfSize:16];
    self.beginTestLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    self.beginTestLab.textAlignment = NSTextAlignmentCenter;
    [self.beginTestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.testImageV.mas_bottom).offset(KSIphonScreenH(32));
        make.left.equalTo(bgView).offset(KSIphonScreenW(12));
        make.right.equalTo(bgView).offset(-KSIphonScreenW(12));
        make.centerX.equalTo(weakSelf.testImageV.mas_centerX);
    }];
    
    self.errorLab = [[UILabel alloc]init];
    [bgView addSubview:self.errorLab];
    self.errorLab.text = @"身份验证失败，请重新验证";
    self.errorLab.textColor = [UIColor colorWithHexString:@"ff3030"];
    self.errorLab.font = [UIFont systemFontOfSize:16];
    self.errorLab.textAlignment = NSTextAlignmentCenter;
    [self.errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.testImageV.mas_bottom).offset(KSIphonScreenH(29));
        make.left.equalTo(bgView).offset(KSIphonScreenW(12));
        make.right.equalTo(bgView).offset(-KSIphonScreenW(12));
        make.centerX.equalTo(weakSelf.testImageV.mas_centerX);
    }];
    self.errorLab.hidden = YES;
    
    self.showErrorLab = [[UILabel alloc]init];
    [bgView addSubview:self.showErrorLab];
    self.showErrorLab.text = @"请保持室内光线充足，检测动作不宜多大";
    self.showErrorLab.font = [UIFont systemFontOfSize:12];
    self.showErrorLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    self.showErrorLab.textAlignment = NSTextAlignmentCenter;
    [self.showErrorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.errorLab.mas_bottom).offset(KSIphonScreenH(6));
        make.left.equalTo(bgView).offset(KSIphonScreenW(12));
        make.right.equalTo(bgView).offset(-KSIphonScreenW(12));
        make.centerX.equalTo(weakSelf.errorLab.mas_centerX);
    }];
    self.showErrorLab.hidden = YES;
    
    self.beginTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:self.beginTestBtn];
    [self.beginTestBtn setTitle:@"开始验证" forState:UIControlStateNormal];
    [self.beginTestBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    [self.beginTestBtn setBackgroundImage:[UIImage imageNamed:@"sfyz_btn_ksyz"] forState:UIControlStateNormal];;
    self.beginTestBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.beginTestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(KSIphonScreenW(228)));
        make.height.equalTo(@(KSIphonScreenH(33)));
        make.top.equalTo(weakSelf.beginTestLab.mas_bottom).offset(KSIphonScreenH(22));
        make.centerX.equalTo(weakSelf.beginTestLab.mas_centerX);
    }];
    self.beginTestBtn.layer.cornerRadius =4;
    self.beginTestBtn.layer.masksToBounds = YES;
 
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:self.cancelBtn];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor colorWithHexString:@"#656565"] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.beginTestBtn.mas_bottom).offset(KSIphonScreenH(15));
        make.centerX.equalTo(weakSelf.beginTestBtn.mas_centerX);
        make.bottom.equalTo(bgView.mas_bottom).offset(-KSIphonScreenH(15));
    }];
    [self.cancelBtn addTarget:self action:@selector(selectCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
}

//点击背景
-(void)selectTap{
    //[self removeFromSuperview];
}
//点击取消
-(void)selectCancelBtn:(UIButton *) sender{
    [self removeFromSuperview];
}

//跟新信息
-(void) updateTestViewSucces:(BOOL)isSucces isEnd:(BOOL) isEnd{
    if (isSucces) {
        if (isEnd) {
            self.beginTestLab.hidden = YES;
            self.errorLab.hidden = NO;
            self.errorLab.text = @"身份验证成功";
            self.errorLab.textColor = [UIColor colorWithHexString:@"#33c500"];
            self.showErrorLab.hidden= NO;
            self.showErrorLab.text = @"请各位考生认真答题，遵守考场纪律";
            self.showErrorLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
            self.cancelBtn.hidden = YES;
            [self.beginTestBtn setTitle:@"继续交卷" forState:UIControlStateNormal];
            [self.beginTestBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
            self.testImageV.image = [UIImage imageNamed:@"zsks_pic_05"];
        }else{
            self.beginTestLab.hidden = YES;
            self.errorLab.hidden = NO;
            self.errorLab.text = @"身份验证成功";
            self.errorLab.textColor = [UIColor colorWithHexString:@"#33c500"];
            self.showErrorLab.hidden= NO;
            self.showErrorLab.text = @"请各位考生认真答题，遵守考场纪律";
            self.showErrorLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
            self.cancelBtn.hidden = YES;
            [self.beginTestBtn setTitle:@"继续答题" forState:UIControlStateNormal];
            [self.beginTestBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
            self.testImageV.image = [UIImage imageNamed:@"zsks_pic_05"];
        }
    }else{
        self.beginTestLab.hidden = YES;
        self.errorLab.hidden = NO;
        self.errorLab.text = @"身份验证失败，请重新验证";
        self.errorLab.textColor = [UIColor colorWithHexString:@"#ff3030"];
        self.showErrorLab.hidden= NO;
        self.showErrorLab.text = @"请保持室内光线充足，检测动作不宜过大";
        self.showErrorLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        self.cancelBtn.hidden = YES;
        [self.beginTestBtn setTitle:@"重新验证" forState:UIControlStateNormal];
        [self.beginTestBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
        self.testImageV.image = [UIImage imageNamed:@"zsks_pic_04"];
    }
}


@end
