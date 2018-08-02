//
//  ShowBlankSpaceView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/2.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowBlankSpaceView.h"

@implementation ShowBlankSpaceView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    
    __weak typeof(self) weakSelf = self;
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [self addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"kqjl_pic_xx"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    UILabel *showLab = [[UILabel alloc]init];
    [self addSubview:showLab];
    showLab.text =@"暂无相关记录~";
    showLab.textColor = [UIColor colorTextBg98BlackColor];
    showLab.font = Font(14);
    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(18);
        make.centerX.equalTo(imageV.mas_centerX);
    }];
    
    
}





@end
