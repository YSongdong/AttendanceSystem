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
//正常标签
@property (nonatomic,strong) UIButton *normalBtn;
//异常标签
@property (nonatomic,strong) UIButton *unusualBtn;
//请假标签
@property (nonatomic,strong) UIButton *leaveBtn;
//地址
@property (nonatomic,strong) UILabel *addressLab;
//地址异常
@property (nonatomic,strong) UILabel  *addressStatuLab;
//身份验证
@property (nonatomic,strong) UILabel *identTestStatuLab;

//------------内容------------//
//显示内容标签
@property (nonatomic,strong) UIButton *showContentLabBtn;
//外勤
@property (nonatomic,strong) UIButton *workStatuBtn;
//补卡按钮
@property (nonatomic,strong) UIButton *applyCardBtn;
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
    self.showWorkTimeLab.text = @"";
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
    self.showCardTimeLab.text =[NSString stringWithFormat:@""];
    self.showCardTimeLab.font = BFont(16);
    self.showCardTimeLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.showCardTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(29);
        make.left.equalTo(weakSelf).offset(33);
    }];
    
    //正常标签
    self.normalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cardTimeView addSubview:self.normalBtn];
    [self.normalBtn setTitle:@"正常" forState:UIControlStateNormal];
    [self.normalBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.normalBtn.titleLabel.font = Font(12);
    [self.normalBtn setBackgroundImage:[UIImage imageNamed:@"ico_zc"] forState:UIControlStateNormal];
    [self.normalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
    }];
    
    //异常标签
    self.unusualBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [cardTimeView addSubview:self.unusualBtn];
    [self.unusualBtn setTitle:@"迟到" forState:UIControlStateNormal];
    [self.unusualBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.unusualBtn.titleLabel.font = Font(12);
    [self.unusualBtn setBackgroundImage:[UIImage imageNamed:@"ico_yc"] forState:UIControlStateNormal];
    [self.unusualBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.normalBtn.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.normalBtn.mas_centerY);
    }];
    
    //请假、外勤标签
    self.leaveBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [cardTimeView addSubview:self.leaveBtn];
    [self.leaveBtn setTitle:@"请假" forState:UIControlStateNormal];
    [self.leaveBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.leaveBtn.titleLabel.font = Font(12);
    [self.leaveBtn setBackgroundImage:[UIImage imageNamed:@"kqjl_ico_wq"] forState:UIControlStateNormal];
    [self.leaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.unusualBtn.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.unusualBtn.mas_centerY);
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
    self.addressLab.text =@"";
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
    self.identTestStatuLab.text = @"";
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

    //外勤、请假按钮
    self.workStatuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.workStatuBtn];
    [self.workStatuBtn setTitle:@"外勤 已通过>" forState:UIControlStateNormal];
    [self.workStatuBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.workStatuBtn.titleLabel.font = Font(12);
    [self.workStatuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(testImageV.mas_left);
        make.top.equalTo(testImageV.mas_bottom).offset(13);
    }];
  
    //申请补卡按钮
    self.applyCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.applyCardBtn];
    self.applyCardBtn.tag = 500;
    [self.applyCardBtn setTitle:@"申请补卡 >" forState:UIControlStateNormal];
    [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.applyCardBtn.titleLabel.font = Font(12);
    [self.applyCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
        make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
    }];
    
    //备注按钮
    self.markBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.markBtn];
    [self.markBtn setTitle:@"添加备注 >" forState:UIControlStateNormal];
    [self.markBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.markBtn.titleLabel.font = Font(12);
    [self.markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.applyCardBtn.mas_right).offset(KSIphonScreenW(20));
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
         clockinTypeStr = @"下班打卡";
    }
    //时间
    self.showWorkTimeLab.text = [NSString stringWithFormat:@"%@%@  (时间%@)",clockStr,clockinTypeStr,dict[@"sureTime"]];
 
    UIView *addressView = [self viewWithTag:201];
    UIView *testView = [self viewWithTag:202];
    UIImageView *addressImageV = [self viewWithTag:300];
    UIImageView *testImageV  = [self viewWithTag:301];

    //回复初始化
    self.showCardTimeLab.hidden = NO;
    self.normalBtn.hidden = NO;
    self.unusualBtn.hidden = NO;
    self.leaveBtn.hidden = NO;
    
    addressView.hidden = NO;
    testView.hidden = NO;
   
    self.applyCardBtn.hidden = NO;
    self.workStatuBtn.hidden = NO;
    self.markBtn.hidden = NO;
    self.applyCardBtn.tag = 500;

    [self.addressStatuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressLab.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.addressLab.mas_centerY);
    }];
    
    [self.workStatuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(testImageV.mas_left);
        make.top.equalTo(testImageV.mas_bottom).offset(13);
    }];
    
    [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
        make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
    }];
    [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.applyCardBtn.mas_right).offset(KSIphonScreenW(20));
        make.centerY.equalTo(weakSelf.applyCardBtn.mas_centerY);
    }];

    //1正常 2外勤 3公共
    NSString *isGoStr  =[NSString stringWithFormat:@"%@",dict[@"isGo"]];
    
    //身份验证
    NSString *faceStatuStr = [NSString stringWithFormat:@"%@",dict[@"faceStatus"]];
    //1 正常记录 2缺卡记录 3补卡记录
    NSString *lackCardStr =[NSString stringWithFormat:@"%@",dict[@"lackCard"]];
    
    //是否打卡
    NSString *timeClockinHiStr =[NSString stringWithFormat:@"%@",dict[@"timeClockinHi"]];
    
    //休息日  1不是休息日 2休息日
    NSString *isRestStr = [NSString stringWithFormat:@"%@",dict[@"isRest"]];
    
    //1 需要打卡人员 2无需打卡人员
    NSString *notClockinStr = [NSString stringWithFormat:@"%@",dict[@"notClockin"]];
    //下班是否需要打卡 1打卡 2不打卡
    NSString *offDutyOutStr = [NSString stringWithFormat:@"%@",dict[@"offDutyOut"]];
    
    //判断是否请假
    NSString *leaveInStr = [NSString stringWithFormat:@"%@",dict[@"leaveIn"]];
    
