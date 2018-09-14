//
//  RecordSuessRevokeView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/9/4.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "RecordSuessRevokeView.h"

@implementation RecordSuessRevokeView

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
    
    
    self.alterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.alterBtn];
    [self.alterBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.alterBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.alterBtn.titleLabel.font = Font(15);
    self.alterBtn.backgroundColor =[UIColor colorCommonGreenColor];
    [self.alterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf.revokeBtn.mas_right);
        make.width.height.equalTo(weakSelf.revokeBtn);
        make.centerY.equalTo(weakSelf.revokeBtn.mas_centerY);
    }];
    [self.alterBtn addTarget:self action:@selector(selectAlterAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)selectRevokeAction:(UIButton *) sender{
    self.suessRevokeBlock();
}

-(void)selectAlterAction:(UIButton *) sneder{
    self.sueccAlterBlcok();
}

@end
