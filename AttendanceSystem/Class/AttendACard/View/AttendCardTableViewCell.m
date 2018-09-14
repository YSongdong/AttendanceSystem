//
//  AttendCardTableViewCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/18.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AttendCardTableViewCell.h"

@interface AttendCardTableViewCell ()
<
AMapLocationManagerDelegate,
AMapSearchDelegate
>
@property (nonatomic, strong) AMapSearchAPI *search;
//上班和时间
@property (nonatomic,strong) UILabel *showWorkTimeLab;
//left图片
@property (nonatomic,strong) UIImageView *leftImageV;
//打卡按钮
@property (nonatomic,strong) UIButton *punchCardBtn;
//打卡类型
@property (nonatomic,strong) UILabel *punchCardTypeLab;
//显示当前时间
@property (nonatomic,strong) UILabel *showTimeLab;
//address
@property (nonatomic,strong) UILabel *addressLab;
//显示地址是否正常
@property (nonatomic,strong) UILabel *normalAddressLab;
//重新定位
@property (nonatomic,strong) UIButton *againLocateBtn;
//定位管理器
@property (nonatomic,strong)AMapLocationManager *locationManager;
//获得自己的位置，方便demo添加围栏进行测试，
@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic,assign) BOOL isCard;

@property (nonatomic,assign) NSTimeInterval interval;

//---------返回信息----------//
//打卡地点状态
@property (nonatomic,assign) NSInteger cardAddressStatu;
//点位地点
@property (nonatomic,assign) NSString *addressStr;
//数据源
@property (nonatomic,strong) NSMutableDictionary *coordDataDict;
@end

