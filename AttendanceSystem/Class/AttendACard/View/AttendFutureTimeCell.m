//
//  AttendFutureTimeCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/25.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AttendFutureTimeCell.h"

@interface AttendFutureTimeCell ()
//上班和时间
@property (nonatomic,strong) UILabel *showWorkTimeLab;
//left图片
@property (nonatomic,strong) UIImageView *leftImageV;
@end


@implementation AttendFutureTimeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    __weak typeof(self) weakSelf = self;
    //显示上班和时间
    self.showWorkTimeLab = [[UILabel alloc]init];
    [self addSubview:self.showWorkTimeLab];
    self.showWorkTimeLab.text = @"上班 (时间09:00)";
    self.showWorkTimeLab.font = Font(13);
    self.showWorkTimeLab.textColor = [UIColor colorTextBg65BlackColor];
    [self.showWorkTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(35);
    }];
    
    self.leftImageV =[[UIImageView alloc]init];
    [self addSubview:self.leftImageV];
    self.leftImageV.image = [UIImage imageNamed:@"pic_site_nor"];
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(12);
        make.centerY.equalTo(weakSelf.showWorkTimeLab.mas_centerY);
    }];
    
    //leftline
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor =[UIColor colorWithHexString:@"#e8e6ed"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_bottom);
        make.bottom.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf.leftImageV.mas_centerX);
        make.width.equalTo(@1);
    }];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [self addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"pic_wdk"];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(27);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    UILabel *showTimeLab = [[UILabel alloc]init];
    [self addSubview:showTimeLab];
    showTimeLab.text =@"还未到打卡时段";
    showTimeLab.font = Font(14);
    showTimeLab.textColor = [UIColor colorTextBg98BlackColor];
    [showTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(18);
        make.centerX.equalTo(imageV.mas_centerX);
    }];
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    //第几次打卡
    NSString *clockinNumStr = [NSString stringWithFormat:@"%@",dict[@"clockinNum"]];
    NSString *clockStr;
    if ([clockinNumStr isEqualToString:@"1"]) {
        clockStr = @"第一次";
    }else if ([clockinNumStr isEqualToString:@"2"]){
        clockStr = @"第二次";
    }else{
        clockStr = @"第三次";
    }
    //是上班还是下班
    NSString *clockinType = [NSString stringWithFormat:@"%@",dict[@"clockinType"]];
    NSString *clockinTypeStr ;
    if ([clockinType isEqualToString:@"1"]) {
        clockinTypeStr = @"上班打卡";
    }else{
        clockinTypeStr = @"下班班打卡";
    }
    //时间
    self.showWorkTimeLab.text = [NSString stringWithFormat:@"%@%@  (时间%@)",clockStr,clockinTypeStr,dict[@"sureTime"]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
