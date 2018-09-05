//
//  MessageAttendaceGoOutCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/9.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "MessageAttendaceGoOutCell.h"

@interface MessageAttendaceGoOutCell ()
//提示时间
@property (nonatomic,strong) UILabel *remindTimeLab;
//
@property (nonatomic,strong) UIImageView *leftImageV;

@property (nonatomic,strong) UILabel *showAttendLab;
//显示contentType
@property (nonatomic,strong) UILabel *showContentTypeLab;
//显示开始时间
@property (nonatomic,strong) UILabel *showBeginTimeLab;
//开始时间
@property (nonatomic,strong) UILabel *beginTimeLab;
//显示结束时间
@property (nonatomic,strong) UILabel *showEndTimeLab;
//结束时间
@property (nonatomic,strong) UILabel *endTimeLab;
//显示外出原因
@property (nonatomic,strong) UILabel *showGoOutReasonLab;
//外出原因
@property (nonatomic,strong) UILabel *goOutReasonLab;
@end

@implementation MessageAttendaceGoOutCell

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
    self.remindTimeLab.text = @"";
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
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.top.equalTo(timeView.mas_bottom).offset(KSIphonScreenH(15));
        make.width.height.equalTo(@(KSIphonScreenW(38)));
    }];
    
    self.showAttendLab = [[UILabel alloc]init];
    [self addSubview:self.showAttendLab];
    self.showAttendLab.textColor = [UIColor colorTextBg98BlackColor];
    self.showAttendLab.font = Font(12);
    self.showAttendLab.text = @"考勤打卡";
    [self.showAttendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(KSIphonScreenW(8));
    }];
    
    
    UIView *contentView = [[UIView alloc]init];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor colorTextWhiteColor];
    
    self.showContentTypeLab = [[UILabel alloc]init];
    [contentView addSubview:self.showContentTypeLab];
    self.showContentTypeLab.text = @"";
    self.showContentTypeLab.textColor = [UIColor colorTextBg28BlackColor];
    self.showContentTypeLab.font = Font(14);
    self.showContentTypeLab.numberOfLines =2;
    [self.showContentTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(KSIphonScreenH(15));
        make.left.equalTo(contentView).offset(KSIphonScreenW(10));
        make.right.equalTo(contentView).offset(-KSIphonScreenW(10));
    }];
    
    self.showBeginTimeLab = [[UILabel alloc]init];
    [contentView addSubview:self.showBeginTimeLab];
    self.showBeginTimeLab.text =@"开始时间";
    self.showBeginTimeLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    self.showBeginTimeLab.font = Font(12);
    [self.showBeginTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showContentTypeLab.mas_bottom).offset(KSIphonScreenH(22));
        make.left.equalTo(weakSelf.showContentTypeLab.mas_left);
    }];
    
    self.beginTimeLab = [[UILabel alloc]init];
    [contentView addSubview:self.beginTimeLab];
    self.beginTimeLab.textColor = [UIColor colorTextBg65BlackColor];
    self.beginTimeLab.font = Font(12);
    [self.beginTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.showBeginTimeLab.mas_right).offset(KSIphonScreenW(10));
        make.centerY.equalTo(weakSelf.showBeginTimeLab.mas_centerY);
        make.right.equalTo(contentView).offset(-KSIphonScreenW(10));
    }];
    
    self.showEndTimeLab = [[UILabel alloc]init];
    [contentView addSubview:self.showEndTimeLab];
    self.showEndTimeLab.text = @"结束时间";
    self.showEndTimeLab.font =Font(12);
    self.showEndTimeLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [self.showEndTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showBeginTimeLab.mas_bottom).offset(KSIphonScreenH(8));
        make.left.equalTo(weakSelf.showBeginTimeLab.mas_left);
    }];
    
    self.endTimeLab = [[UILabel alloc]init];
    [contentView addSubview:self.endTimeLab];
    self.endTimeLab.textColor = [UIColor colorTextBg65BlackColor];
    self.endTimeLab.font = Font(12);
    [self.endTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.beginTimeLab.mas_left);
        make.centerY.equalTo(weakSelf.showEndTimeLab.mas_centerY);
        make.right.equalTo(contentView).offset(-KSIphonScreenW(10));
    }];
    
    self.showGoOutReasonLab  =[[UILabel alloc]init];
    [contentView addSubview:self.showGoOutReasonLab];
    self.showGoOutReasonLab.text = @"外出原因";
    self.showGoOutReasonLab.font =Font(12);
    self.showGoOutReasonLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [self.showGoOutReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showEndTimeLab.mas_bottom).offset(KSIphonScreenH(8));
        make.left.equalTo(weakSelf.showEndTimeLab.mas_left);
        make.right.equalTo(contentView).offset(-KSIphonScreenW(10));
    }];
    
    self.goOutReasonLab = [[UILabel alloc]init];
    [contentView addSubview:self.goOutReasonLab];
    self.goOutReasonLab.textColor = [UIColor colorTextBg65BlackColor];
    self.goOutReasonLab.font = Font(12);
    [self.goOutReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.beginTimeLab.mas_left);
        make.centerY.equalTo(weakSelf.showGoOutReasonLab.mas_centerY);
        make.right.equalTo(contentView).offset(-KSIphonScreenW(10));
    }];
    
    UIView *detaView  =[[ UIView alloc]init];
    [contentView addSubview:detaView];
    detaView.backgroundColor = [UIColor colorTextWhiteColor];
    [detaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(weakSelf.showGoOutReasonLab.mas_bottom).offset(KSIphonScreenH(10));
        make.height.equalTo(@(KSIphonScreenH(28)));
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
        make.left.equalTo(detaView).offset(KSIphonScreenW(10));
        make.centerY.equalTo(detaView.mas_centerY);
    }];
    
    UIImageView *rightImageV = [[UIImageView alloc]init];
    [detaView addSubview:rightImageV];
    rightImageV.image = [UIImage imageNamed:@"ico_cxdw_enter"];
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(detaView).offset(-KSIphonScreenW(10));
        make.centerY.equalTo(showDetaLab.mas_centerY);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showAttendLab.mas_bottom).offset(KSIphonScreenH(5));
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(KSIphonScreenW(8));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(27));
        make.bottom.equalTo(detaView.mas_bottom);
    }];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderWidth = 0.5;
    contentView.layer.borderColor = [UIColor colorWithHexString:@"#e7e7e7"].CGColor;
}
//计算cell 高度
+(CGFloat) getWithCellHeight:(NSDictionary *) dict{
    CGFloat height = 0;
    
    height += 240;
    NSString *titleStr = dict[@"title"];
    CGFloat heightText = [SDTool getLabelHeightWithText:titleStr width:KScreenW-130 font:14];
    
    height = height+heightText;
    
    return height;
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    NSInteger type =[dict[@"type"] integerValue];
    //我审批的
    if (type > 0 && type <9) {
        //时间
        self.remindTimeLab.text = dict[@"startTime"];
        
        self.showAttendLab.text = @"我审批的";
        
        self.leftImageV.image = [UIImage imageNamed:@"msg_ico_01"];
        
        //标题
        self.showContentTypeLab.attributedText =[self getAttributedText:dict[@"title"] andType:type andStatu:[dict[@"type"] integerValue]];
        
        if (type == 1 || type == 5) {
            // 请假
            //请假类型
            NSString *infoStr =[NSString stringWithFormat:@"%@",dict[@"info"]];
            NSString *type ;
            if ([infoStr isEqualToString:@"1"]) {
                type = @"年假";
            }else if ([infoStr isEqualToString:@"2"]){
                type = @"事假";
            }else if ([infoStr isEqualToString:@"3"]){
                type = @"调休";
            }else if ([infoStr isEqualToString:@"4"]){
                type = @"产假";
            }else if ([infoStr isEqualToString:@"5"]){
                type = @"婚假";
            }else if ([infoStr isEqualToString:@"6"]){
                type = @"丧假";
            }else if ([infoStr isEqualToString:@"7"]){
                type = @"护理假";
            }else if ([infoStr isEqualToString:@"8"]){
                type = @"病假";
            }else if ([infoStr isEqualToString:@"9"]){
                type = @"轮休";
            }
            self.showBeginTimeLab.text =[NSString stringWithFormat:@"请假类型 %@",type];
            //开始时间
            self.showEndTimeLab.text =[NSString stringWithFormat:@"开始时间 %@",dict[@"startTime"]];
            //结束时间
            self.showGoOutReasonLab.text =[NSString stringWithFormat:@"结束时间 %@",dict[@"endTime"]];
        }else if (type == 2 || type == 6){
            //外出
            //开始时间
            self.showBeginTimeLab.text =[NSString stringWithFormat:@"开始时间 %@",dict[@"startTime"]];
            //结束时间
            self.showEndTimeLab.text =[NSString stringWithFormat:@"结束时间 %@",dict[@"endTime"]];
            //事由
            self.showGoOutReasonLab.text =[NSString stringWithFormat:@"外出事由 %@",dict[@"info"]];
        }else if (type == 3 || type == 7){
            // 加班
            //开始时间
            self.showBeginTimeLab.text =[NSString stringWithFormat:@"开始时间 %@",dict[@"startTime"]];
            //结束时间
            self.showEndTimeLab.text =[NSString stringWithFormat:@"结束时间 %@",dict[@"endTime"]];
            //事由
            self.showGoOutReasonLab.text =[NSString stringWithFormat:@"加班事由 %@",dict[@"info"]];
        }
        
    }else if(type > 8 && type <17 )  {
        //我发起的
        //时间
        self.remindTimeLab.text = dict[@"startTime"];
        
        self.showAttendLab.text = @"我发起的";
        
        self.leftImageV.image = [UIImage imageNamed:@"ico_wfqd"];
        
        //标题
        self.showContentTypeLab.attributedText =[self getAttributedText:dict[@"title"] andType:type andStatu:[dict[@"type"] integerValue]];
       
        if (type == 9 || type == 13) {
            // 请假
            //请假类型
            NSString *infoStr =[NSString stringWithFormat:@"%@",dict[@"info"]];
            NSString *type ;
            if ([infoStr isEqualToString:@"1"]) {
                type = @"年假";
            }else if ([infoStr isEqualToString:@"2"]){
                type = @"事假";
            }else if ([infoStr isEqualToString:@"3"]){
                type = @"调休";
            }else if ([infoStr isEqualToString:@"4"]){
                type = @"产假";
            }else if ([infoStr isEqualToString:@"5"]){
                type = @"婚假";
            }else if ([infoStr isEqualToString:@"6"]){
                type = @"丧假";
            }else if ([infoStr isEqualToString:@"7"]){
                type = @"护理假";
            }else if ([infoStr isEqualToString:@"8"]){
                type = @"病假";
            }else if ([infoStr isEqualToString:@"9"]){
                type = @"轮休";
            }
            self.showBeginTimeLab.text =[NSString stringWithFormat:@"请假类型 %@",type];
            //开始时间
            self.showEndTimeLab.text =[NSString stringWithFormat:@"开始时间 %@",dict[@"startTime"]];
            //结束时间
            self.showGoOutReasonLab.text =[NSString stringWithFormat:@"结束时间 %@",dict[@"endTime"]];
        }else if (type == 10 || type == 14){
            //外出
            //开始时间
            self.showBeginTimeLab.text =[NSString stringWithFormat:@"开始时间 %@",dict[@"startTime"]];
            //结束时间
            self.showEndTimeLab.text =[NSString stringWithFormat:@"结束时间 %@",dict[@"endTime"]];
            //事由
            self.showGoOutReasonLab.text =[NSString stringWithFormat:@"外出事由 %@",dict[@"info"]];
        }else if (type == 11 || type == 15){
            // 加班
            //开始时间
            self.showBeginTimeLab.text =[NSString stringWithFormat:@"开始时间 %@",dict[@"startTime"]];
            //结束时间
            self.showEndTimeLab.text =[NSString stringWithFormat:@"结束时间 %@",dict[@"endTime"]];
            //事由
            self.showGoOutReasonLab.text =[NSString stringWithFormat:@"加班事由 %@",dict[@"info"]];
        }

    }
}
-(NSMutableAttributedString *) getAttributedText:(NSString *) text andType:(NSInteger) type andStatu:(NSInteger)statu{
    if ([text isEqualToString:@""]) {
        return nil ;
    }
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:text];
    if ([text rangeOfString:@"已同意"].location !=NSNotFound ) {
        if ([text rangeOfString:@"等待"].location != NSNotFound) {
            //已同意
            NSRange  agreeBegRange = [text rangeOfString:@"申请" options:NSLiteralSearch];
            NSRange  agreeEndRange = [text rangeOfString:@"同意" options:NSLiteralSearch];
            NSRange  agreeRange = NSMakeRange(agreeBegRange.location+2, agreeEndRange.location-agreeBegRange.location+2);
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorCommonGreenColor] range:agreeRange];
            
            //审核中
            NSRange  beginRange = [text rangeOfString:@"等待" options:NSLiteralSearch];
            NSRange  endRange = [text rangeOfString:@"审批" options:NSLiteralSearch];
            NSRange  range = NSMakeRange(beginRange.location, endRange.location-beginRange.location+2);
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffb046"] range:range];
        }else{
            //已同意
            NSRange  agreeBegRange = [text rangeOfString:@"申请" options:NSLiteralSearch];
            NSRange  agreeEndRange = [text rangeOfString:@"同意" options:NSLiteralSearch];
            NSRange  agreeRange = NSMakeRange(agreeBegRange.location+2, agreeEndRange.location-agreeBegRange.location+2);
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorCommonGreenColor] range:agreeRange];
        }
        return attributedStr;
    }
    
    if ([text rangeOfString:@"等待"].location !=NSNotFound ) {
        //审核中
        NSRange  beginRange = [text rangeOfString:@"等待" options:NSLiteralSearch];
        NSRange  endRange = [text rangeOfString:@"审批" options:NSLiteralSearch];
        NSRange  range = NSMakeRange(beginRange.location, endRange.location-beginRange.location+2);
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffb046"] range:range];
        
        return attributedStr ;
    }
    if ([text rangeOfString:@"审批未通过"].location !=NSNotFound ) {
        NSRange range = [text rangeOfString:@"审批未通过"];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#f75254"] range:range];
        
          return attributedStr;
        }
    
    if ([text rangeOfString:@"审批通过"].location !=NSNotFound) {
        NSRange range = [text rangeOfString:@"审批通过"];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorCommonGreenColor] range:range];
        return attributedStr;
    }
   
    if ([text rangeOfString:@"已撤销"].location !=NSNotFound) {
        NSRange range = [text rangeOfString:@"已撤销"];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#aaaaaa"] range:range];
        return attributedStr;
    }
    
    return nil;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
