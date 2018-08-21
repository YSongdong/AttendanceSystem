//
//  AttendCountController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/17.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AttendCountController.h"

#import "AttendRecordController.h"

#import "DateTimePickerView.h"
#import "AttendCardHeaderView.h"

#import "CountGroupHeaderView.h"
#define COUNTGROUPHEADERVIEW @"CountGroupHeaderView"

#import "AttendCountTableViewCell.h"
#define ATTENDCOUNTTABLEVIEW_CELL @"AttendCountTableViewCell"

#define HEAHERVIEWHEIGHT  67
@interface AttendCountController ()
<
DateTimePickerViewDelegate,
UITableViewDelegate,
UITableViewDataSource
>
//头部视图
@property (nonatomic,strong) AttendCardHeaderView *headerView;
//时间选择器
@property (nonatomic, strong) DateTimePickerView *datePickerView;
@property (nonatomic,strong) UITableView *countTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;
//记录选择日期
@property (nonatomic,strong) NSString *selectCalendarStr;
@end

@implementation AttendCountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectCalendarStr = @"";
    [self createNavi];
    [self createTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //请求当天的日期
    NSString *dateStr = [[self requestDateFormatter]stringFromDate:[NSDate date]];
    self.selectCalendarStr = dateStr;
    [self.headerView.selectBtn setTitle:dateStr forState:UIControlStateNormal];
    //获取当天的数据
    [self requestAttendCountData:self.selectCalendarStr];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = self.dataArr[section];
    NSString *isOffStr = dict[@"isOff"];
    if ([isOffStr isEqualToString:@"1"]) {
        return 0;
    }else{
        NSArray *arr = dict[@"data"];
        return arr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttendCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ATTENDCOUNTTABLEVIEW_CELL forIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSArray *arr = dict[@"data"];
    cell.dict = arr[indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CountGroupHeaderView *headerView= [[CountGroupHeaderView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 60)];
    NSDictionary *dict = self.dataArr[section];
    headerView.dict = dict;
    headerView.selectGroupBlcok = ^{
        __weak typeof(self) weakSelf = self;
        //判断是否是否可以展开
        NSString *numStr = [NSString stringWithFormat:@"%@",dict[@"num"]];
        NSMutableDictionary *mutablDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        if ([numStr integerValue] > 0) {
            if ([dict[@"isOff"] isEqualToString:@"1"]) {
                mutablDict[@"isOff"] = @"2";
            }else{
               mutablDict[@"isOff"] = @"1";
            }
            [weakSelf.dataArr replaceObjectAtIndex:section withObject:mutablDict.copy];
            [weakSelf.countTableView reloadSection:section withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = self.dataArr[section];
    if ([dict[@"type"] isEqualToString:@"missCard"] || [dict[@"type"] isEqualToString:@"onTime"] || [dict[@"type"] isEqualToString:@"abnormal"]) {
       return 70;
    }else{
       return 60;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDict = self.dataArr[indexPath.section];
    NSArray *arr = dataDict[@"data"];
    NSDictionary *dict = arr[indexPath.row];
    AttendRecordController *recodVC =[[AttendRecordController alloc]init];
    NSString *sureDateStr =  dict[@"sureDate"];
    sureDateStr = [sureDateStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    recodVC.selectDate = sureDateStr;
    [self.navigationController pushViewController:recodVC animated:YES];
}
#pragma mark ---时间选择器-----
-(void)selectTimeAction:(UIButton *) sender{
    [self.view addSubview:self.datePickerView];
    [self.datePickerView showDateTimePickerView];
}
#pragma mark - delegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    [self.headerView.selectBtn setTitle:date forState:UIControlStateNormal];
    self.selectCalendarStr = date;
    //请求数据
    [self requestAttendCountData:date];
}
#pragma mark -----tableview-----
-(void) createTableView{
    //加载headerView
    [self.view addSubview:self.headerView];
    [self.headerView.selectBtn addTarget:self action:@selector(selectTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.countTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+HEAHERVIEWHEIGHT, KScreenW, KScreenH-KSNaviTopHeight-HEAHERVIEWHEIGHT-KSTabbarH) style:UITableViewStyleGrouped];
    [self.view addSubview:self.countTableView];
    
    self.countTableView.delegate = self;
    self.countTableView.dataSource = self;
    self.countTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.countTableView registerNib:[UINib nibWithNibName:ATTENDCOUNTTABLEVIEW_CELL bundle:nil] forCellReuseIdentifier:ATTENDCOUNTTABLEVIEW_CELL];
}
//设置navi
-(void) createNavi{
    self.customNavBar.title = @"考勤统计";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.customNavBar wr_setRightButtonWithTitle:@"考勤记录" titleColor:[UIColor colorTextWhiteColor]];
    self.customNavBar.onClickRightButton = ^{
        AttendRecordController *recodVC =[[AttendRecordController alloc]init];
        recodVC.selectDate = [[weakSelf showDateFormatter]stringFromDate:[NSDate date]];
        [weakSelf.navigationController pushViewController:recodVC animated:YES];
    };
}
#pragma mark ---懒加载-----
-(AttendCardHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[AttendCardHeaderView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, HEAHERVIEWHEIGHT)];
    }
    return _headerView;
}
-(DateTimePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView =[[DateTimePickerView alloc] init];
        _datePickerView.delegate = self;
       // _datePickerView.currentDate = [NSDate date];
        _datePickerView.pickerViewMode = DatePickerViewDateYMode;
    }
    return _datePickerView;
}
- (NSDateFormatter *)requestDateFormatter{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"YYYY.MM";
    }
    return dateFormatter;
}
- (NSDateFormatter *)showDateFormatter{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"YYYY.MM.dd";
    }
    return dateFormatter;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark ---数据相关----
