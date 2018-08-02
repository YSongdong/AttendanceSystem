//
//  AlterPassNumberController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/14.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AlterPassNumberController.h"

#import "SDLoginController.h"

#import "SDRootNavigationController.h"
#import "HomeViewController.h"
#import "LeftUserController.h"

@interface AlterPassNumberController ()
<
REFrostedViewControllerDelegate,
UITextFieldDelegate
>
//原密码
@property (nonatomic,strong) UITextField *oldPsdTF;
//新密码
@property (nonatomic,strong) UITextField *newsPsdTF;
//新密码
@property (nonatomic,strong) UITextField *truePsdTF;

@end

@implementation AlterPassNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建Navi
    [self createNavi];
    //创建view
    [self createView];
}
   //创建Navi
-(void) createNavi{
     self.customNavBar.title = @"修改登录密码";
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
    NSArray *arr = @[@"原密码",@"新密码",@"确认密码"];
    NSArray *palaceArr = @[@"请输入旧密码",@"新密码",@"确认密码"];
    for (int i=0; i<3; i++) {
        UIView * numberView = [[UIView alloc]init];
        [self.view addSubview:numberView];
        numberView.tag =  200 +i;
        numberView.backgroundColor = [UIColor colorTextWhiteColor];
        [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).offset(KSNaviTopHeight+16+i*60);
            make.left.right.equalTo(weakSelf.view);
            make.height.equalTo(@60);
            make.centerX.equalTo(weakSelf.view.mas_centerX);
        }];
        
        UILabel *lab = [[UILabel alloc]init];
        [numberView addSubview:lab];
        lab.font = [UIFont systemFontOfSize:16];
        lab.text =arr[i];
        lab.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(numberView).offset(21);
            make.width.equalTo(@70);
            make.centerY.equalTo(numberView.mas_centerY);
        }];
        
        UITextField *textField = [[UITextField alloc]init];
        [numberView addSubview:textField];
        textField.placeholder = palaceArr[i];
        textField.tag = 100+i;
       // textField.secureTextEntry = YES;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        textField.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        textField.font = [UIFont systemFontOfSize:16];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab.mas_right).offset(17);
            make.right.equalTo(numberView);
            make.centerY.equalTo(lab.mas_centerY);
        }];
        
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
    UIView *lastView = [self.view viewWithTag:202];
    
    if (!_isMine) {
        //首次进入显示
        NSString *homeStr = @"进入 【个人中心-个人资料】也可对用户手机号码进行绑定和修改";
        NSMutableAttributedString *attrHomeStr = [[NSMutableAttributedString alloc] initWithString:homeStr];
        [attrHomeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:[homeStr rangeOfString:homeStr]];
        //添加颜色
        [attrHomeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorCommonGreenColor]
                            range:NSMakeRange(3, 11)];
        UILabel *homeLab  =[[UILabel alloc]init];
        [self.view addSubview:homeLab];
        homeLab.numberOfLines = 0;
        homeLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        [homeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(14);
            make.left.equalTo(weakSelf.view).offset(15);
            make.right.equalTo(weakSelf.view).offset(-15);
        }];
        homeLab.attributedText = attrHomeStr;
        
        //确定按钮
        UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:trueBtn];
        [trueBtn setTitle:@"确认修改" forState:UIControlStateNormal];
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
        
        UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:homeBtn];
        [homeBtn setTitle:@"进入首页" forState:UIControlStateNormal];
        [homeBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
        homeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(trueBtn.mas_bottom).offset(15);
            make.width.equalTo(trueBtn);
            make.height.equalTo(@44);
            make.centerX.equalTo(trueBtn.mas_centerX);
        }];
        homeBtn.layer.cornerRadius = 22;
        homeBtn.layer.masksToBounds = YES;
        homeBtn.layer.borderWidth = 1;
        homeBtn.layer.borderColor = [UIColor colorCommonGreenColor].CGColor;
        [homeBtn addTarget:self action:@selector(selectHomeAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        //确定按钮
        UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:trueBtn];
        [trueBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        [trueBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
        trueBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [trueBtn setBackgroundImage:[UIImage imageNamed:@"btn_01"] forState:UIControlStateNormal];
        [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(74);
            make.left.equalTo(weakSelf.view).offset(25);
            make.right.equalTo(weakSelf.view).offset(-25);
            make.centerX.equalTo(lastView.mas_centerX);
        }];
        [trueBtn addTarget:self action:@selector(trueBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    UITextField *oldTF = [self.view viewWithTag:100];
    UITextField *newTF = [self.view viewWithTag:101];
    UITextField *trueTF = [self.view viewWithTag:102];
    if (range.length == 1 && string.length == 0) {
        return YES;
    } else if ([textField isEqual:oldTF]) {
        return oldTF.text.length < 16;
    }else if ([textField isEqual:newTF]){
        return newTF.text.length < 16;
    }else if ([textField isEqual:trueTF]){
        return trueTF.text.length < 16;
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
//确定按钮
-(void)trueBtn:(UIButton *) sender{
    UITextField *oldTF = [self.view viewWithTag:100];
    UITextField *newTF = [self.view viewWithTag:101];
    UITextField *trueTF = [self.view viewWithTag:102];
    
    if (oldTF.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入旧密码"];
        return;
    }
    if (oldTF.text.length < 6) {
        [SDShowSystemPrompView showSystemPrompStr:@"密码不少于6位"];
        return;
    }
    if (newTF.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入新密码"];
        return;
    }
    if (newTF.text.length < 6) {
        [SDShowSystemPrompView showSystemPrompStr:@"新密码不少于6位"];
        return;
    }
    if (trueTF.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入确认密码"];
        return;
    }
    if (trueTF.text.length < 6) {
        [SDShowSystemPrompView showSystemPrompStr:@"确认密码不少于6位"];
        return;
    }
    if (![newTF.text isEqualToString:trueTF.text]) {
        [SDShowSystemPrompView showSystemPrompStr:@"两次密码不一致"];
        return;
    }
    [self requestEditPassword];
}
//进入首页
-(void)selectHomeAction:(UIButton *) sender{
    [self passHome];
}
-(void)setIsMine:(BOOL)isMine{
    _isMine = isMine;
}
//进入首页
-(void) passHome{
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

#pragma mark -----  数据相关----
//修改登录密码
-(void) requestEditPassword{
    UITextField *oldTF = [self.view viewWithTag:100];
    UITextField *newTF = [self.view viewWithTag:101];
    UITextField *trueTF = [self.view viewWithTag:102];
   
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] =[SDUserInfo obtainWithUserId];
    param[@"token"] = [SDTool getNewToken];
    param[@"oldPassword"] = oldTF.text;
    param[@"newPassword"] = newTF.text;
    param[@"rePassword"] = trueTF.text;
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ALTERPASSWROD_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
             [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        [SDShowSystemPrompView showSystemPrompStr:@"用户密码修改成功"];
    
        // 自动延迟3秒执行
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            //进入首页
            if (weakSelf.isMine) {
                //删除用户信息
                [SDUserInfo delUserInfo];
                
                SDLoginController *loginVC = [[SDLoginController alloc]init];
                [weakSelf.navigationController pushViewController:loginVC animated:YES];
                
            }else{
                 [weakSelf passHome];
            }
        });
    }];
}

@end
