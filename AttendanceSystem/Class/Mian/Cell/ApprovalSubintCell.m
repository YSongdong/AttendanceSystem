//
//  ApprovalSubintCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ApprovalSubintCell.h"

@implementation ApprovalSubintCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorTextWhiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(9);
        make.right.left.bottom.equalTo(weakSelf);
    }];
    
    self.subimtBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:self.subimtBtn];
    [self.subimtBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.subimtBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.subimtBtn.titleLabel.font = Font(16);
    [self.subimtBtn setBackgroundImage:[UIImage imageNamed:@"btn_01"] forState:UIControlStateNormal];
    [self.subimtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(17);
        make.left.equalTo(bgView).offset(25);
        make.right.equalTo(bgView).offset(-25);
        make.height.equalTo(@44);
    }];
    [self.subimtBtn addTarget:self action:@selector(selectSubimtAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectSubimtAction:(UIButton *) sender{
    
    self.subimtBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
