//
//  RecordDetailHeaderView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "RecordDetailHeaderView.h"

@interface RecordDetailHeaderView ()
//头像
@property (nonatomic,strong) UIImageView *headerImageV;
//名字
@property (nonatomic,strong) UILabel *nameLab;
//状态
@property (nonatomic,strong) UILabel *statusLab;
//状态ImageV
@property (nonatomic,strong) UIImageView *statusImageV;
//审批编号
@property (nonatomic,strong) UILabel *approveNumberLab;
//考勤分组
@property (nonatomic,strong) UILabel *attendGrounpLab;
//所属部门
@property (nonatomic,strong) UILabel *departmentNameLab;
//开始时间
@property (nonatomic,strong) UILabel *beginTimeLab;
//结束时间
@property (nonatomic,strong) UILabel *endTimeLab;
//时长
@property (nonatomic,strong) UILabel *timeNumberLab;
//显示事件type
@property (nonatomic,strong) UILabel *showIncidentTypenLab;
//事件原因
@property (nonatomic,strong) UILabel *incidentReaSonLab;
//显示地点
@property (nonatomic,strong) UILabel *showAddressLab;
//地点
@property (nonatomic,strong) UILabel *addressLab;
//地点ImageV
@property (nonatomic,strong) UIImageView *addressImageV;
//图片view
@property (nonatomic,strong) UIView *ImageArrView;
//显示请假类型
@property (nonatomic,strong) UILabel *showLeaveLab;
//请假类型
@property (nonatomic,strong) UILabel *leaveLab;

@end

