//
//  SDSettingViewController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/17.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SDSettingViewController.h"

#import "UpdateVersionView.h"

@interface SDSettingViewController ()
//升级版本view
@property (nonatomic,strong) UpdateVersionView *updateVersionView;
//
@property (nonatomic,strong) UILabel *updateLab;


@end

@implementation SDSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkVersion];
}
//创建Navi
-(void) createNavi{
    self.customNavBar.title = @"设置";
    self.customNavBar.rightButton.hidden= YES;
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
    
    self.updateLab = [[UILabel alloc]init];
    [versiView addSubview:self.updateLab];
    self.updateLab.textColor = [UIColor colorTextBg98BlackColor];
    self.updateLab.font = Font(13);
    [self.updateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImageV.mas_left).offset(-9);
        make.centerY.equalTo(rightImageV.mas_centerY);
    }];
    self.updateLab.text = @"";
    self.updateLab.hidden = YES;
    
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
    if (self.updateLab.hidden) {
        [SDShowSystemPrompView showSystemPrompStr:@"已最新版本"];
        return ;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.updateVersionView];
   
    self.updateVersionView.updateBlock = ^{
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E4%BA%91%E6%97%B6%E9%99%85/id1422609325?mt=8"]];
    };
}
//清除缓存
-(void)selectclearTap{
     [[SDImageCache sharedImageCache]clearDiskOnCompletion:nil];
     [SDShowSystemPrompView showSystemPrompStr:@"清除成功"];
}
//检查更新
-(void)checkVersion
{
    NSString *newVersion;
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=1422609325"];//这个URL地址是该app在iTunes connect里面的相关配置信息。其中id是该app在app store唯一的ID编号。
    NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    // NSLog(@"通过appStore获取的数据信息：%@",jsonResponseString);
    
    NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
    
    //获取本地软件的版本号
    NSString *localVersion =  [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    if (data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = json[@"results"];
        
        for (NSDictionary *dic in array) {
            
            newVersion = [dic valueForKey:@"version"];
        }
        //对比发现的新版本和本地的版本
        if (![newVersion  isEqualToString:localVersion]){
             self.updateLab.hidden = NO;
             self.updateLab.text = [NSString stringWithFormat:@"V%@版",newVersion];
        }else{
            self.updateLab.hidden = YES;
            self.updateLab.text = @"";
        }
    }
}

-(UpdateVersionView *)updateVersionView{
    if (!_updateVersionView) {
        _updateVersionView  =[[UpdateVersionView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _updateVersionView;
}





@end
