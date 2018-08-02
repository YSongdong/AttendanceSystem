//
//  AttendCardHeaderView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/18.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AttendCardHeaderView.h"

@implementation AttendCardHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createHeaderView];
    }
    return self;
}

-(void) createHeaderView{
    __weak typeof(self) weakSelf = self;
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    
    UIImageView *headerImageV = [[UIImageView alloc]init];
    [self addSubview:headerImageV];
    [UIImageView sd_setImageView:headerImageV WithURL:[SDUserInfo obtainWithPhoto]];
    [headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(12);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.height.equalTo(@44);
    }];
    headerImageV.layer.cornerRadius = 22;
    headerImageV.layer.masksToBounds = YES;
    
    UILabel *nameLab = [[UILabel alloc]init];
    [self addSubview:nameLab];
    nameLab.text =[SDUserInfo obtainWithRealName];
    nameLab.font = Font(15);
    nameLab.textColor = [UIColor colorTextBg28BlackColor];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageV.mas_right).offset(6);
        make.top.equalTo(weakSelf).offset(18);
    }];
    
    UILabel *departNameLab  = [[UILabel alloc]init];
    [self addSubview:departNameLab];
    departNameLab.textColor = [UIColor colorTextBg98BlackColor];
    departNameLab.font = Font(12);
    departNameLab.text =  [NSString stringWithFormat:@"考勤分组:%@",[SDUserInfo obtainWithProGroupName]];
    [departNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLab.mas_bottom).offset(6);
        make.left.equalTo(nameLab.mas_left);
        make.right.equalTo(weakSelf).offset(-125);
    }];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"YYYY.MM.dd"];
    NSString *dateString = [dataFormatter stringFromDate:currentDate];
    self.selectBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.selectBtn];
    [self.selectBtn setTitle:[NSString stringWithFormat:@"%@ ",dateString] forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:[UIColor colorWithHexString:@"#239566"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"ico_sj_xl"] forState:UIControlStateNormal];
    self.selectBtn.titleLabel.font =  Font(13);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.selectBtn LZSetbuttonType:LZCategoryTypeLeft];
    });
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.width.equalTo(@112);
        make.height.equalTo(@35);
        make.centerY.equalTo(departNameLab.mas_centerY);
    }];
    
    
}




@end
