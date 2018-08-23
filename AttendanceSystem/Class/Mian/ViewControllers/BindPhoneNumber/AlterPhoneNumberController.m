//
//  AlterPhoneNumberController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/14.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AlterPhoneNumberController.h"

#import "BindingPhoneController.h"

@interface AlterPhoneNumberController ()
<
UITextFieldDelegate
>
{
    NSTimer *_timer;
}
//密码
@property (nonatomic,strong) UITextField *codeTF;
//发送验证码
@property (nonatomic,strong) UIButton *sendBtn;
//显示时间
@property (nonatomic,assign) NSInteger timerPage;
//记录UserID
@property (nonatomic,strong) NSString *userID;
@end

@implementation AlterPhoneNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createView];
}
-(void) createNavi{
    self.customNavBar.title = @"修改绑定号码";
    self.customNavBar.rightButton.hidden= YES;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
-(void) createView{
    self.view.backgroundColor = [UIColor viewBackGrounpColor];

    __weak typeof(self) weakSelf = self;
    UIImageView *nomalImageV = [[UIImageView alloc]init];
    [self.view addSubview:nomalImageV];
    nomalImageV.image = [UIImage imageNamed:@"pic_sj"];
    [nomalImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(KSNaviTopHeight+27);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *showNameLab  =[[UILabel alloc]init];
    [self.view addSubview:showNameLab];
    showNameLab.text = @"真实姓名";
    showNameLab.font = Font(15);
    showNameLab.textColor = [UIColor colorWithHexString:@"#989898"];
    [showNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nomalImageV.mas_bottom).offset(22);
        make.left.equalTo(weakSelf.view).offset(94);
    }];
    
    UILabel *nameLab = [[UILabel alloc]init];
    [self.view addSubview:nameLab];
    nameLab.textColor = [UIColor colorTextBg28BlackColor];
    nameLab.text = [SDUserInfo obtainWithRealName];
    nameLab.font = Font(15);
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showNameLab.mas_right).offset(33);
        make.centerY.equalTo(showNameLab.mas_centerY);
    }];
    
    UILabel *showPhoneLab = [[UILabel alloc]init];
    [self.view addSubview:showPhoneLab];
    showPhoneLab.textColor =[UIColor colorWithHexString:@"#989898"];
    showPhoneLab.font = Font(15);
    showPhoneLab.text = @"已绑定手机";
    [showPhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showNameLab.mas_bottom).offset(10);
        make.left.equalTo(showNameLab.mas_left);
    }];
    
    UILabel *phoneLab = [[UILabel alloc]init];
    [self.view addSubview:phoneLab];
    phoneLab.textColor = [UIColor colorTextBg28BlackColor];
    phoneLab.text = [SDUserInfo obtainWithPhone];
    phoneLab.font = Font(15);
    [phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showPhoneLab.mas_right).offset(16);
        make.centerY.equalTo(showPhoneLab.mas_centerY);
    }];
   
    self.codeTF = [[UITextField alloc]init];
    [self.view addSubview:self.codeTF];
    self.codeTF.delegate = self;
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLab.mas_bottom).offset(40);
        make.left.equalTo(weakSelf.view).offset(25);
        make.right.equalTo(weakSelf.view).offset(-25);
        make.height.equalTo(@40);
    }];
    UIImageView *loginLeftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mazh_ico_yzm"]];
    UIView *loginLeftView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    loginLeftImage.center = loginLeftView.center;
    [loginLeftView addSubview:loginLeftImage];
    self.codeTF.leftViewMode = UITextFieldViewModeAlways;
    self.codeTF.leftView =loginLeftView;
    self.codeTF.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.codeTF.placeholder = @"请输入验证码";
    self.codeTF.font = [UIFont systemFontOfSize:15];
    
    //发送验证码
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.sendBtn];
    [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@69);
        make.height.equalTo(@27);
        make.right.equalTo(weakSelf.view).offset(-30);
        make.centerY.equalTo(weakSelf.codeTF.mas_centerY);
    }];
    self.sendBtn.layer.borderWidth = 0.5;
    self.sendBtn.layer.borderColor = [UIColor colorCommonGreenColor].CGColor;
    self.sendBtn.layer.cornerRadius = 27/2;
    self.sendBtn.layer.masksToBounds = YES;
    [self.sendBtn addTarget:self action:@selector(selectSendBtn:) forControlEvents:UIControlEventTouchUpInside];
 
    
    UIView *accountLineView = [[UIView alloc]init];
    [self.view addSubview:accountLineView];
    [accountLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.codeTF.mas_bottom);
        make.left.width.equalTo(weakSelf.codeTF);
        make.height.equalTo(@1);
        make.centerX.equalTo(weakSelf.codeTF.mas_centerX);
    }];
    accountLineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];

    //下一步
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextBtn];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_01"] forState:UIControlStateNormal];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(accountLineView.mas_bottom).offset(64);
        make.left.equalTo(weakSelf.view).offset(25);
        make.right.equalTo(weakSelf.view).offset(-25);
        make.centerX.equalTo(accountLineView.mas_centerX);
    }];
    [nextBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark ----UITextFeildDelegate---
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//发送验证码
-(void)selectSendBtn:(UIButton *) sender{
    [self requsetTestCode];
}
//下一步
-(void)nextBtn:(UIButton *) sender{
    if (self.codeTF.text.length == 0 ) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入验证码"];
        return ;
    }
    [self requestEditPhone];
}
//时间实现方法
-(void)repeat
{
    if (self.timerPage > 0) {
        self.timerPage --;
        [self.sendBtn setTitle:[NSString stringWithFormat:@"%ld%@",(long)self.timerPage,@"S"] forState:UIControlStateNormal];
    }else{
        self.sendBtn.enabled = YES;
        [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark ----数据相关----
//验证手机号码
-(void) requestEditPhone{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] =[SDUserInfo obtainWithPhone];
    param[@"code"] = self.codeTF.text;
    param[@"userId"] =self.userID ==  nil ? [SDUserInfo obtainWithUserId] : self.userID;
    param[@"token"] = [SDTool getNewToken];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPUSERISBINGPHONE_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        [SDShowSystemPrompView showSystemPrompStr:@"手机验证成功"];
        // 自动延迟3秒执行
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            BindingPhoneController *bindVC = [[BindingPhoneController alloc]init];
            bindVC.isMine = YES;
            [weakSelf.navigationController pushViewController:bindVC animated:YES];
        });
    }];
}

//发送验证码
-(void)requsetTestCode{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = [SDUserInfo obtainWithPhone];
    param[@"type"] = @"isBing";
    param[@"token"] = [SDTool getNewToken];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPUSERSENDSMS_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        
        weakSelf.userID = showdata[@"userId"];
        [SDShowSystemPrompView showSystemPrompStr:@"发送成功"];
       
        weakSelf.timerPage = 60;
        self->_timer = [HWWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeat)userInfo:nil repeats:YES];
        self.sendBtn.enabled = NO;
    }];
}



@end
