//
//  OverTimeApplyforController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/23.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "OverTimeApplyforController.h"

#import "ShowSelectCameraView.h"
#import "GoOutRecordController.h"
#import "RecordApproveDetaController.h"

#import "SelectLeaveInTimeCell.h"
#define SELECTLEAVEINTIME_CELL @"SelectLeaveInTimeCell"

#import "ApprovarReasonCell.h"
#define APPROVALREASON_CELL @"ApprovarReasonCell"


#import "ApprovalSelectPhotoCell.h"
#define APPROVALSELECTPHOTO_CELL @"ApprovalSelectPhotoCell"

#import "ApprovalSubintCell.h"
#define APPROVALSUBINT_CELL @"ApprovalSubintCell"

#import "ApprovalPersonCell.h"
#define APPROVALPERSON_CELL @"ApprovalPersonCell"

@interface OverTimeApplyforController ()
<
UITableViewDelegate,
UITableViewDataSource,
DateTimePickerViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
@property (nonatomic,strong)UITableView *overTimeTableView;
//选择相机view
@property (nonatomic,strong)ShowSelectCameraView *showSelectCameraView;
//时间选择器
@property (nonatomic, strong) DateTimePickerView *datePickerView;
//选择时间类型  1 开始时间  2结束时间
@property (nonatomic,strong)NSString *selectTimeType;

@property (nonatomic,strong)NSString *beginTimeStr;
@property (nonatomic,strong)NSString *endTimeStr;
//外出原因
@property (nonatomic,strong) NSString *leaveReasonStr;

//请求参数数据
@property (nonatomic,strong) NSMutableDictionary *dataDcit;
//接受选择外出地点
@property (nonatomic,strong) NSMutableDictionary *addressDict;
//审批人数据源
@property (nonatomic,strong) NSMutableArray *approvalArr;

@end