#pragma mark ---是请假-----
     //请假
    if ([leaveInStr isEqualToString:@"2"]) {
        //隐藏标签
        self.normalBtn.hidden = YES;
        self.unusualBtn.hidden = YES;
        self.leaveBtn.hidden = NO;
#pragma mark ---是请假，没有打卡-----
        //判断是否打卡
        if ([timeClockinHiStr isEqualToString:@""]) {
            
            self.showCardTimeLab.hidden = YES;
            
            [self.leaveBtn setTitle:@"请假" forState:UIControlStateNormal];
            [self.leaveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(29);
                make.left.equalTo(weakSelf.showWorkTimeLab.mas_left);
            }];
            
            //没有打卡
            addressView.hidden = YES;
            testImageV.hidden= YES;
            testView.hidden = YES;
            addressImageV.hidden= YES;
          
            /// 补卡
            self.applyCardBtn.hidden = YES;
            //请假已通过
            self.workStatuBtn.hidden = NO;
            self.workStatuBtn.tag =  600;
            [self.workStatuBtn setTitle:@"请假 已通过>" forState:UIControlStateNormal];
            [self.workStatuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.leaveBtn.mas_left);
                make.top.equalTo(weakSelf.leaveBtn.mas_bottom).offset(KSIphonScreenH(13));
            }];
            [self.workStatuBtn addTarget:self action:@selector(selectLeavaAction:) forControlEvents:UIControlEventTouchUpInside];
            
            /// 显示备注
            self.markBtn.hidden = NO;
            NSArray *photoArr = (NSArray *)dict[@"photo"];
            if ([dict[@"remark"] isEqualToString:@""] && photoArr.count == 0) {
                self.markBtn.hidden = NO;
                [self.markBtn setTitle:@"添加备注>" forState:UIControlStateNormal];
                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
                    make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                }];
            }else{
                self.markBtn.hidden = NO;
                [self.markBtn setTitle:@"查看备注>" forState:UIControlStateNormal];
                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
                    make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                }];
            }
            [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
            return;
        }
