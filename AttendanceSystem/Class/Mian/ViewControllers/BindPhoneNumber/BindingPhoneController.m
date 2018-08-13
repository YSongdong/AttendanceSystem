//
//  BindingPhoneController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/13.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "BindingPhoneController.h"

#import "AlterPassNumberController.h"

@interface BindingPhoneController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>{
    NSTimer *_timer;
}
//发送验证码
@property (nonatomic,strong) UIButton *sendBtn;
//显示时间
@property (nonatomic,assign) NSInteger timerPage;

@end

@implementation BindingPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置Navi
    [self createNavi];
    //创建view
    [self createView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isMine) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.isMine) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
#pragma mark   -----设置Navi-----
-(void) createNavi{
    self.customNavBar.title = @"绑定手机号";
    if (_isMine) {
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
        __weak typeof(self) weakSelf = self;
        self.customNavBar.onClickLeftButton = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
}
#pragma mark -----创建view-------
-(void) createView{
    
    self.view.backgroundColor = [UIColor viewBackGrounpColor];
    
    __weak typeof(self) weakSelf = self;
    
    NSArray *labArr = @[@"手机号",@"验证码"];
    
    NSArray *arr = @[@"请输入绑定手机号码",@"请输入验证码"];
    
    for (int i=0; i<2; i++) {
        UIView * numberView = [[UIView alloc]init];
        [self.view addSubview:numberView];
        numberView.tag =  200 +i;
        numberView.backgroundColor = [UIColor colorTextWhiteColor];
        [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(KSNaviTopHeight+15+i*60);
            make.left.right.equalTo(weakSelf.view);
            make.height.equalTo(@60);
            make.centerX.equalTo(weakSelf.view.mas_centerX);
        }];
        
        UILabel *lab = [[UILabel alloc]init];
        [numberView addSubview:lab];
        lab.font = [UIFont systemFontOfSize:16];
        lab.text =labArr[i];
        lab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(numberView).offset(21);
            make.width.equalTo(@70);
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
            make.left.equalTo(lab.mas_right).offset(17);
            make.right.equalTo(numberView);
            make.centerY.equalTo(lab.mas_centerY);
        }];
        if (i== 0 ) {
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
        
        UIView *lineView = [[UIView alloc]init];
        [numberView addSubview:lineView];
        lineView.backgroundColor = [UIColor viewBackGrounpColor];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.top.equalTo(numberView.mas_bottom).offset(-1);
            make.left.equalTo(numberView).offset(5);
            make.right.equalTo(numberView).offset(-5);
            make.centerX.equalTo(numberView.mas_centerX);
        }];
        
    }
    //找到最后一个view
    UIView *lastView = [self.view viewWithTag:201];
    
    //说明
    NSString *markStr = @"说明: 用户绑定手机号码成功后，不仅支持账号+密码登录，还可新增两种登录方式：①绑定手机号码+密码登录；②绑定手机号+验证码登录";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:markStr];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f]
                    range:[markStr rangeOfString:markStr]];
    //添加颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorCommonGreenColor]
                    range:NSMakeRange(0, 3)];
    UILabel *markLab = [[UILabel alloc]init];
    [self.view addSubview:markLab];
    markLab.numberOfLines = 0;
    markLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [markLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(15);
        make.top.equalTo(lastView.mas_bottom).offset(15);
        make.right.equalTo(weakSelf.view).offset(-15);
    }];
    [markLab sizeToFit];
    markLab.attributedText = attrStr;
    
    if (!_isMine) {
        //首次进入显示
        NSString *homeStr = @"进入 【个人中心-个人资料】也可对用户手机号码进行绑定和修改";
        NSMutableAttributedString *attrHomeStr = [[NSMutableAttributedString alloc] initWithString:homeStr];
        [attrHomeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f]
                            range:[homeStr rangeOfString:homeStr]];
        //添加颜色
        [attrHomeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorCommonGreenColor]
                            range:NSMakeRange(3, 11)];
        UILabel *homeLab  =[[UILabel alloc]init];
        [self.view addSubview:homeLab];
        homeLab.numberOfLines = 0;
        homeLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        [homeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(markLab.mas_bottom).offset(14);
            make.left.equalTo(weakSelf.view).offset(15);
            make.right.equalTo(weakSelf.view).offset(-15);
        }];
        homeLab.attributedText = attrHomeStr;
        
        //确定按钮
        UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:trueBtn];
        [trueBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
        [trueBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
        trueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [trueBtn setBackgroundImage:[UIImage imageNamed:@"btn_01"] forState:UIControlStateNormal];
        [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(homeLab.mas_bottom).offset(74);
            make.left.equalTo(weakSelf.view).offset(25);
            make.right.equalTo(weakSelf.view).offset(-25);
            make.centerX.equalTo(lastView.mas_centerX);
        }];
        [trueBtn addTarget:self action:@selector(trueBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *uBindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:uBindBtn];
        [uBindBtn setTitle:@"暂不绑定" forState:UIControlStateNormal];
        [uBindBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
        uBindBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [uBindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(trueBtn.mas_bottom).offset(15);
            make.width.equalTo(trueBtn);
            make.height.equalTo(@44);
            make.centerX.equalTo(trueBtn.mas_centerX);
        }];
        uBindBtn.layer.cornerRadius = 22;
        uBindBtn.layer.masksToBounds = YES;
        uBindBtn.layer.borderWidth = 1;
        uBindBtn.layer.borderColor = [UIColor colorCommonGreenColor].CGColor;
        [uBindBtn addTarget:self action:@selector(selectdUbindAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        //确定按钮
        UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:trueBtn];
        [trueBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
        [trueBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
        trueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [trueBtn setBackgroundImage:[UIImage imageNamed:@"btn_01"] forState:UIControlStateNormal];
        [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(markLab.mas_bottom).offset(74);
            make.left.equalTo(weakSelf.view).offset(25);
            make.right.equalTo(weakSelf.view).offset(-25);
            make.centerX.equalTo(lastView.mas_centerX);
        }];
        [trueBtn addTarget:self action:@selector(trueBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
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
//暂不绑定手机
-(void)selectdUbindAction:(UIButton *) sender{
    AlterPassNumberController *passVC = [[AlterPassNumberController alloc]init];
    passVC.isMine = self.isMine;
    [self.navigationController pushViewController:passVC animated:YES];
}
//发送验证码
-(void)selectSendBtn:(UIButton *) sender{
    UITextField *textfield = [self.view viewWithTag:100];
    
    if (textfield.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入手机号"];
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
    if (phoneTF.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入绑定手机号码"];
        return;
    }
    if (codeTF.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入验证码"];
        return;
    }
    [self requestEditPhone];
}
-(void)setIsMine:(BOOL)isMine{
    _isMine  = isMine;
}
-(void)setUserID:(NSString *)userID{
    _userID = userID;
}
#pragma mark - ------手势事件方法----
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //YES：允许右滑返回  NO：禁止右滑返回
    if (_isMine) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark -----  数据相关----
//修改手机号码
-(void) requestEditPhone{
    
    UITextField *phoneTF = [self.view viewWithTag:100];
    UITextField *codeTF = [self.view viewWithTag:101];
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] =phoneTF.text;
    param[@"code"] = codeTF.text;
    param[@"userId"] =self.userID ==  nil ? [SDUserInfo obtainWithUserId] : self.userID;
    param[@"token"] = [SDTool getNewToken];
    
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPUSERBINGPHONE_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        //保持用户修改手机号码
        [SDUserInfo alterNumberPhone:showdata];
        
        [SDShowSystemPrompView showSystemPrompStr:@"手机绑定成功"];
      
        // 自动延迟3秒执行
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            if (weakSelf.isMine) {
                [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }else{
                AlterPassNumberController *passVC = [[AlterPassNumberController alloc]init];
                [weakSelf.navigationController pushViewController:passVC animated:YES];
            }
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
    param[@"type"] = @"bing";
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
