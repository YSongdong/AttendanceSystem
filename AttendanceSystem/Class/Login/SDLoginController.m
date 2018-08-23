//
//  SDLoginController.m
//  SDSafetyManageControl
//
//  Created by tiao on 2018/4/11.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "SDLoginController.h"

#import "HWWeakTimer.h"
#import "SDPassWordLookForController.h"
#import "BindingPhoneController.h"
#import "AlterPassNumberController.h"

#import "SDPhotoCollectController.h"
#import "SDRootNavigationController.h"
#import "HomeViewController.h"
#import "LeftUserController.h"

typedef enum {
    SDLoginStyleAccount = 0, //账号密码登录
    SDLoginStylePhone,  // 电话登录
}SDLoginStyle;
@interface SDLoginController () <UITextFieldDelegate,REFrostedViewControllerDelegate>{
    NSTimer *_timer;
}

//账号
@property (nonatomic,strong) UITextField *phoneTF;
//发送验证码
@property (nonatomic,strong) UIButton *sendBtn;
//密码
@property (nonatomic,strong) UITextField *passwordTF;
//表示登录type
@property (nonatomic,assign) SDLoginStyle loginType;
//登录按钮
@property (nonatomic,strong) UIButton *loginBtn;
//忘记密码
@property (nonatomic,strong) UIButton *forgetPsdBtn;
//隐藏、显示密码
@property (nonatomic,strong) UIButton *hidePassBtn;

//切换按钮
@property (nonatomic,strong) UIButton *cutTypeBtn;

@property (nonatomic,strong) NSString *type;
//显示时间
@property (nonatomic,assign) NSInteger timerPage;

//记录userID
@property (nonatomic,strong) NSString *userID;

@end