#pragma mark -----------是请假，打卡----------------
        if (![timeClockinHiStr isEqualToString:@""]) {
            //显示打卡时间
            self.showCardTimeLab.hidden = NO;
            self.showCardTimeLab.text = [NSString stringWithFormat:@"打卡时间: %@",dict[@"timeClockinHi"]];
            
            [self.leaveBtn setTitle:@"请假" forState:UIControlStateNormal];
            [self.leaveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(7);
                make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
            }];
            
            //显示打卡地点
            addressImageV.hidden= NO;
            addressView.hidden = NO;
            NSString *addressStr =dict[@"clockinCoordinate"][@"title"];
            self.addressLab.text =addressStr;
            CGFloat addressW =  [SDTool calStrWith:addressStr andFontSize:12].width+10;
            //地点判断
            NSString *addressStatuStr =[NSString stringWithFormat:@"%@",dict[@"abnormalCoordinateIs"]];
            if ([addressStatuStr isEqualToString:@"1"]) {
                self.addressStatuLab.hidden = YES;
            }else{
                self.addressStatuLab.hidden = NO;
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
            if ([faceStatuStr isEqualToString:@"2"]) {
                //隐藏身份验证view
                testView.hidden = YES;
                testImageV.hidden = YES;
                self.identTestStatuLab.text = @"未通过";
            }else{
                testView.hidden = NO;
                testImageV.hidden = NO;
                NSString *faceTestStatuStr  =[NSString stringWithFormat:@"%@",dict[@"abnormalIdentityIs"]];
                if ([faceTestStatuStr isEqualToString:@"2"]) {
                    self.identTestStatuLab.text= @"未通过";
                    self.identTestStatuLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
                }else{
                    self.identTestStatuLab.text= @"已通过";
                    self.identTestStatuLab.textColor = [UIColor colorCommonGreenColor];
                }
            }
            self.workStatuBtn.hidden = NO;
            self.workStatuBtn.tag =  600;
            [self.workStatuBtn setTitle:@"请假 已通过>" forState:UIControlStateNormal];
            [self.workStatuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(addressImageV.mas_left);
                make.top.equalTo(addressImageV.mas_bottom).offset(KSIphonScreenH(25));
            }];
            [self.workStatuBtn addTarget:self action:@selector(selectLeavaAction:) forControlEvents:UIControlEventTouchUpInside];
            //隐藏补卡
            self.applyCardBtn.hidden= YES;
            //打卡
            NSArray *photoArr = (NSArray *)dict[@"photo"];
            if ([dict[@"remark"] isEqualToString:@""] && photoArr.count == 0) {
                self.markBtn.hidden = NO;
                [self.markBtn setTitle:@"添加备注>" forState:UIControlStateNormal];
                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
                    make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                }];
            }else{
                self.markBtn.hidden = NO;
                [self.markBtn setTitle:@"查看备注>" forState:UIControlStateNormal];
                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
                    make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                }];
            }
            [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
            return ;
        }
    }
#pragma mark --------------是外勤 ------------------
    //判断是否是外勤   2 是外勤
    if ([isGoStr isEqualToString:@"2"]) {
        self.normalBtn.hidden = YES;
        self.unusualBtn.hidden = YES;
        self.leaveBtn.hidden = YES;
#pragma mark ---是外勤，不是补卡   也没有打卡-----
        //不是补卡   也没有打卡
        if (![lackCardStr isEqualToString:@"3"] && [timeClockinHiStr isEqualToString:@""]) {
            //没有打卡
            addressView.hidden = YES;
            testView.hidden = YES;
          
            self.showCardTimeLab.hidden= YES;
            
            //判断是否标记不做异常处理
            if ([isRestStr isEqualToString:@"2"] || [notClockinStr isEqualToString:@"2"] || [offDutyOutStr isEqualToString:@"2"] ) {
                
                self.leaveBtn.hidden= NO;
                [self.leaveBtn setTitle:@"外勤" forState:UIControlStateNormal];
                [self.leaveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(KSIphonScreenW(29));
                    make.left.equalTo(weakSelf.showWorkTimeLab.mas_left);
                }];
                
            }else{
                self.unusualBtn.hidden = NO;
                [self.unusualBtn setTitle:@"缺卡" forState:UIControlStateNormal];
                [self.unusualBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(KSIphonScreenW(29));
                    make.left.equalTo(weakSelf.showWorkTimeLab.mas_left);
                }];
                
                self.leaveBtn.hidden= NO;
                [self.leaveBtn setTitle:@"外勤" forState:UIControlStateNormal];
                [self.leaveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.unusualBtn.mas_right).offset(KSIphonScreenW(7));
                    make.centerY.equalTo(weakSelf.unusualBtn.mas_centerY);
                }];
            }
            
            //外勤已通过
            self.workStatuBtn.hidden = NO;
            self.workStatuBtn.tag =  601;
            [self.workStatuBtn setTitle:@"外勤 已通过>" forState:UIControlStateNormal];
            [self.workStatuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.showWorkTimeLab.mas_left);
                make.top.equalTo(weakSelf.leaveBtn.mas_bottom).offset(KSIphonScreenH(20));
            }];
            [self.workStatuBtn addTarget:self action:@selector(selectLeavaAction:) forControlEvents:UIControlEventTouchUpInside];
            
