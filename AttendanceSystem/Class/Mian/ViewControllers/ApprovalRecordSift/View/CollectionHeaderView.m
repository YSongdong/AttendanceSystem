//
//  CollectionHeaderView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "CollectionHeaderView.h"

@interface CollectionHeaderView ()

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UILabel *nameLab;

@end

@implementation CollectionHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    
    __weak typeof(self) weakSelf = self;
    
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.equalTo(@1);
    }];
    
    self.nameLab = [[UILabel alloc]init];
    [self addSubview:self.nameLab];
    self.nameLab.text = @"状态";
    self.nameLab.font =  Font(16);
    self.nameLab.textColor = [UIColor colorCommonGreenColor];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(30);
        make.top.equalTo(weakSelf).offset(22);
    }];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [self addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"ico_zt"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.nameLab.mas_left).offset(-7);
        make.centerY.equalTo(weakSelf.nameLab.mas_centerY);
    }];
    
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.section == 0) {
        self.lineView.hidden = YES;
        self.nameLab.text = @"状态";
    }else{
        self.lineView.hidden = NO;
        self.nameLab.text = @"类型";
    }
}





@end
