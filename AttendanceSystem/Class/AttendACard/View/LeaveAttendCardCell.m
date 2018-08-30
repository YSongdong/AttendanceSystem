//
//  LeaveAttendCardCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/24.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "LeaveAttendCardCell.h"

@interface LeaveAttendCardCell ()
//上班和时间
@property (nonatomic,strong) UILabel *showWorkTimeLab;
//left图片
@property (nonatomic,strong) UIImageView *leftImageV;
//显示打卡时间view
@property (nonatomic,strong) UIView *cardTimeView;
//打卡时间
@property (nonatomic,strong) UILabel *showCardTimeLab;
//请假标签
@property (nonatomic,strong) UIButton *leaveBtn;

//显示地址view
@property (nonatomic,strong) UIView *addressView;
//地址
@property (nonatomic,strong) UILabel *addressLab;
//地址异常
@property (nonatomic,strong) UILabel  *addressStatuLab;

//显示身份验证view
@property (nonatomic,strong)UIView *testView;
//身份验证
@property (nonatomic,strong) UILabel *identTestStatuLab;

//请假 已通过》
@property (nonatomic,strong) UIButton *leaveStatuBtn;
//备注按钮
@property (nonatomic,strong) UIButton *markBtn;

@end

@implementation LeaveAttendCardCell

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
    
    //显示打卡时间view
    self.cardTimeView = [[UIView alloc]init];
    [self addSubview:self.cardTimeView];
    //打卡时间
    self.showCardTimeLab = [[UILabel alloc]init];
    [self.cardTimeView addSubview:self.showCardTimeLab];
    self.showCardTimeLab.text =[NSString stringWithFormat:@""];
    self.showCardTimeLab.font = BFont(16);
    self.showCardTimeLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.showCardTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(29);
        make.left.equalTo(weakSelf).offset(33);
    }];
    
    //请假、外勤标签
    self.leaveBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.cardTimeView addSubview:self.leaveBtn];
    [self.leaveBtn setTitle:@"请假" forState:UIControlStateNormal];
    [self.leaveBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.leaveBtn.titleLabel.font = Font(12);
    [self.leaveBtn setBackgroundImage:[UIImage imageNamed:@"kqjl_ico_wq"] forState:UIControlStateNormal];
    [self.leaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.showCardTimeLab.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.showCardTimeLab.mas_centerY);
    }];
    [self.cardTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(29);
        make.left.width.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.bottom.equalTo(weakSelf.showCardTimeLab.mas_bottom);
    }];
    
    self.addressView = [[UIView alloc]init];
    [self addSubview:self.addressView];
    
    UIImageView *addressImageV = [[UIImageView alloc]init];
    [self.addressView addSubview:addressImageV];
    addressImageV.tag = 300;
    addressImageV.image =[UIImage imageNamed:@"qrxx_ico_dw"];
    [addressImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.showCardTimeLab.mas_left);
        make.centerY.equalTo(weakSelf.addressView.mas_centerY);
        make.width.equalTo(@12);
    }];
    
    self.addressLab  = [[UILabel alloc]init];
    [self.addressView addSubview:self.addressLab];
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
    
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showCardTimeLab.mas_bottom).offset(10);
        make.left.width.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.bottom.equalTo(weakSelf.addressStatuLab.mas_bottom);
    }];
    
    self.testView = [[UIView alloc]init];
    [self addSubview:self.testView];
    
    UIImageView *testImageV = [[UIImageView alloc]init];
    [self.testView addSubview:testImageV];
    testImageV.tag = 301;
    testImageV.image = [UIImage imageNamed:@"qrxx_ico_sfyz"];
    [testImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressImageV.mas_bottom).offset(4);
        make.left.equalTo(addressImageV.mas_left);
    }];
    
    UILabel *showIdentiTestLab  = [[UILabel alloc]init];
    [self.testView addSubview:showIdentiTestLab];
    showIdentiTestLab.text =@"身份验证:";
    showIdentiTestLab.font = Font(12);
    showIdentiTestLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [showIdentiTestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(testImageV.mas_right).offset(5);
        make.centerY.equalTo(testImageV.mas_centerY);
    }];
    
    self.identTestStatuLab = [[UILabel alloc]init];
    [self.testView addSubview:self.identTestStatuLab];
    self.identTestStatuLab.textColor = [UIColor colorCommonGreenColor];
    self.identTestStatuLab.font = Font(12);
    self.identTestStatuLab.text = @"";
    [self.identTestStatuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showIdentiTestLab.mas_right).offset(9);
        make.centerY.equalTo(showIdentiTestLab.mas_centerY);
    }];
    
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addressView.mas_bottom);
        make.left.width.equalTo(weakSelf.addressView);
        make.centerX.equalTo(weakSelf.addressView.mas_centerX);
        make.bottom.equalTo(weakSelf.identTestStatuLab.mas_bottom);
    }];
    
    //请假按钮
    self.leaveStatuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.leaveStatuBtn];
    [self.leaveStatuBtn setTitle:@"请假 已通过>" forState:UIControlStateNormal];
    [self.leaveStatuBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.leaveStatuBtn.titleLabel.font = Font(12);
    [self.leaveStatuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(testImageV.mas_left);
        make.top.equalTo(testImageV.mas_bottom).offset(13);
    }];
    
    //备注按钮
    self.markBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.markBtn];
    [self.markBtn setTitle:@"添加备注 >" forState:UIControlStateNormal];
    [self.markBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.markBtn.titleLabel.font = Font(12);
    [self.markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leaveStatuBtn.mas_right).offset(KSIphonScreenW(20));
        make.centerY.equalTo(weakSelf.leaveStatuBtn.mas_centerY);
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
    
    UIImageView *addressImageV = [self viewWithTag:300];
    //回复初始化
    self.showCardTimeLab.hidden = NO;
    self.leaveBtn.hidden = NO;
    addressImageV.hidden = NO;
    self.addressView.hidden = NO;
    self.testView.hidden = NO;
    
    self.leaveStatuBtn.hidden = NO;
    self.markBtn.hidden = NO;
  
    [self.addressStatuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressLab.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.addressLab.mas_centerY);
    }];
    
    [self.leaveStatuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.testView.mas_left);
        make.top.equalTo(weakSelf.testView.mas_bottom).offset(13);
    }];
    
    [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leaveStatuBtn.mas_right).offset(KSIphonScreenW(20));
        make.centerY.equalTo(weakSelf.leaveStatuBtn.mas_centerY);
    }];
    
    //身份验证
    NSString *faceStatuStr = [NSString stringWithFormat:@"%@",dict[@"faceStatus"]];
 
    //是否打卡
    NSString *timeClockinHiStr =[NSString stringWithFormat:@"%@",dict[@"timeClockinHi"]];
    
    //判断是否打卡
    if ([timeClockinHiStr isEqualToString:@""]) {
        //没有打卡
        self.showCardTimeLab.hidden = YES;
        
        [self.leaveBtn setTitle:@"请假" forState:UIControlStateNormal];
        [self.leaveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(29);
            make.left.equalTo(weakSelf.showWorkTimeLab.mas_left);
        }];
        
        //没有打卡
        self.addressView.hidden = YES;
        self.testView.hidden = YES;
        /// 隐藏备注
        self.markBtn.hidden = YES;
      
        //请假已通过
        self.leaveStatuBtn.hidden = NO;
        [self.leaveStatuBtn setTitle:@"请假 已通过>" forState:UIControlStateNormal];
        [self.leaveStatuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leaveBtn.mas_left);
            make.top.equalTo(weakSelf.leaveBtn.mas_bottom).offset(KSIphonScreenH(13));
        }];
        [self.leaveStatuBtn addTarget:self action:@selector(selectLeavaAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return;
    }
   
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
        self.addressView.hidden = NO;
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
            self.testView.hidden = YES;
            self.identTestStatuLab.text = @"未通过";
            
        }else{
            self.testView.hidden = NO;
            NSString *faceTestStatuStr  =[NSString stringWithFormat:@"%@",dict[@"abnormalIdentityIs"]];
            if ([faceTestStatuStr isEqualToString:@"2"]) {
                self.identTestStatuLab.text= @"未通过";
                self.identTestStatuLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
            }else{
                self.identTestStatuLab.text= @"已通过";
                self.identTestStatuLab.textColor = [UIColor colorCommonGreenColor];
            }
        }
        self.leaveStatuBtn.hidden = NO;
        [self.leaveStatuBtn setTitle:@"请假 已通过>" forState:UIControlStateNormal];
        [self.leaveStatuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.showWorkTimeLab.mas_left);
            make.top.equalTo(addressImageV.mas_bottom).offset(KSIphonScreenH(27));
        }];
        [self.leaveStatuBtn addTarget:self action:@selector(selectLeavaAction:) forControlEvents:UIControlEventTouchUpInside];
       
        //备注
        if ([dict[@"remark"] isEqualToString:@""]) {
            self.markBtn.hidden = NO;
            [self.markBtn setTitle:@"添加备注>" forState:UIControlStateNormal];
            [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.leaveStatuBtn.mas_right).offset(KSIphonScreenW(20));
                make.centerY.equalTo(weakSelf.leaveStatuBtn.mas_centerY);
            }];
        }else{
            self.markBtn.hidden = NO;
            [self.markBtn setTitle:@"查看备注>" forState:UIControlStateNormal];
            [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.leaveStatuBtn.mas_right).offset(KSIphonScreenW(20));
                make.centerY.equalTo(weakSelf.leaveStatuBtn.mas_centerY);
            }];
        }
        [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
        return ;
    }
}

//请假
-(void)selectLeavaAction:(UIButton *) sender{
    self.askForLeaveBlock();
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
