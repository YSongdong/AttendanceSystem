//
//  ShowRefuseReasonView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/2.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowRefuseReasonView.h"



@implementation ShowRefuseReasonView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    __weak typeof(self) weakSelf = self;
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor =[UIColor blackColor];
    bgView.alpha = 0.35;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectdTap)];
    [bgView addGestureRecognizer:tap];
    
    
    UIView *samilView = [[UIView alloc]init];
    [self addSubview:samilView];
    samilView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    [samilView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(65);
        make.right.equalTo(weakSelf).offset(-65);
        make.height.equalTo(@233);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    samilView.layer.cornerRadius = 8;
    samilView.layer.masksToBounds  = YES;
    
    UIView *subView = [[UIView alloc]init];
    [samilView addSubview:subView];
    subView.backgroundColor = [UIColor colorTextWhiteColor];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(samilView);
        make.height.equalTo(@40);
        make.centerX.equalTo(samilView.mas_centerX);
    }];
    
    UILabel *promptSubjLab = [[UILabel alloc]init];
    [subView addSubview:promptSubjLab];
    promptSubjLab.font = [UIFont boldSystemFontOfSize:17];
    promptSubjLab.textColor =[UIColor colorTextBg28BlackColor];
    promptSubjLab.text =@"提示";
    [promptSubjLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(subView.mas_centerX);
        make.centerY.equalTo(subView.mas_centerY);
    }];
    
    UIView *concetView = [[UIView alloc]init];
    [samilView addSubview:concetView];
    concetView.backgroundColor =[UIColor colorTextWhiteColor];
    [concetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subView.mas_bottom).offset(1);
        make.left.right.equalTo(samilView);
        make.height.equalTo(@50);
    }];
    
     UILabel  *showLab = [[UILabel alloc]init];
    [concetView addSubview:showLab];
    showLab.text = @"您是否确认撤销该条外出申请?";
    showLab.font = Font(14);
    showLab.numberOfLines = 0;
    showLab.textColor = [UIColor colorTextBg65BlackColor];
    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(concetView).offset(10);
        make.right.equalTo(concetView).offset(-10);
        make.centerX.equalTo(concetView.mas_centerX);
        make.centerY.equalTo(concetView.mas_centerY);
    }];
    
    UIView *refuseView =[[UIView alloc]init];
    [samilView addSubview:refuseView];
    refuseView.backgroundColor =[UIColor colorWithHexString:@"#f9f9f9"];
    [refuseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(concetView.mas_bottom).offset(1);
        make.left.right.equalTo(samilView);
         make.bottom.equalTo(samilView).offset(-46);
    }];
    
    self.refuesTextView = [[UITextView alloc]init];
    [refuseView addSubview:self.refuesTextView];
    self.refuesTextView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    self.refuesTextView.textColor =[UIColor colorTextBg65BlackColor];
    self.refuesTextView.font = Font(14);
    self.refuesTextView.delegate=self;
    self.refuesTextView.returnKeyType = UIReturnKeyDone;
    [self.refuesTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(refuseView).offset(5);
        make.right.equalTo(refuseView).offset(-5);
        make.bottom.equalTo(refuseView);
    }];
    
    self.showPlaceLab = [[UILabel alloc]init];
    [refuseView addSubview:self.showPlaceLab];
    self.showPlaceLab.text= @"请输入拒绝原因 (选填)";
    self.showPlaceLab.textColor =[UIColor colorTextBg65BlackColor];
    self.showPlaceLab.font = Font(14);
    [self.showPlaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(refuseView).offset(10);
    }];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [samilView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Font(16);
    cancelBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(samilView);
        make.top.equalTo(refuseView.mas_bottom).offset(1);
    }];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [samilView addSubview:trueBtn];
    [trueBtn setTitle:@"确认" forState:UIControlStateNormal];
    [trueBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    trueBtn.titleLabel.font = Font(16);
    trueBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cancelBtn.mas_right).offset(1);
        make.right.equalTo(samilView);
        make.width.height.equalTo(cancelBtn);
        make.centerY.equalTo(cancelBtn.mas_centerY);
    }];
    [trueBtn addTarget:self action:@selector(tureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        
        if (textView.text.length == 0) {
            self.showPlaceLab.hidden = NO;
        }else{
            self.showPlaceLab.hidden = YES;
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    if (text.length > 0) {
        self.showPlaceLab.hidden = YES;
    }else{
        if (self.refuesTextView.text.length == 0) {
            self.showPlaceLab.hidden = NO;
        }
    }
    return YES;
}
-(void)selectdTap{
    [self removeFromSuperview];
}
-(void)cancelBtnAction:(UIButton *) sender{
    [self selectdTap];
}
-(void)tureBtnAction:(UIButton *) sender{
    
    self.trueBlock();
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.refuesTextView resignFirstResponder];
}



@end
