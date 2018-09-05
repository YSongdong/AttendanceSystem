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
    __weak typeof(self) weakSelf = self;
    
    self.revokeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.revokeBtn];
    [self.revokeBtn setImage:[UIImage imageNamed:@"ico_cx"] forState:UIControlStateNormal];
    [self.revokeBtn setTitle:@" 撤销申请" forState:UIControlStateNormal];
    [self.revokeBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.revokeBtn.titleLabel.font = Font(15);
    self.revokeBtn.backgroundColor =[UIColor colorWithHexString:@"#f6f6f6"];
    [self.revokeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    [self.revokeBtn addTarget:self action:@selector(selectRevokeAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)selectRevokeAction:(UIButton *) sender{
    self.suessRevokeBlock();
}


@end