@implementation RecordDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void)createView{
    __weak typeof(self) weakSelf = self;
    
    UIView *headerView =[[UIView alloc]init];
    [self addSubview:headerView];
    headerView.backgroundColor =[UIColor colorTextWhiteColor];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.equalTo(@68);
    }];
    UIView *lineView = [[UIView alloc]init];
    [headerView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(headerView);
        make.height.equalTo(@1);
    }];
    
    self.headerImageV = [[UIImageView alloc]init];
    [headerView addSubview:self.headerImageV];
    self.headerImageV.image = [UIImage imageNamed:@"cbl_pic_user"];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(12);
        make.centerY.equalTo(headerView.mas_centerY);
        make.width.height.equalTo(@44);
    }];
    self.headerImageV.layer.cornerRadius = 22;
    self.headerImageV.layer.masksToBounds = YES;
    
    self.nameLab = [[UILabel alloc]init];
    [headerView addSubview:self.nameLab];
    self.nameLab.text = @"李巧";
    self.nameLab.font = Font(16);
    self.nameLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerImageV.mas_top).offset(5);
        make.left.equalTo(weakSelf.headerImageV.mas_right).offset(8);
    }];
    
    self.statusLab = [[UILabel alloc]init];
    [headerView addSubview:self.statusLab];
    self.statusLab.text =@"等待审核";
    self.statusLab.font = Font(13);
    self.statusLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab.mas_left);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).offset(7);
        make.width.equalTo(@185);
    }];
    
    UILabel *showNumberLab = [[UILabel alloc]init];
    [self addSubview:showNumberLab];
    showNumberLab.text = @"审批编号";
    showNumberLab.font = Font(12);
    showNumberLab.textColor = [UIColor colorTextBg98BlackColor];
    [showNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(15);
        make.left.equalTo(weakSelf).offset(12);
    }];
    
    self.approveNumberLab = [[UILabel alloc]init];
    [self addSubview:self.approveNumberLab];
    self.approveNumberLab.text =@"";
    self.approveNumberLab.font = Font(12);
    self.approveNumberLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.approveNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showNumberLab.mas_right).offset(28);
        make.centerY.equalTo(showNumberLab.mas_centerY);
    }];
    
    self.statusImageV = [[UIImageView alloc]init];
    [self addSubview:self.statusImageV];
    self.statusImageV.image = [UIImage imageNamed:@"ico_wtg"];
    [self.statusImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(15);
        make.right.equalTo(weakSelf).offset(-12);
    }];
    
    UILabel *showAttendGrounpLab = [[UILabel alloc]init];
    [self addSubview:showAttendGrounpLab];
    showAttendGrounpLab.text = @"考勤分组";
    showAttendGrounpLab.font = Font(12);
    showAttendGrounpLab.textColor = [UIColor colorTextBg98BlackColor];
    [showAttendGrounpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showNumberLab.mas_bottom).offset(16);
        make.left.equalTo(showNumberLab.mas_left);
    }];
    
    self.attendGrounpLab = [[UILabel alloc]init];
    [self addSubview:self.attendGrounpLab];
    self.attendGrounpLab.text =@"";
    self.attendGrounpLab.font = Font(12);
    self.attendGrounpLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.attendGrounpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showAttendGrounpLab.mas_right).offset(28);
        make.centerY.equalTo(showAttendGrounpLab.mas_centerY);
    }];
    
    
    UILabel *showDepartmentNameLab = [[UILabel alloc]init];
    [self addSubview:showDepartmentNameLab];
    showDepartmentNameLab.text = @"所属部门";
    showDepartmentNameLab.tag = 500;
    showDepartmentNameLab.font = Font(12);
    showDepartmentNameLab.textColor = [UIColor colorTextBg98BlackColor];
    [showDepartmentNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showAttendGrounpLab.mas_bottom).offset(16);
        make.left.equalTo(showAttendGrounpLab.mas_left);
    }];
    
    self.departmentNameLab = [[UILabel alloc]init];
    [self addSubview:self.departmentNameLab];
    self.departmentNameLab.text =@"";
    self.departmentNameLab.font = Font(12);
    self.departmentNameLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.departmentNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showDepartmentNameLab.mas_right).offset(28);
        make.centerY.equalTo(showDepartmentNameLab.mas_centerY);
    }];
    
    self.showLeaveLab = [[UILabel alloc]init];
    [self addSubview:self.showLeaveLab];
    self.showLeaveLab.text = @"请假类型";
    self.showLeaveLab.font = Font(12);
    self.showLeaveLab.textColor = [UIColor colorTextBg98BlackColor];
    [self.showLeaveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showDepartmentNameLab.mas_bottom).offset(16);
        make.left.equalTo(showDepartmentNameLab.mas_left);
    }];
    
    self.leaveLab = [[UILabel alloc]init];
    [self addSubview:self.leaveLab];
    self.leaveLab.text =@"";
    self.leaveLab.font = Font(12);
    self.leaveLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.leaveLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.showLeaveLab.mas_right).offset(28);
        make.centerY.equalTo(weakSelf.showLeaveLab.mas_centerY);
    }];
    
    UILabel *showBeginTimeLab = [[UILabel alloc]init];
    [self addSubview:showBeginTimeLab];
    showBeginTimeLab.tag = 300;
    showBeginTimeLab.text = @"开始时间";
    showBeginTimeLab.font = Font(12);
    showBeginTimeLab.textColor = [UIColor colorTextBg98BlackColor];
    [showBeginTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showLeaveLab.mas_bottom).offset(16);
        make.left.equalTo(weakSelf.showLeaveLab.mas_left);
    }];
    
    self.beginTimeLab = [[UILabel alloc]init];
    [self addSubview:self.beginTimeLab];
    self.beginTimeLab.text =@"";
    self.beginTimeLab.font = Font(12);
    self.beginTimeLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.beginTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showBeginTimeLab.mas_right).offset(28);
        make.top.equalTo(showBeginTimeLab.mas_top);
