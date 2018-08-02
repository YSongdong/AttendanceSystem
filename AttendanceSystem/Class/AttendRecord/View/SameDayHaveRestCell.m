//
//  SameDayHaveRestCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/26.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SameDayHaveRestCell.h"

@implementation SameDayHaveRestCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [self addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"pic_wdk"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(20);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    UILabel *showLab = [[UILabel alloc]init];
    [self addSubview:showLab];
    showLab.text =@"还未到打卡时段";
    showLab.textColor = [UIColor colorTextBg98BlackColor];
    showLab.font = Font(14);
    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(17);
        make.centerX.equalTo(imageV.mas_centerX);
    }];
    
//    UIButton *buCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:buCardBtn];
//    [buCardBtn setTitle:@"申请补卡>" forState:UIControlStateNormal];
//    [buCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
//    buCardBtn.titleLabel.font = Font(12);
//    [buCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(showLab.mas_bottom).offset(24);
//        make.centerX.equalTo(showLab.mas_centerX);
//    }];
//    [buCardBtn addTarget:self action:@selector(timeUnusualUFace:) forControlEvents:UIControlEventTouchUpInside];
}
-(void) timeUnusualUFace:(UIButton *) sender{
    self.timeUnusualUFaceBuCardBlock();
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
