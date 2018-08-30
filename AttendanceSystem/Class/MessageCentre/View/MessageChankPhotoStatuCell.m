//
//  MessageChankPhotoStatuCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/23.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "MessageChankPhotoStatuCell.h"

@interface MessageChankPhotoStatuCell ()
//提示时间
@property (nonatomic,strong) UILabel *remindTimeLab;
//
@property (nonatomic,strong) UIImageView *leftImageV;

@property (nonatomic,strong) UILabel *showAttendLab;
//显示contentType
@property (nonatomic,strong) UILabel *showChankPhotoRulstLab;


@end

@implementation MessageChankPhotoStatuCell

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
        make.height.equalTo(@(KSIphonScreenH(15)));
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
    self.leftImageV.image = [UIImage imageNamed:@"ico_zpsh"];
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(12));
        make.top.equalTo(timeView.mas_bottom).offset(KSIphonScreenH(15));
        make.width.height.equalTo(@(KSIphonScreenW(38)));
    }];
    
    self.showAttendLab = [[UILabel alloc]init];
    [self addSubview:self.showAttendLab];
    self.showAttendLab.textColor = [UIColor colorTextBg98BlackColor];
    self.showAttendLab.font = Font(12);
    self.showAttendLab.text = @"照片审核结果";
    [self.showAttendLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImageV.mas_top);
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(KSIphonScreenW(8));
    }];

    UIView *contentView = [[UIView alloc]init];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor colorTextWhiteColor];
    
    UILabel *showPhotoLab = [[UILabel alloc]init];
    [contentView addSubview:showPhotoLab];
    showPhotoLab.text = @"照片审核结果";
    showPhotoLab.font = Font(16);
    showPhotoLab.textColor = [UIColor colorCommonGreenColor];
    [showPhotoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(KSIphonScreenH(10));
        make.left.equalTo(contentView).offset(KSIphonScreenW(10));
    }];
    
    self.showChankPhotoRulstLab = [[UILabel alloc]init];
    [contentView addSubview:self.showChankPhotoRulstLab];
    self.showChankPhotoRulstLab.text = @"您的用户留底照片认证";
    self.showChankPhotoRulstLab.textColor = [UIColor colorTextBg28BlackColor];
    self.showChankPhotoRulstLab.font = Font(14);
    self.showChankPhotoRulstLab.numberOfLines =0;
    [self.showChankPhotoRulstLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showPhotoLab.mas_bottom).offset(KSIphonScreenH(10));
        make.left.equalTo(showPhotoLab.mas_left);
        make.right.equalTo(contentView).offset(-KSIphonScreenW(10));
        make.bottom.equalTo(contentView).offset(-KSIphonScreenH(13));
    }];
  
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showAttendLab.mas_bottom).offset(KSIphonScreenH(5));
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(KSIphonScreenW(8));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(27));
        make.bottom.equalTo(weakSelf).offset(-KSIphonScreenH(13));
    }];
    
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    contentView.layer.borderWidth = 0.5;
    contentView.layer.borderColor = [UIColor colorWithHexString:@"#e7e7e7"].CGColor;
}

//计算cell 高度
+(CGFloat) getWithCellHeight:(NSDictionary *) dict{
    CGFloat height = 0;
    
    height += 140;
    NSString *titleStr = dict[@"title"];
    CGFloat heightText = [SDTool getLabelHeightWithText:titleStr width:KScreenW-130 font:14];
    
    height = height+heightText;

    return height;
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    //时间
    self.remindTimeLab.text = dict[@"createTime"];
    //结果
    self.showChankPhotoRulstLab.attributedText = [self getReplacementStr:dict];
}
-(NSMutableAttributedString * )getReplacementStr:(NSDictionary *)dict{
    NSString *titleStr = dict[@"title"];
    
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    
    NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([typeStr  isEqualToString:@"1"]) {
        NSRange range;
        range = [titleStr rangeOfString:@"已通过"];
        if (range.location != NSNotFound) {
            // 设置颜色
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorCommonGreenColor] range:range];
        }
    }else{
        NSRange range;
        range = [titleStr rangeOfString:@"未通过"];
        if (range.location != NSNotFound) {
            // 设置颜色
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#f75254"] range:range];
        }
    }
    return attributedStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