//            /// 补卡
            self.applyCardBtn.hidden = YES;
            
            /// 显示备注
            self.markBtn.hidden = NO;
            NSArray *photoArr = (NSArray *)dict[@"photo"];
            if ([dict[@"remark"] isEqualToString:@""] && photoArr.count == 0) {
                self.markBtn.hidden = NO;
                [self.markBtn setTitle:@"添加备注>" forState:UIControlStateNormal];
                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
                    make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                }];
            }else{
                self.markBtn.hidden = NO;
                [self.markBtn setTitle:@"查看备注>" forState:UIControlStateNormal];
                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
                    make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                }];
            }
            [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
            
//            self.applyCardBtn.tag = 500;
//            [self.applyCardBtn setTitle:@"申请补卡>" forState:UIControlStateNormal];
//            [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
//                make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
//            }];
//            [self.applyCardBtn addTarget:self action:@selector(timeUnusualUFaceBuCard:) forControlEvents:UIControlEventTouchUpInside];
            return ;
        }
#pragma mark -----------是外勤，打卡-----------
        if (![lackCardStr isEqualToString:@"3"] && ![timeClockinHiStr isEqualToString:@""]) {
            self.unusualBtn.hidden = YES;
            self.normalBtn.hidden = YES;
            
            //显示打卡时间
            self.showCardTimeLab.text = [NSString stringWithFormat:@"打卡时间: %@",dict[@"timeClockinHi"]];
            
            //显示标签
            NSString *unusualRemarkStr = [NSString stringWithFormat:@"%@",dict[@"unusualRemark"]];
            NSArray *arr = [unusualRemarkStr componentsSeparatedByString:@","];
            if (![unusualRemarkStr isEqualToString:@""]) {
                for (int i=0; i< arr.count; i++) {
                    NSString *nameStr = arr[i];
                    if ([nameStr isEqualToString:@"正常"]) {
                        self.normalBtn.hidden = NO;
                        [self.normalBtn setTitle:nameStr forState:UIControlStateNormal];
                        [self.normalBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(KSIphonScreenW(7));
                            make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
                        }];
                    }
                    if ([arr containsObject:@"迟到"] ||[arr containsObject:@"早退"] || [arr containsObject:@"旷工"]) {
                        self.unusualBtn.hidden = NO;
                        [self.unusualBtn setTitle:nameStr forState:UIControlStateNormal];
                        [self.unusualBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(KSIphonScreenW(7));
                            make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
                        }];
                    }
                }
            }
            //判断是否标记不做异常处理
            if ([isRestStr isEqualToString:@"2"] || [notClockinStr isEqualToString:@"2"] || [offDutyOutStr isEqualToString:@"2"]) {
                self.unusualBtn.hidden = YES;
                self.normalBtn.hidden = YES;
                //显示外勤标签
                self.leaveBtn.hidden = NO;
                [self.leaveBtn setTitle:@"外勤" forState:UIControlStateNormal];
                [self.leaveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(KSIphonScreenW(7));
                    make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
                }];
            }else{
                
                if ([arr containsObject:@"正常"]) {
                    //显示外勤标签
                    self.leaveBtn.hidden = NO;
                    [self.leaveBtn setTitle:@"外勤" forState:UIControlStateNormal];
                    [self.leaveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(weakSelf.normalBtn.mas_right).offset(KSIphonScreenW(7));
                        make.centerY.equalTo(weakSelf.normalBtn.mas_centerY);
                    }];
                }
                
                if ([arr containsObject:@"迟到"] ||[arr containsObject:@"早退"] || [arr containsObject:@"旷工"]) {
                    //显示外勤标签
                    self.leaveBtn.hidden = NO;
                    [self.leaveBtn setTitle:@"外勤" forState:UIControlStateNormal];
                    [self.leaveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(weakSelf.unusualBtn.mas_right).offset(KSIphonScreenW(7));
                        make.centerY.equalTo(weakSelf.unusualBtn.mas_centerY);
                    }];
                }
            }
            
            //显示打卡地点
            addressView.hidden = NO;
            addressImageV.hidden =  NO;
            NSString *addressStr =dict[@"clockinCoordinate"][@"title"];
            self.addressLab.text =addressStr;
            CGFloat addressW =  [SDTool calStrWith:addressStr andFontSize:12].width+10;
            //地点判断
            NSString *addressStatuStr =[NSString stringWithFormat:@"%@",dict[@"abnormalCoordinateIs"]];
            if ([addressStatuStr isEqualToString:@"1"]) {
                self.addressStatuLab.hidden = YES;
            }else{
                self.addressStatuLab.hidden = NO;
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
            if ([faceStatuStr isEqualToString:@"2"]) {
                //隐藏身份验证view
                testView.hidden = YES;
                testImageV.hidden = YES;
                self.identTestStatuLab.text = @"未通过";
            }else{
                testView.hidden = NO;
                testImageV.hidden = NO;
                NSString *faceTestStatuStr  =[NSString stringWithFormat:@"%@",dict[@"abnormalIdentityIs"]];
                if ([faceTestStatuStr isEqualToString:@"2"]) {
                    self.identTestStatuLab.text= @"未通过";
                    self.identTestStatuLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
                }else{
                    self.identTestStatuLab.text= @"已通过";
                    self.identTestStatuLab.textColor = [UIColor colorCommonGreenColor];
                }
            }
            self.workStatuBtn.hidden = NO;
            self.workStatuBtn.tag =  601;
            [self.workStatuBtn setTitle:@"外勤 已通过>" forState:UIControlStateNormal];
            [self.workStatuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(addressImageV.mas_left);
                make.top.equalTo(addressImageV.mas_bottom).offset(KSIphonScreenH(30));
            }];
            [self.workStatuBtn addTarget:self action:@selector(selectLeavaAction:) forControlEvents:UIControlEventTouchUpInside];
            
