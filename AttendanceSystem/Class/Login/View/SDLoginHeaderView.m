//
//  SDLoginHeaderView.m
//  SDSafetyManageControl
//
//  Created by tiao on 2018/4/25.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "SDLoginHeaderView.h"

@interface SDLoginHeaderView ()

//账号
@property (nonatomic,strong) UITextField *phoneTF;
//发送验证码
@property (nonatomic,strong) UIButton *sendBtn;
//密码
@property (nonatomic,strong) UITextField *passwordTF;


@end

@implementation SDLoginHeaderView

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
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    //大背景
    UIImageView *bigImageV = [[UIImageView alloc]init];
    [bgView addSubview:bigImageV];
    if (KIsiPhoneX) {
         bigImageV.image = [UIImage imageNamed:@"dl_bg"];
    }else{
        bigImageV.image = [UIImage imageNamed:@"bg"];
    }
    [bigImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView);
    }];
    
    UIImageView *logoImageV = [[UIImageView alloc]init];
    [self addSubview:logoImageV];
    logoImageV.image = [UIImage imageNamed:@"dl_logo"];
    logoImageV.contentMode = UIViewContentModeScaleAspectFit;
    [logoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSNaviTopHeight+21);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.height.equalTo(@165);
    }];
    
    //账号
    UIView *phoneView = [[UIView alloc]init];
    [bgView addSubview:phoneView];
    phoneView.backgroundColor =[UIColor colorWithHexString:@"#69vbb4"];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageV.mas_bottom).offset(85);
        make.left.equalTo(bgView).offset(25);
        make.right.equalTo(bgView).offset(-25);
        make.height.equalTo(@44);
    }];
    phoneView.layer.cornerRadius = 22;
    phoneView.layer.masksToBounds = YES;
    
    UIImageView *leftImageV = [[UIImageView alloc]init];
    [phoneView addSubview:leftImageV];
    leftImageV.image = [UIImage imageNamed:@""];
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(22);
        make.centerY.equalTo(bgView.mas_centerY);
    }];
    
    self.phoneTF= [[UITextField alloc]init];
    [phoneView addSubview:self.phoneTF];
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageV).offset(12);
        make.top.bottom.right.equalTo(phoneView);
        make.centerY.equalTo(phoneView.mas_centerY);
    }];
    
}
-(void)selectdAccountBtn:(UIButton *) sender{
    
   
}
-(void)selectPhoneBtn:(UIButton *) sender{
    
  
}




@end
