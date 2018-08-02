//
//  LeaveInApprovalController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "GoOutApprovalController.h"

#import "GoOutRecordController.h"
#import "ShowSelectCameraView.h"
#import "RecordMapSelectViewController.h"
#import "RecordApproveDetaController.h"

#import "SelectLeaveInTimeCell.h"
#define SELECTLEAVEINTIME_CELL @"SelectLeaveInTimeCell"

#import "ApprovarReasonCell.h"
#define APPROVALREASON_CELL @"ApprovarReasonCell"

#import "LeaveInDestinAddressCell.h"
#define LEAVEINDESTIONADDRESS_CELL @"LeaveInDestinAddressCell"

#import "ApprovalSelectPhotoCell.h"
#define APPROVALSELECTPHOTO_CELL @"ApprovalSelectPhotoCell"

#import "ApprovalSubintCell.h"
#define APPROVALSUBINT_CELL @"ApprovalSubintCell"

#import "ApprovalPersonCell.h"
#define APPROVALPERSON_CELL @"ApprovalPersonCell"



@interface GoOutApprovalController ()
<
UITableViewDelegate,
UITableViewDataSource,
DateTimePickerViewDelegate,
RecordMapSelectViewControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic,strong)UITableView *leaveTableView;
//选择相机view
@property (nonatomic,strong)ShowSelectCameraView *showSelectCameraView;
//时间选择器
@property (nonatomic, strong) DateTimePickerView *datePickerView;
//选择时间类型  1 开始时间  2结束时间
@property (nonatomic,strong)NSString *selectTimeType;

@property (nonatomic,strong)NSString *beginTimeStr;
@property (nonatomic,strong)NSString *endTimeStr;

//请求参数数据
@property (nonatomic,strong) NSMutableDictionary *dataDcit;
//接受选择外出地点
@property (nonatomic,strong) NSMutableDictionary *addressDict;

@end