@implementation SDLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.type = @"account";
    //设置导航栏
    [self createNavi];
    //创建ui
    [self createView];
}
-(void) createNavi{
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    self.customNavBar.rightButton.hidden= YES;
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
-(void) createView{
    __weak typeof(self) weakSelf = self;
    
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    //大背景
    UIImageView *bigImageV = [[UIImageView alloc]init];
    [bgView addSubview:bigImageV];
    bigImageV.image = [UIImage imageNamed:@"dl_bg"];
    [bigImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView);
    }];
    
    UIImageView *logoImageV = [[UIImageView alloc]init];
    [bgView addSubview:logoImageV];
    logoImageV.image = [UIImage imageNamed:@"dl_logo"];
    logoImageV.contentMode = UIViewContentModeScaleAspectFit;
    [logoImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(KSIphonScreenH(KSNaviTopHeight)+KSIphonScreenH(21));
        make.centerX.equalTo(bgView.mas_centerX);
    }];
    
    //账号
    UIView *phoneView = [[UIView alloc]init];
    [bgView addSubview:phoneView];
    phoneView.backgroundColor =[UIColor colorWithHexString:@"#69cbb4"];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageV.mas_bottom).offset(KSIphonScreenH(85));
        make.left.equalTo(bgView).offset(KSIphonScreenW(25));
        make.right.equalTo(bgView).offset(-KSIphonScreenW(25));
        make.height.equalTo(@(KSIphonScreenH(44)));
    }];
    phoneView.layer.cornerRadius = KSIphonScreenH(22);
    phoneView.layer.masksToBounds = YES;

    UIImageView *leftImageV = [[UIImageView alloc]init];
    [phoneView addSubview:leftImageV];
    leftImageV.tag =300;
    leftImageV.image = [UIImage imageNamed:@"att_login_account_num"];
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView).offset(KSIphonScreenW(22));
        make.width.equalTo(@(KSIphonScreenW(15)));
        make.centerY.equalTo(phoneView.mas_centerY);
    }];

    self.phoneTF= [[UITextField alloc]init];
    [phoneView addSubview:self.phoneTF];
    self.phoneTF.delegate = self;
    self.phoneTF.returnKeyType =UIReturnKeyDone;
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageV.mas_right).offset(KSIphonScreenW(12));
        make.top.bottom.right.equalTo(phoneView);
        make.centerY.equalTo(phoneView.mas_centerY);
    }];
    self.phoneTF.placeholder = @"请输入员工工号/绑定手机号";
    //设置颜色和大小
    [ self.phoneTF setValue:[UIColor colorTextWhiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [ self.phoneTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    self.phoneTF.textColor = [UIColor colorTextBg28BlackColor];
    self.phoneTF.font = Font(15);
    
    //显示清空按钮
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.tag = 200;
    [clearButton addTarget:self action:@selector(clearButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
    [phoneView addSubview:clearButton];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneView).offset(-KSIphonScreenW(10));
        make.centerY.equalTo(phoneView.mas_centerY);
    }];
    clearButton.hidden = YES;
    
    //密码
    UIView *passView = [[UIView alloc]init];
    [bgView addSubview:passView];
    passView.backgroundColor =[UIColor colorWithHexString:@"#69cbb4"];
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom).offset(KSIphonScreenW(15));
        make.left.equalTo(phoneView.mas_left);
        make.height.width.equalTo(phoneView);
        make.centerX.equalTo(phoneView.mas_centerX);
    }];
    passView.layer.cornerRadius = KSIphonScreenH(22);
    passView.layer.masksToBounds = YES;

    UIImageView *leftNameImageV = [[UIImageView alloc]init];
    [passView addSubview:leftNameImageV];
    leftNameImageV.tag = 301;
    leftNameImageV.image = [UIImage imageNamed:@"att_login_account_pwd"];
    [leftNameImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passView).offset(KSIphonScreenW(22));
        make.width.equalTo(@15);
        make.centerY.equalTo(passView.mas_centerY);
    }];

    self.passwordTF= [[UITextField alloc]init];
    [passView addSubview:self.passwordTF];
    self.passwordTF.delegate = self;
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.returnKeyType =UIReturnKeyDone;
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftNameImageV.mas_right).offset(KSIphonScreenW(12));
        make.top.bottom.equalTo(passView);
        make.centerY.equalTo(passView.mas_centerY);
        make.right.equalTo(passView).offset(-KSIphonScreenW(60));
    }];
    self.passwordTF.placeholder = @"请输入员工登录密码";
    //设置颜色和大小
    [ self.passwordTF setValue:[UIColor colorTextWhiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [ self.passwordTF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];

    self.passwordTF.textColor =[UIColor colorTextBg28BlackColor];
    self.passwordTF.font = Font(15);
    
    //显示、隐藏密码
    self.hidePassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [passView addSubview:self.hidePassBtn];
    [self.hidePassBtn setImage:[UIImage imageNamed:@"ico_gb"] forState:UIControlStateNormal];
    [self.hidePassBtn setImage:[UIImage imageNamed:@"ico_xs"] forState:UIControlStateSelected];
    [self.hidePassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(passView).offset(-KSIphonScreenW(10));
        make.centerY.equalTo(passView.mas_centerY);
    }];
    [self.hidePassBtn addTarget:self action:@selector(selectHideAction:) forControlEvents:UIControlEventTouchUpInside];
     self.hidePassBtn.hidden =  YES;
    
    //显示清空按钮
    UIButton *clearPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearPassButton.tag = 201;
    [clearPassButton addTarget:self action:@selector(clearPassBtn:) forControlEvents:UIControlEventTouchUpInside];
    [clearPassButton setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
    [passView addSubview:clearPassButton];
    [clearPassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.hidePassBtn.mas_left).offset(-KSIphonScreenW(10));
        make.centerY.equalTo(passView.mas_centerY);
    }];
    clearPassButton.hidden = YES;
    
    //发送验证码
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [passView addSubview:self.sendBtn];
    [self.sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(KSIphonScreenW(101)));
        make.height.right.equalTo(passView);
        make.centerY.equalTo(passView.mas_centerY);
    }];
   
    [self.sendBtn addTarget:self action:@selector(selectSendBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn.hidden = YES;
    
   //登录
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:self.loginBtn];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = [UIColor colorTextWhiteColor];
    self.loginBtn.titleLabel.font = Font(15);
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passView.mas_bottom).offset(KSIphonScreenH(41));
        make.left.width.height.equalTo(passView);
        make.centerX.equalTo(passView.mas_centerX);
    }];
    self.loginBtn.layer.cornerRadius = KSIphonScreenH(22);
    self.loginBtn.layer.masksToBounds = YES;
    [self.loginBtn addTarget:self action:@selector(selectLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //忘记密码
    self.forgetPsdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:self.forgetPsdBtn];
    [self.forgetPsdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [self.forgetPsdBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.forgetPsdBtn.titleLabel.font = Font(12);
    [self.forgetPsdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(KSIphonScreenW(44));
        make.top.equalTo(weakSelf.loginBtn.mas_bottom).offset(KSIphonScreenH(16));
    }];
    [self.forgetPsdBtn addTarget:self action:@selector(forgetPassAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    //切换登录方式
//    self.cutTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [bgView addSubview:self.cutTypeBtn];
//    [self.cutTypeBtn setImage:[UIImage imageNamed:@"btn_enter"] forState:UIControlStateNormal];
//    [self.cutTypeBtn setTitle:@"验证码登录 " forState:UIControlStateNormal];
//    [self.cutTypeBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf.cutTypeBtn LZSetbuttonType:LZCategoryTypeLeft];
//    });
//    self.cutTypeBtn.titleLabel.font = Font(14);
//    [self.cutTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.forgetPsdBtn.mas_bottom).offset(56);
//        make.right.equalTo(bgView).offset(-25);
//        make.height.equalTo(@20);
//    }];
//    [self.cutTypeBtn addTarget:self action:@selector(selectCatAction:) forControlEvents:UIControlEventTouchUpInside];
 
}
#pragma mark ----UITextFeildDelegate---
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 1 && string.length == 0) {
        return YES;
    } else if ([textField isEqual:self.phoneTF]) {
        if ([_type isEqualToString:@"account"] ) {
            return textField.text.length < 18;
        }else{
            return textField.text.length < 11;
        }
    }else if ([textField isEqual:self.passwordTF]){
        if ([_type isEqualToString:@"account"] ) {
            return textField.text.length < 16;
        }else{
            return textField.text.length < 11;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    UIButton *clearButton = [self.view viewWithTag:200];
    clearButton.hidden = YES;
    UIButton *passBtn = [self.view viewWithTag:201];
    passBtn.hidden = YES;
    if (self.passwordTF.text.length == 0) {
        self.hidePassBtn.hidden  = YES;
    }
    return  YES;
}
// 进入编辑模式
- (void)textFieldDidBeginEditing:(UITextField*)textField{
    UIButton *clearButton = [self.view viewWithTag:200];
    UIButton *passBtn = [self.view viewWithTag:201];
    if ([self.type isEqualToString:@"account"]) {
        if (textField == self.phoneTF) {
            clearButton.hidden = NO;
        }
        if (textField == self.passwordTF) {
            self.hidePassBtn.hidden =  NO;
            passBtn.hidden = NO;
        }
    }else{
         clearButton.hidden = YES;
        self.hidePassBtn.hidden =  YES;
        passBtn.hidden = YES;
    }
   
    if (textField == self.passwordTF) {
        CGRect viewFrame =self.view.frame;
        viewFrame.origin.y -= KSIphonScreenH(80);
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = viewFrame;
        }];
    }
    if (textField == self.phoneTF) {
        CGRect viewFrame =self.view.frame;
        viewFrame.origin.y -= KSIphonScreenH(70);
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = viewFrame;
        }];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.passwordTF) {
        CGRect viewFrame =self.view.frame;
        viewFrame.origin.y +=KSIphonScreenH(80);
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = viewFrame;
        }];
    }
    if (textField == self.phoneTF) {
        CGRect viewFrame =self.view.frame;
        viewFrame.origin.y += KSIphonScreenH(70);
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = viewFrame;
        }];
    }
}
#pragma  mark -----清空按钮------
//电话号码
- (void)clearButtonDidClick: (UIButton *)button {
    self.phoneTF.text = nil;
}
-(void) clearPassBtn:(UIButton *) sender{
    self.passwordTF.text = nil;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
    UIButton *clearButton = [self.view viewWithTag:200];
    clearButton.hidden = YES;
    UIButton *passBtn = [self.view viewWithTag:201];
    passBtn.hidden = YES;
    if (self.passwordTF.text.length == 0) {
        self.hidePassBtn.hidden  = YES;
    }
}