//            if ([arr containsObject:@"正常"]) {
                self.applyCardBtn.hidden = YES;
                //打卡
                NSArray *photoArr = (NSArray *)dict[@"photo"];
                if ([dict[@"remark"] isEqualToString:@""] && photoArr.count == 0) {
                    self.markBtn.hidden = NO;
                    [self.markBtn setTitle:@"添加备注>" forState:UIControlStateNormal];
                    [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
                        make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                    }];
                }else{
                    self.markBtn.hidden = NO;
                    [self.markBtn setTitle:@"查看备注>" forState:UIControlStateNormal];
                    [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
                        make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                    }];
                }
//            }else{
//                /// 补卡
//                self.applyCardBtn.hidden = YES;
//                self.applyCardBtn.tag = 500;
//                [self.applyCardBtn setTitle:@"申请补卡>" forState:UIControlStateNormal];
//                [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
//                    make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
//                }];
//                [self.applyCardBtn addTarget:self action:@selector(timeUnusualUFaceBuCard:) forControlEvents:UIControlEventTouchUpInside];
                
                
//                //打卡
//                if ([dict[@"remark"] isEqualToString:@""]) {
//                    self.markBtn.hidden = NO;
//                    [self.markBtn setTitle:@"添加备注>" forState:UIControlStateNormal];
//                    [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(weakSelf.applyCardBtn.mas_right).offset(KSIphonScreenW(20));
//                        make.centerY.equalTo(weakSelf.applyCardBtn.mas_centerY);
//                    }];
//                }else{
//                    self.markBtn.hidden = NO;
//                    [self.markBtn setTitle:@"查看备注>" forState:UIControlStateNormal];
//                    [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(weakSelf.applyCardBtn.mas_right).offset(KSIphonScreenW(20));
//                        make.centerY.equalTo(weakSelf.applyCardBtn.mas_centerY);
//                    }];
//                }
//
//            }
            [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
            
            return;
        }