//        make.right.equalTo(weakSelf).offset(-12);
    }];
    
    UILabel *showEndTimeLab = [[UILabel alloc]init];
    [self addSubview:showEndTimeLab];
    showEndTimeLab.tag = 301;
    showEndTimeLab.text = @"结束时间";
    showEndTimeLab.font = Font(12);
    showEndTimeLab.textColor = [UIColor colorTextBg98BlackColor];
    [showEndTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showBeginTimeLab.mas_bottom).offset(16);
        make.left.equalTo(showBeginTimeLab.mas_left);
    }];
    
    self.endTimeLab = [[UILabel alloc]init];
    [self addSubview:self.endTimeLab];
    self.endTimeLab.text =@"";
    self.endTimeLab.font = Font(12);
    self.endTimeLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.endTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showEndTimeLab.mas_right).offset(28);
        make.centerY.equalTo(showEndTimeLab.mas_centerY);
    }];
    
    UILabel *showTimeNumberLab = [[UILabel alloc]init];
    [self addSubview:showTimeNumberLab];
    showTimeNumberLab.tag = 302;
    showTimeNumberLab.text = @"时长(小时)";
    showTimeNumberLab.font = Font(12);
    showTimeNumberLab.textColor = [UIColor colorTextBg98BlackColor];
    [showTimeNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showEndTimeLab.mas_bottom).offset(16);
        make.left.equalTo(showEndTimeLab.mas_left);
    }];
    
    self.timeNumberLab = [[UILabel alloc]init];
    [self addSubview:self.timeNumberLab];
    self.timeNumberLab.text =@"";
    self.timeNumberLab.font = Font(12);
    self.timeNumberLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.timeNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.approveNumberLab.mas_left);
        make.centerY.equalTo(showTimeNumberLab.mas_centerY);
    }];
    
    self.showIncidentTypenLab = [[UILabel alloc]init];
    [self addSubview:self.showIncidentTypenLab];
    self.showIncidentTypenLab.text = @"外出事由";
    self.showIncidentTypenLab.font = Font(12);
    self.showIncidentTypenLab.textColor = [UIColor colorTextBg98BlackColor];
    [self.showIncidentTypenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showTimeNumberLab.mas_bottom).offset(16);
        make.left.equalTo(showTimeNumberLab.mas_left);
    }];
    
    self.incidentReaSonLab = [[UILabel alloc]init];
    [self addSubview:self.incidentReaSonLab];
    self.incidentReaSonLab.text =@"";
    self.incidentReaSonLab.font = Font(12);
    self.incidentReaSonLab.numberOfLines = 0;
    self.incidentReaSonLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.incidentReaSonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.approveNumberLab.mas_left);
        make.top.equalTo(weakSelf.showIncidentTypenLab.mas_top);
        make.width.equalTo(@278);
    }];
    
    self.showAddressLab = [[UILabel alloc]init];
    [self addSubview:self.showAddressLab];
    self.showAddressLab.text = @"外出地点";
    self.showAddressLab.font = Font(12);
    self.showAddressLab.textColor = [UIColor colorTextBg98BlackColor];
    [self.showAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.incidentReaSonLab.mas_bottom).offset(16);
        make.left.equalTo(weakSelf.showIncidentTypenLab.mas_left);
    }];
    
    self.addressLab = [[UILabel alloc]init];
    [self addSubview:self.addressLab];
    self.addressLab.text =@"";
    self.addressLab.font = Font(12);
    self.addressLab.numberOfLines = 0;
    self.addressLab.textColor = [UIColor colorCommonGreenColor];
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.approveNumberLab.mas_left);
        make.top.equalTo(weakSelf.showAddressLab.mas_top);
    }];
    self.addressLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddressTap)];
    [self.addressLab addGestureRecognizer:addressTap];
    
    self.addressImageV = [[UIImageView alloc]init];
    [self addSubview:self.addressImageV];
    self.addressImageV.image =[UIImage imageNamed:@"ico_dw01"];
    [self.addressImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressLab.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.addressLab.mas_centerY);
    }];
    
    UIView *bottomLineView = [[UIView alloc]init];
    [self addSubview:bottomLineView];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.equalTo(@10);
    }];
    
    self.ImageArrView = [[UIView alloc]init];
    [self addSubview:self.ImageArrView];
    [self.ImageArrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.showAddressLab.mas_bottom).offset(15);
        make.height.equalTo(@52);
    }];
    
    UILabel *showImageLab = [[UILabel alloc]init];
    [self.ImageArrView addSubview:showImageLab];
    showImageLab.text = @"上传图片";
    showImageLab.font = Font(12);
    showImageLab.textColor = [UIColor colorTextBg98BlackColor];
    [showImageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.ImageArrView);
        make.left.equalTo(weakSelf.ImageArrView).offset(12);
    }];
}
-(void)selectAddressTap{
    self.selectAddressBlock();
}
-(void)setHeaderType:(RecordDetailHeaderType)headerType{
    _headerType = headerType;
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    UILabel *showBeginTimeLab =  [self viewWithTag:300];
    UILabel *showEndTimeLab =  [self viewWithTag:301];
    UILabel *showTimeNumberLab = [self viewWithTag:302];
    UILabel *showDepartmentNameLab = [self viewWithTag:500];
    showBeginTimeLab.text = @"开始时间";
    showEndTimeLab.hidden = NO;
    showTimeNumberLab.hidden = NO;
    self.statusImageV.hidden = NO;
    self.ImageArrView.hidden = NO;
    self.showAddressLab.hidden = NO;
    self.addressLab.hidden = NO;
    self.addressImageV.hidden =NO;
    //结束时间
    self.endTimeLab.hidden =NO;
    //时长
    self.timeNumberLab.hidden =NO;
    
    //外出
    NSDictionary *infoDict = dict[@"userInfo"];
    //名字
    self.nameLab.text = infoDict[@"realName"];
    //头像
    [UIImageView sd_setImageView:self.headerImageV WithURL:infoDict[@"photo"]];
    
    NSString *statusStr =[NSString stringWithFormat:@"%@",dict[@"status"]];
    if ([statusStr isEqualToString:@"3"]) {
        //未通过
        self.statusLab.text = @"审批未通过";
        self.statusLab.textColor = [UIColor colorWithHexString:@"#f76254"];
        
        self.statusImageV.image = [UIImage imageNamed:@"ico_wtg"];
        
    }else if ([statusStr isEqualToString:@"2"]){
        //通过
        self.statusLab.text =@"审批同意";
        self.statusLab.textColor = [UIColor colorCommonGreenColor];
        
        self.statusImageV.image = [UIImage imageNamed:@"ico_tg"];
    }else if ([statusStr isEqualToString:@"1"]){
        //待审批
        //被审批者
        NSArray *arr = dict[@"approvalUser"];
        NSMutableString *nameStr = [NSMutableString new];
        if (arr.count > 0 ) {
            for (int i=0; i<arr.count; i++) {
                if ([arr[i] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *userDict = arr[i];
                    if([[userDict allKeys] containsObject:@"realName"]) {
                        [nameStr appendString:userDict[@"realName"]];
                        if (i != arr.count-1) {
                            [nameStr appendString:@"/"];
                        }
                    }
                }
               
            }
        }
        self.statusLab.text =[NSString stringWithFormat:@"等待%@审批",nameStr];
        self.statusLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
        
        self.statusImageV.hidden = YES;
    }else if ([statusStr isEqualToString:@"4"]){
        //4:撤回
        self.statusLab.text =@"申请已撤销";
        self.statusLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
        
        self.statusImageV.image = [UIImage imageNamed:@"ico_ycx"];
    }
    //审批编号
    self.approveNumberLab.text = dict[@"numberId"];
    //考勤分组
    self.attendGrounpLab.text =dict[@"agName"];
    //部门
    self.departmentNameLab.text =dict[@"department"];
    
    __weak typeof(self) weakSelf = self;
    if (_headerType == RecordDetailHeaderGoOutType) {
        //隐藏请假类型
        self.showLeaveLab.hidden = YES;
        self.leaveLab.hidden = YES;
        [showBeginTimeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showDepartmentNameLab.mas_bottom).offset(16);
            make.left.equalTo(showDepartmentNameLab.mas_left);
        }];
        
        //开始时间
        self.beginTimeLab.text =dict[@"startTime"];
        //结束时间
        self.endTimeLab.text =dict[@"endTime"];
        //时长
        self.timeNumberLab.text =[NSString stringWithFormat:@"%.2f",[dict[@"numbers"]floatValue]];
        
        NSString *outGoStr = dict[@"outGo"];
        if ([outGoStr isEqualToString:@""]) {
            [self.showAddressLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.showIncidentTypenLab.mas_bottom).offset(16);
                make.left.equalTo(weakSelf.showIncidentTypenLab.mas_left);
            }];
        }
        
        //外出事由
        self.incidentReaSonLab.numberOfLines = 4;
        self.incidentReaSonLab.text =outGoStr;
        //外出地点
        NSString *addressStr =dict[@"address"];
        CGFloat w = [SDTool calStrWith:addressStr andFontSize:12].width;
        self.addressLab.text =dict[@"address"];
        if (w > KScreenW-129) {
            [self.addressImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(weakSelf).offset(-12);
                make.left.equalTo(weakSelf.addressLab.mas_right).offset(12);
                make.centerY.equalTo(weakSelf.addressLab.mas_centerY);
            }];
        }
        
        NSArray *imageArr = dict[@"images"];
        if (imageArr.count == 0) {
            self.ImageArrView.hidden = YES;
        }else{
            for (int i=0; i<imageArr.count; i++) {
                UIImageView *imageV = [[UIImageView alloc]init];
                [self.ImageArrView addSubview:imageV];
                [SDTool sd_setImageView:imageV WithURL:imageArr[i]];
                imageV.tag =  200+i;
                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf).offset(85+i*54+i*5);
                    make.bottom.equalTo(weakSelf.mas_bottom).offset(-17);
                    make.width.height.equalTo(@54);
                }];
                imageV.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageAciton:)];
                [imageV addGestureRecognizer:tap];
            }
        }
    }else if (_headerType == RecordDetailHeaderLeaveType){
        //请假类型
        NSString *leaveTypeStr = [NSString stringWithFormat:@"%@",dict[@"leaveType"]];
        if ([leaveTypeStr isEqualToString:@"1"]) {
            self.leaveLab.text = @"年假";
        }else if ([leaveTypeStr isEqualToString:@"2"]){
            self.leaveLab.text = @"事假";
        }else if ([leaveTypeStr isEqualToString:@"3"]){
            self.leaveLab.text = @"调休";
        }else if ([leaveTypeStr isEqualToString:@"4"]){
            self.leaveLab.text = @"产假";
        }else if ([leaveTypeStr isEqualToString:@"5"]){
            self.leaveLab.text = @"婚假";
        }else if ([leaveTypeStr isEqualToString:@"6"]){
            self.leaveLab.text = @"丧假";
        }else if ([leaveTypeStr isEqualToString:@"7"]){
            self.leaveLab.text = @"护理假";
        }else if ([leaveTypeStr isEqualToString:@"8"]){
            self.leaveLab.text = @"病假";
        }else if ([leaveTypeStr isEqualToString:@"9"]){
            self.leaveLab.text = @"轮休";
        }
        
        //开始时间
        self.beginTimeLab.text =dict[@"startTime"];
        //结束时间
        self.endTimeLab.text =dict[@"endTime"];
        //时长
        self.timeNumberLab.text =[NSString stringWithFormat:@"%.2f",[dict[@"numbers"]floatValue]];
        
        NSString *outGoStr = dict[@"leaveInfo"];
        if ([outGoStr isEqualToString:@""]) {
            [self.ImageArrView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.showIncidentTypenLab.mas_bottom).offset(16);
                make.left.right.equalTo(weakSelf);
                make.height.equalTo(@52);
            }];
        }else{
            [self.ImageArrView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.incidentReaSonLab.mas_bottom).offset(16);
                make.left.right.equalTo(weakSelf);
                make.height.equalTo(@52);
            }];
        }
        self.showIncidentTypenLab.text = @"请假事由";
        //请假事由
        self.incidentReaSonLab.numberOfLines = 4;
        self.incidentReaSonLab.text =outGoStr;
        
        //隐藏选择地点
        self.showAddressLab.hidden = YES;
        self.addressLab.hidden = YES;
        self.addressImageV.hidden =YES;
        
        NSArray *imageArr = dict[@"images"];
        if (imageArr.count == 0) {
            self.ImageArrView.hidden = YES;
        }else{
            for (int i=0; i<imageArr.count; i++) {
                UIImageView *imageV = [[UIImageView alloc]init];
                [self.ImageArrView addSubview:imageV];
                [SDTool sd_setImageView:imageV WithURL:imageArr[i]];
                imageV.tag =  200+i;
                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf).offset(85+i*54+i*5);
                    make.bottom.equalTo(weakSelf.mas_bottom).offset(-17);
                    make.width.height.equalTo(@54);
                }];
                imageV.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageAciton:)];
                [imageV addGestureRecognizer:tap];
            }
        }
        
    }else if (_headerType == RecordDetailHeaderCardType){
        //隐藏请假类型
        self.showLeaveLab.hidden = YES;
        self.leaveLab.hidden = YES;
        [showBeginTimeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showDepartmentNameLab.mas_bottom).offset(16);
            make.left.equalTo(showDepartmentNameLab.mas_left);
        }];
        //补卡
        //结束时间
        self.endTimeLab.hidden =YES;
        //时长
        self.timeNumberLab.hidden =YES;
        showEndTimeLab.hidden = YES;
        showTimeNumberLab.hidden = YES;
        //隐藏选择地点
        self.showAddressLab.hidden = YES;
        self.addressLab.hidden = YES;
        self.addressImageV.hidden =YES;
        
        showBeginTimeLab.text = @"补卡班次";
        
        NSString *baseTypeStr  ;
        if ([dict[@"baseType"] integerValue] == 2) {
            baseTypeStr = @"下班";
        }else{
             baseTypeStr = @"上班";
        }
        //补卡班次
        self.beginTimeLab.numberOfLines = 4;
        self.beginTimeLab.text =[NSString stringWithFormat:@"%@,%@,%@%@,补卡时间 %@",dict[@"replacementTime"],dict[@"today"],baseTypeStr,dict[@"sureTime"],dict[@"cardTime"]];
        
        [self.beginTimeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showBeginTimeLab.mas_right).offset(28);
            make.top.equalTo(showBeginTimeLab.mas_top);
            make.right.equalTo(weakSelf).offset(-12);
        }];
        
        //事由
        self.showIncidentTypenLab.text = @"缺卡原因";
        [self.showIncidentTypenLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showBeginTimeLab.mas_left);
            make.top.equalTo(weakSelf.beginTimeLab.mas_bottom).offset(16);
        }];
        //原因
        self.incidentReaSonLab.text = dict[@"reason"];
        
        [self.ImageArrView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf.showIncidentTypenLab.mas_bottom).offset(15);
            make.height.equalTo(@52);
        }];
        
        NSArray *imageArr = dict[@"images"];
        if (imageArr.count == 0) {
            self.ImageArrView.hidden = YES;
        }else{
            for (int i=0; i<imageArr.count; i++) {
                UIImageView *imageV = [[UIImageView alloc]init];
                [self.ImageArrView addSubview:imageV];
                [SDTool sd_setImageView:imageV WithURL:imageArr[i]];
                imageV.tag =  200+i;
                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf).offset(85+i*50+i*5);
                    make.bottom.equalTo(weakSelf.mas_bottom).offset(-17);
                    make.width.height.equalTo(@50);
                }];
                imageV.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageAciton:)];
                [imageV addGestureRecognizer:tap];
            }
        }
    }else if (_headerType == RecordDetailHeaderOverTimeType){
         //隐藏请假类型
        self.showLeaveLab.hidden = YES;
        self.leaveLab.hidden = YES;
        [showBeginTimeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showDepartmentNameLab.mas_bottom).offset(16);
            make.left.equalTo(showDepartmentNameLab.mas_left);
        }];
        
        //开始时间
        self.beginTimeLab.text =dict[@"startTime"];
        //结束时间
        self.endTimeLab.text =dict[@"endTime"];
        //时长
        self.timeNumberLab.text =[NSString stringWithFormat:@"%.2f",[dict[@"numbers"]floatValue]];
        
        NSString *overTimeStr = dict[@"overTimeInfo"];
        if ([overTimeStr isEqualToString:@""]) {
            [self.ImageArrView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.showIncidentTypenLab.mas_bottom).offset(16);
                make.left.right.equalTo(weakSelf);
                make.height.equalTo(@52);
            }];
        }else{
            [self.ImageArrView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.incidentReaSonLab.mas_bottom).offset(16);
                make.left.right.equalTo(weakSelf);
                make.height.equalTo(@52);
            }];
        }
        self.showIncidentTypenLab.text = @"加班事由";
        //加班事由
        self.incidentReaSonLab.numberOfLines = 4;
        self.incidentReaSonLab.text =overTimeStr;
        
        //隐藏选择地点
        self.showAddressLab.hidden = YES;
        self.addressLab.hidden = YES;
        self.addressImageV.hidden =YES;
        
        NSArray *imageArr = dict[@"images"];
        if (imageArr.count == 0) {
            self.ImageArrView.hidden = YES;
        }else{
            for (int i=0; i<imageArr.count; i++) {
                UIImageView *imageV = [[UIImageView alloc]init];
                [self.ImageArrView addSubview:imageV];
                [SDTool sd_setImageView:imageV WithURL:imageArr[i]];
                imageV.tag =  200+i;
                [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(weakSelf).offset(85+i*54+i*5);
                    make.bottom.equalTo(weakSelf.mas_bottom).offset(-17);
                    make.width.height.equalTo(@54);
                }];
                imageV.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageAciton:)];
                [imageV addGestureRecognizer:tap];
            }
        }
        
    }

}
-(void)addImageAciton:(UITapGestureRecognizer *) tap{
    UIImageView *imageV = (UIImageView *)tap.view;
    [XWScanImage scanBigImageWithImageView:imageV];
    
}
//计算高度
+(CGFloat) getWithTextHeaderViewHeight:(NSDictionary *)dict headerType:(NSString *)headerType{
   
    CGFloat outGoHeig = 0.0;
    ////外出
    if ([headerType isEqualToString:@"2"]) {
        //计算原因高度
        NSString *outGoStr = dict[@"outGo"];
        if (![outGoStr isEqualToString:@""]) {
            outGoHeig  = [SDTool getLabelHeightWithText:outGoStr width:KScreenW-85-12 font:12];
        }else{
            outGoHeig = 17;
        }
        NSArray *imageArr = dict[@"images"];
        if (imageArr.count > 0) {
            outGoHeig += 52;
        }
         return outGoHeig + 320;
    }else if ([headerType isEqualToString:@"1"]){
        //计算请假事由高度
        NSString *leaveInfoStr = dict[@"leaveInfo"];
        //请假
        if (![leaveInfoStr isEqualToString:@""]) {
            outGoHeig  = [SDTool getLabelHeightWithText:leaveInfoStr width:KScreenW-85-12 font:12];
        }else{
            outGoHeig = 17;
        }
        NSArray *imageArr = dict[@"images"];
        if (imageArr.count > 0) {
            outGoHeig += 52;
        }
        
        return outGoHeig + 320;
    }else if ([headerType isEqualToString:@"3"]){
        //计算请假事由高度
        NSString *leaveInfoStr = dict[@"reason"];
        //补卡
        if (![leaveInfoStr isEqualToString:@""]) {
            outGoHeig  = [SDTool getLabelHeightWithText:leaveInfoStr width:KScreenW-85-12 font:12];
        }else{
            outGoHeig = 17;
        }
        NSArray *imageArr = dict[@"images"];
        if (imageArr.count > 0) {
            outGoHeig += 52;
        }
        
        return outGoHeig + 250;
    }else if ([headerType isEqualToString:@"5"]){
        //计算加班事由高度
        NSString *leaveInfoStr = dict[@"overTimeInfo"];
        //加班
        if (![leaveInfoStr isEqualToString:@""]) {
            outGoHeig  = [SDTool getLabelHeightWithText:leaveInfoStr width:KScreenW-85-12 font:12];
        }else{
            outGoHeig = 17;
        }
        NSArray *imageArr = dict[@"images"];
        if (imageArr.count > 0) {
            outGoHeig += 52;
        }
        return outGoHeig +290;
    }
     return 0;
}



@end
