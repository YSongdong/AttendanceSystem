//
//  LeftUserController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/10.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "LeftUserController.h"

#import "AppDelegate.h"

#import "SDUserInfoController.h"
#import "SDSettingViewController.h"

@interface LeftUserController ()
//头部头像
@property (nonatomic,strong) UIImageView *headerImageV;
//状态
@property (nonatomic,strong) UIImageView *chenkImageV ;
//姓名
@property (nonatomic,strong) UILabel *nameLab;
//工号
@property (nonatomic,strong) UILabel *jobnumberLab;
//所属部门
@property (nonatomic,strong) UILabel *departNameLab;

@end

@implementation LeftUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    [self.customNavBar wr_setBackgroundAlpha:0];
    [self createHeaderView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //加载数据源
    [self requestUserInfoData];
}
-(void) createHeaderView{
    __weak typeof(self) weakSelf = self;
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [bgView addGestureRecognizer:tap];
    
    UIImageView *naviImageV = [[UIImageView alloc]init];
    [bgView addSubview:naviImageV];
    if (KIsiPhoneX) {
        naviImageV.image = [UIImage imageNamed:@"cbl_bg-1"];
    }else{
        naviImageV.image = [UIImage imageNamed:@"cbl_bg"];
    }
    [naviImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
    }];
    
    self.headerImageV  = [[UIImageView alloc]init];
    [bgView addSubview:self.headerImageV];
    [UIImageView sd_setImageView:self.headerImageV WithURL:[SDUserInfo obtainWithPhoto]];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(KSNaviTopHeight+KSIphonScreenH(18));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.height.equalTo(@(KSIphonScreenW(80)));
    }];
    self.headerImageV.layer.cornerRadius = KSIphonScreenW(40);
    self.headerImageV.layer.masksToBounds = YES;
    self.headerImageV.userInteractionEnabled = YES;
    
    self.chenkImageV = [[UIImageView alloc]init];
    [bgView addSubview:self.chenkImageV];
    self.chenkImageV.tag = 200;
    NSString *photoStatu = [SDUserInfo obtainWithPotoStatus];
    if ([photoStatu isEqualToString:@"1"]) {
        //待审核
        self.chenkImageV.image = [UIImage imageNamed:@"grzx_ico_shz"];
    }else if ([photoStatu isEqualToString:@"2"]){
        //未通过
        self.chenkImageV.image = [UIImage imageNamed:@"grzx_ico_wtg"];
    }else if ([photoStatu isEqualToString:@"3"]){
        //审核通过
        self.chenkImageV.image = [UIImage imageNamed:@"grzx_ico_ytg"];
    }else{
        //未采集
        self.chenkImageV.image = [UIImage imageNamed:@"grzx_ico_wcj"];
    }
    [self.chenkImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.headerImageV.mas_bottom);
        make.centerX.equalTo(weakSelf.headerImageV.mas_centerX);
    }];
    
    self.nameLab = [[UILabel alloc]init];
    [bgView addSubview:self.nameLab];
    self.nameLab.tag = 201;
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chenkImageV.mas_bottom).offset(KSIphonScreenH(10));
        make.centerX.equalTo(weakSelf.chenkImageV.mas_centerX);
        make.width.equalTo(@(KSIphonScreenW(100)));
    }];
    UIImage *img ;
    NSString *sexStr = [NSString stringWithFormat:@"%@",[SDUserInfo obtainWithSex]];
    if ([sexStr isEqualToString:@"0"]) {
        //未填写身份证
         img  = [UIImage imageNamed:@"grzx_ico_wz"];
    }else if ([sexStr isEqualToString:@"1"]) {
        //女
        img  = [UIImage imageNamed:@"grzx_pic_ns"];
    }else if ([sexStr isEqualToString:@"2"]){
        //男
         img  = [UIImage imageNamed:@"grzx_pic_nh"];
    }
    NSString *nameStr = [SDUserInfo obtainWithRealName];
    //设置富文本
    NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:nameStr];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, [UIColor colorTextBg28BlackColor],NSForegroundColorAttributeName,nil];
    [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
    
    //添加图片
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = img;
    attach.bounds = CGRectMake(-5, -2, 12, 12);
    NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
    [attributeStr1 insertAttributedString:attributeStr2 atIndex:0];
    self.nameLab.attributedText = attributeStr1;
    
    //身份证
    self.jobnumberLab  =[[UILabel alloc]init];
    [bgView addSubview:self.jobnumberLab];
    self.jobnumberLab.font = BFont(14);
    self.jobnumberLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.jobnumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab.mas_bottom).offset(41);
        make.centerX.equalTo(weakSelf.nameLab.mas_centerX);
    }];
    self.jobnumberLab.text =[NSString stringWithFormat:@"员工工号:%@",[SDUserInfo obtainWithJobNumber]];
   
    //所属部门
    self.departNameLab = [[UILabel alloc]init];
    [bgView addSubview:self.departNameLab];
    self.departNameLab.text = [NSString stringWithFormat:@"所属部门:%@",[SDUserInfo obtainWithDepartmentName]];
    self.departNameLab.font = BFont(14);
    self.departNameLab.textAlignment = NSTextAlignmentCenter;
    self.departNameLab.textColor = [UIColor colorTextBg98BlackColor];
    [self.departNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.jobnumberLab.mas_bottom).offset(KSIphonScreenH(18));
        make.left.equalTo(weakSelf.view).offset(KSIphonScreenW(40));
        make.right.equalTo(weakSelf.view).offset(-(KSIphonScreenW(40)));
        make.centerX.equalTo(weakSelf.jobnumberLab.mas_centerX);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.departNameLab.mas_bottom).offset(KSIphonScreenH(74));
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [self.view addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.departNameLab.mas_bottom).offset(KSIphonScreenH(75));
        make.left.equalTo(weakSelf.view).offset(KSIphonScreenW(20));
        make.right.equalTo(weakSelf.view).offset(-(KSIphonScreenW(20)));
        make.height.equalTo(@1);
    }];
    
    //设置view
    UIView *settingView =  [[UIView alloc]init];
    [self.view addSubview:settingView];
    [settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(KSIphonScreenH(10));
        make.height.equalTo(@(KSIphonScreenH(44)));
        make.left.width.equalTo(lineView);
        make.centerX.equalTo(lineView.mas_centerX);
    }];
    
    UITapGestureRecognizer *setTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectSettTap)];
    [settingView addGestureRecognizer:setTap];
    
    UIImageView *leftImageV = [[UIImageView alloc]init];
    [settingView addSubview:leftImageV];
    leftImageV.image = [UIImage imageNamed:@"ico_sz"];
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(settingView).offset(KSIphonScreenW(13));
        make.centerY.equalTo(settingView.mas_centerY);
    }];
    
    UILabel *settLab = [[UILabel alloc]init];
    [settingView addSubview:settLab];
    settLab.text = @"设置";
    settLab.font = BFont(14);
    settLab.textColor = [UIColor colorTextBg28BlackColor];
    [settLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageV.mas_right).offset(9);
        make.centerY.equalTo(leftImageV.mas_centerY);
    }];
    
    UIImageView *rightImageV = [[UIImageView alloc]init];
    [settingView addSubview:rightImageV];
    rightImageV.image = [UIImage imageNamed:@"cbl_ico_enter"];
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(settingView);
        make.centerY.equalTo(settLab.mas_centerY);
    }];
}
// 关闭右侧侧边栏
-(void)selectTap{
    // 关闭右侧侧边栏
    [self.frostedViewController hideMenuViewController];
    UINavigationController *navCtr= ((AppDelegate*)[UIApplication sharedApplication].delegate).rootTabbarCtrV.selectedViewController;
    SDUserInfoController *userVC = [[SDUserInfoController alloc]init];
    [navCtr pushViewController:userVC animated:YES];
}
//设置
-(void)selectSettTap{
    // 关闭右侧侧边栏
    [self.frostedViewController hideMenuViewController];
    UINavigationController *navCtr= ((AppDelegate*)[UIApplication sharedApplication].delegate).rootTabbarCtrV.selectedViewController;
    SDSettingViewController *settingVC =[[SDSettingViewController alloc]init];
    [navCtr pushViewController:settingVC animated:YES];
}