#pragma mark ---------是外勤，补卡--------------
        if ([lackCardStr isEqualToString:@"3"]){
            NSString *isDoSureStr =[NSString stringWithFormat:@"%@",dict[@"lackCardData"][@"isDoSure"]];
            if ([isDoSureStr isEqualToString:@"2"]) {
            //显示补卡时间
            NSDictionary *lackCardDict = dict[@"lackCardData"];
            self.showCardTimeLab.text = [NSString stringWithFormat:@"补卡时间: %@",lackCardDict[@"doTime"]];
            
            self.leaveBtn.hidden= NO;
            [self.leaveBtn setTitle:@"外勤" forState:UIControlStateNormal];
            [self.leaveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(KSIphonScreenW(7));
                make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
            }];
            
            //隐藏地址和身份验证
            addressView.hidden = YES;
            addressImageV.hidden = YES;
            testView.hidden = YES;
            testImageV.hidden= YES;
           
            //外勤已通过
            self.workStatuBtn.hidden = NO;
            self.workStatuBtn.tag =  601;
            [self.workStatuBtn setTitle:@"外勤 已通过>" forState:UIControlStateNormal];
            [self.workStatuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.showCardTimeLab.mas_left);
                make.top.equalTo(weakSelf.showCardTimeLab.mas_bottom).offset(KSIphonScreenH(25));
            }];
            [self.workStatuBtn addTarget:self action:@selector(selectLeavaAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //补卡已通过
            self.applyCardBtn.hidden = YES;
                
            // 显示备注
            self.markBtn.hidden = NO;
            NSArray *photoArr = (NSArray *)dict[@"photo"];
            if ([dict[@"remark"] isEqualToString:@""] && photoArr.count == 0) {
                self.markBtn.hidden = NO;
                [self.markBtn setTitle:@"添加备注>" forState:UIControlStateNormal];
                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
                    make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                }];
            }else{
                self.markBtn.hidden = NO;
                [self.markBtn setTitle:@"查看备注>" forState:UIControlStateNormal];
                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
                    make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
                }];
            }
            [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];

//            self.applyCardBtn.tag = 501;
//            [self.applyCardBtn setTitle:@"补卡 已通过>" forState:UIControlStateNormal];
//            [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(weakSelf.workStatuBtn.mas_right).offset(KSIphonScreenW(20));
//                make.centerY.equalTo(weakSelf.workStatuBtn.mas_centerY);
//            }];
//            [self.applyCardBtn addTarget:self action:@selector(timeUnusualUFaceBuCard:) forControlEvents:UIControlEventTouchUpInside];
            return;
          }
        }
        return;
    }
#pragma mark -----------不是外勤，补卡------------
//    if ([lackCardStr isEqualToString:@"3"]){
//         NSString *isDoSureStr =[NSString stringWithFormat:@"%@",dict[@"lackCardData"][@"isDoSure"]];
//        if ([isDoSureStr isEqualToString:@"2"]) {
//            self.normalBtn.hidden = YES;
//            self.unusualBtn.hidden = YES;
//            self.leaveBtn.hidden =  YES;
//            //显示补卡时间
//            NSDictionary *lackCardDict = dict[@"lackCardData"];
//            self.showCardTimeLab.text = [NSString stringWithFormat:@"补卡时间: %@",lackCardDict[@"doTime"]];
//            //隐藏地址和身份验证
//            addressView.hidden = YES;
//            addressImageV.hidden = YES;
//            testView.hidden = YES;
//            testImageV.hidden = YES;
//            //隐藏备注
//            self.markBtn.hidden = YES;
//            //外勤已通过
//            self.workStatuBtn.hidden = YES;
//
//            //补卡已通过
//            self.applyCardBtn.hidden =YES;
//            self.applyCardBtn.tag = 501;
//            [self.applyCardBtn setTitle:@"补卡 已通过>" forState:UIControlStateNormal];
//            [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(weakSelf.showCardTimeLab.mas_left);
//                make.top.equalTo(weakSelf.showCardTimeLab.mas_bottom).offset(KSIphonScreenH(13));
//            }];
//            [self.applyCardBtn addTarget:self action:@selector(timeUnusualUFaceBuCard:) forControlEvents:UIControlEventTouchUpInside];
//            return;
//        }
//    }
#pragma mark ---不是外勤，也没有打卡-----
    //判断是否打卡
    if ([timeClockinHiStr isEqualToString:@""]) {
        self.normalBtn.hidden = YES;
        self.leaveBtn.hidden = YES;
        //隐藏打卡时间
        self.showCardTimeLab.hidden = YES;
        
        self.unusualBtn.hidden = NO;
        [self.unusualBtn setTitle:@"缺卡" forState:UIControlStateNormal];
        [self.unusualBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(29);
            make.left.equalTo(weakSelf).offset(33);
        }];
        
        //判断是否标记不做异常处理
        if ([isRestStr isEqualToString:@"2"] || [notClockinStr isEqualToString:@"2"] || [offDutyOutStr isEqualToString:@"2"] ) {
            self.unusualBtn.hidden = YES;
            self.normalBtn.hidden = YES;
        }
        
        //没有打卡
        addressView.hidden = YES;
        testView.hidden = YES;
        addressImageV.hidden = YES;
        testImageV.hidden =  YES;
        //外勤已通过
        self.workStatuBtn.hidden = YES;
        