-(void)requestAttendCountData:(NSString *)date{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"date"] = date;
    param[@"token"] =[SDTool getNewToken];
    param[@"userId"] =[SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_APPATTENDACESTATISTIAPPGET_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if (![showdata isKindOfClass:[NSDictionary class]]) {
            return;
        }
        //移除之前的数据
        [self.dataArr removeAllObjects];
        
        //缺卡
        NSMutableDictionary * missCardDict= [NSMutableDictionary dictionaryWithDictionary:showdata[@"missCard"]];
        missCardDict[@"isOff"] = @"1";
        missCardDict[@"name"] = @"缺卡";
        missCardDict[@"type"] = @"missCard";
        [self.dataArr addObject:missCardDict];
        //旷工
        NSMutableDictionary * completionDict= [NSMutableDictionary dictionaryWithDictionary:showdata[@"completion"]];
        completionDict[@"isOff"] = @"1";
        completionDict[@"name"] = @"旷工";
        completionDict[@"type"] = @"completion";
        [self.dataArr addObject:completionDict];
        //迟到
        NSMutableDictionary * lateDict= [NSMutableDictionary dictionaryWithDictionary:showdata[@"late"]];
        lateDict[@"isOff"] = @"1";
        lateDict[@"name"] = @"迟到";
        lateDict[@"type"] = @"late";
        [self.dataArr addObject:lateDict];
        //早退
        NSMutableDictionary * leavEarlyDict= [NSMutableDictionary dictionaryWithDictionary:showdata[@"leavEarly"]];
        leavEarlyDict[@"isOff"] = @"1";
        leavEarlyDict[@"name"] = @"早退";
        leavEarlyDict[@"type"] = @"leavEarly";
        [self.dataArr addObject:leavEarlyDict];
        //准时
        NSMutableDictionary * onTimeDict= [NSMutableDictionary dictionaryWithDictionary:showdata[@"onTime"]];
        onTimeDict[@"isOff"] = @"1";
        onTimeDict[@"name"] = @"准时";
        onTimeDict[@"type"] = @"onTime";
        [self.dataArr addObject:onTimeDict];
        //补卡申请
        NSMutableDictionary * supCardDict= [NSMutableDictionary dictionaryWithDictionary:showdata[@"supCard"]];
        supCardDict[@"isOff"] = @"1";
        supCardDict[@"name"] = @"补卡申请";
        supCardDict[@"type"] = @"supCard";
        [self.dataArr addObject:supCardDict];
        //外勤
        NSMutableDictionary * fieldDict= [NSMutableDictionary dictionaryWithDictionary:showdata[@"field"]];
        fieldDict[@"isOff"] = @"1";
        fieldDict[@"name"] = @"外勤";
        fieldDict[@"type"] = @"field";
        [self.dataArr addObject:fieldDict];
        //请假
        NSMutableDictionary * leaveDict= [NSMutableDictionary dictionaryWithDictionary:showdata[@"leave"]];
        leaveDict[@"isOff"] = @"1";
        leaveDict[@"name"] = @"请假";
        leaveDict[@"type"] = @"leave";
        [self.dataArr addObject:leaveDict];
        //异常记录
        NSMutableDictionary * abnormalDict= [NSMutableDictionary dictionaryWithDictionary:showdata[@"abnormal"]];
        abnormalDict[@"isOff"] = @"1";
        abnormalDict[@"name"] = @"异常记录";
        abnormalDict[@"type"] = @"abnormal";
        [self.dataArr addObject:abnormalDict];
        
        [self.countTableView reloadData];
        
    }];
    
}




@end
