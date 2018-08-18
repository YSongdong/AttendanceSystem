//
//  LeaveApprovalController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "LeaveApprovalController.h"

#import "RecordApproveDetaController.h"
#import "GoOutRecordController.h"
#import "HQPickerView.h"
#import "ShowSelectCameraView.h"

#import "SelectTimeTypeCell.h"
#define SELECTTIMETYPE_CELL @"SelectTimeTypeCell"

#import "ApprovarReasonCell.h"
#define APPROVARREASON_CELL @"ApprovarReasonCell"

#import "ApprovalSelectPhotoCell.h"
#define APPROVALSELECTPHONE_CELL @"ApprovalSelectPhotoCell"

#import "ApprovalPersonCell.h"
#define APPROVALPERSON_CELL @"ApprovalPersonCell"

#import "ApprovalSubintCell.h"
#define APPOVALSUBIMT_CELL @"ApprovalSubintCell"

@interface LeaveApprovalController ()
<
UITableViewDelegate,
UITableViewDataSource,
DateTimePickerViewDelegate,
HQPickerViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
@property (nonatomic,strong) UITableView *leaveTableView;
//选择相机view
@property (nonatomic,strong)ShowSelectCameraView *showSelectCameraView;
//时间选择器
@property (nonatomic, strong) DateTimePickerView *datePickerView;
//自定义选择器
@property (nonatomic,strong) HQPickerView *hpPickerView;
//选择时间类型  1 开始时间  2结束时间
@property (nonatomic,strong)NSString *selectTimeType;
//请求参数数据
@property (nonatomic,strong) NSMutableDictionary *dataDcit;

@property (nonatomic,strong)NSString *leaveTypeStr;
@property (nonatomic,strong)NSString *beginTimeStr;
@property (nonatomic,strong)NSString *endTimeStr;
//审批人数据源
@property (nonatomic,strong) NSMutableArray *approvalArr;
//请假原因
@property (nonatomic,strong) NSString *leaveReasonStr;
@end

