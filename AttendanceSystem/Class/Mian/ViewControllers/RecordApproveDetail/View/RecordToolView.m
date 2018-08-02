//
//  RecordToolView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "RecordToolView.h"

@implementation RecordToolView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    __weak typeof(self) weakSelf= self;
    
    self.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    
    self.revokeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.revokeBtn];
    [self.revokeBtn setTitle:@"撤销" forState:UIControlStateNormal];
    [self.revokeBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.revokeBtn.titleLabel.font = Font(15);
    self.revokeBtn.backgroundColor =[UIColor colorWithHexString:@"#f6f6f6"];
    [self.revokeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf).offset(1);
    }];
    [self.revokeBtn addTarget:self action:@selector(selectRevokeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.urgentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.urgentBtn];
    [self.urgentBtn setTitle:@"催办" forState:UIControlStateNormal];
    [self.urgentBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.urgentBtn.titleLabel.font = Font(15);
    self.urgentBtn.backgroundColor =[UIColor colorCommonGreenColor];
    [self.urgentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf.revokeBtn.mas_right);
        make.width.height.equalTo(weakSelf.revokeBtn);
        make.centerY.equalTo(weakSelf.revokeBtn.mas_centerY);
    }];
    [self.urgentBtn addTarget:self action:@selector(selectUrgentAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)selectRevokeAction:(UIButton *) sender{
    self.RevokeBlock();
}
-(void)selectUrgentAction:(UIButton *) sender{
    self.UrgentBlock();
}


@end
