//
//  AttendRecordController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/22.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AttendRecordController.h"


#import "ShowMarkView.h"

#import "SupplementCardController.h"
#import "RecordApproveDetaController.h"


#import "ShowPunchCardCell.h"
#define SHOWPUNCHCARD_CELL @"ShowPunchCardCell"

#import "SameDayHaveRestCell.h"
#define SAMEDAYHAVEREST_CELL @"SameDayHaveRestCell"

#import "ShowUnPunchCardCell.h"
#define SHOWNNPUNCHCARD_CELL @"ShowUnPunchCardCell"

#import "AttendFutureTimeCell.h"
#define ATTENDFUTURETIME_CELL @"AttendFutureTimeCell"

#define HEADERBGVIEWHIGHT 408
@interface AttendRecordController ()
<JTCalendarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *_eventsByDate;
    NSDate *_dateSelected;
}
//备注view
@property (nonatomic,strong) ShowMarkView *showMarkView;

@property (nonatomic,strong) UITableView *recordTableView;
//日历
@property (strong, nonatomic) JTCalendarManager *calendarManager;
//日历view
@property (nonatomic,strong) JTHorizontalCalendarView *calenderView;
//显示日历lab；
@property (nonatomic,strong) UILabel *showNowCalendarLab;
//数据源字典
@property (nonatomic,strong) NSDictionary *dataDict;
//日历数据源
@property (nonatomic,strong) NSMutableDictionary *calendarDict;
//当天的数据源
@property (nonatomic,strong) NSMutableArray *dayArr;
@end

