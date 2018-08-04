//
//  ShowPunchCardCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/19.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowPunchCardCell.h"

@interface ShowPunchCardCell ()
//上班和时间
@property (nonatomic,strong) UILabel *showWorkTimeLab;
//left图片
@property (nonatomic,strong) UIImageView *leftImageV;
//显示打卡时间
@property (nonatomic,strong) UILabel *showCardTimeLab;
//显示打卡状态
@property (nonatomic,strong) UIButton *normalStatusBtn;
//外勤
@property (nonatomic,strong) UIButton *fieldWorkBtn;
//迟到
@property (nonatomic,strong) UIButton *latecomerBtn;

//地址
@property (nonatomic,strong) UILabel *addressLab;
//地址异常
@property (nonatomic,strong) UILabel  *addressStatuLab;
//身份验证
@property (nonatomic,strong) UILabel *identTestStatuLab;
//外勤
@property (nonatomic,strong) UIButton *workStatuBtn;
//------------内容------------//
//显示内容标签
@property (nonatomic,strong) UIButton *showContentLabBtn;
//补卡按钮
@property (nonatomic,strong) UIButton *applyCardBtn;
//请假按钮
@property (nonatomic,strong) UIButton *leaveInBtn;
//备注按钮
@property (nonatomic,strong) UIButton *markBtn;

@end