@implementation OverTimeApplyforController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    self.endTimeStr = @"";
    self.beginTimeStr = @"";
    self.leaveReasonStr = @"";
    [self createNavi];
    [self createTableView];
    [self requestApprovalMemberData];
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)  name:UIKeyboardWillHideNotification object:nil];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        SelectLeaveInTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:SELECTLEAVEINTIME_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //开始时间
        cell.beginTimeBlock = ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            ApprovarReasonCell *cell = [weakSelf.overTimeTableView cellForRowAtIndexPath:indexPath];
            [cell.cellTextView resignFirstResponder];
            weakSelf.leaveReasonStr = cell.cellTextView.text;
            
            weakSelf.selectTimeType = @"1";
            [weakSelf.view addSubview:weakSelf.datePickerView];
            [weakSelf.datePickerView showDateTimePickerView];
        };
        //结束时间
        cell.endTimeBlock = ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            ApprovarReasonCell *cell = [weakSelf.overTimeTableView cellForRowAtIndexPath:indexPath];
            [cell.cellTextView resignFirstResponder];
            weakSelf.leaveReasonStr = cell.cellTextView.text;
            
            weakSelf.selectTimeType = @"2";
            [weakSelf.view addSubview:weakSelf.datePickerView];
            [weakSelf.datePickerView showDateTimePickerView];
        };
        return cell;
    }else if (indexPath.row ==1){
        ApprovarReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALREASON_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showReasonLab.text = @"加班事由";
        cell.showPropentReasonLab.text = @"请输入加班事由";
        cell.reasonBlock = ^(NSString *reasonStr) {
            weakSelf.leaveReasonStr = reasonStr;
        };
        return cell;
    }else if(indexPath.row ==2){
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
    }else if (indexPath.row == 3){
        ApprovalPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALPERSON_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellUINSArr:self.approvalArr];
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
        return KSIphonScreenH(135);
    }else if (indexPath.row == 2){
        return KSIphonScreenH(135);
    }else if (indexPath.row ==3){
        return KSIphonScreenH(165);
    }else{
        return KSIphonScreenH(80);
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
    
    //事由
    if ([weaSelf.leaveReasonStr isEqualToString:@""]) {
        [SDShowSystemPrompView showSystemPrompStr:@"请输入加班事由"];
        return;
    }
    weaSelf.dataDcit[@"overTimeInfo"] = weaSelf.leaveReasonStr;

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
#pragma mark -----键盘收起通知-----
//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    ApprovarReasonCell *cell = [self.overTimeTableView cellForRowAtIndexPath:indexPath];
    [cell.cellTextView resignFirstResponder];
    self.leaveReasonStr = cell.cellTextView.text;
}
#pragma mark ----调系统相机上传头像------
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    ApprovalSelectPhotoCell *cell = [self.overTimeTableView cellForRowAtIndexPath:indexPath];
    [cell.imageArr insertObject:image atIndex:0];
    //更新UI
    [cell updateUI];
}
#pragma mark ----- delegate------
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    if ([self.selectTimeType isEqualToString:@"1"]) {
        self.beginTimeStr = date;
    }else{
        self.endTimeStr = date;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SelectLeaveInTimeCell *cell  = [self.overTimeTableView cellForRowAtIndexPath:indexPath];
    [cell updateTimeType:self.selectTimeType andTimeStr:date];
}
-(void) createTableView{
    self.overTimeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
    [self.view addSubview:self.overTimeTableView];
    
    self.overTimeTableView.delegate = self;
    self.overTimeTableView.dataSource = self;
    self.overTimeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.overTimeTableView.tableFooterView  =[[UIView alloc]initWithFrame:CGRectZero];
    // self.leaveTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.overTimeTableView registerNib:[UINib nibWithNibName:SELECTLEAVEINTIME_CELL bundle:nil] forCellReuseIdentifier:SELECTLEAVEINTIME_CELL];
    [self.overTimeTableView registerNib:[UINib nibWithNibName:APPROVALREASON_CELL bundle:nil] forCellReuseIdentifier:APPROVALREASON_CELL];
    [self.overTimeTableView registerClass:[ApprovalSelectPhotoCell class] forCellReuseIdentifier:APPROVALSELECTPHOTO_CELL];
    [self.overTimeTableView registerClass:[ApprovalSubintCell class] forCellReuseIdentifier:APPROVALSUBINT_CELL];
    [self.overTimeTableView registerClass:[ApprovalPersonCell class] forCellReuseIdentifier:APPROVALPERSON_CELL];
    
    if (@available(iOS 11.0, *)) {
        self.overTimeTableView.estimatedRowHeight = 0;
        self.overTimeTableView.estimatedSectionFooterHeight = 0;
        self.overTimeTableView.estimatedSectionHeaderHeight = 0 ;
        self.overTimeTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    [self.overTimeTableView addGestureRecognizer:tableViewGesture];
}
//设置navi
-(void) createNavi{
    self.customNavBar.title = @"加班";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //右边
    [self.customNavBar wr_setRightButtonWithNormal:nil highlighted:nil];
    [self.customNavBar.rightButton setTitle:@"加班记录" forState:UIControlStateNormal];
    self.customNavBar.rightButton.frame = CGRectMake(KScreenW - 70, KSStatusHeight, 70 , 44);
    self.customNavBar.onClickRightButton = ^{
        //收起键盘
        [weakSelf commentTableViewTouchInSide];
        
        GoOutRecordController *recordVC = [[GoOutRecordController alloc]init];
        recordVC.recordType = ApporvalRecordOverTimeType;
        recordVC.titleStr = @"加班记录";
        [weakSelf.navigationController pushViewController:recordVC animated:YES];
    };
}
#pragma mark -----手势点击事件----
//点击tableivew收起键盘
-(void)commentTableViewTouchInSide{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    ApprovarReasonCell *cell = [self.overTimeTableView cellForRowAtIndexPath:indexPath];
    [cell.cellTextView resignFirstResponder];
    self.leaveReasonStr = cell.cellTextView.text;
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
-(NSMutableArray *)approvalArr{
    if (!_approvalArr) {
        _approvalArr =[NSMutableArray array];
    }
    return _approvalArr;
}

#pragma  mark ------数据相关------
//申请页审批流程
-(void)requestApprovalMemberData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"type"] = @"5";
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPAPPROVALMEMBER_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            if ([[showdata allKeys] containsObject:@"rule"]){
                self.approvalArr = [NSMutableArray arrayWithArray:showdata[@"rule"]];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                ApprovalPersonCell *cell =[self.overTimeTableView cellForRowAtIndexPath:indexPath];
                [cell updateCellUINSArr:self.approvalArr];
            }
        }
    }];
}
//申请流程提交
-(void) requestSubimtData{
    __weak typeof(self) weakSelf = self;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    ApprovalSelectPhotoCell *cell = [self.overTimeTableView cellForRowAtIndexPath:indexPath];
    [cell.imageArr removeLastObject];
    [[KRMainNetTool sharedKRMainNetTool]upLoadData:HTTP_ATTAPPOVERTIMEADDOVERTIME_URL params:self.dataDcit.copy andData:cell.imageArr waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [cell.imageArr addObject:[UIImage imageNamed:@"att_attendance_dialogmsg_add"]];
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            [SDShowSystemPrompView showSystemPrompStr:@"提交成功，等待审批"];
            // 自动延迟3秒执行
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
                detaVC.detaType = recordApproveOverTimeDetaType;
                detaVC.isSkipGrade = YES;
                detaVC.typeStr = @"5";
                //审核中
                detaVC.chenkStatusStr = @"1";
                detaVC.titleStr = [NSString stringWithFormat:@"%@加班申请",[SDUserInfo obtainWithRealName]];
                detaVC.recordIdStr = showdata[@"id"];
                [weakSelf.navigationController pushViewController:detaVC animated:YES];
            });
        }
        
    }];
    
}
@end
