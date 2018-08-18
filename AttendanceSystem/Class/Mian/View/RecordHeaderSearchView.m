//
//  RecordHeaderSearchView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "RecordHeaderSearchView.h"

@interface RecordHeaderSearchView () <UITextFieldDelegate>

@end

@implementation RecordHeaderSearchView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       [self createView];
    }
    return self;
}
-(void) createView{
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor  = [UIColor colorTextWhiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(12);
        make.left.equalTo(weakSelf).offset(15);
        make.right.equalTo(weakSelf).offset(-15);
        make.bottom.equalTo(weakSelf).offset(-12);
    }];
    bgView.layer.cornerRadius = 3;
    bgView.layer.masksToBounds = YES;
    
    UIImageView *searchImageV = [[UIImageView alloc]init];
    [bgView addSubview:searchImageV];
    searchImageV.image = [UIImage imageNamed:@"ico_search"];
    [searchImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.equalTo(@15);
    }];
    
    self.searchTextField = [[UITextField alloc]init];
    [bgView addSubview:self.searchTextField];
    self.searchTextField.font = Font(13);
    self.searchTextField.textColor = [UIColor colorTextBg28BlackColor];
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.clearButtonMode=UITextFieldViewModeAlways;
    self.searchTextField.placeholder = @"请输入编号、正文内容";
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchImageV.mas_right).offset(10);
        make.top.bottom.right.equalTo(bgView);
    }];
    self.searchTextField.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    self.searchBlock(textField.text);
    return  YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}





@end
