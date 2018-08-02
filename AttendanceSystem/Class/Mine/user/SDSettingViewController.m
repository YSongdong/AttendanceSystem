//
//  SDSettingViewController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/17.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SDSettingViewController.h"

@interface SDSettingViewController ()

@end

@implementation SDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createView];
}
//创建Navi
-(void) createNavi{
    self.customNavBar.title = @"设置";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
-(void) createView{
    
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    UIImageView *iconImageV = [[UIImageView alloc]init];
    [self.view addSubview:iconImageV];
    iconImageV.image =[UIImage imageNamed:@"logo"];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(KSNaviTopHeight+44);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *versiLab = [[UILabel alloc]init];
    [self.view addSubview:versiLab];
    versiLab.textColor = [UIColor colorTextBg98BlackColor];
    versiLab.font = Font(14);
    //获取本地软件的版本号
    NSString *localVersion =  [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versiLab.text = [NSString stringWithFormat:@"送变电员工考勤系统%@版",localVersion];
    [versiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageV.mas_bottom).offset(14);
        make.centerX.equalTo(iconImageV.mas_centerX);
    }];
   
    UIView *versiView = [[UIView alloc]init];
    [self.view addSubview:versiView];
    versiView.backgroundColor = [UIColor colorTextWhiteColor];
    [versiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versiLab.mas_bottom).offset(62);
        make.right.left.equalTo(weakSelf.view);
        make.height.equalTo(@60);
        make.centerX.equalTo(versiLab.mas_centerX);
    }];
    UITapGestureRecognizer *versiTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectVersiTap)];
    [versiView addGestureRecognizer:versiTap];
    
    
    UILabel *showVersiLab  =[[UILabel alloc]init];
    [versiView addSubview:showVersiLab];
    showVersiLab.textColor = [UIColor colorTextBg28BlackColor];
    showVersiLab.font = Font(16);
    showVersiLab.text = @"版本更新";
    [showVersiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(versiView).offset(17);
        make.centerY.equalTo(versiView.mas_centerY);
    }];
    
    UIImageView *rightImageV = [[UIImageView alloc]init];
    [versiView addSubview:rightImageV];
    rightImageV.image =[UIImage imageNamed:@"cbl_ico_enter"];
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(versiView).offset(-12);
        make.centerY.equalTo(versiView.mas_centerY);
    }];
    
    UIView *clearView = [[UIView alloc]init];
    [self.view addSubview:clearView];
    clearView.backgroundColor = [UIColor colorTextWhiteColor];
    [clearView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versiView.mas_bottom).offset(1);
        make.width.height.equalTo(versiView);
        make.centerX.equalTo(versiView.mas_centerX);
    }];
    UITapGestureRecognizer *clearTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclearTap)];
    [clearView addGestureRecognizer:clearTap];
    
    
    UILabel *showClearLab  =[[UILabel alloc]init];
    [clearView addSubview:showClearLab];
    showClearLab.textColor = [UIColor colorTextBg28BlackColor];
    showClearLab.font = Font(16);
    showClearLab.text = @"清除缓存";
    [showClearLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showVersiLab.mas_left);
        make.centerY.equalTo(clearView.mas_centerY);
    }];
    
    UIImageView *rightClaerImageV = [[UIImageView alloc]init];
    [clearView addSubview:rightClaerImageV];
    rightClaerImageV.image =[UIImage imageNamed:@"cbl_ico_enter"];
    [rightClaerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImageV.mas_right);
        make.centerY.equalTo(clearView.mas_centerY);
    }];
    
}
//版本跟新
-(void)selectVersiTap{
    [SDShowSystemPrompView showSystemPrompStr:@"已最新版本"];
}
//清除缓存
-(void)selectclearTap{
     [[SDImageCache sharedImageCache]clearDiskOnCompletion:nil];
     [SDShowSystemPrompView showSystemPrompStr:@"清除成功"];
}






@end
