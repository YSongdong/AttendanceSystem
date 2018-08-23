//
//  MessageAttendaceRemindCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/9.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "MessageAttendaceRemindCell.h"

@interface MessageAttendaceRemindCell ()

//提示时间
@property (nonatomic,strong) UILabel *remindTimeLab;

//提示
@property (nonatomic,strong) UILabel *showTimeLab;

@end

@implementation MessageAttendaceRemindCell

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
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(12));
        make.height.equalTo(@(KSIphonScreenH(19)));
        make.width.equalTo(@(KSIphonScreenW(125)));
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    timeView.layer.cornerRadius = 3 ;
    timeView.layer.masksToBounds = YES;
    
    self.remindTimeLab  =[[UILabel alloc]init];
    [timeView addSubview:self.remindTimeLab];
    self.remindTimeLab.text = @"2018.02.03 12:30:30";
    self.remindTimeLab.textColor =[ UIColor colorTextWhiteColor];
    self.remindTimeLab.font = Font(12);
    [self.remindTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(timeView.mas_centerX);
        make.centerY.equalTo(timeView.mas_centerY);
    }];
    
    UIImageView *leftImageV = [[UIImageView alloc]init];
    [self addSubview:leftImageV];
    leftImageV.image = [UIImage imageNamed:@"ico_kq"];
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.top.equalTo(timeView.mas_bottom).offset(KSIphonScreenH(15));
        make.width.height.equalTo(@(KSIphonScreenH(38)));
    }];
    
    UILabel *showAttendLab = [[UILabel alloc]init];
    [self addSubview:showAttendLab];
    showAttendLab.textColor = [UIColor colorTextBg98BlackColor];
    showAttendLab.font = Font(12);
    showAttendLab.text = @"考勤打卡";
    [showAttendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftImageV.mas_top);
        make.left.equalTo(leftImageV.mas_right).offset(KSIphonScreenW(8));
    }];
    
    UIView *contentView = [[UIView alloc]init];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor colorTextWhiteColor];
    
    UILabel *showLab = [[UILabel alloc]init];
    [contentView addSubview:showLab];
    showLab.text = @"考勤打卡";
    showLab.textColor = [UIColor colorWithHexString:@"#3dbafd"];
    showLab.font = Font(16);
    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(KSIphonScreenH(15));
        make.left.equalTo(contentView).offset(KSIphonScreenW(10));
    }];
    
    self.showTimeLab = [[UILabel alloc]init];
    [contentView addSubview:self.showTimeLab];
    self.showTimeLab.textColor  = [UIColor colorTextBg28BlackColor];
    self.showTimeLab.text = @"还有10分钟就要上班了，别忘记打卡";
    self.showTimeLab.font = Font(13);
    self.showTimeLab.numberOfLines = 0;
    [self.showTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showLab.mas_left);
        make.top.equalTo(showLab.mas_bottom).offset(KSIphonScreenH(15));
        make.right.equalTo(contentView).offset(-KSIphonScreenW(10));
    }];
   
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showAttendLab.mas_bottom).offset(KSIphonScreenH(5));
        make.left.equalTo(leftImageV.mas_right).offset(KSIphonScreenW(8));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(27));
        make.bottom.equalTo(weakSelf.showTimeLab.mas_bottom).offset(15);
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
