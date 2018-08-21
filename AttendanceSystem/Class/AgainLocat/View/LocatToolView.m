//
//  LocatToolView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/19.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "LocatToolView.h"

@interface LocatToolView ()
//打卡范围
@property (nonatomic,strong) UILabel *pouncCardLab;
//显示是否正常
@property (nonatomic,strong) UIButton *normalBtn;
//地址
@property (nonatomic,strong) UILabel *addressLab;
//打卡btn
@property (nonatomic,strong) UIButton *cardBtn;
@end


@implementation LocatToolView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void)createView{
    
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorTextWhiteColor];
    
    UILabel *showNameLab  = [[UILabel alloc]init];
    [self addSubview:showNameLab];
    [showNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.top.equalTo(weakSelf).offset(KSIphonScreenH(18));
    }];
    showNameLab.text = @"我的位置";
    showNameLab.font = BFont(18);
    showNameLab.textColor = [UIColor colorTextBg28BlackColor];
    
    
    self.pouncCardLab = [[UILabel alloc]init];
    [self addSubview:self.pouncCardLab];
    
    self.pouncCardLab.font = Font(12);
    self.pouncCardLab.textColor = [UIColor colorTextBg98BlackColor];
    [self.pouncCardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showNameLab.mas_right).offset(2);
        make.centerY.equalTo(showNameLab.mas_centerY);
    }];
    NSString *nameStr =@"(在打卡范围内)";
    //设置富文本
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:nameStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorCommonGreenColor]
                         range:NSMakeRange(2, nameStr.length-4)];
    self.pouncCardLab.attributedText = attributeStr;
    self.pouncCardLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selelctTap)];
    [self.pouncCardLab addGestureRecognizer:tap];
    
    //地址
    self.addressLab = [[UILabel alloc]init];
    [weakSelf addSubview:self.addressLab];
    self.addressLab.numberOfLines = 2;
    self.addressLab.font = Font(12);
    self.addressLab.textColor = [UIColor colorTextBg98BlackColor];
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showNameLab.mas_left);
        make.top.equalTo(showNameLab.mas_bottom).offset(KSIphonScreenH(8));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(12));
    }];
  
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@1);
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(65));
    }];
    
    self.cardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.cardBtn];
    [self.cardBtn setBackgroundImage:[UIImage imageNamed:@"sfyz_btn_ksyz"] forState:UIControlStateNormal];
    [self.cardBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.cardBtn.titleLabel.font = Font(16);
    [self.cardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(14));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(25));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(25));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.height.equalTo(@(KSIphonScreenH(40)));
    }];
    [self.cardBtn addTarget:self action:@selector(selectCardAction:) forControlEvents:UIControlEventTouchUpInside];
    //开启时间
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}
-(void)updateTime{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dataFormatter stringFromDate:currentDate];
    
    //第几次打卡
    NSString *clockinNumStr = [NSString stringWithFormat:@"%@",self.dict[@"clockinNum"]];
    NSString *clockStr;
    if ([clockinNumStr isEqualToString:@"1"]) {
        clockStr = @"第一次";
    }else if ([clockinNumStr isEqualToString:@"2"]){
        clockStr = @"第二次";
    }else{
        clockStr = @"第三次";
    }
    
    //考勤类型
    NSString *isGoStr = [NSString stringWithFormat:@"%@",self.dict[@"isGo"]];
    //是上班还是下班
    NSString *clockinType = [NSString stringWithFormat:@"%@",self.dict[@"clockinType"]];
    NSString *clockinTypeStr ;
    //外勤打卡
    if ([isGoStr isEqualToString:@"2"]) {
        clockinTypeStr = @"外勤打卡";
    }else{
        if ([clockinType isEqualToString:@"1"]) {
            clockinTypeStr = @"上班打卡";
        }else{
            clockinTypeStr = @"下班打卡";
        }
    }
    [self.cardBtn setTitle:[NSString stringWithFormat:@"%@  %@%@",dateString,clockStr,clockinTypeStr] forState:UIControlStateNormal];
    
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
}
//打卡范围
-(void)selelctTap{
    self.selectLocatBlock();
}
-(void)selectCardAction:(UIButton *) sender{
    self.cardBtnBlock();
}
-(void)setMinDistance:(CGFloat)minDistance{
    _minDistance = minDistance;
}
//更新位置信息
-(void)updateAddress:(NSString *) address{
    NSString *addressStr = [NSString stringWithFormat:@" %@",address];
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:addressStr];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"dqdw_ico_zc"]; //设置图片源
    textAttachment.bounds = CGRectMake(0, -3, 30, 15);                 //设置图片位置和大小
    NSAttributedString *attrStr11 = [NSAttributedString attributedStringWithAttachment: textAttachment];
    [AttributedStr1 insertAttributedString: attrStr11 atIndex: 0]; //NSTextAttachment占用一个字符长度，插入后原字符串长度增加1
    self.addressLab.attributedText = AttributedStr1;
}

// 更新显示状态 1/正常 2异常
-(void) updateAddressStatu:(NSString *) statu address:(NSString *)address isGo:(NSString *)isGoStr{
    
    NSString *addressStr = [NSString stringWithFormat:@" %@",address];
     //判断是否是外勤  1正常 2外勤 3公共
    if ([isGoStr isEqualToString:@"2"]) {
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString: addressStr];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"dqdw_ico_wq"]; //设置图片源
        textAttachment.bounds = CGRectMake(0, -3, 30, 15);                 //设置图片位置和大小
        NSAttributedString *attrStr11 = [NSAttributedString attributedStringWithAttachment: textAttachment];
        [AttributedStr1 insertAttributedString: attrStr11 atIndex: 0]; //NSTextAttachment占用一个字符长度，插入后原字符串长度增加1
        self.addressLab.attributedText = AttributedStr1;
    }else{
        if ([statu isEqualToString:@"1"]) {
            NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString: addressStr];
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"dqdw_ico_zc"]; //设置图片源
            textAttachment.bounds = CGRectMake(0, -3, 30, 15);                 //设置图片位置和大小
            NSAttributedString *attrStr11 = [NSAttributedString attributedStringWithAttachment: textAttachment];
            [AttributedStr1 insertAttributedString: attrStr11 atIndex: 0]; //NSTextAttachment占用一个字符长度，插入后原字符串长度增加1
            self.addressLab.attributedText = AttributedStr1;
        }else{
            NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString: addressStr];
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"dqdw_ico_yc"]; //设置图片源
            textAttachment.bounds = CGRectMake(0, 0, 30, 15);                 //设置图片位置和大小
            NSAttributedString *attrStr11 = [NSAttributedString attributedStringWithAttachment: textAttachment];
            [AttributedStr1 insertAttributedString: attrStr11 atIndex: 0]; //NSTextAttachment占用一个字符长度，插入后原字符串长度增加1
            self.addressLab.attributedText = AttributedStr1;
            
            //距离最近的考勤范围
            NSString *nameStr ;
            if (self.minDistance > 1000) {
                nameStr =[NSString stringWithFormat:@"(距最近的考勤范围%.1fkm)",self.minDistance/1000];
            }else{
                nameStr =[NSString stringWithFormat:@"(距最近的考勤范围%.1fm)",self.minDistance];
            }
            //设置富文本
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:nameStr];
            [attributeStr addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorCommonGreenColor]
                                 range:NSMakeRange(5, 4)];
            self.pouncCardLab.attributedText = attributeStr;
            
        }
    }
}



@end
