//
//  HomeView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/13.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "HomeView.h"

#import "SGAdvertScrollView.h"

@interface  HomeView ()
//用户头像
@property (nonatomic,strong) UILabel *headerNameLab;
//用户名称
@property (nonatomic,strong) UILabel *nameLab;
//职位
@property (nonatomic,strong) UILabel *posiLab;
//跑马灯效果
@property (nonatomic,strong) SGAdvertScrollView *advertView;


@end

@implementation HomeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    __weak typeof(self) weakSelf = self;
    //背景色
    self.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
    UIImageView *bgImageV = [[UIImageView alloc]init];
    [self addSubview:bgImageV];
    bgImageV.image = [UIImage imageNamed:@""];
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    UIView *headerView = [[UIView alloc]init];
    [self addSubview:headerView];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSNaviTopHeight+13);
        make.width.height.equalTo(@48);
        make.left.equalTo(weakSelf).offset(12);
    }];
    headerView.layer.cornerRadius = CGRectGetWidth(headerView.frame)/2;
    headerView.layer.masksToBounds = YES;
    
    UIImageView *namlImageV = [[UIImageView alloc]init];
    [headerView addSubview:namlImageV];
    [UIImageView sd_setImageView:namlImageV WithURL:[SDUserInfo obtainWithPhoto]];
    [namlImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY);
        make.centerX.equalTo(headerView.mas_centerX);
    }];
    
//    self.headerNameLab = [[UILabel alloc]init];
//    [headerView addSubview:self.headerNameLab];
//    self.headerNameLab.text = @"李巧";
//    self.headerNameLab.textColor = [UIColor colorCommonGreenColor];
//    self.headerNameLab.font = Font(15);
//    [self.headerNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(headerView.mas_centerY);
//        make.centerX.equalTo(headerView.mas_centerX);
//    }];
   
    self.nameLab = [[UILabel alloc]init];
    [self addSubview:self.nameLab];
    self.nameLab.textColor = [UIColor whiteColor];
    self.nameLab.text = @"fwfwofwfw ";
    self.nameLab.font = Font(16);
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(8);
        make.left.equalTo(headerView.mas_right).offset(7);
    }];
    
    self.posiLab =[[UILabel alloc]init];
    [self addSubview:self.posiLab];
    self.posiLab.textColor = [UIColor whiteColor];
    self.posiLab.text = [NSString stringWithFormat:@"部门名称:%@",[SDUserInfo obtainWithDepartmentName]];
    self.posiLab.font =Font(12);
    [self.posiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab.mas_left);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).offset(5);
    }];
    
    //跑马灯效果
    self.advertView = [[SGAdvertScrollView alloc]init];
    [self addSubview:self.advertView];
    [self.advertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(17);
        make.top.equalTo(headerView.mas_bottom).offset(15);
        make.right.equalTo(weakSelf).offset(-17);
        make.height.equalTo(@20);
    }];
    self.advertView.titles = @[@"京东、天猫等 app 首页常见的广告滚动视图", @"采用代理设计模式进行封装, 可进行事件点击处理", @"建议在 github 上下载"];
    self.advertView.signImages = @[@"sy_ico_ad"];
    self.advertView.titleFont = Font(13);
    
   
    //考勤专区
    UIView *attendView = [[UIView alloc]init];
    [self addSubview:attendView];
    [attendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.advertView.mas_bottom).offset(16);
        make.left.equalTo(weakSelf).offset(17);
        make.right.equalTo(weakSelf).offset(-17);
    }];
    
    UIImageView *attendImageV = [[UIImageView alloc]init];
    [attendView addSubview:attendImageV];
    attendImageV.image = [UIImage imageNamed:@""];
    [attendImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(attendView);
    }];
    
    UILabel *attendLab = [[UILabel alloc]init];
    [attendView addSubview:attendLab];
    attendLab.text = @"考勤专区";
    attendLab.font =Font(12);
    attendLab.textColor = [UIColor colorTextBg28BlackColor];
    [attendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(attendView).offset(14);
        make.left.equalTo(attendView).offset(15);
    }];
    
    
    
}




@end