//        /// 补卡
        self.applyCardBtn.hidden = YES;
        
        // 显示备注
        self.markBtn.hidden = NO;
        NSArray *photoArr = (NSArray *)dict[@"photo"];
        if ([dict[@"remark"] isEqualToString:@""] && photoArr.count == 0) {
            self.markBtn.hidden = NO;
            [self.markBtn setTitle:@"添加备注>" forState:UIControlStateNormal];
            [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.unusualBtn.mas_left);
                make.top.equalTo(weakSelf.unusualBtn.mas_bottom).offset(KSIphonScreenH(25));
            }];
        }else{
            self.markBtn.hidden = NO;
            [self.markBtn setTitle:@"查看备注>" forState:UIControlStateNormal];
            [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.unusualBtn.mas_left);
                make.top.equalTo(weakSelf.unusualBtn.mas_bottom).offset(KSIphonScreenH(25));
            }];
        }
        [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
        
        
//        self.applyCardBtn.tag = 500;
//        [self.applyCardBtn setTitle:@"申请补卡>" forState:UIControlStateNormal];
//        [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf.unusualBtn.mas_left);
//            make.top.equalTo(weakSelf.unusualBtn.mas_bottom).offset(KSIphonScreenH(13));
//        }];
//        [self.applyCardBtn addTarget:self action:@selector(timeUnusualUFaceBuCard:) forControlEvents:UIControlEventTouchUpInside];
        return;
    }
 #pragma mark ---不是外勤，打卡-----
    //判断是否打卡
    if (![timeClockinHiStr isEqualToString:@""]) {
        //隐藏标签
        self.normalBtn.hidden = YES;
        self.unusualBtn.hidden = YES;
        self.leaveBtn.hidden = YES;
        
        //显示打卡时间
        self.showCardTimeLab.text = [NSString stringWithFormat:@"打卡时间: %@",dict[@"timeClockinHi"]];
        //显示标签
        NSString *unusualRemarkStr = [NSString stringWithFormat:@"%@",dict[@"unusualRemark"]];
        NSArray *arr = [unusualRemarkStr componentsSeparatedByString:@","];
        if (![unusualRemarkStr isEqualToString:@""]) {
            for (int i=0; i< arr.count; i++) {
                NSString *nameStr = arr[i];
                if ([nameStr isEqualToString:@"正常"]) {
                    self.normalBtn.hidden = NO;
                    [self.normalBtn setTitle:nameStr forState:UIControlStateNormal];
                    [self.normalBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(KSIphonScreenW(7));
                        make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
                    }];
                }
                if ([arr containsObject:@"迟到"] ||[arr containsObject:@"早退"] || [arr containsObject:@"旷工"]) {
                    self.unusualBtn.hidden = NO;
                    [self.unusualBtn setTitle:nameStr forState:UIControlStateNormal];
                    [self.unusualBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(KSIphonScreenW(7));
                        make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
                    }];
                }
            }
        }
        //判断是否标记不做异常处理
        if ([isRestStr isEqualToString:@"2"] || [notClockinStr isEqualToString:@"2"] || [offDutyOutStr isEqualToString:@"2"] ) {
            self.unusualBtn.hidden = YES;
            self.normalBtn.hidden = YES;
        }
        
        //显示打卡地点
        addressView.hidden = NO;
        addressImageV.hidden= NO;
        NSString *addressStr =dict[@"clockinCoordinate"][@"title"];
        self.addressLab.text =addressStr;
        CGFloat addressW =  [SDTool calStrWith:addressStr andFontSize:12].width+10;
        //地点判断
        NSString *addressStatuStr =[NSString stringWithFormat:@"%@",dict[@"abnormalCoordinateIs"]];
        if ([addressStatuStr isEqualToString:@"1"]) {
            self.addressStatuLab.hidden = YES;
        }else{
            self.addressStatuLab.hidden = NO;
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
        if ([faceStatuStr isEqualToString:@"2"]) {
            //隐藏身份验证view
            testView.hidden = YES;
            testImageV.hidden = YES;
            self.identTestStatuLab.text = @"未通过";
        }else{
            testView.hidden = NO;
            testImageV.hidden = NO;
            NSString *faceTestStatuStr  =[NSString stringWithFormat:@"%@",dict[@"abnormalIdentityIs"]];
            if ([faceTestStatuStr isEqualToString:@"2"]) {
                self.identTestStatuLab.text= @"未通过";
                self.identTestStatuLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
            }else{
                self.identTestStatuLab.text= @"已通过";
                self.identTestStatuLab.textColor = [UIColor colorCommonGreenColor];
            }
        }
        //隐藏
        self.workStatuBtn.hidden = YES;
        self.applyCardBtn.hidden = YES;
        
        
        
//        if ([arr containsObject:@"正常"]) {
            //隐藏补卡
            self.applyCardBtn.hidden= YES;
        
           NSArray *photoArr =(NSArray *)dict[@"photo"];
            //打卡
            if ([dict[@"remark"] isEqualToString:@""] &&  photoArr.count == 0) {
                self.markBtn.hidden = NO;
                [self.markBtn setTitle:@"添加备注>" forState:UIControlStateNormal];
                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(addressImageV.mas_left);
                    make.top.equalTo(addressImageV.mas_bottom).offset(KSIphonScreenH(25));
                }];
            }else{
                self.markBtn.hidden = NO;
                [self.markBtn setTitle:@"查看备注>" forState:UIControlStateNormal];
                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(addressImageV.mas_left);
                    make.top.equalTo(addressImageV.mas_bottom).offset(KSIphonScreenH(25));
                }];
            }
