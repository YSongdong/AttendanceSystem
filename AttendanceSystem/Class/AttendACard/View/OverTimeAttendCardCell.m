//
//  OverTimeAttendCardCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/24.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "OverTimeAttendCardCell.h"

@interface OverTimeAttendCardCell ()
//上班和时间
@property (nonatomic,strong) UILabel *showWorkTimeLab;
//left图片
@property (nonatomic,strong) UIImageView *leftImageV;
//显示打卡时间view
@property (nonatomic,strong) UIView *cardTimeView;
//打卡时间
@property (nonatomic,strong) UILabel *showCardTimeLab;
//正常标签
@property (nonatomic,strong) UIButton *normalBtn;
//异常标签
@property (nonatomic,strong) UIButton *unusualBtn;
//请假标签
@property (nonatomic,strong) UIButton *leaveBtn;
//加班标签
@property (nonatomic,strong) UIButton *overTimeBtn;

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
//加班 已通过>
@property (nonatomic,strong) UIButton *overTimeStatuBtn;
//补卡按钮
@property (nonatomic,strong) UIButton *applyCardBtn;
//备注按钮
@property (nonatomic,strong) UIButton *markBtn;

@end

@implementation OverTimeAttendCardCell

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
    
    //正常标签
    self.normalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cardTimeView addSubview:self.normalBtn];
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
    [self.cardTimeView addSubview:self.unusualBtn];
    [self.unusualBtn setTitle:@"迟到" forState:UIControlStateNormal];
    [self.unusualBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.unusualBtn.titleLabel.font = Font(12);
    [self.unusualBtn setBackgroundImage:[UIImage imageNamed:@"ico_yc"] forState:UIControlStateNormal];
    [self.unusualBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.normalBtn.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.normalBtn.mas_centerY);
    }];

    //外勤标签
    self.leaveBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [self.cardTimeView addSubview:self.leaveBtn];
    [self.leaveBtn setTitle:@"请假" forState:UIControlStateNormal];
    [self.leaveBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    self.leaveBtn.titleLabel.font = Font(12);
    [self.leaveBtn setBackgroundImage:[UIImage imageNamed:@"kqjl_ico_wq"] forState:UIControlStateNormal];
    [self.leaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.unusualBtn.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.unusualBtn.mas_centerY);
    }];
    
//    //请假标签
//    self.overTimeBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
//    [self.cardTimeView addSubview:self.overTimeBtn];
//    [self.overTimeBtn setTitle:@"加班" forState:UIControlStateNormal];
//    [self.overTimeBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
//    self.overTimeBtn.titleLabel.font = Font(12);
//    [self.overTimeBtn setBackgroundImage:[UIImage imageNamed:@"kqjl_ico_wq"] forState:UIControlStateNormal];
//    [self.overTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.leaveBtn.mas_right).offset(7);
//        make.centerY.equalTo(weakSelf.leaveBtn.mas_centerY);
//    }];
    
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
    [self.leaveStatuBtn addTarget:self action:@selector(selectLeavaAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    //加班按钮
//    self.overTimeStatuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:self.overTimeStatuBtn];
//    [self.overTimeStatuBtn setTitle:@"加班 已通过>" forState:UIControlStateNormal];
//    [self.overTimeStatuBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
//    self.overTimeStatuBtn.titleLabel.font = Font(12);
//    [self.overTimeStatuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.leaveStatuBtn.mas_right).offset(KSIphonScreenW(20));
//        make.centerY.equalTo(weakSelf.leaveStatuBtn.mas_centerY);
//    }];
    
    //申请补卡按钮
    self.applyCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.applyCardBtn];
    self.applyCardBtn.tag = 500;
    [self.applyCardBtn setTitle:@"申请补卡 >" forState:UIControlStateNormal];
    [self.applyCardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.applyCardBtn.titleLabel.font = Font(12);
    [self.applyCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leaveStatuBtn.mas_right).offset(KSIphonScreenW(20));
        make.centerY.equalTo(weakSelf.leaveStatuBtn.mas_centerY);
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
    [self.markBtn addTarget:self action:@selector(nomalLookMark:) forControlEvents:UIControlEventTouchUpInside];
    
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
    self.overTimeBtn.hidden = NO;
    
    self.addressView.hidden = NO;
    self.testView.hidden = NO;
    
    self.applyCardBtn.hidden = NO;
    self.leaveStatuBtn.hidden = NO;
    self.overTimeStatuBtn.hidden = NO;
    self.markBtn.hidden = NO;
    self.applyCardBtn.tag = 500;
    
    [self.addressStatuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressLab.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.addressLab.mas_centerY);
    }];
    
    [self.leaveStatuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(testImageV.mas_left);
        make.top.equalTo(testImageV.mas_bottom).offset(13);
    }];
    
    [self.applyCardBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leaveStatuBtn.mas_right).offset(KSIphonScreenW(20));
        make.centerY.equalTo(weakSelf.leaveStatuBtn.mas_centerY);
    }];
    [self.markBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.applyCardBtn.mas_right).offset(KSIphonScreenW(20));
        make.centerY.equalTo(weakSelf.applyCardBtn.mas_centerY);
    }];
    //1正常 2外勤 3公共
    NSString *isGoStr  =[NSString stringWithFormat:@"%@",dict[@"isGo"]];
   // 1正常打卡 2缺卡 3补卡
    NSString *noStr =[NSString stringWithFormat:@"%@",dict[@"no"]];
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
    
    //1需要补卡 2无需补卡
    NSString *cardReissueStr = [NSString stringWithFormat:@"%@",[SDUserInfo obtainWithCardReissue]];

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
