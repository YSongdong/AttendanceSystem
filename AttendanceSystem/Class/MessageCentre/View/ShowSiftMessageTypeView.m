//
//  ShowSiftMessageTypeView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/9.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowSiftMessageTypeView.h"

@implementation ShowSiftMessageTypeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    __weak typeof(self) weakSelf = self;
    
    UIView *bigBgView = [[UIView alloc]init];
    [self addSubview:bigBgView];
    bigBgView.backgroundColor = [UIColor blackColor];
    bigBgView.alpha = 0.35;
    [bigBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [bigBgView addGestureRecognizer:tap];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(weakSelf);
        make.height.equalTo(@143);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorTextBg28BlackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Font(18);
    cancelBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bgView);
        make.height.equalTo(@44);
    }];
    [cancelBtn addTarget:self action:@selector(selectCancelActtion:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)selectTap{
    [self removeFromSuperview];
}

-(void)selectCancelActtion:(UIButton *) sender{
    [self removeFromSuperview];
}

@end
