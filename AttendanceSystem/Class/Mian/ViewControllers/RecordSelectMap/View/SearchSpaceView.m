//
//  SearchSpaceView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SearchSpaceView.h"

@implementation SearchSpaceView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void)createView{
    __weak typeof(self) weakSelf = self;
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [self addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"kqjl_pic_xx"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(50);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    UILabel *showLab = [[UILabel alloc]init];
    [self addSubview:showLab];
    showLab.text =@"无搜索结果";
    showLab.textColor = [UIColor colorTextBg98BlackColor];
    showLab.font = Font(14);
    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(17);
        make.centerX.equalTo(imageV.mas_centerX);
    }];
    
}



@end
