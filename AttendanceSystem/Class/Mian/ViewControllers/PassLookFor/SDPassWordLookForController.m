//
//  SDPassWordLookForController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/16.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SDPassWordLookForController.h"

@interface SDPassWordLookForController ()
<
UITextFieldDelegate
>{
    NSTimer *_timer;
}
//发送验证码
@property (nonatomic,strong) UIButton *sendBtn;
//显示时间
@property (nonatomic,assign) NSInteger timerPage;
//记录UserID
@property (nonatomic,strong) NSString *userID;
@end

@implementation SDPassWordLookForController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createView];
}
//创建Navi
-(void) createNavi{
    self.customNavBar.title = @"密码找回";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };

}
#pragma mark -----创建view-------
-(void) createView{
    self.view.backgroundColor = [UIColor viewBackGrounpColor];
    
    __weak typeof(self) weakSelf = self;
    NSArray *arr = @[@"请输入绑定手机号码",@"请输入验证码",@"请输入新密码",@"请确认密码"];
    NSArray *imageArr = @[@"mazh_ico_sj",@"mazh_ico_yzm",@"mazh_ico_mm",@"mazh_ico_mm"];
    for (int i=0; i<arr.count; i++) {
        UIView * numberView = [[UIView alloc]init];
        [self.view addSubview:numberView];
        numberView.tag =  200 +i;
        numberView.backgroundColor = [UIColor viewBackGrounpColor];
        [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(KSNaviTopHeight+15+i*60);
            make.left.right.equalTo(weakSelf.view);
            make.height.equalTo(@60);
            make.centerX.equalTo(weakSelf.view.mas_centerX);
        }];
        
        UIImageView *leftImageV = [[UIImageView alloc]init];
        [numberView addSubview:leftImageV];
        leftImageV.image = [UIImage imageNamed:imageArr[i]];
        [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(numberView).offset(33);
            make.width.equalTo(@15);
            make.centerY.equalTo(numberView.mas_centerY);
        }];
        
        UITextField *textField = [[UITextField alloc]init];
        [numberView addSubview:textField];
        textField.placeholder = arr[i];
        textField.tag = 100+i;
        textField.delegate = self;
        textField.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        textField.font = [UIFont systemFontOfSize:16];
        textField.returnKeyType = UIReturnKeyDone;
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftImageV.mas_right).offset(15);
            make.right.equalTo(numberView);
            make.height.equalTo(numberView);
            make.centerY.equalTo(leftImageV.mas_centerY);
        }];
        if (i == 0) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 1) {
            //发送验证码
            self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.view addSubview:self.sendBtn];
            [self.sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [self.sendBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
            self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@69);
                make.height.equalTo(@27);
                make.right.equalTo(weakSelf.view).offset(-20);
                make.centerY.equalTo(textField.mas_centerY);
            }];
            self.sendBtn.layer.borderWidth = 0.5;
            self.sendBtn.layer.borderColor = [UIColor colorCommonGreenColor].CGColor;
            self.sendBtn.layer.cornerRadius = 27/2;
            self.sendBtn.layer.masksToBounds = YES;
            [self.sendBtn addTarget:self action:@selector(selectSendBtn:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        if (i== 2 || i == 3) {
            textField.secureTextEntry =  YES;
        }
    
        UIView *lineView = [[UIView alloc]init];
        [numberView addSubview:lineView];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.top.equalTo(numberView.mas_bottom).offset(-1);
            make.left.equalTo(numberView).offset(5);
            make.right.equalTo(numberView).offset(-5);
            make.centerX.equalTo(numberView.mas_centerX);
        }];
        
    }
    //找到最后一个view
    UIView *lastView = [self.view viewWithTag:203];
  
    //确定按钮
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:trueBtn];
    [trueBtn setTitle:@"确认" forState:UIControlStateNormal];
    [trueBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    trueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [trueBtn setBackgroundImage:[UIImage imageNamed:@"btn_01"] forState:UIControlStateNormal];
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(51);
        make.left.equalTo(weakSelf.view).offset(25);
        make.right.equalTo(weakSelf.view).offset(-25);
        make.centerX.equalTo(lastView.mas_centerX);
    }];
    [trueBtn addTarget:self action:@selector(trueBtn:) forControlEvents:UIControlEventTouchUpInside];
   
}

#pragma mark ----UITextFeildDelegate---
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    UITextField *phoneTF = [self.view viewWithTag:100];
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (textField == phoneTF) {
        return textField.text.length < 11;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//发送验证码
-(void)selectSendBtn:(UIButton *) sender{
    UITextField *textfield = [self.view viewWithTag:100];
    if (textfield.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入绑定手机号码"];
        return ;
    }
    [self requsetTestCode];
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
//确定按钮
-(void)trueBtn:(UIButton *) sender{
    UITextField *phoneTF = [self.view viewWithTag:100];
    UITextField *codeTF = [self.view viewWithTag:101];
    UITextField *passTF = [self.view viewWithTag:102];
    UITextField *newPassTF = [self.view viewWithTag:103];
    if (phoneTF.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入绑定手机号码"];
        return;
    }
    if (codeTF.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入验证码"];
        return;
    }
    if (passTF.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入新密码"];
        return;
    }
    if (newPassTF.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请确认密码"];
        return;
    }
    if (![newPassTF.text isEqualToString:passTF.text]) {
        [SDShowSystemPrompView showSystemPrompStr:@"两次密码输入不一致"];
        return;
    }
    [self requestEditPhone];
}

#pragma mark -----  数据相关----
-(void) requestEditPhone{
    UITextField *phoneTF = [self.view viewWithTag:100];
    UITextField *codeTF = [self.view viewWithTag:101];
    UITextField *passTF = [self.view viewWithTag:102];
    UITextField *newPassTF = [self.view viewWithTag:103];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] =phoneTF.text;
    param[@"code"] = codeTF.text;
    param[@"userId"] =self.userID ==  nil ? [SDUserInfo obtainWithUserId] : self.userID;
    param[@"password"] = passTF.text;
    param[@"rePassword"] = newPassTF.text;
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPUSERFORGETPASSWORD_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
       
        [SDShowSystemPrompView showSystemPrompStr:@"找回成功"];
        
        // 自动延迟3秒执行
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            //移除
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }];
}
//发送验证码
-(void)requsetTestCode{
    //手机号
    UITextField *textfield = [self.view viewWithTag:100];
    //取消第一响应
    [textfield resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = textfield.text;
    param[@"type"] = @"repassword";
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPUSERSENDSMS_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        
        weakSelf.userID = showdata[@"userId"];
        [SDShowSystemPrompView showSystemPrompStr:@"获取成功"];
        
        weakSelf.timerPage = 60;
        self->_timer = [HWWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repeat)userInfo:nil repeats:YES];
        self.sendBtn.enabled = NO;
    }];
}



@end