-(void) updateUserInfo{
    //头像
    [UIImageView sd_setImageView:self.headerImageV WithURL:[SDUserInfo obtainWithPhoto]];
    
    //状态
    NSString *photoStatu = [SDUserInfo obtainWithPotoStatus];
    if ([photoStatu isEqualToString:@"1"]) {
        //待审核
        self.chenkImageV.image = [UIImage imageNamed:@"grzx_ico_shz"];
    }else if ([photoStatu isEqualToString:@"2"]){
        //未通过
        self.chenkImageV.image = [UIImage imageNamed:@"grzx_ico_wtg"];
    }else if ([photoStatu isEqualToString:@"3"]){
        //审核通过
        self.chenkImageV.image = [UIImage imageNamed:@"grzx_ico_ytg"];
    }else{
        //未采集
        self.chenkImageV.image = [UIImage imageNamed:@"grzx_ico_wcj"];
    }
    
    //姓名
    UIImage *img ;
    NSString *sexStr = [NSString stringWithFormat:@"%@",[SDUserInfo obtainWithSex]];
    if ([sexStr isEqualToString:@"1"]) {
        //女
        img  = [UIImage imageNamed:@"grzx_pic_ns"];
    }else if ([sexStr isEqualToString:@"2"]){
        //男
        img  = [UIImage imageNamed:@"grzx_pic_nh"];
    }
    NSString *nameStr = [SDUserInfo obtainWithRealName];
    //设置富文本
    NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:nameStr];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, [UIColor colorTextBg28BlackColor],NSForegroundColorAttributeName,nil];
    [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
    
    //添加图片
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = img;
    attach.bounds = CGRectMake(-5, -2, 12, 12);
    NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
    [attributeStr1 insertAttributedString:attributeStr2 atIndex:0];
    self.nameLab.attributedText = attributeStr1;
    
    //员工工号
    self.jobnumberLab.text =[NSString stringWithFormat:@"员工工号:%@",[SDUserInfo obtainWithJobNumber]];
    //部门
    self.departNameLab.text = [NSString stringWithFormat:@"所属部门:%@",[SDUserInfo obtainWithDepartmentName]];
}
#pragma mark ----数据相关-----
-(void) requestUserInfoData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] =  [SDUserInfo obtainWithUserId];
    param[@"token"] = [SDTool getNewToken];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPUSERUSERINFO_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            //修改用户保存信息
            [SDUserInfo alterUserInfo:showdata];
            //更新信息
            [self updateUserInfo];
        }
    }];
}

@end
