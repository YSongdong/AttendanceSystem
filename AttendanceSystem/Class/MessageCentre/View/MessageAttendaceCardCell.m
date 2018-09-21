//
//  MessageAttendaceCardCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/9.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "MessageAttendaceCardCell.h"

@interface MessageAttendaceCardCell ()
//提示时间
@property (nonatomic,strong) UILabel *remindTimeLab;
//
@property (nonatomic,strong) UIImageView *leftImageV;

@property (nonatomic,strong) UILabel *showAttendLab;
//显示contentType
@property (nonatomic,strong) UILabel *showContentTypeLab;
//补卡班次
@property (nonatomic,strong) UILabel *cardNumberLab;
//补卡原因
@property (nonatomic,strong) UILabel *cardReasonLab;

@end


@implementation MessageAttendaceCardCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    __weak typeof(self) weakSelf = self;
    
    self.backgroundColor =[UIColor colorCommonf2GreyColor];
    
    UIView *timeView = [[UIView alloc]init];
    [self addSubview:timeView];
    timeView.backgroundColor = [UIColor colorWithHexString:@"#d8d8d8"];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(12);
        make.height.equalTo(@19);
        make.width.equalTo(@125);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    self.remindTimeLab  =[[UILabel alloc]init];
    [timeView addSubview:self.remindTimeLab];
    self.remindTimeLab.text = @"2018.02.03 12:30:30";
    self.remindTimeLab.textColor =[ UIColor colorTextWhiteColor];
    self.remindTimeLab.font = Font(12);
    [self.remindTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(timeView.mas_centerX);
        make.centerY.equalTo(timeView.mas_centerY);
    }];
    
    self.leftImageV = [[UIImageView alloc]init];
    [self addSubview:self.leftImageV];
    self.leftImageV.image = [UIImage imageNamed:@"ico_kq"];
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(12);
        make.top.equalTo(timeView.mas_bottom).offset(15);
        make.width.height.equalTo(@38);
    }];
    
    self.showAttendLab = [[UILabel alloc]init];
    [self addSubview:self.showAttendLab];
    self.showAttendLab.textColor = [UIColor colorTextBg98BlackColor];
    self.showAttendLab.font = Font(12);
    self.showAttendLab.text = @"考勤打卡";
    [self.showAttendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(8);
    }];
    
    UIView *contentView = [[UIView alloc]init];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor colorTextWhiteColor];
    
    
    self.showContentTypeLab = [[UILabel alloc]init];
    [contentView addSubview:self.showContentTypeLab];
    self.showContentTypeLab.text = @"您的补卡申请已提交";
    self.showContentTypeLab.textColor = [UIColor colorTextBg28BlackColor];
    self.showContentTypeLab.font = Font(14);
    self.showContentTypeLab.numberOfLines =2;
    [self.showContentTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(15);
        make.left.equalTo(contentView).offset(10);
    }];
    
    UILabel *showBuCardNumberLab = [[UILabel alloc]init];
    [contentView addSubview:showBuCardNumberLab];
    showBuCardNumberLab.text =@"补卡班次";
    showBuCardNumberLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    showBuCardNumberLab.font = Font(12);
    [showBuCardNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showContentTypeLab.mas_bottom).offset(22);
        make.left.equalTo(weakSelf.showContentTypeLab.mas_left);
    }];
    
    self.cardNumberLab = [[UILabel alloc]init];
    [contentView addSubview:self.cardNumberLab];
    self.cardNumberLab.textColor = [UIColor colorTextBg65BlackColor];
    self.cardNumberLab.font = Font(12);
    [self.cardNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showBuCardNumberLab.mas_right).offset(10);
        make.centerY.equalTo(showBuCardNumberLab.mas_centerY);
        make.right.equalTo(contentView).offset(-10);
    }];
    
    UILabel *showCardReasonLab = [[UILabel alloc]init];
    [contentView addSubview:showCardReasonLab];
    showCardReasonLab.text = @"缺卡原因";
    showCardReasonLab.font =Font(12);
    showCardReasonLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [showCardReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showBuCardNumberLab.mas_bottom).offset(8);
        make.left.equalTo(showBuCardNumberLab.mas_left);
    }];
   
    self.cardReasonLab = [[UILabel alloc]init];
    [contentView addSubview:self.cardReasonLab];
    self.cardReasonLab.textColor = [UIColor colorTextBg65BlackColor];
    self.cardReasonLab.font = Font(12);
    [self.cardReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.cardNumberLab.mas_left);
        make.centerY.equalTo(showCardReasonLab.mas_centerY);
        make.right.equalTo(contentView).offset(-10);
    }];
    
    UIView *detaView  =[[ UIView alloc]init];
    [contentView addSubview:detaView];
    detaView.backgroundColor = [UIColor colorTextWhiteColor];
    [detaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(showCardReasonLab.mas_bottom).offset(10);
        make.height.equalTo(@33);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    [detaView addSubview:lineView];
    lineView.backgroundColor =[UIColor colorCommonf2GreyColor];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.equalTo(detaView);
        make.height.equalTo(@1);
    }];
    
    UILabel *showDetaLab =[[ UILabel alloc]init];
    [detaView addSubview:showDetaLab];
    showDetaLab.text = @"查看详情";
    showDetaLab.textColor = [UIColor colorWithHexString:@"#239566"];
    showDetaLab.font = Font(12);
    [showDetaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detaView).offset(10);
        make.centerY.equalTo(detaView.mas_centerY);
    }];
    
    UIImageView *rightImageV = [[UIImageView alloc]init];
    [detaView addSubview:rightImageV];
    rightImageV.image = [UIImage imageNamed:@"ico_cxdw_enter"];
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(detaView).offset(-10);
        make.centerY.equalTo(showDetaLab.mas_centerY);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showAttendLab.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(8);
        make.right.equalTo(weakSelf).offset(-27);
        make.bottom.equalTo(detaView.mas_bottom);
    }];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderWidth = 0.5;
    contentView.layer.borderColor = [UIColor colorWithHexString:@"#e7e7e7"].CGColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