@implementation LeaveApprovalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    self.endTimeStr = @"";
    self.beginTimeStr = @"";
    self.leaveReasonStr = @"";
    [self createNavi];
    [self createTableView];
    [self requestApprovalMemberData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        SelectTimeTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:SELECTTIMETYPE_CELL forIndexPath:indexPath];
        //请假类型
        cell.leaveTypeBlock = ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            ApprovarReasonCell *cell = [weakSelf.leaveTableView cellForRowAtIndexPath:indexPath];
            [cell.cellTextView resignFirstResponder];
            [weakSelf createHPPickView];
        };
        //开始时间
        cell.beginTimeBlock = ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            ApprovarReasonCell *cell = [weakSelf.leaveTableView cellForRowAtIndexPath:indexPath];
            [cell.cellTextView resignFirstResponder];
             weakSelf.selectTimeType = @"1";
            [weakSelf.view addSubview:weakSelf.datePickerView];
            [weakSelf.datePickerView showDateTimePickerView];
        };
        //结束时间
        cell.endTimeBlock = ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            ApprovarReasonCell *cell = [weakSelf.leaveTableView cellForRowAtIndexPath:indexPath];
            [cell.cellTextView resignFirstResponder];
             weakSelf.selectTimeType = @"2";
            [weakSelf.view addSubview:weakSelf.datePickerView];
            [weakSelf.datePickerView showDateTimePickerView];
        };
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row ==1){
        ApprovarReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVARREASON_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showReasonLab.text = @"请假事由";
        cell.showPropentReasonLab.text = @"请输入请假事由";
        cell.reasonBlock = ^(NSString *reasonStr) {
            weakSelf.leaveReasonStr = reasonStr;
        };
        return cell;
    }else if (indexPath.row ==2){
        ApprovalSelectPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALSELECTPHONE_CELL forIndexPath:indexPath];
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
    }else if (indexPath.row == 3){
        ApprovalPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALPERSON_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellUINSArr:self.approvalArr];
        return cell;
    }else{
        ApprovalSubintCell *cell = [tableView dequeueReusableCellWithIdentifier:APPOVALSUBIMT_CELL forIndexPath:indexPath];
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
        return 250;
    }else if (indexPath.row ==1){
         return 135;
    }else if (indexPath.row ==2){
         return 135;
    }else if (indexPath.row ==3){
         return 165;
    }else{
        return 80;
    }
}
-(void) getSubmitData{
    __weak typeof(self) weaSelf= self;
    if ([weaSelf.beginTimeStr isEqualToString:@""]) {
        [SDShowSystemPrompView showSystemPrompStr:@"请选择开始时间"];
        return;
    }
    if ([weaSelf.endTimeStr isEqualToString:@""]) {
        [SDShowSystemPrompView showSystemPrompStr:@"请选择结束时间"];
        return;
    }
    CGFloat timeLong = [SDTool calculateWithStartTime:weaSelf.beginTimeStr endTime:weaSelf.endTimeStr];
    if (timeLong < 0 ) {
        [SDShowSystemPrompView showSystemPrompStr:@"结束时间小于开始时间"];
        return;
    }
    weaSelf.dataDcit[@"startTime"] = [weaSelf.beginTimeStr stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    weaSelf.dataDcit[@"endTime"] =[weaSelf.endTimeStr stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    weaSelf.dataDcit[@"numbers"] = [NSString stringWithFormat:@"%.2f",timeLong];
    //请假类型
    NSString *typeStr;
    if ([self.leaveTypeStr isEqualToString:@"请选择"]) {
        [SDShowSystemPrompView showSystemPrompStr:@"请假类型是必选类型"];
        return;
    }else if ([self.leaveTypeStr isEqualToString:@"年假"]) {
        typeStr = @"1";
    }else if ([self.leaveTypeStr isEqualToString:@"事假"]){
         typeStr = @"2";
    }else if ([self.leaveTypeStr isEqualToString:@"护理假"]){
        typeStr = @"7";
    }else if ([self.leaveTypeStr isEqualToString:@"产假"]){
        typeStr = @"4";
    }else if ([self.leaveTypeStr isEqualToString:@"婚假"]){
        typeStr = @"5";
    }else if ([self.leaveTypeStr isEqualToString:@"丧假"]){
        typeStr = @"6";
    } else if ([self.leaveTypeStr isEqualToString:@"病假"]){
        typeStr = @"8";
    }
    weaSelf.dataDcit[@"type"] =typeStr;
    //事由
    if ([weaSelf.leaveReasonStr isEqualToString:@""]) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入请假事由"];
        return;
    }
     weaSelf.dataDcit[@"leave"] = weaSelf.leaveReasonStr;
    weaSelf.dataDcit[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    weaSelf.dataDcit[@"token"] = [SDTool getNewToken];
    weaSelf.dataDcit[@"unitId"] = [SDUserInfo obtainWithUniId];
    weaSelf.dataDcit[@"userId"] = [SDUserInfo obtainWithUserId];
    
    //提交请假
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    ApprovalSelectPhotoCell *cell = [self.leaveTableView cellForRowAtIndexPath:indexPath];
    [cell.imageArr insertObject:image atIndex:0];
    //更新UI
    [cell updateUI];
}
#pragma mark -----手势点击事件----
//点击tableivew收起键盘
-(void)commentTableViewTouchInSide{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    ApprovarReasonCell *cell = [self.leaveTableView cellForRowAtIndexPath:indexPath];
    [cell.cellTextView resignFirstResponder];
    self.leaveReasonStr = cell.cellTextView.text;
}
#pragma mark -----时间选择器 ---- delegate------
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    if ([self.selectTimeType isEqualToString:@"1"]) {
        self.beginTimeStr = date;
    }else{
        self.endTimeStr = date;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SelectTimeTypeCell *cell  = [self.leaveTableView cellForRowAtIndexPath:indexPath];
    [cell updateTimeType:self.selectTimeType andTimeStr:date];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectText:(NSString *)text{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SelectTimeTypeCell *cell  = [self.leaveTableView cellForRowAtIndexPath:indexPath];
    cell.showLeaveTypeLab.text = text;
    self.leaveTypeStr = text;
    cell.showLeaveTypeLab.textColor = [UIColor colorTextBg65BlackColor];
}
-(void) createTableView{
    self.leaveTableView  =[[ UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
    [self.view addSubview:self.leaveTableView];
    
    self.leaveTableView.dataSource = self;
    self.leaveTableView.delegate= self;
    
    self.leaveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leaveTableView.tableFooterView  =[[UIView alloc]initWithFrame:CGRectZero];
   
    [self.leaveTableView registerNib:[UINib nibWithNibName:SELECTTIMETYPE_CELL bundle:nil] forCellReuseIdentifier:SELECTTIMETYPE_CELL];
    [self.leaveTableView registerNib:[UINib nibWithNibName:APPROVARREASON_CELL bundle:nil] forCellReuseIdentifier:APPROVARREASON_CELL];
    [self.leaveTableView registerClass:[ApprovalSelectPhotoCell class] forCellReuseIdentifier:APPROVALSELECTPHONE_CELL];
    [self.leaveTableView registerClass:[ApprovalSubintCell class] forCellReuseIdentifier:APPOVALSUBIMT_CELL];
    [self.leaveTableView registerClass:[ApprovalPersonCell class] forCellReuseIdentifier:APPROVALPERSON_CELL];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    [self.leaveTableView addGestureRecognizer:tableViewGesture];
    
}
//设置navi
-(void) createNavi{
    self.customNavBar.title = @"请假";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //右边
    [self.customNavBar wr_setRightButtonWithTitle:@"请假记录" titleColor:[UIColor colorTextWhiteColor]];
    self.customNavBar.onClickRightButton = ^{
        GoOutRecordController *recordVC = [[GoOutRecordController alloc]init];
        recordVC.recordType = ApporvalRecordLeaveType;
        recordVC.titleStr = @"请假记录";
        [weakSelf.navigationController pushViewController:recordVC animated:YES];
    };
}
//自定义选择器
-(void)createHPPickView{
    _hpPickerView = [[HQPickerView alloc]initWithFrame:self.view.bounds];
    _hpPickerView.delegate = self ;
    _hpPickerView.customArr = @[@"年假",@"事假",@"产假",@"婚假",@"丧假",@"护理假",@"病假"];
    [self.view addSubview:self.hpPickerView];
}
#pragma mark -----懒加载--------
-(DateTimePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[DateTimePickerView alloc] init];
        _datePickerView.delegate = self;
        _datePickerView.pickerViewMode = DatePickerViewDateTimeMode;
    }
    return _datePickerView;
}
-(ShowSelectCameraView *)showSelectCameraView{
    if (!_showSelectCameraView) {
        _showSelectCameraView = [[ShowSelectCameraView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showSelectCameraView;
}
-(NSMutableDictionary *)dataDcit{
    if (!_dataDcit) {
        _dataDcit = [NSMutableDictionary dictionary];
    }
    return _dataDcit;
}
-(NSMutableArray *)approvalArr{
    if (!_approvalArr) {
        _approvalArr =[NSMutableArray array];
    }
    return _approvalArr;
}
#pragma mark ----数据相关-----
//申请页审批流程
-(void)requestApprovalMemberData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"type"] = @"1";
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPAPPROVALMEMBER_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
      
        if ([showdata isKindOfClass:[NSArray class]]) {
            self.approvalArr = [NSMutableArray arrayWithArray:showdata];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            ApprovalPersonCell *cell =[self.leaveTableView cellForRowAtIndexPath:indexPath];
            [cell updateCellUINSArr:self.approvalArr];
        }
    }];
}
//申请流程提交
-(void) requestSubimtData{
    __weak typeof(self) weakSelf = self;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    ApprovalSelectPhotoCell *cell = [self.leaveTableView cellForRowAtIndexPath:indexPath];
    [cell.imageArr removeLastObject];
    [[KRMainNetTool sharedKRMainNetTool]upLoadData:HTTP_ATTAPPLEAVEADDLEAVE_URL params:self.dataDcit.copy andData:cell.imageArr waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [cell.imageArr addObject:[UIImage imageNamed:@"att_attendance_dialogmsg_add"]];
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        [SDShowSystemPrompView showSystemPrompStr:@"提交成功，等待审批"];
        // 自动延迟3秒执行
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
            detaVC.detaType = RecordApproveLeaveDetaType;
            detaVC.titleStr = [NSString stringWithFormat:@"%@请假申请",[SDUserInfo obtainWithRealName]];
            detaVC.typeStr = @"1";
            detaVC.isSkipGrade = YES;
            //审核中
            detaVC.chenkStatusStr = @"1";
            detaVC.recordIdStr = showdata[@"id"];
            [weakSelf.navigationController pushViewController:detaVC animated:YES];
        });
    }];
    
    
}


@end