#pragma mark ----按钮点击事件-----
//点击登录
-(void)selectLoginAction:(UIButton *) sender{
    [self.phoneTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    
    if ([self.type isEqualToString:@"account"]) {
        if (self.phoneTF.text.length == 0) {
            [SDShowSystemPrompView showSystemPrompStr:@"请输入员工工号/绑定手机号"];
            return ;
        }
        if (self.passwordTF.text.length == 0 ) {
            [SDShowSystemPrompView showSystemPrompStr:@"请输入员工登录密码"];
            return ;
        }
        if (self.passwordTF.text.length < 4) {
            [SDShowSystemPrompView showSystemPrompStr:@"密码不少于6位"];
            return;
        }
        
    }else{
        if (self.phoneTF.text.length == 0) {
            [SDShowSystemPrompView showSystemPrompStr:@"请输入绑定手机号码"];
            return ;
        }
        if (self.passwordTF.text.length == 0 ) {
            [SDShowSystemPrompView showSystemPrompStr:@"请输入验证码"];
            return ;
        }
    }
    [self requestLoginData];
}
//忘记密码
-(void)forgetPassAction:(UIButton *) sender{
    SDPassWordLookForController *passVC = [[SDPassWordLookForController alloc]init];
    [self.navigationController pushViewController:passVC animated:YES];
}
//发送验证码
-(void)selectSendBtn:(UIButton *) sender{
    if (self.phoneTF.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入手机号"];
        return ;
    }
    [self requsetTestCode];
}
//显示、隐藏密码
-(void)selectHideAction:(UIButton *) sender{
    sender.selected =! sender.selected;
    if (sender.selected) {
         self.passwordTF.secureTextEntry = NO;
    }else{
         self.passwordTF.secureTextEntry = YES;
    }
}
-(void)selectCatAction:(UIButton *) sender{
    sender.selected =! sender.selected;
     __weak typeof(self) weakSelf = self;
     UIImageView *leftImageV = [self.view viewWithTag:300];
     UIImageView *leftNameImageV  = [self.view viewWithTag:301];
    if (sender.selected) {
        self.type = @"phone";
        
        //清空
        self.passwordTF.text =  nil;
        self.phoneTF.text = nil;
        
        leftImageV.image = [UIImage imageNamed:@"ico_sj"];
        self.phoneTF.placeholder = @"请输入绑定手机号码";
        self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        
        leftNameImageV.image = [UIImage imageNamed:@"ico_yzm"];
        self.passwordTF.placeholder = @"请输入验证码";
        self.hidePassBtn.hidden = YES;
        
        //隐藏忘记密码
        self.forgetPsdBtn.hidden = YES;
        //显示发送按钮
        self.sendBtn.hidden = NO;
        
        //显示明文
        self.passwordTF.secureTextEntry = NO;
        
        [self.cutTypeBtn setImage:[UIImage imageNamed:@"btn_enter"] forState:UIControlStateNormal];
        [self.cutTypeBtn setTitle:@"账户密码登录 " forState:UIControlStateNormal];
        [self.cutTypeBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.cutTypeBtn LZSetbuttonType:LZCategoryTypeLeft];
        });
        
    }else{
         self.type = @"account";
        
        //清空
        self.passwordTF.text =  nil;
        self.phoneTF.text = nil;
        
        leftImageV.image = [UIImage imageNamed:@"att_login_account_num"];
        self.phoneTF.placeholder = @"请输入员工身份证号码/绑定手机号";
        self.phoneTF.keyboardType = UIKeyboardTypeDefault;
        
        leftNameImageV.image = [UIImage imageNamed:@"att_login_account_pwd"];
        self.passwordTF.placeholder = @"请输入员工登录密码";
        
        //隐藏忘记密码
        self.forgetPsdBtn.hidden = NO;
        //显示发送按钮
        self.sendBtn.hidden = YES;
    
        [self.cutTypeBtn setImage:[UIImage imageNamed:@"btn_enter"] forState:UIControlStateNormal];
        [self.cutTypeBtn setTitle:@"验证码登录 " forState:UIControlStateNormal];
        [self.cutTypeBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.cutTypeBtn LZSetbuttonType:LZCategoryTypeLeft];
        });
    }
}
//时间实现方法
-(void)repeat
{
    if (self.timerPage > 0) {
        self.timerPage --;
        [self.sendBtn setTitle:[NSString stringWithFormat:@"%ld%@",(long)self.timerPage,@"S"] forState:UIControlStateNormal];
    }else{
        //启动
        self.sendBtn.enabled = YES;
        [self.sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
    }
}
//判断是否是首次登录
-(void) passHome:(NSString *)photoStatusStr{
    if ([photoStatusStr isEqualToString:@"1"]) {
        NSString *photoStatusStr = [SDUserInfo obtainWithPotoStatus];
        if ([photoStatusStr isEqualToString:@"4"]) {
             //未上传照片
            SDPhotoCollectController *photoVC = [[SDPhotoCollectController alloc]init];
            [self.navigationController pushViewController:photoVC animated:YES];
            return ;
        }
        NSString *isBindPhoneStr = [SDUserInfo obtainWithBindPhone];
        if ([isBindPhoneStr isEqualToString:@"2"]) {
            //未绑定手机号
            BindingPhoneController *bindVC = [[BindingPhoneController alloc]init];
            bindVC.isMine = NO;
            [self.navigationController pushViewController:bindVC animated:YES];
            return ;
        }
        AlterPassNumberController *passVC = [[AlterPassNumberController alloc]init];
        passVC.isMine =  NO;
        [self.navigationController pushViewController:passVC animated:YES];
        
    }else{
        //否则直接进入应用
        SDRootNavigationController *leftVC = [[SDRootNavigationController alloc]initWithRootViewController:[LeftUserController new]];
        
        SDRootNavigationController *rootVC = [[SDRootNavigationController alloc]initWithRootViewController:[HomeViewController new]];
        
        UITabBarController *tarBarCtr=[[UITabBarController alloc]init];
        [tarBarCtr setViewControllers:[NSArray arrayWithObjects:rootVC, nil]];
        //侧边栏
        REFrostedViewController *rostedViewController = [[REFrostedViewController alloc] initWithContentViewController:tarBarCtr menuViewController:leftVC];
        rostedViewController.direction = REFrostedViewControllerDirectionLeft;
        rostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;
        rostedViewController.liveBlur = YES;
        rostedViewController.limitMenuViewSize = YES;
        rostedViewController.backgroundFadeAmount=0.5;
        rostedViewController.delegate = self;
        rostedViewController.menuViewSize=CGSizeMake(leftSideMeunWidth, ScreenHeight);
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdel.rootTabbarCtrV = tarBarCtr;
        appdel.window.rootViewController =rostedViewController;
    }
}
#pragma mark ---- 数据相关----
-(void) requestLoginData{
    
    if ([self.type isEqualToString:@"account"]) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"username"] =self.phoneTF.text;
        param[@"password"] = self.passwordTF.text;
        [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPUSERLOGIN_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (error) {
                [SDShowSystemPrompView showSystemPrompStr:error];
                return ;
            }
            //删除用户信息
            [SDUserInfo delUserInfo];
            // 保存用户信息
            [SDUserInfo saveUserData:showdata];

            //设置极光推送别名
            NSString *aliasStr ;
            if ([showdata[@"userId"] isEqualToString:@"1"]) {
                aliasStr = @"one";
            }else{
                aliasStr = showdata[@"userId"];
            }
            [JPUSHService setAlias:aliasStr completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NSLog(@"---iAlias---%@-------",iAlias);
                if (iResCode == 0) {
                    NSLog(@"添加别名成功");
                }
            } seq:1];
            
            //判断是否第一次进入
            NSString *isFirstLoginStr = showdata[@"isFirstLogin"];
            [self passHome:isFirstLoginStr];
        }];
    }else{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"phone"] =self.phoneTF.text;
        param[@"code"] = self.passwordTF.text;
        param[@"userId"] = self.userID;
        [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPUSERPHONELOGIN_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
            if (error) {
                [SDShowSystemPrompView showSystemPrompStr:error];
                return ;
            }
            //删除用户信息
            [SDUserInfo delUserInfo];
            // 保存用户信息
            [SDUserInfo saveUserData:showdata];
            
            //判断是否第一次进入
            NSString *isFirstLoginStr = showdata[@"isFirstLogin"];
            [self passHome:isFirstLoginStr];
    
        }];
    }
}
-(void)requsetTestCode{
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] =self.phoneTF.text;
    param[@"type"] = @"login";
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPUSERSENDSMS_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (!error) {
            //提示信息
           [SDShowSystemPrompView showSystemPrompStr:@"获取成功"];
            
            weakSelf.timerPage = 60;
            
            self->_timer = [HWWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeat)userInfo:nil repeats:YES];
            //禁用
            self.sendBtn.enabled = NO;
            
            weakSelf.userID = showdata[@"userId"];
            
        }else{
            //提示信息
            [SDShowSystemPrompView showSystemPrompStr:error];
        }
    }];
}




@end