@implementation AttendCardTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //打卡地点状态 2打卡地点异常
        self.cardAddressStatu = 2;
        self.isCard = NO;
        [self createView];
    }
    return self;
}
-(void)createView{
    __weak typeof(self) weakSelf = self;
    //显示上班和时间
    self.showWorkTimeLab = [[UILabel alloc]init];
    [self addSubview:self.showWorkTimeLab];
    self.showWorkTimeLab.text = @"";
    self.showWorkTimeLab.font = Font(13);
    self.showWorkTimeLab.textColor = [UIColor colorTextBg65BlackColor];
    [self.showWorkTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(35));
    }];
    
    self.leftImageV =[[UIImageView alloc]init];
    [self addSubview:self.leftImageV];
    self.leftImageV.image = [UIImage imageNamed:@"pic_site_sel"];
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(9));
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
    
    self.punchCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.punchCardBtn];
    [self.punchCardBtn setBackgroundImage:[UIImage imageNamed:@"ico_sbdk"] forState:UIControlStateNormal];
    [self.punchCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showWorkTimeLab.mas_bottom).offset(KSIphonScreenH(27));
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    [self.punchCardBtn addTarget:self action:@selector(selctPunchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //打卡类型
    self.punchCardTypeLab = [[UILabel alloc]init];
    [self addSubview:self.punchCardTypeLab];
    self.punchCardTypeLab.text = @"上班打卡";
    self.punchCardTypeLab.textColor = [UIColor colorTextWhiteColor];
    self.punchCardTypeLab.font =  Font(18);
    [self.punchCardTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.punchCardBtn.mas_top).offset(KSIphonScreenH(45));
        make.centerX.equalTo(weakSelf.punchCardBtn.mas_centerX);
    }];

    //开启时间
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    //显示时间
    self.showTimeLab = [[UILabel alloc]init];
    [self addSubview:self.showTimeLab];
    self.showTimeLab.textColor = [UIColor colorTextWhiteColor];
    self.showTimeLab.font = Font(13);
    [self.showTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.punchCardTypeLab.mas_bottom).offset(KSIphonScreenH(11));
        make.centerX.equalTo(weakSelf.punchCardTypeLab.mas_centerX);
    }];
    
    UIView *addressView = [[UIView alloc]init];
    [self addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.punchCardBtn.mas_bottom).offset(KSIphonScreenH(18));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(45));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(45));
        make.height.equalTo(@(KSIphonScreenH(30)));
        make.centerX.equalTo(weakSelf.punchCardBtn.mas_centerX);
    }];
    
    self.againLocateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressView addSubview:self.againLocateBtn];
    [self.againLocateBtn setTitle:@"重新定位 >" forState:UIControlStateNormal];
    [self.againLocateBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.againLocateBtn.titleLabel.font = Font(12);
    [self.againLocateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addressView);
        make.centerY.equalTo(addressView.mas_centerY);
    }];
    [self.againLocateBtn addTarget:self action:@selector(selelctAgainBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //地址
    self.addressLab  =[[UILabel alloc]init];
    [addressView addSubview:self.addressLab];
    self.addressLab.textAlignment = NSTextAlignmentCenter;
    self.addressLab.font = Font(12);
    self.addressLab.textAlignment = NSTextAlignmentCenter;
    self.addressLab.textColor = [UIColor colorTextBg65BlackColor];
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.againLocateBtn.mas_left).offset(-KSIphonScreenW(12));
        make.centerY.equalTo(weakSelf.againLocateBtn.mas_centerY);
    }];
 
    self.normalAddressLab = [[UILabel alloc]init];
    [addressView addSubview:self.normalAddressLab];
    self.normalAddressLab.font = Font(12);
    self.normalAddressLab.text = @"当前定位信号弱:";
    self.normalAddressLab.textAlignment = NSTextAlignmentCenter;
    self.normalAddressLab.textColor = [UIColor colorTextBg65BlackColor];
    [self.normalAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.addressLab.mas_left).offset(-KSIphonScreenW(9));
        make.centerY.equalTo(weakSelf.addressLab.mas_centerY);
    }];
    
    UIImageView *leftImageV = [[UIImageView alloc]init];
    [addressView addSubview:leftImageV];
    leftImageV.image = [UIImage imageNamed:@"qrxx_ico_dw"];
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.normalAddressLab.mas_left).offset(-KSIphonScreenW(5));
        make.left.equalTo(addressView.mas_left);
        make.centerY.equalTo(weakSelf.normalAddressLab.mas_centerY);
    }];
    
}
-(void)updateTime{
    NSDate *currentDate;
    if (self.dict == nil) {
        currentDate  = [NSDate date];
    }else{
        self.interval +=1;
        currentDate = [NSDate dateWithTimeIntervalSince1970:self.interval];
    }
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    [dataFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dataFormatter stringFromDate:currentDate];
    self.showTimeLab.text = dateString;
}
//重新定位
-(void)selelctAgainBtn:(UIButton *) sender{
    self.againLocationBlcok(self.dict);
}
//打卡
-(void)selctPunchBtnAction:(UIButton *) sender{
    NSArray *arr = [SDTool getData:self.dict Locat:self.userLocation];
    NSString *deviationStr;
    for (NSDictionary *dict in arr) {
        NSString *isScopeStr  = dict[@"isScope"];
        if ([isScopeStr isEqualToString:@"1"]) {
           deviationStr =  dict[@"coordinate"][@"deviation"];
        }
    }
    //如果地点异常， 就选用最近的点作为半径
    if (deviationStr == nil) {
        //排序（按最近的距离）
        NSArray *tempArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if([[obj1 objectForKey:@"distance"]intValue] < [[obj2 objectForKey:@"distance"]intValue]){
                return NSOrderedAscending;
            }
            if([[obj1 objectForKey:@"distance"]intValue] > [[obj2 objectForKey:@"distance"]intValue]){
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        NSDictionary *frintDict = [tempArr firstObject];
        deviationStr =  frintDict[@"distance"];
    }
    
    //打卡状态
    NSMutableDictionary *coordinateDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *ChildcoordinateDict = [NSMutableDictionary dictionary];
    //打卡经纬度
    ChildcoordinateDict[@"lat"] = [NSString stringWithFormat:@"%f",self.userLocation.coordinate.latitude];
    ChildcoordinateDict[@"lng"] = [NSString stringWithFormat:@"%f",self.userLocation.coordinate.longitude];
    coordinateDict[@"coordinate"] = ChildcoordinateDict;
    coordinateDict[@"abnormalCoordinateIs"] =  [NSString stringWithFormat:@"%ld",(long)self.cardAddressStatu];
    coordinateDict[@"title"] = self.addressLab.text ;
    coordinateDict[@"deviation"] =deviationStr;
    self.selectCardBlcok(coordinateDict);
}
-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    //服务器时间作对
    self.interval = [dataDict[@"time"] doubleValue];
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
    
    //考勤类型
    NSString *isGoStr = [NSString stringWithFormat:@"%@",dict[@"isGo"]];
    //是上班还是下班
    NSString *clockinType = [NSString stringWithFormat:@"%@",dict[@"clockinType"]];
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
    //时间
    self.showWorkTimeLab.text = [NSString stringWithFormat:@"%@%@  (时间%@)",clockStr,clockinTypeStr,dict[@"sureTime"]];
    
   //打卡类型
    self.punchCardTypeLab.text = clockinTypeStr;
}
//更新地点 和显示状态
-(void)updateAddress:(NSString *)addressStr location:(CLLocation *)location{
    //位置坐标
    self.userLocation = location;
    self.addressLab.text = addressStr;
    NSArray *arr = [SDTool getData:self.dict Locat:location];
    BOOL isScope = NO;
    for (NSDictionary *dict in arr) {
        NSString *isScopeStr  = dict[@"isScope"];
        if ([isScopeStr isEqualToString:@"1"]) {
            isScope = YES;
            self.cardAddressStatu = 1;
        }
    }
    if (isScope) {
        self.normalAddressLab.text = @"已进入打卡范围:";
    }else{
        NSString *addressStr = @"地点异常当前定位:";
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:addressStr];
        [attributStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ffb046"] range:NSMakeRange(0, 4)];
        self.normalAddressLab.attributedText = attributStr;
    }
    //更新地址
    self.addressBlock(addressStr);
}

-(NSMutableDictionary *)coordDataDict{
    if(!_coordDataDict){
        _coordDataDict = [NSMutableDictionary dictionary];
    }
    return _coordDataDict;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
