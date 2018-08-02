//
//  MapSearchHeaderView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "MapSearchHeaderView.h"

@interface MapSearchHeaderView ()
<
UITextFieldDelegate
>
@end

@implementation MapSearchHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    __weak typeof(self) weakSelf= self;
    
    UIView *bigBgView = [[UIView alloc]init];
    [self addSubview:bigBgView];
    bigBgView.backgroundColor = [UIColor colorTextWhiteColor];
    [bigBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bigBgView).offset(12);
        make.top.equalTo(bigBgView).offset(10);
        make.bottom.equalTo(bigBgView).offset(-10);
        make.right.equalTo(bigBgView).offset(-12);
    }];
    bgView.layer.cornerRadius = 3;
    bgView.layer.masksToBounds = YES;
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [bgView addSubview:imageV];
    imageV.image  =[UIImage imageNamed:@"ico_search"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(12);
        make.centerY.equalTo(bgView.mas_centerY);
        make.width.equalTo(@15);
    }];
    
    self.searchTextField  = [[UITextField alloc]init];
    [bgView addSubview:self.searchTextField];
    self.searchTextField.textColor = [UIColor colorTextBg28BlackColor];
    self.searchTextField.font = Font(12);
    self.searchTextField.placeholder = @"请搜索外出地点";
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(6);
        make.right.top.bottom.equalTo(bgView);
    }];
    self.searchTextField.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    self.searchBlock(textField.text);
    return YES;
}




@end
