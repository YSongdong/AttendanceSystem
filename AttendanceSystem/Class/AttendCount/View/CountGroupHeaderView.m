//
//  CountGroupHeaderView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/17.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "CountGroupHeaderView.h"

@interface CountGroupHeaderView ()

@property (nonatomic,strong) UIImageView *leftImageV;

@property (nonatomic,strong) UILabel *groupNameLab;

@property (nonatomic,strong) UILabel *groupCountLab;

@property (nonatomic,strong) UIImageView *reightImageV;

@end


@implementation CountGroupHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    
    __weak typeof(self) weakSelf = self;
    self.backgroundColor =[ UIColor colorCommonf2GreyColor];

    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorTextWhiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.equalTo(@60);
    }];
    
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:bgBtn];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView);
    }];
    [bgBtn addTarget:self action:@selector(selectGroupAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.leftImageV =[[UIImageView alloc]init];
    [bgView addSubview:self.leftImageV];
    self.leftImageV.image = [UIImage imageNamed:@"ico_05"];
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    self.groupNameLab  =[[UILabel alloc]init];
    [bgView addSubview:self.groupNameLab];
    self.groupNameLab.text = @"准时";
    self.groupNameLab.textColor = [UIColor colorCommonGreenColor];
    self.groupNameLab.font = Font(16);
    [self.groupNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(KSIphonScreenW(8));
        make.centerY.equalTo(weakSelf.leftImageV.mas_centerY);
    }];
    
    
    self.reightImageV = [[UIImageView alloc]init];
    [bgView addSubview:self.reightImageV];
    self.reightImageV.image = [UIImage imageNamed:@"ico_xl_02"];
    [self.reightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-(KSIphonScreenW(12)));
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    self.groupCountLab =[[UILabel alloc]init];
    [bgView addSubview:self.groupCountLab];
    self.groupCountLab.textColor = [UIColor colorTextBg98BlackColor];
    self.groupCountLab.font = Font(14);
    self.groupCountLab.text = @"3次";
    [self.groupCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.reightImageV.mas_left).offset(-KSIphonScreenW(8));
        make.centerY.equalTo(weakSelf.reightImageV.mas_centerY);
    }];
    
    UIView *lineView =[[UIView alloc]init];
    [bgView addSubview:lineView];
    lineView.backgroundColor  =[ UIColor colorWithHexString:@"#e0e0e0"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(weakSelf);
        make.height.equalTo(@1);
    }];
 
}

-(void)selectGroupAction:(UIButton *) sender{
    self.selectGroupBlcok();
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    //名字
    self.groupNameLab.text = dict[@"name"];

    //统计
    NSString *numStr = [NSString stringWithFormat:@"%@",dict[@"num"]];
    if ([numStr integerValue] > 0) {
        self.groupCountLab.text = [NSString stringWithFormat:@"%@次",numStr];
        self.groupCountLab.textColor = [UIColor colorTextBg98BlackColor];
        NSString *isOffStr = dict[@"isOff"];
        if ([isOffStr isEqualToString:@"1"]) {
            self.reightImageV.image = [UIImage imageNamed:@"ico_xl_02"];
        }else{
           self.reightImageV.image = [UIImage imageNamed:@"ico_xl_03"];
        }
    }else{
        self.groupCountLab.text = @"0次";
        self.groupCountLab.textColor = [UIColor colorWithHexString:@"#dbdbdb"];
        self.reightImageV.image = [UIImage imageNamed:@"ico_xl_05"];
    }
    
    //类型
    NSString *typeStr = dict[@"type"];
    if ([typeStr isEqualToString:@"missCard"]) {
        //缺卡
        self.leftImageV.image = [UIImage imageNamed:@"ico_01"];
    }else if ([typeStr isEqualToString:@"completion"]){
        //旷工
        self.leftImageV.image = [UIImage imageNamed:@"ico_02"];
    }else if ([typeStr isEqualToString:@"late"]){
        //迟到
        self.leftImageV.image = [UIImage imageNamed:@"ico_03"];
    }else if ([typeStr isEqualToString:@"leavEarly"]){
        //早退
        self.leftImageV.image = [UIImage imageNamed:@"ico_04"];
    }else if ([typeStr isEqualToString:@"onTime"]){
        //准时
        self.leftImageV.image = [UIImage imageNamed:@"ico_05"];
    }else if ([typeStr isEqualToString:@"supCard"]){
        //补卡申请
        self.leftImageV.image = [UIImage imageNamed:@"ico_06"];
    }else if ([typeStr isEqualToString:@"field"]){
        //外勤
        self.leftImageV.image = [UIImage imageNamed:@"ico_07"];
    }else if ([typeStr isEqualToString:@"leave"]){
        //请假
        self.leftImageV.image = [UIImage imageNamed:@"ico_08"];
    }else if ([typeStr isEqualToString:@"abnormal"]){
        //异常记录
        self.leftImageV.image = [UIImage imageNamed:@"ico_09"];
    }
    
}










@end