@implementation ShowPunchCardCell

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
    
    UIView *cardTimeView = [[UIView alloc]init];
    [self addSubview:cardTimeView];
    cardTimeView.tag = 200;
    //打卡时间
    self.showCardTimeLab = [[UILabel alloc]init];
    [cardTimeView addSubview:self.showCardTimeLab];
    self.showCardTimeLab.text =[NSString stringWithFormat:@"打卡时间： 09:00"];
    self.showCardTimeLab.font = BFont(16);
    self.showCardTimeLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.showCardTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(29);
        make.left.equalTo(weakSelf).offset(33);
    }];
    
    //标签
    self.normalStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cardTimeView addSubview:self.normalStatusBtn];
    [self.normalStatusBtn setTitle:@"正常" forState:UIControlStateNormal];
    [self.normalStatusBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.normalStatusBtn.titleLabel.font = Font(12);
    [self.normalStatusBtn setBackgroundImage:[UIImage imageNamed:@"ico_zc"] forState:UIControlStateNormal];
    [self.normalStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
    }];
    
    //外勤
    self.fieldWorkBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [cardTimeView addSubview:self.fieldWorkBtn];
    [self.fieldWorkBtn setTitle:@"外勤" forState:UIControlStateNormal];
    [self.fieldWorkBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.fieldWorkBtn.titleLabel.font = Font(12);
    [self.fieldWorkBtn setBackgroundImage:[UIImage imageNamed:@"kqjl_ico_wq"] forState:UIControlStateNormal];
    [self.fieldWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.normalStatusBtn.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.normalStatusBtn.mas_centerY);
    }];
    
    [cardTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(29);
        make.left.width.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.bottom.equalTo(weakSelf.showCardTimeLab.mas_bottom);
    }];
    
    UIView *addressView = [[UIView alloc]init];
    [self addSubview:addressView];
    addressView.tag = 201;
    
    UIImageView *addressImageV = [[UIImageView alloc]init];
    [addressView addSubview:addressImageV];
    addressImageV.tag = 300;
    addressImageV.image =[UIImage imageNamed:@"qrxx_ico_dw"];
    [addressImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.showCardTimeLab.mas_left);
        make.centerY.equalTo(addressView.mas_centerY);
        make.width.equalTo(@12);
    }];
    
    self.addressLab  = [[UILabel alloc]init];
    [addressImageV addSubview:self.addressLab];
    self.addressLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    self.addressLab.font = Font(12);
    self.addressLab.text =@"渝高。智博中心";
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressImageV.mas_right).offset(5);
        make.centerY.equalTo(addressImageV.mas_centerY);
    }];
    
    self.addressStatuLab =  [[UILabel alloc]init];
    [addressImageV addSubview:self.addressStatuLab];
    self.addressStatuLab.font = Font(12);
    self.addressStatuLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
    self.addressStatuLab.text = @"地点异常";
    [self.addressStatuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressLab.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.addressLab.mas_centerY);
    }];
    
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showCardTimeLab.mas_bottom).offset(10);
        make.left.width.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.bottom.equalTo(weakSelf.addressStatuLab.mas_bottom);
    }];
    
    UIView *testView = [[UIView alloc]init];
    [self addSubview:testView];
    testView.tag = 202;
    
    UIImageView *testImageV = [[UIImageView alloc]init];
    [testView addSubview:testImageV];
    testImageV.tag = 301;
    testImageV.image = [UIImage imageNamed:@"qrxx_ico_sfyz"];
    [testImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressImageV.mas_bottom).offset(4);
        make.left.equalTo(addressImageV.mas_left);
    }];
    
    UILabel *showIdentiTestLab  = [[UILabel alloc]init];
    [testView addSubview:showIdentiTestLab];
    showIdentiTestLab.text =@"身份验证:";
    showIdentiTestLab.font = Font(12);
    showIdentiTestLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [showIdentiTestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(testImageV.mas_right).offset(5);
        make.centerY.equalTo(testImageV.mas_centerY);
    }];
    
    self.identTestStatuLab = [[UILabel alloc]init];
    [testView addSubview:self.identTestStatuLab];
    self.identTestStatuLab.textColor = [UIColor colorCommonGreenColor];
    self.identTestStatuLab.font = Font(12);
    self.identTestStatuLab.text = @"已通过";
    [self.identTestStatuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showIdentiTestLab.mas_right).offset(9);
        make.centerY.equalTo(showIdentiTestLab.mas_centerY);
    }];
    
    [testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom);
        make.left.width.equalTo(addressView);
        make.centerX.equalTo(addressView.mas_centerX);
        make.bottom.equalTo(weakSelf.identTestStatuLab.mas_bottom);
    }];

    //申请补卡按钮
    self.applyCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.applyCardBtn];
    [self.applyCardBtn setTitle:@"申请补卡 >" forState:UIControlStateNormal];
    [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.applyCardBtn.titleLabel.font = Font(12);
    [self.applyCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(testImageV.mas_left);
        make.top.equalTo(testImageV.mas_bottom).offset(13);
    }];
    
    //备注
    self.markBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.markBtn];
    [self.markBtn setTitle:@"添加备注 >" forState:UIControlStateNormal];
    [self.markBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.markBtn.titleLabel.font = Font(12);
    [self.markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.applyCardBtn.mas_right).offset(22);
        make.centerY.equalTo(weakSelf.applyCardBtn.mas_centerY);
    }];
}
-(void)setDict:(NSDictionary *)dict{
   
    __weak typeof(self) weakSelf = self;
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
 
    //记录状态
    NSString *markStr = [NSString stringWithFormat:@"%@",dict[@"unusualRemark"]];
    NSArray *markArr = [markStr componentsSeparatedByString:@","];
  
    UIView *addressView = [self viewWithTag:201];
    UIView *testView = [self viewWithTag:202];
    UIImageView *addressImageV = [self viewWithTag:300];
    UIImageView *testImageV  = [self viewWithTag:301];

    //回复初始化
    self.showCardTimeLab.hidden = NO;
    self.normalStatusBtn.hidden = NO;
    addressView.hidden = NO;
    testView.hidden = NO;
    //备注
    self.markBtn.hidden = NO;
    //外勤
    self.fieldWorkBtn.hidden = NO;
    self.applyCardBtn.hidden = NO;
    for (NSString *textStr in markArr) {
        //缺卡
        if ([textStr rangeOfString:@"缺卡"].location !=NSNotFound) {

            //隐藏打卡时间lab
            self.showCardTimeLab.hidden = YES;
            //标签
            [self.normalStatusBtn setTitle:textStr forState:UIControlStateNormal];
            [self.normalStatusBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
            self.normalStatusBtn.titleLabel.font = Font(12);
            [self.normalStatusBtn setBackgroundImage:[UIImage imageNamed:@"ico_yc"] forState:UIControlStateNormal];
            [self.normalStatusBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(29);
                make.left.equalTo(weakSelf).offset(33);
            }];
            addressView.hidden = YES;
            testView.hidden = YES;
            //备注
            self.markBtn.hidden = YES;
            //外勤
            self.fieldWorkBtn.hidden = YES;
        
            //是否包含外勤
            if ([markArr containsObject:@"外勤"]) {
                
                [self.fieldWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.normalStatusBtn.mas_right).offset(7);
                    make.centerY.equalTo(weakSelf.normalStatusBtn.mas_centerY);
                }];
                
                //外出 已通过
                [self.applyCardBtn setTitle:@"外出 已通过>" forState:UIControlStateNormal];
                [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                self.applyCardBtn.titleLabel.font = Font(12);
                [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.normalStatusBtn.mas_left);
                    make.top.equalTo(weakSelf.normalStatusBtn.mas_bottom).offset(13);
                }];
                [self.applyCardBtn addTarget:self action:@selector(leaveInWorkSucces:) forControlEvents:UIControlEventTouchUpInside];
                
                NSDictionary *lackCardDict = dict[@"lackCardData"];
                //有没有补卡记录 1 有  2 没有
                NSString *isTypeStr = [NSString stringWithFormat:@"%@",lackCardDict[@"isType"]];
                if ([isTypeStr isEqualToString:@"1"]) {
                    //0未提交 1审核中 2审核通过 3未通过 4撤销
                    NSString *isDoSureStatuStr = [NSString stringWithFormat:@"%@",lackCardDict[@"isDoSure"]];
                    if ([isDoSureStatuStr isEqualToString:@"1"]) {
                        //申请补卡
                        self.markBtn.hidden = NO;
                        [self.markBtn setTitle:@"补卡 审核中>" forState:UIControlStateNormal];
                        [self.markBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                        self.markBtn.titleLabel.font =Font(12);
                        [self.markBtn addTarget:self action:@selector(lackCardBuCardChenkConcet:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                }else{
                    //申请补卡
                    self.markBtn.hidden = NO;
                    [self.markBtn setTitle:@"申请补卡>" forState:UIControlStateNormal];
                    [self.markBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                    self.markBtn.titleLabel.font =Font(12);
                    [self.markBtn addTarget:self action:@selector(timeUnusualUFaceBuCard:) forControlEvents:UIControlEventTouchUpInside];
                }

            }else{
                NSDictionary *lackCardDict = dict[@"lackCardData"];
                //有没有补卡记录 1 有  2 没有
                NSString *isTypeStr = [NSString stringWithFormat:@"%@",lackCardDict[@"isType"]];
                if ([isTypeStr isEqualToString:@"1"]) {
                    //0未提交 1审核中 2审核通过 3未通过 4撤销
                    NSString *isDoSureStatuStr = [NSString stringWithFormat:@"%@",lackCardDict[@"isDoSure"]];
                    if ([isDoSureStatuStr isEqualToString:@"1"]) {
                        [self.applyCardBtn setTitle:@"补卡 审核中>" forState:UIControlStateNormal];
                        [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                        self.applyCardBtn.titleLabel.font =Font(12);
                        [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(weakSelf.normalStatusBtn.mas_left);
                            make.top.equalTo(weakSelf.normalStatusBtn.mas_bottom).offset(13);
                        }];
                        [self.applyCardBtn addTarget:self action:@selector(lackCardBuCardChenkConcet:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }else{
                    [self.applyCardBtn setTitle:@"申请补卡>" forState:UIControlStateNormal];
                    [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                    self.applyCardBtn.titleLabel.font =Font(12);
                    [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(weakSelf.normalStatusBtn.mas_left);
                        make.top.equalTo(weakSelf.normalStatusBtn.mas_bottom).offset(13);
                    }];
                    [self.applyCardBtn addTarget:self action:@selector(timeUnusualUFaceBuCard:) forControlEvents:UIControlEventTouchUpInside];
                }
    
            }

        }else if ([textStr rangeOfString:@"补卡"].location !=NSNotFound){
            self.normalStatusBtn.hidden = YES;
            
            addressView.hidden = YES;
            testView.hidden = YES;
            //备注
            self.markBtn.hidden = YES;
            //外勤
            self.fieldWorkBtn.hidden = YES;
            
            NSDictionary *lackCardDict = dict[@"lackCardData"];
            //打卡时间
            self.showCardTimeLab.text = [NSString stringWithFormat:@"打卡时间: %@",lackCardDict[@"doTime"]];
            
            //是否包含外勤
            if ([markArr containsObject:@"外勤"]) {
                //外勤
                self.fieldWorkBtn.hidden = NO;
                [self.fieldWorkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(7);
                    make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
                }];
                
                self.applyCardBtn.hidden = NO;
                //外出 已通过
                [self.applyCardBtn setTitle:@"外出 已通过>" forState:UIControlStateNormal];
                [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                self.applyCardBtn.titleLabel.font = Font(12);
                [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.showCardTimeLab.mas_left);
                    make.top.equalTo(weakSelf.showCardTimeLab.mas_bottom).offset(13);
                }];
                [self.applyCardBtn addTarget:self action:@selector(leaveInWorkSucces:) forControlEvents:UIControlEventTouchUpInside];
                
                self.markBtn.hidden = NO;
                //申请补卡按钮
                [self.markBtn setTitle:@"补卡 已通过 >" forState:UIControlStateNormal];
                [self.markBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                self.markBtn.titleLabel.font = Font(12);
                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.applyCardBtn.mas_right).offset(22);
                    make.centerY.equalTo(weakSelf.applyCardBtn.mas_centerY);
                }];
                 [self.markBtn addTarget:self action:@selector(leaveInBuCardSucce:) forControlEvents:UIControlEventTouchUpInside];
                return ;
            }
            
            //申请补卡按钮
            [self.applyCardBtn setTitle:@"补卡 已通过 >" forState:UIControlStateNormal];
            [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
            self.applyCardBtn.titleLabel.font = Font(12);
            [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.showCardTimeLab.mas_left);
                make.top.equalTo(weakSelf.showCardTimeLab.mas_bottom).offset(13);
            }];
            [self.applyCardBtn addTarget:self action:@selector(leaveInBuCardSucce:) forControlEvents:UIControlEventTouchUpInside];
    
        } else if ([textStr rangeOfString:@"迟到"].location !=NSNotFound || [textStr rangeOfString:@"正常"].location !=NSNotFound || [textStr rangeOfString:@"早退"].location !=NSNotFound || [textStr rangeOfString:@"旷工"].location !=NSNotFound){
         
            //外勤
            self.fieldWorkBtn.hidden = YES;
            //打卡时间
            self.showCardTimeLab.text = [NSString stringWithFormat:@"打卡时间: %@",dict[@"timeClockinHi"]];
            //迟到标签
            CGFloat w =  [SDTool calStrWith:textStr andFontSize:12].width+10;
            //标签
            [self.normalStatusBtn setTitle:textStr forState:UIControlStateNormal];
            [self.normalStatusBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
            self.normalStatusBtn.titleLabel.font = Font(12);
            if ([textStr isEqualToString:@"正常"]) {
                [self.normalStatusBtn setBackgroundImage:[UIImage imageNamed:@"ico_zc"] forState:UIControlStateNormal];
            }else{
               [self.normalStatusBtn setBackgroundImage:[UIImage imageNamed:@"ico_yc"] forState:UIControlStateNormal];
            }
            [self.normalStatusBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(7);
                make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
                make.width.equalTo(@(w));
            }];
            
            NSString *addressStr =dict[@"clockinCoordinate"][@"title"];
            self.addressLab.text =addressStr;
            
             CGFloat addressW =  [SDTool calStrWith:addressStr andFontSize:12].width+10;
            //地点判断
            NSString *addressStatuStr =[NSString stringWithFormat:@"%@",dict[@"abnormalCoordinateIs"]];
            if ([addressStatuStr isEqualToString:@"1"]) {
                self.addressStatuLab.hidden = YES;
            }else{
                //判断宽度
                CGFloat screenW = KScreenW-34-76;
                if (addressW>screenW) {
                    [self.addressLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(addressImageV.mas_right).offset(5);
                        make.centerY.equalTo(addressImageV.mas_centerY);
                    }];
                    
                    [self.addressStatuLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(weakSelf).offset(-12);
                        make.left.equalTo(weakSelf.addressLab.mas_right).offset(12);
                        make.centerY.equalTo(weakSelf.addressLab.mas_centerY);
                        make.width.equalTo(@53);
                    }];
                }
            }
            //身份验证
            NSString *faceStatuStr = [NSString stringWithFormat:@"%@",dict[@"faceStatus"]];
            if ([faceStatuStr isEqualToString:@"2"]) {
                //隐藏身份验证view
                testView.hidden = YES;
                self.identTestStatuLab.text = @"未通过";

                [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(addressImageV.mas_left);
                    make.top.equalTo(addressImageV.mas_bottom).offset(13);
                }];
                [self.applyCardBtn addTarget:self action:@selector(timeUnusualUFaceBuCard:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                
                NSString *faceTestStatuStr  =[NSString stringWithFormat:@"%@",dict[@"abnormalIdentityIs"]];
                if ([faceTestStatuStr isEqualToString:@"2"]) {
                    self.identTestStatuLab.text= @"未通过";
                    self.identTestStatuLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
                }else{
                    self.identTestStatuLab.text= @"已通过";
                    self.identTestStatuLab.textColor = [UIColor colorCommonGreenColor];
                }
            }
            if ([markArr containsObject:@"外勤"]) {
                self.fieldWorkBtn.hidden = NO;
                [self.fieldWorkBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.normalStatusBtn.mas_right).offset(7);
                    make.centerY.equalTo(weakSelf.normalStatusBtn.mas_centerY);
                }];
                
                self.workStatuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self addSubview:self.workStatuBtn];
                [self.workStatuBtn setTitle:@"外勤 已通过 >" forState:UIControlStateNormal];
                [self.workStatuBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                self.workStatuBtn.titleLabel.font = Font(12);
                [self.workStatuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(testImageV.mas_left);
                    make.top.equalTo(testImageV.mas_bottom).offset(13);
                }];
                [self.workStatuBtn addTarget:self action:@selector(leaveInWorkSucces:) forControlEvents:UIControlEventTouchUpInside];
                
                //是否包含外勤
                if ([markArr containsObject:@"正常"]) {
                    self.applyCardBtn.hidden = YES;
                    [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(22);
                        make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                    }];
                    [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
                }
                //申请补卡
                [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(22);
                    make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                }];
                
                NSString *lackCardStr =[NSString stringWithFormat:@"%@",dict[@"lackCard"]];
                if ([lackCardStr isEqualToString:@"2"]) {
                    NSDictionary *lackCardDict = dict[@"lackCardData"];
                    if ([lackCardDict[@"isDoSure"]integerValue] == 1) {
                        [self.applyCardBtn setTitle:@"补卡 审核中>" forState:UIControlStateNormal];
                        [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                        [self.applyCardBtn addTarget:self action:@selector(lackCardBuCardChenkConcet:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }else{
                    [self.applyCardBtn setTitle:@"申请补卡>" forState:UIControlStateNormal];
                    [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                    
                    [self.applyCardBtn addTarget:self action:@selector(timeUnusualUFaceBuCard:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                //备注
                NSString *remarkStr =dict[@"remark"];
                //照片
                NSArray *photoArr = dict[@"photo"];
                if ([remarkStr isEqualToString:@""] && photoArr.count == 0) {
                    [self.markBtn setTitle:@"添加备注 >" forState:UIControlStateNormal];
                }else{
                    [self.markBtn setTitle:@"查看备注 >" forState:UIControlStateNormal];
                }
                [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
               
            }else{
                //是否包含外勤
                if ([markArr containsObject:@"正常"]) {
                    self.applyCardBtn.hidden = YES;
                    [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(testImageV.mas_left);
                        make.top.equalTo(testImageV.mas_bottom).offset(13);
                    }];
                    
                     [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                //申请补卡
                [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(testImageV.mas_left);
                    make.top.equalTo(testImageV.mas_bottom).offset(13);
                 }];
                
                NSString *lackCardStr =[NSString stringWithFormat:@"%@",dict[@"lackCard"]];
                if ([lackCardStr isEqualToString:@"2"]) {
                    NSDictionary *lackCardDict = dict[@"lackCardData"];
                    if ([lackCardDict[@"isDoSure"]integerValue] == 1) {
                        [self.applyCardBtn setTitle:@"补卡 审核中>" forState:UIControlStateNormal];
                        [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                        [self.applyCardBtn addTarget:self action:@selector(lackCardBuCardChenkConcet:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }else{
                    [self.applyCardBtn setTitle:@"申请补卡>" forState:UIControlStateNormal];
                    [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];

                    [self.applyCardBtn addTarget:self action:@selector(timeUnusualUFaceBuCard:) forControlEvents:UIControlEventTouchUpInside];
                }
                //备注
                NSString *remarkStr =dict[@"remark"];
                //照片
                NSArray *photoArr = dict[@"photo"];
                if ([remarkStr isEqualToString:@""] && photoArr.count == 0) {
                    [self.markBtn setTitle:@"添加备注 >" forState:UIControlStateNormal];
                }else{
                    [self.markBtn setTitle:@"查看备注 >" forState:UIControlStateNormal];
                }
                [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
            }
          
        }else if ([textStr rangeOfString:@"请假"].location !=NSNotFound){
           
            //隐藏打卡时间lab
            self.showCardTimeLab.hidden = YES;
            //请假标签
            [self.normalStatusBtn setTitle:textStr forState:UIControlStateNormal];
            [self.normalStatusBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
            self.normalStatusBtn.titleLabel.font = Font(12);
            [self.normalStatusBtn setBackgroundImage:[UIImage imageNamed:@"kqjl_ico_wq"] forState:UIControlStateNormal];
            [self.normalStatusBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(29);
                make.left.equalTo(weakSelf.showWorkTimeLab.mas_left);
            }];

            addressView.hidden = YES;

            testView.hidden = YES;
            //备注
            self.markBtn.hidden = YES;
            //外勤
            self.fieldWorkBtn.hidden = YES;

            //是否包含外勤
            if ([markArr containsObject:@"外勤"]) {
                //外勤
                self.fieldWorkBtn.hidden = NO;
                //请假
                self.markBtn.hidden = NO;

                //外勤 已通过>
                [self.applyCardBtn setTitle:@"外勤 已通过>" forState:UIControlStateNormal];
                [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.normalStatusBtn.mas_left);
                    make.top.equalTo(weakSelf.normalStatusBtn.mas_bottom).offset(13);
                }];
                [self.applyCardBtn addTarget:self action:@selector(leaveInWorkSucces:) forControlEvents:UIControlEventTouchUpInside];
                
                //请假已通过>
                [self.markBtn setTitle:@"请假 已通过>" forState:UIControlStateNormal];
                [self.markBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                [self.markBtn addTarget:self action:@selector(askForLeave:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //请假 已通过>
                [self.applyCardBtn setTitle:@"请假 已通过>" forState:UIControlStateNormal];
                [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.normalStatusBtn.mas_left);
                    make.top.equalTo(weakSelf.normalStatusBtn.mas_bottom).offset(13);
                }];
                [self.applyCardBtn addTarget:self action:@selector(askForLeave:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
 
}
#pragma mark ------按钮点击事件------
//补卡审核中
-(void)lackCardBuCardChenkConcet:(UIButton *)sender{
    self.buCardChenkConcetBlock();
}
//请假
-(void)askForLeave:(UIButton *) sender{
    self.askForLeaveBlock();
}
//外勤补卡通过
-(void)leaveInBuCardSucce:(UIButton *) sender{
    self.leaveInBuCardSucceBlock();
}
//外勤通过
-(void)leaveInWorkSucces:(UIButton *) sender{
    self.leaveInWorkSuccesBlock();
}
//申请补卡
-(void)timeUnusualUFaceBuCard:(UIButton *) sender{
    self.timeUnusualUFaceBuCardBlock();
}
//备注
-(void)nomalLookMark:(UIButton *) sender{
    self.markBlock();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
