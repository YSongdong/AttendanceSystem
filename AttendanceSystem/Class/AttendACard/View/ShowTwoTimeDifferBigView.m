//
//  ShowTwoTimeDifferBigView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/21.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowTwoTimeDifferBigView.h"

@implementation ShowTwoTimeDifferBigView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    
    __weak typeof(self) weakSelf = self;
    self.backgroundColor =[UIColor colorTextWhiteColor];
    
    
    UIImageView *bgImageV = [[UIImageView alloc]init];
    [self addSubview:bgImageV];
    bgImageV.image = [UIImage imageNamed:@"sjxcgd_pic"];
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(107);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    UILabel *showTimeLab = [[UILabel alloc]init];
    [self addSubview:showTimeLab];
    showTimeLab.text =@"你的手机时间与本地标准时间相差过大~";
    showTimeLab.font = Font(15);
    showTimeLab.textColor = [UIColor colorTextBg98BlackColor];
    [showTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageV.mas_bottom).offset(29);
        make.centerX.equalTo(bgImageV.mas_centerX);
    }];

    self.showStandardTimeLab = [[UILabel alloc]init];
    [self addSubview:_showStandardTimeLab];
    _showStandardTimeLab.font =Font(12);
    _showStandardTimeLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    [_showStandardTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showTimeLab.mas_bottom).offset(12);
        make.centerX.equalTo(showTimeLab.mas_centerX);
    }];
    
   
    UILabel *showIphoneTimeLab = [[UILabel alloc]init];
    [self addSubview:showIphoneTimeLab];
    showIphoneTimeLab.font =Font(12);
    showIphoneTimeLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
    [showIphoneTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showStandardTimeLab.mas_bottom).offset(6);
        make.centerX.equalTo(weakSelf.showStandardTimeLab.mas_centerX);
    }];
    
    NSString *timeStr =[NSString stringWithFormat:@"你的手机时间  %@",[self dateNowTime]];
    
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:timeStr];
    [attributStr addAttribute:NSFontAttributeName value:BFont(12)
                    range:NSMakeRange(8, timeStr.length-8)];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#cccccc"] range:NSMakeRange(0, 7)];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorTextBg28BlackColor] range:NSMakeRange(8, timeStr.length-8)];
    
    showIphoneTimeLab.attributedText = attributStr;
    

    UILabel *showTryLab  =[[UILabel alloc]init];
    [self addSubview:showTryLab];
    showTryLab.text =@"你可以通过以下尝试:";
    showTryLab.textColor = [UIColor colorCommonGreenColor];
    showTryLab.font = Font(14);
    [showTryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(40);
        make.top.equalTo(showIphoneTimeLab.mas_bottom).offset(61);
    }];
    
    UILabel *showSettingLab = [[UILabel alloc]init];
    [self addSubview:showSettingLab];
    showSettingLab.text = @"在手机系统设置-通用-日期与时间里设置为自动对时或者手动调整时间与本地时间一致";
    showSettingLab.font =  Font(12);
    showSettingLab.numberOfLines = 0;
    showSettingLab.textColor = [UIColor colorTextBg98BlackColor];
    [showSettingLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showTryLab.mas_bottom).offset(15);
        make.left.equalTo(showTryLab.mas_left);
        make.right.equalTo(weakSelf).offset(-40);
    }];
    
}

-(void)setStandTime:(double)standTime{
    _standTime = standTime;
   NSString *timeStr =[NSString stringWithFormat:@"本地标准时间  %@",[self dateTime:standTime]];
    
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:timeStr];
    [attributStr addAttribute:NSFontAttributeName value:BFont(12)
                        range:NSMakeRange(8, timeStr.length-8)];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#cccccc"] range:NSMakeRange(0, 7)];
    [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorTextBg28BlackColor] range:NSMakeRange(8, timeStr.length-8)];
    
    self.showStandardTimeLab.attributedText = attributStr;
    
}


//时间戳转换为时间
-(NSString *)dateTime:(double)timeStam{
    NSTimeInterval interval    =timeStam ;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH.mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}
//获取手机时间
-(NSString*) dateNowTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH.mm"];
    NSString *dateString       = [formatter stringFromDate: [NSDate date]];
    return dateString;
}



@end
