//
//  SDLeaveBtnShowView.m
//  SDSafetyManageControl
//
//  Created by tiao on 2018/5/2.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "SDLeaveBtnShowView.h"

@interface SDLeaveBtnShowView ()



@end


@implementation SDLeaveBtnShowView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView{
    
    __weak typeof(self) weakSelf = self;
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.75;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    UIView *showView = [[UIView alloc]init];
    [self addSubview:showView];
    showView.backgroundColor = [UIColor whiteColor];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@140);
        make.left.equalTo(weakSelf).offset(50);
        make.right.equalTo(weakSelf).offset(-50);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    showView.layer.cornerRadius = 15;
    showView.layer.masksToBounds = YES;
    
    UILabel *lab = [[UILabel alloc]init];
    [showView addSubview:lab];
    lab.text =@"退出平台";
    lab.font = [UIFont systemFontOfSize:17];
    //lab.textColor = [UIColor colorText33333BlackColor];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showView).offset(20);
        make.centerX.equalTo(showView.mas_centerX);
    }];
    
    self.titleLab = [[UILabel alloc]init];
    [showView addSubview:_titleLab];
    self.titleLab.text = @"";
    self.titleLab.numberOfLines = 0;
    self.titleLab.font = [UIFont systemFontOfSize:13];
    self.titleLab.textColor = [UIColor colorWithHexString:@"#6c6c6c"];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(5);
        make.left.equalTo(showView.mas_left).offset(17);
        make.right.equalTo(showView.mas_right).offset(-17);
        make.centerX.equalTo(showView.mas_centerX);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [showView addSubview:lineView];
   // lineView.backgroundColor = [UIColor lineBackGrounpColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(showView.mas_bottom).offset(-45);
        make.width.left.equalTo(showView);
        make.centerX.equalTo(showView.mas_centerX);
        make.height.equalTo(@1);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
   // [cancelBtn setTitleColor:[UIColor colorTextBlueColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.bottom.equalTo(showView);
        make.bottom.equalTo(showView);
        
    }];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];


    UIView *line1 = [[UIView alloc]init];
    [showView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cancelBtn.mas_top);
        make.left.equalTo(cancelBtn.mas_right);
        make.height.equalTo(cancelBtn.mas_height);
        make.width.equalTo(@1);
    }];
  //  line1.backgroundColor = [UIColor lineBackGrounpColor];

    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showView addSubview:trueBtn];
    [trueBtn setTitle:@"确定" forState:UIControlStateNormal];
   // [trueBtn setTitleColor:[UIColor colorTextBlueColor] forState:UIControlStateNormal];
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line1.mas_right);
        make.right.equalTo(showView);
        make.width.height.equalTo(cancelBtn);
        make.centerY.equalTo(cancelBtn.mas_centerY);
    }];
    [trueBtn addTarget:self action:@selector(trueBtn:) forControlEvents:UIControlEventTouchUpInside];

}

//取消
-(void)cancelBtn:(UIButton *) sender{
    
    [self removeFromSuperview];
}
//确定
-(void)trueBtn:(UIButton *) sender{
    self.trueBtnBlock();
    
}
//关闭显示view
-(void) closeShowView{
    [self cancelBtn:nil];
}

@end