//        }else{
//            //显示补卡
//            self.applyCardBtn.hidden= NO;
//            self.applyCardBtn.tag = 500;
//            [self.applyCardBtn setTitle:@"申请补卡>" forState:UIControlStateNormal];
//            [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(addressImageV.mas_left);
//                make.top.equalTo(addressImageV.mas_bottom).offset(KSIphonScreenH(25));
//            }];
//            [self.applyCardBtn addTarget:self action:@selector(timeUnusualUFaceBuCard:) forControlEvents:UIControlEventTouchUpInside];
//            //打卡
//            if ([dict[@"remark"] isEqualToString:@""]) {
//                self.markBtn.hidden = NO;
//                [self.markBtn setTitle:@"添加备注>" forState:UIControlStateNormal];
//                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(weakSelf.applyCardBtn.mas_right).offset(KSIphonScreenW(20));
//                    make.centerY.equalTo(weakSelf.applyCardBtn.mas_centerY);
//                }];
//            }else{
//                self.markBtn.hidden = NO;
//                [self.markBtn setTitle:@"查看备注>" forState:UIControlStateNormal];
//                [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(weakSelf.applyCardBtn.mas_right).offset(KSIphonScreenW(20));
//                    make.centerY.equalTo(weakSelf.applyCardBtn.mas_centerY);
//                }];
//            }
//        }
        [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
        return;
    }
    
   dispatch_async(dispatch_get_main_queue(), ^{
       
    });
}
#pragma mark ------按钮点击事件------
//请假已通过
-(void)selectLeavaAction:(UIButton *) sender{
    switch (sender.tag - 600) {
        case 0:{
            // 请假 已通过
            self.askForLeaveBlock();
            break;
        }
        case 1:{
            // 外勤 已通过
           self.leaveInWorkSuccesBlock();
            break;
        }
            
        default:
            break;
    }
}

//申请补卡
-(void)timeUnusualUFaceBuCard:(UIButton *) sender{
    switch (sender.tag - 500) {
        case 0:{
            //申请补卡
             self.timeUnusualUFaceBuCardBlock();
            break;
        }
        case 1:{
            // 补卡 已通过
            self.leaveInBuCardSucceBlock();
            break;
        }
       
        default:
            break;
    }
    
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