@implementation AttendRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    [self createNavi];
    [self createView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataDict = nil;
    [self.dayArr removeAllObjects];
    if (self.selectDate == nil) {
        _dateSelected =[NSDate date];
        //获取当月的数据
        [self requestCalendarMondData:[[self requestDateFormatter]stringFromDate:[NSDate date]]];
        //获取当天的数据
        [self requestCalendarDayData:[[self requestDateFormatter]stringFromDate:[NSDate date]]];
    }else{
        _dateSelected = [[self requestDateFormatter]dateFromString:self.selectDate];
        //获取当月的数据
        [self requestCalendarMondData:self.selectDate];
        //获取当天的数据
        [self requestCalendarDayData:self.selectDate];
        
    }
    
   
}
-(void) createView{
    __weak typeof(self) weakSelf = self;
    UIView *headerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, HEADERBGVIEWHIGHT)];
    headerBgView.backgroundColor = [UIColor colorTextWhiteColor];
   
    UIView *headerView  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 44)];
    headerView.backgroundColor =[UIColor colorTextWhiteColor];
    [headerBgView addSubview:headerView];

    self.showNowCalendarLab = [[UILabel alloc]init];
    [headerView addSubview:self.showNowCalendarLab];
    self.showNowCalendarLab.font = BFont(16);
    self.showNowCalendarLab.text = [[self showDateFormatter]stringFromDate:[NSDate date]];
    self.showNowCalendarLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.showNowCalendarLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY);
        make.centerX.equalTo(headerView.mas_centerX);
    }];
    
    //下一个月
    UIButton *nextMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:nextMonthBtn];
    [nextMonthBtn setImage:[UIImage imageNamed:@"kqjl_ico_yj"] forState:UIControlStateNormal];
    [nextMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(headerView);
        make.left.equalTo(weakSelf.showNowCalendarLab.mas_right);
        make.centerY.equalTo(weakSelf.showNowCalendarLab.mas_centerY);
        make.width.height.equalTo(@44);
    }];
    [nextMonthBtn addTarget:self action:@selector(selectNextMonth:) forControlEvents:UIControlEventTouchUpInside];

    //上一月
    UIButton *previousMonthBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:previousMonthBtn];
    [previousMonthBtn setImage:[UIImage imageNamed:@"kqjl_ico_zj"] forState:UIControlStateNormal];
    [previousMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(headerView);
        make.right.equalTo(weakSelf.showNowCalendarLab.mas_left);
        make.centerY.equalTo(weakSelf.showNowCalendarLab.mas_centerY);
        make.width.height.equalTo(@44);
    }];
    [previousMonthBtn addTarget:self action:@selector(previousMonth:) forControlEvents:UIControlEventTouchUpInside];

    UIView *lineView  =[[UIView alloc]init];
    [headerView addSubview:lineView];
    lineView.backgroundColor  =[UIColor colorWithHexString:@"#e0e0e0"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(headerView);
        make.height.equalTo(@1);
    }];

    UIView *attendGrounpView = [[UIView alloc]initWithFrame:CGRectMake(0, HEADERBGVIEWHIGHT-44-20, KScreenW, 44)];
    attendGrounpView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [headerBgView addSubview:attendGrounpView];

    UILabel *showAttendGrounpLab  =[[UILabel alloc]init];
    [attendGrounpView addSubview:showAttendGrounpLab];
    showAttendGrounpLab.font = Font(14);
    showAttendGrounpLab.textColor = [UIColor colorTextBg65BlackColor];
    [showAttendGrounpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(attendGrounpView).offset(12);
        make.centerY.equalTo(attendGrounpView.mas_centerY);
    }];
    showAttendGrounpLab.text = [NSString stringWithFormat:@"考勤组: %@",[SDUserInfo obtainWithProGroupName]];

    self.calenderView = [[JTHorizontalCalendarView alloc]init];
    [headerBgView addSubview:self.calenderView];
    self.calenderView.pagingEnabled = YES;
    [self.calenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.right.left.equalTo(headerBgView);
        make.bottom.equalTo(attendGrounpView.mas_top);
        make.centerX.equalTo(headerBgView.mas_centerX);
    }];
    self.calendarManager =[JTCalendarManager new];
    self.calendarManager.delegate = self;

    //设置第一列为周一
    self.calendarManager.dateHelper.calendar.firstWeekday = 2;
    //显示第一列显示样式
    self.calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
    //设置需要显示日历的View
    [self.calendarManager setContentView:self.calenderView];
    //在日历显示初始化的时候就需要
    [self.calendarManager setDate:[NSDate date]];

    self.recordTableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
    [self.view addSubview:self.recordTableView];
    
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    self.recordTableView.tableHeaderView = headerBgView;
    self.recordTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.recordTableView registerClass:[ShowPunchCardCell class] forCellReuseIdentifier:SHOWPUNCHCARD_CELL];
    [self.recordTableView registerClass:[SameDayHaveRestCell class] forCellReuseIdentifier:SAMEDAYHAVEREST_CELL];
    [self.recordTableView registerClass:[AttendFutureTimeCell class] forCellReuseIdentifier:ATTENDFUTURETIME_CELL];
}
#pragma mark --TableViewDelegate-----
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dayArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *nowStr =[NSString stringWithFormat:@"%@",self.dataDict[@"now"]];
    NSDictionary *dict =  self.dayArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if ([nowStr isEqualToString:@"3"]) {
        //还未到打卡时间
        SameDayHaveRestCell *cell = [tableView dequeueReusableCellWithIdentifier:SAMEDAYHAVEREST_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        //过去
        //有考勤记录
        ShowPunchCardCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOWPUNCHCARD_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dict = dict;
        //备注
        cell.markBlock = ^{
            __weak typeof(weakSelf) stongSelf = weakSelf;
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showMarkView];
            weakSelf.showMarkView.dict = dict;
            weakSelf.showMarkView.addMarkBlock = ^(NSString *markStr) {
                NSMutableDictionary *mutableDict =  [NSMutableDictionary dictionaryWithDictionary:dict];
                mutableDict[@"remark"]= markStr;
                //贴换元素
                [stongSelf.dayArr replaceObjectAtIndex:indexPath.row withObject:mutableDict.copy];
                [stongSelf.recordTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
            };
        };
        //请假
        cell.askForLeaveBlock = ^{
            RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
          
            detaVC.detaType = RecordApproveLeaveDetaType;
            detaVC.typeStr = @"1";
            NSString *leaveInStr = [NSString stringWithFormat:@"%@",dict[@"leaveIn"]];
            if ([leaveInStr isEqualToString:@"2"]) {
                detaVC.recordIdStr = dict[@"leaveInId"];
            }
            detaVC.titleStr = [NSString stringWithFormat:@"%@请假申请",[SDUserInfo obtainWithRealName]];
            //其他
            detaVC.chenkStatusStr = @"2";
            [weakSelf.navigationController pushViewController:detaVC animated:YES];
        };
        //补卡通过
        cell.leaveInBuCardSucceBlock = ^{
            RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
            //补卡
            detaVC.detaType = recordApproveCardDetaType;
            detaVC.typeStr = @"3";
            if ([dict[@"no"] isEqualToString:@"3"]) {
                detaVC.recordIdStr = dict[@"noId"];
            }
            detaVC.titleStr = [NSString stringWithFormat:@"%@补卡申请",[SDUserInfo obtainWithRealName]];
            //其他
            detaVC.chenkStatusStr = @"2";
            [weakSelf.navigationController pushViewController:detaVC animated:YES];
        };
        //外勤通过
        cell.leaveInWorkSuccesBlock = ^{
            RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
            //外出
            detaVC.detaType = RecordApproveGoOutDetaType;
            detaVC.typeStr = @"2";
            if ([dict[@"isGo"] isEqualToString:@"2"]) {
                detaVC.recordIdStr = dict[@"outgoRecordId"];
            }
            detaVC.titleStr = [NSString stringWithFormat:@"%@外勤申请",[SDUserInfo obtainWithRealName]];
            //其他
            detaVC.chenkStatusStr = @"2";
            [weakSelf.navigationController pushViewController:detaVC animated:YES];
        };
        //申请补卡
        cell.timeUnusualUFaceBuCardBlock = ^{
            NSString *recardStr = [NSString stringWithFormat:@"%@",[SDUserInfo obtainWithRecard]];
            if ([recardStr isEqualToString:@"2"]) {
                [SDShowSystemPrompView showSystemPrompStr:@"请先联系管理员设置审批规则"];
                return;
            }
            NSString *recordIdStr =dict[@"Id"];
            SupplementCardController *supplementVC = [[SupplementCardController alloc]init];
            supplementVC.recordIdStr =recordIdStr;
            [weakSelf.navigationController pushViewController:supplementVC animated:YES];
        };
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *nowStr =[NSString stringWithFormat:@"%@",self.dataDict[@"now"]];
    if ([nowStr isEqualToString:@"3"]) {
        return 225;
    }else   {
        return 145;
    }
}
#pragma mark - CalendarManager delegate------
//改变日历的代理方法
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Other month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    //日期为今天的样式
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithHexString:@"#9fe1c6"];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor colorWithHexString:@"#239566"];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorCommonGreenColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        NSDictionary *dict = [self haveEventFordayView:dayView];
        if ([dict[@"type"] isEqualToString:@"2"]) {
            dayView.circleView.hidden = YES;
            dayView.dotView.backgroundColor = [UIColor redColor];
            dayView.textLabel.textColor = [UIColor colorWithHexString:@"#cccccc"];
        }else{
            dayView.circleView.hidden = YES;
            dayView.dotView.backgroundColor = [UIColor redColor];
            dayView.textLabel.textColor = [UIColor colorTextBg28BlackColor];
        }
    }

        NSDictionary *dict = [self haveEventFordayView:dayView];
        if ([dict[@"type"] isEqualToString:@"1"]) {
            if ([dict[@"status"] isEqualToString:@"1"]) {
                dayView.dotView.hidden = NO;
                //时间错误红色
                dayView.dotView.backgroundColor = [UIColor colorWithHexString:@"#f75254"];
            }else  if ([dict[@"status"] isEqualToString:@"2"]) {
                dayView.dotView.hidden = NO;
                //2身份地点错误黄色
                dayView.dotView.backgroundColor = [UIColor colorWithHexString:@"#ffb046"];
            }else if ([dict[@"status"] isEqualToString:@"3"]){
                dayView.dotView.hidden = NO;
                // 3都正确绿色
                dayView.dotView.backgroundColor = [UIColor colorCommonGreenColor];
            }else{
                dayView.dotView.hidden = YES;
            }
        }else{
            dayView.dotView.hidden = YES;
        }
}
- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    self.showNowCalendarLab.text =  [[self showDateFormatter]stringFromDate:_dateSelected];
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView duration:.3  options:0  animations:^{
        dayView.circleView.transform = CGAffineTransformIdentity;
            [self.calendarManager reload];
    } completion:nil];
    if(![_calendarManager.dateHelper date:_calenderView.date isTheSameMonthThan:dayView.date]){
        if([_calenderView.date compare:dayView.date] == NSOrderedAscending){
            [_calenderView loadNextPageWithAnimation];
        }
        else{
            [_calenderView loadPreviousPageWithAnimation];
        }
    }
    //移除数据源
    [self.dayArr removeAllObjects];
    self.dataDict = nil;
    //获取当天的数据
    [self requestCalendarDayData:[[self requestDateFormatter]stringFromDate:dayView.date]];
}
-(void)calendarDidLoadNextPage:(JTCalendarManager *)calendar{
    //移除数据源
    self.dataDict =  nil;
    [self.dayArr removeAllObjects];
    
    //设置选中日期
    _dateSelected = calendar.date;
    
    //从服务器请求下一个月时间
    [ self requestCalendarMondData:[[self requestDateFormatter]stringFromDate:calendar.date]];
    //请求下一月这一天的数据
    [self requestCalendarDayData:[[self requestDateFormatter]stringFromDate:calendar.date]];
    //显示日期
    self.showNowCalendarLab.text =[[self showDateFormatter]stringFromDate:calendar.date];
}
-(void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar{
    //移除数据源
    self.dataDict =  nil;
    [self.dayArr removeAllObjects];
    //设置选中日期
    _dateSelected = calendar.date;
    
    //从服务器请求下一个月时间
    [ self requestCalendarMondData:[[self requestDateFormatter]stringFromDate:calendar.date]];
    //请求下一月这一天的数据
    [self requestCalendarDayData:[[self requestDateFormatter]stringFromDate:calendar.date]];
    //显示日期
    self.showNowCalendarLab.text =[[self showDateFormatter]stringFromDate:calendar.date];
}
-(NSDictionary *) haveEventFordayView:(JTCalendarDayView *)dayView{
    NSString *key =[self dateWithString:dayView.date];
    NSDictionary *dict = self.calendarDict[key];
    return dict;
}
#pragma mark -------按钮点击事件------
//下一月
-(void)selectNextMonth:(UIButton *) sender{
    [_calenderView loadNextPageWithAnimation];
}
//上一月
-(void)previousMonth:(UIButton *) sender{
     [_calenderView loadPreviousPageWithAnimation];
}
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    return dateFormatter;
}
- (NSDateFormatter *)showDateFormatter{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"YYYY年MM月";
    }
    return dateFormatter;
}
- (NSDateFormatter *)requestDateFormatter{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"YYYY.MM.dd";
    }
    return dateFormatter;
}
-(NSDate *) stringWithDate:(NSString *)timeStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //解决8小时时间差问题
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *birthdayDate = [dateFormatter dateFromString:timeStr];
    return birthdayDate;
}
-(NSString *) dateWithString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
#pragma mark ----懒加载-------
-(NSMutableArray *)dayArr{
    if (!_dayArr) {
        _dayArr = [NSMutableArray array];
    }
    return _dayArr;
}
-(ShowMarkView *)showMarkView{
    if (!_showMarkView) {
        _showMarkView = [[ ShowMarkView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showMarkView;
}
-(NSMutableDictionary *)calendarDict{
    if (!_calendarDict) {
        _calendarDict = [NSMutableDictionary dictionary];
    }
    return _calendarDict;
}
//设置navi
-(void) createNavi{
    self.customNavBar.title = @"考勤记录";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
-(void)setSelectDate:(NSString *)selectDate{
    _selectDate = selectDate;
}
#pragma mark -----数据相关-----
//获取一个月的数据
-(void)requestCalendarMondData:(NSString *)date{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"date"] = date;
    param[@"type"] = @"2";
    param[@"token"] = [SDTool getNewToken];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_APPATTENDSTATUSLIST_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            self.calendarDict = [NSMutableDictionary dictionaryWithDictionary:showdata];
            [self.calendarManager reload];
        }
    }];
}
//获取当前的考勤
-(void)requestCalendarDayData:(NSString *)date{
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    param[@"date"] = date;
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_APPUSERDAYSATTENDACEGROUINFO_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            self.dataDict = [NSDictionary dictionary];
            self.dataDict = showdata;
            
            NSString *nowStr = [NSString stringWithFormat:@"%@",showdata[@"now"]];
            if ([nowStr isEqualToString:@"3"]) {
                //未来时间
                [self.dayArr addObject:@""];
                [self.recordTableView reloadData];
            }else{
                // 1 有考勤记录
                for (NSDictionary *dict in showdata[@"data"]) {
                    NSString *titleStr = [NSString stringWithFormat:@"%@",dict[@"title"]];
                    if ([titleStr isEqualToString:@"3"]) {
                        [self.dayArr addObject:dict];
                    }
                }
                [self.recordTableView reloadData];
            }
        }
    }];

}



@end