@implementation GoOutApprovalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createTableView];
    [self requestApprovalMemberData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        SelectLeaveInTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:SELECTLEAVEINTIME_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //开始时间
        cell.beginTimeBlock = ^{
            weakSelf.selectTimeType = @"1";
            [weakSelf.view addSubview:weakSelf.datePickerView];
            [weakSelf.datePickerView showDateTimePickerView];
        };
        //结束时间
        cell.endTimeBlock = ^{
            weakSelf.selectTimeType = @"2";
            [weakSelf.view addSubview:weakSelf.datePickerView];
            [weakSelf.datePickerView showDateTimePickerView];
        };
        return cell;
    }else if (indexPath.row ==1){
        ApprovarReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALREASON_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row ==2){
        LeaveInDestinAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:LEAVEINDESTIONADDRESS_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectAddressBlock = ^{
            __weak typeof(weakSelf) stongSelf = weakSelf;
            RecordMapSelectViewController *mapSelectVC = [[RecordMapSelectViewController alloc]init];
            mapSelectVC.delegate = stongSelf;
            [weakSelf.navigationController pushViewController:mapSelectVC animated:YES];
        };
        return cell;
    }else if(indexPath.row ==3){
        ApprovalSelectPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALSELECTPHOTO_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //选择相机
        cell.selectPhotoBlock = ^{
           [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showSelectCameraView];
            //选择相机
            weakSelf.showSelectCameraView.cameraBlock = ^{
                [weakSelf selectphotoType:@"2"];
            };
            //选择相册
            weakSelf.showSelectCameraView.photoBlock = ^{
               [weakSelf selectphotoType:@"1"];
            };
        };
        return cell;
    }else if (indexPath.row == 4){
        ApprovalPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALPERSON_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ApprovalSubintCell *cell  = [tableView dequeueReusableCellWithIdentifier:APPROVALSUBINT_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.subimtBlock = ^{
            //提交
            [weakSelf getSubmitData];
        };
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 190;
    }else if (indexPath.row ==1){
        return 135;
    }else if (indexPath.row ==2){
        return 115;
    }else if (indexPath.row == 3){
        return 135;
    }else if (indexPath.row ==4){
        return 165;
    }else{
        return 80;
    }
}
-(void) getSubmitData{
    __weak typeof(self) weaSelf= self;
    if (self.beginTimeStr == nil) {
        [SDShowSystemPrompView showSystemPrompStr:@"请选择结束时间"];
        return;
    }
    if (self.endTimeStr == nil) {
        [SDShowSystemPrompView showSystemPrompStr:@"请选择开始时间"];
        return;
    }
   
    weaSelf.dataDcit[@"startTime"] = [weaSelf.beginTimeStr stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    weaSelf.dataDcit[@"endTime"] =[weaSelf.endTimeStr stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    NSInteger timeLong = [SDTool calculateWithStartTime:weaSelf.beginTimeStr endTime:weaSelf.endTimeStr];
    weaSelf.dataDcit[@"numbers"] = [NSString stringWithFormat:@"%ld",(long)timeLong];
    //事由
    NSIndexPath *reasonIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    ApprovarReasonCell *reasonCell =[self.leaveTableView cellForRowAtIndexPath:reasonIndexPath];
    if (reasonCell.cellTextView.text != nil) {
       weaSelf.dataDcit[@"outGo"] = reasonCell.cellTextView.text;
    }
    //地址
    NSIndexPath *addressIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    LeaveInDestinAddressCell *addressCell = [self.leaveTableView cellForRowAtIndexPath:addressIndexPath];
    if (addressCell.showAddressLab.text == nil) {
        [SDShowSystemPrompView showSystemPrompStr:@"请选择外出地点"];
        return;
    }
    weaSelf.dataDcit[@"address"] = weaSelf.addressDict[@"title"];
    CLLocation *location = weaSelf.addressDict[@"location"];
    weaSelf.dataDcit[@"lat"] = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    weaSelf.dataDcit[@"lng"] = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    weaSelf.dataDcit[@"radius"] = @"1000";
    
    weaSelf.dataDcit[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    weaSelf.dataDcit[@"token"] = [SDTool getNewToken];
    weaSelf.dataDcit[@"unitId"] = [SDUserInfo obtainWithUniId];
    weaSelf.dataDcit[@"userId"] = [SDUserInfo obtainWithUserId];
    
    //申请外出
    [weaSelf requestSubimtData];
}
#pragma mark ---选取照片------
-(void) selectphotoType:(NSString *)type{
    __weak typeof(self) weakSelf = self;
    //移除弹出相机view
    [weakSelf.showSelectCameraView removeFromSuperview];
    
    if ([type isEqualToString:@"1"]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = weakSelf;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = weakSelf;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [weakSelf presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}
#pragma mark ----调系统相机上传头像------
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    ApprovalSelectPhotoCell *cell = [self.leaveTableView cellForRowAtIndexPath:indexPath];
    [cell.imageArr insertObject:image atIndex:0];
    //更新UI
    [cell updateUI];
}
#pragma mark ---- RecordMapSelectViewControllerDelegate ---
//添加外出打卡点击
- (void)selectAddressDict:(NSDictionary *)dict{
    self.addressDict = nil;
    self.addressDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    LeaveInDestinAddressCell *cell = [self.leaveTableView cellForRowAtIndexPath:indexPath];
    [cell addAddressUpdateUI:dict[@"title"]];
}
#pragma mark ----- delegate------
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SelectLeaveInTimeCell *cell  = [self.leaveTableView cellForRowAtIndexPath:indexPath];
    [cell updateTimeType:self.selectTimeType andTimeStr:date];
    if ([self.selectTimeType isEqualToString:@"1"]) {
        self.beginTimeStr = date;
    }else{
        self.endTimeStr = date;
    }
}
-(void) createTableView{
    self.leaveTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight)];
    [self.view addSubview:self.leaveTableView];
    
    self.leaveTableView.delegate = self;
    self.leaveTableView.dataSource = self;
    self.leaveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leaveTableView.tableFooterView  =[[UIView alloc]initWithFrame:CGRectZero];
    self.leaveTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.leaveTableView registerNib:[UINib nibWithNibName:SELECTLEAVEINTIME_CELL bundle:nil] forCellReuseIdentifier:SELECTLEAVEINTIME_CELL];
    [self.leaveTableView registerNib:[UINib nibWithNibName:APPROVALREASON_CELL bundle:nil] forCellReuseIdentifier:APPROVALREASON_CELL];
    [self.leaveTableView registerNib:[UINib nibWithNibName:LEAVEINDESTIONADDRESS_CELL bundle:nil] forCellReuseIdentifier:LEAVEINDESTIONADDRESS_CELL];
    [self.leaveTableView registerClass:[ApprovalSelectPhotoCell class] forCellReuseIdentifier:APPROVALSELECTPHOTO_CELL];
    [self.leaveTableView registerClass:[ApprovalSubintCell class] forCellReuseIdentifier:APPROVALSUBINT_CELL];
    [self.leaveTableView registerClass:[ApprovalPersonCell class] forCellReuseIdentifier:APPROVALPERSON_CELL];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    [self.leaveTableView addGestureRecognizer:tableViewGesture];
}
//设置navi
-(void) createNavi{
    self.customNavBar.title = @"外出";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //右边
    [self.customNavBar wr_setRightButtonWithTitle:@"外出记录" titleColor:[UIColor colorTextWhiteColor]];
    self.customNavBar.onClickRightButton = ^{
        GoOutRecordController *recordVC = [[GoOutRecordController alloc]init];
        recordVC.recordType = ApporvalRecordOutType;
        recordVC.titleStr = @"外出记录";
        [weakSelf.navigationController pushViewController:recordVC animated:YES];
    };
}
#pragma mark -----手势点击事件----
//点击tableivew收起键盘
-(void)commentTableViewTouchInSide{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    ApprovarReasonCell *cell = [self.leaveTableView cellForRowAtIndexPath:indexPath];
    [cell.cellTextView resignFirstResponder];
}
#pragma mark --------懒加载------
-(ShowSelectCameraView *)showSelectCameraView{
    if (!_showSelectCameraView) {
        _showSelectCameraView = [[ShowSelectCameraView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showSelectCameraView;
}
-(DateTimePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[DateTimePickerView alloc] init];
        _datePickerView.delegate = self;
        _datePickerView.pickerViewMode = DatePickerViewDateTimeMode;
    }
    return _datePickerView;
}
-(NSMutableDictionary *)dataDcit{
    if (!_dataDcit) {
        _dataDcit = [NSMutableDictionary dictionary];
    }
    return _dataDcit;
}
-(NSMutableDictionary *)addressDict{
    if (!_addressDict) {
        _addressDict = [NSMutableDictionary dictionary];
    }
    return _addressDict;
}
#pragma  mark ------数据相关------
//申请页审批流程
-(void)requestApprovalMemberData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"type"] = @"2";
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPAPPROVALMEMBER_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSArray class]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            ApprovalPersonCell *cell =[self.leaveTableView cellForRowAtIndexPath:indexPath];
            [cell updateCellUINSArr:showdata];
        }
    }];
}
//申请流程提交
-(void) requestSubimtData{
    __weak typeof(self) weakSelf = self;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    ApprovalSelectPhotoCell *cell = [self.leaveTableView cellForRowAtIndexPath:indexPath];
    [[KRMainNetTool sharedKRMainNetTool]upLoadData:HTTP_ATTAPPAPPADDOUTGO_URL params:self.dataDcit.copy andData:cell.imageArr waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            [SDShowSystemPrompView showSystemPrompStr:@"外出申请成功"];
            // 自动延迟3秒执行
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
                detaVC.detaType = RecordApproveGoOutDetaType;
                detaVC.typeStr = @"2";
                detaVC.recordIdStr = showdata[@"id"];
                [weakSelf.navigationController pushViewController:detaVC animated:YES];
            });
        }
        
        
    }];
    
    
}


@end