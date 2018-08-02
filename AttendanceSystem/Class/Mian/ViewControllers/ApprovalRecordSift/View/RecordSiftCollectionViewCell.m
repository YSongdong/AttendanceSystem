//
//  RecordSiftCollectionViewCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "RecordSiftCollectionViewCell.h"

@interface RecordSiftCollectionViewCell ()

@property (nonatomic,strong) UIButton *cellBtn;

@end

@implementation RecordSiftCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self ;
}

-(void) createView{
    __weak typeof(self) weakSelf =  self;
    
    self.cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.cellBtn];
    [self.cellBtn setTitle:@"全部" forState:UIControlStateNormal];
    [self.cellBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.cellBtn.titleLabel.font = Font(14);
    [self.cellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    self.cellBtn.layer.cornerRadius = 3;
    self.cellBtn.layer.masksToBounds = YES;
    self.cellBtn.userInteractionEnabled = NO;
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    if ([dict[@"isSelect"] isEqualToString:@"1"]) {
        //选中
        [self.cellBtn setTitle:dict[@"content"] forState:UIControlStateNormal];
        [self.cellBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
        self.cellBtn.backgroundColor = [UIColor colorWithHexString:@"#d5f6e9"];
    }else{
        //未选中
        [self.cellBtn setTitle:dict[@"content"] forState:UIControlStateNormal];
        [self.cellBtn setTitleColor:[UIColor colorTextBg98BlackColor] forState:UIControlStateNormal];
        self.cellBtn.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    }
}




@end
