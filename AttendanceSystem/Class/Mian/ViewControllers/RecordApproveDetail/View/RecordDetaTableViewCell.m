//
//  RecordDetaTableViewCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "RecordDetaTableViewCell.h"

@interface RecordDetaTableViewCell ()


//
@property (nonatomic,strong) UIImageView *headerImageV;

@property (nonatomic,strong) UILabel *showStatusLab;

@property (nonatomic,strong) UILabel *showNameLab;

@property (nonatomic,strong) UILabel *showReasonLab;

@property (nonatomic,strong) UILabel *showTimeLab;
//层级
@property (nonatomic,strong) UILabel *showLevelLab;
@end

@implementation RecordDetaTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    
    __weak typeof(self) weakSelf = self;
    
    self.headerImageV  =[[UIImageView alloc]init];
    [self addSubview:self.headerImageV];
    self.headerImageV.image = [UIImage imageNamed:@"cbl_pic_user"];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(45);
        make.top.equalTo(weakSelf).offset(15);
        make.width.height.equalTo(@48);
    }];
    self.headerImageV.layer.cornerRadius = 24;
    self.headerImageV.layer.masksToBounds = YES;
    
    UIView *iconView = [[UIView alloc]init];
    [self addSubview:iconView];
    iconView.tag = 300;
    iconView.backgroundColor =[UIColor colorCommonGreenColor];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@10);
        make.right.equalTo(weakSelf.headerImageV.mas_left).offset(-20);
        make.centerY.equalTo(weakSelf.headerImageV.mas_centerY);
    }];
    iconView.layer.cornerRadius =5;
    iconView.layer.masksToBounds = YES;
    
    self.topLineView = [[UIView alloc]init];
    [self addSubview:self.topLineView];
    self.topLineView.backgroundColor =[UIColor colorWithHexString:@"#f6f6f6"];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(iconView.mas_top);
        make.width.equalTo(@1);
        make.centerX.equalTo(iconView.mas_centerX);
    }];
    
    self.bottomLineView =[[UIView alloc]init];
    [self addSubview:self.bottomLineView];
    self.bottomLineView.backgroundColor =[UIColor colorWithHexString:@"#f6f6f6"];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf);
        make.top.equalTo(iconView.mas_bottom);
        make.width.equalTo(@1);
        make.centerX.equalTo(iconView.mas_centerX);
    }];
    
    UIView *samilView = [[UIView alloc]init];
    [self addSubview:samilView];
    samilView.tag = 200;
    samilView.backgroundColor = [UIColor colorWithHexString:@"#d5f6e9"];
    [samilView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@17);
        make.top.equalTo(weakSelf.headerImageV.mas_bottom).offset(6);
        make.centerX.equalTo(weakSelf.headerImageV.mas_centerX);
    }];
    samilView.layer.cornerRadius = 3;
    samilView.layer.masksToBounds = YES;
    
    self.showLevelLab = [[UILabel alloc]init];
    [samilView addSubview:self.showLevelLab];
    self.showLevelLab.textColor = [UIColor colorCommonGreenColor];
    self.showLevelLab.font = Font(9);
    self.showLevelLab.textAlignment =  NSTextAlignmentCenter;
    [self.showLevelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(samilView);
        make.centerX.equalTo(samilView.mas_centerX);
        make.centerY.equalTo(samilView.mas_centerY);
    }];
    
    self.showStatusLab = [[UILabel alloc]init];
    [self addSubview:self.showStatusLab];
    self.showStatusLab.text =@"发起申请";
    self.showStatusLab.textColor = [UIColor colorTextBg28BlackColor];
    self.showStatusLab.font = Font(12);
    [self.showStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerImageV.mas_top).offset(7);
        make.left.equalTo(weakSelf.headerImageV.mas_right).offset(10);
    }];
    
    self.showTimeLab = [[UILabel alloc]init];
    [self addSubview:self.showTimeLab];
    self.showTimeLab.text =@"";
    self.showTimeLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    self.showTimeLab.font = Font(12);
    [self.showTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-12);
        make.centerY.equalTo(weakSelf.showStatusLab.mas_centerY);
    }];
    
    
    self.showNameLab = [[UILabel alloc]init];
    [self addSubview:self.showNameLab];
    self.showNameLab.text =@"";
    self.showNameLab.font = Font(11);
    self.showNameLab.numberOfLines = 3;
    self.showNameLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.showNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showStatusLab.mas_bottom).offset(9);
        make.left.equalTo(weakSelf.showStatusLab.mas_left);
        make.right.equalTo(weakSelf).offset(-12);
    }];
    
    self.showReasonLab = [[UILabel alloc]init];
    [self addSubview:self.showReasonLab];
    self.showReasonLab.textColor = [UIColor colorWithHexString:@"#656565"];
    self.showReasonLab.text =@"";
    self.showReasonLab.font = Font(11);
    self.showReasonLab.numberOfLines = 3;
    [self.showReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showNameLab.mas_bottom).offset(16);
        make.left.right.equalTo(weakSelf.showNameLab);
    }];
    
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    UIView *samilView = [self viewWithTag:200];
    samilView.hidden = NO;
    UIView *iconView = [self viewWithTag:300];
    iconView.backgroundColor =[UIColor colorWithHexString:@"#f6f6f6"];
    self.showStatusLab.hidden = NO;
    self.showTimeLab.hidden = NO;
    self.showReasonLab.hidden = NO;
    
    //主管
    NSString *levelStr = [NSString stringWithFormat:@"%@",dict[@"level"]];
    if ([levelStr isEqualToString:@"0"]) {
        NSDictionary *infoDict = dict[@"userInfo"];
        
        iconView.backgroundColor =[UIColor colorCommonGreenColor];
        
        //时间
        self.showTimeLab.text = infoDict[@"createTime"];
        //头像
        [UIImageView sd_setImageView:self.headerImageV WithURL:infoDict[@"photo"]];
        
        self.showStatusLab.text =@"发起申请";
        self.showStatusLab.textColor = [UIColor colorTextBg28BlackColor];
        
        NSArray *arr = infoDict[@"userName"];
        self.showNameLab.text = arr[0];
        self.showNameLab.textColor =[UIColor colorTextBg28BlackColor];
        
        //主管view
        samilView.hidden = YES;
        self.showReasonLab.hidden = YES;
        
    }else{
        
        NSDictionary *infoDict = dict[@"userInfo"];
        //时间
        self.showTimeLab.text = infoDict[@"createTime"];
        NSString *isShowStr = [NSString stringWithFormat:@"%@",infoDict[@"isShow"]];
        if ([isShowStr isEqualToString:@"1"]) {
            iconView.backgroundColor =[UIColor colorCommonGreenColor];
            self.showTimeLab.hidden = NO;
            self.showStatusLab.hidden = NO;
        }else{
            self.showTimeLab.hidden = YES;
            self.showStatusLab.hidden = YES;
            iconView.backgroundColor =[UIColor colorWithHexString:@"#f6f6f6"];
        }

        NSArray *arr = infoDict[@"userName"];
        NSMutableString *nameStr = [NSMutableString new];
        if (arr.count > 0 ) {
            for (int i=0; i<arr.count; i++) {
                [nameStr appendString:arr[i]];
                if (i != arr.count-1) {
                    [nameStr appendString:@"/"];
                }
            }
        }
        if (arr.count > 1) {
            //头像
            self.headerImageV.image = [UIImage imageNamed:@"pic_user"];
        }else{
            //头像
            [UIImageView sd_setImageView:self.headerImageV WithURL:infoDict[@"photo"]];
        }
       
        self.showNameLab.textColor =[UIColor colorTextBg28BlackColor];
        
        NSString *adoptStr =[NSString stringWithFormat:@"%@",infoDict[@"adopt"]];
        if ([adoptStr isEqualToString:@"3"]) {
            //未通过
            self.showStatusLab.text =@"已拒绝";
            self.showStatusLab.textColor = [UIColor colorWithHexString:@"#f76254"];
            
            self.showNameLab.text = nameStr;
            
            if ([infoDict[@"info"] isEqualToString:@""]) {
                self.showReasonLab.hidden = YES;
            }else{
                self.showReasonLab.hidden = NO;
                //原因
                self.showReasonLab.text = [NSString stringWithFormat:@"拒绝原因: %@",infoDict[@"info"]];
            }
        }else if ([adoptStr isEqualToString:@"2"]){
            //通过
            self.showStatusLab.text =@"已同意";
            self.showStatusLab.textColor = [UIColor colorCommonGreenColor];
            
            self.showNameLab.text = nameStr;
            
            //原因
            self.showReasonLab.hidden = YES;
            
        }else if ([adoptStr isEqualToString:@"1"]){
            //待审批
            self.showStatusLab.text =@"待审核";
            self.showStatusLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
            
            self.showNameLab.text =[NSString stringWithFormat:@"%@",nameStr];
            
            //原因
            self.showReasonLab.hidden = YES;
            
        }else if ([adoptStr isEqualToString:@"4"]){
            //4:撤回
            self.showStatusLab.hidden = YES;
            self.showTimeLab.hidden = YES;
            self.showReasonLab.hidden = YES;
            
            self.showNameLab.text = nameStr;
        }
        
        //主管view
        samilView.hidden = NO;
       // self.showLevelLab.text = [NSString stringWithFormat:@"第%@级主管",levelStr];
        self.showLevelLab.text = dict[@"levelName"];
    }
    
}

//计算高度
+(CGFloat) getWithTextCellHeight:(NSDictionary *)dict{
    
    NSDictionary *infoDict = dict[@"userInfo"];
    
    NSArray *arr = infoDict[@"userName"];
    NSMutableString *nameStr = [NSMutableString new];
    if (arr.count > 0 ) {
        for (int i=0; i<arr.count; i++) {
            [nameStr appendString:arr[i]];
            if (i != arr.count-1) {
                [nameStr appendString:@"/"];
            }
        }
    }
    //计算名字高度
    CGFloat height = [SDTool getLabelHeightWithText:nameStr width:KScreenW-105-12 font:11];
    
    NSString *adoptStr =[NSString stringWithFormat:@"%@",infoDict[@"adopt"]];
    if ([adoptStr isEqualToString:@"1"]) {
        //已拒绝
        NSString *reasonStr = [NSString stringWithFormat:@"拒绝原因: %@",infoDict[@"info"]];
        //计算原因
        CGFloat reasonHeight = [SDTool getLabelHeightWithText:reasonStr width:KScreenW-105-12 font:11];
        
        return height+reasonHeight +65;
    }
    return height +65;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
