//
//  SupplementCardController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SupplementCardController.h"

#import "RecordApproveDetaController.h"
#import "GoOutRecordController.h"
#import "ShowSelectCameraView.h"
#import "DateTimePickerView.h"

#import "SupplementCardTimeCell.h"
#define SUPPLEMENTCARDTIME_CELL @"SupplementCardTimeCell"

#import "ApprovarReasonCell.h"
#define APPROVARREASON_CELL @"ApprovarReasonCell"

#import "ApprovalSelectPhotoCell.h"
#define APPROVALSELECTPHONE_CELL @"ApprovalSelectPhotoCell"

#import "ApprovalPersonCell.h"
#define APPROVALPERSON_CELL @"ApprovalPersonCell"

#import "ApprovalSubintCell.h"
#define APPOVALSUBIMT_CELL @"ApprovalSubintCell"

@interface SupplementCardController ()
<
UITableViewDelegate,
UITableViewDataSource,
DateTimePickerViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic,strong) UITableView *cardTableView;
//选择相机view
@property (nonatomic,strong)ShowSelectCameraView *showSelectCameraView;
//时间选择器
@property (nonatomic, strong) DateTimePickerView *datePickerView;
@property (nonatomic,strong)NSMutableDictionary *dataDcit;
//补卡信息数据源
@property (nonatomic,strong) NSMutableDictionary *cardDict;

@end

@implementation SupplementCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    [self createNavi];
    [self createTableView];
    [self requesRepairCardInfo];
    [self requestApprovalMemberData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        SupplementCardTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:SUPPLEMENTCARDTIME_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cardTimeBlock = ^{
            [weakSelf.view addSubview:weakSelf.datePickerView];
            [weakSelf.datePickerView showDateTimePickerView];
        };
        return cell;
    }else if (indexPath.row ==1){
        ApprovarReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVARREASON_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showReasonLab.text =@"缺卡原因";
        cell.showPropentReasonLab.text =@"请输入缺卡事由";
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
        return 100;
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
    __weak typeof(self) weakSelf = self;
    NSIndexPath *cardIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SupplementCardTimeCell *cardCell =[self.cardTableView cellForRowAtIndexPath:cardIndexPath];
    NSString *timeStr =cardCell.showCardTimeLab.text;
    if ([timeStr isEqualToString:@"请选择"]) {
        [SDShowSystemPrompView showSystemPrompStr:@"请选择补卡时间"];
        return;
    }
    weakSelf.dataDcit[@"cardTime"] =[timeStr stringByReplacingOccurrencesOfString:@"." withString:@"-"];
    //事由
    NSIndexPath *reasonIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    ApprovarReasonCell *reasonCell =[self.cardTableView cellForRowAtIndexPath:reasonIndexPath];
    if (reasonCell.cellTextView.text != nil) {
        weakSelf.dataDcit[@"reason"] = reasonCell.cellTextView.text;
    }

    weakSelf.dataDcit[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    weakSelf.dataDcit[@"token"] = [SDTool getNewToken];
    weakSelf.dataDcit[@"unitId"] = [SDUserInfo obtainWithUniId];
    weakSelf.dataDcit[@"userId"] = [SDUserInfo obtainWithUserId];
    weakSelf.dataDcit[@"cardId"] = weakSelf.recordIdStr;
    //申请外出
    [weakSelf requestSubimtData];
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
    ApprovalSelectPhotoCell *cell = [self.cardTableView cellForRowAtIndexPath:indexPath];
    [cell.imageArr insertObject:image atIndex:0];
    //更新UI
    [cell updateUI];
}
#pragma mark ----- delegate------
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    SupplementCardTimeCell *cell  = [self.cardTableView cellForRowAtIndexPath:indexPath];
    NSString *timeStr = [NSString stringWithFormat:@"%@ %@",[[self requestDateFormatter]stringFromDate:[NSDate date]],date];
    cell.showCardTimeLab.text = timeStr;
    cell.showCardTimeLab.textColor = [UIColor colorTextBg28BlackColor];
}
-(void) createTableView{
    self.cardTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
    [self.view addSubview:self.cardTableView];
    
    self.cardTableView.delegate = self;
    self.cardTableView.dataSource = self;
    self.cardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cardTableView.tableFooterView  =[[UIView alloc]initWithFrame:CGRectZero];
    self.cardTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.cardTableView registerNib:[UINib nibWithNibName:SUPPLEMENTCARDTIME_CELL bundle:nil] forCellReuseIdentifier:SUPPLEMENTCARDTIME_CELL];
    [self.cardTableView registerNib:[UINib nibWithNibName:APPROVARREASON_CELL bundle:nil] forCellReuseIdentifier:APPROVARREASON_CELL];
    [self.cardTableView registerClass:[ApprovalSelectPhotoCell class] forCellReuseIdentifier:APPROVALSELECTPHONE_CELL];
    [self.cardTableView registerClass:[ApprovalSubintCell class] forCellReuseIdentifier:APPOVALSUBIMT_CELL];
    [self.cardTableView registerClass:[ApprovalPersonCell class] forCellReuseIdentifier:APPROVALPERSON_CELL];
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    [self.cardTableView addGestureRecognizer:tableViewGesture];
}

//设置navi
-(void) createNavi{
    self.customNavBar.title = @"补卡";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //右边
    [self.customNavBar wr_setRightButtonWithTitle:@"补卡记录" titleColor:[UIColor colorTextWhiteColor]];
    self.customNavBar.onClickRightButton = ^{
        GoOutRecordController *recordVC = [[GoOutRecordController alloc]init];
        recordVC.recordType = ApporvalRecordCardType;
        recordVC.titleStr = @"补卡记录";
        [weakSelf.navigationController pushViewController:recordVC animated:YES];
    };
}
#pragma mark -----手势点击事件----
//点击tableivew收起键盘
-(void)commentTableViewTouchInSide{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    ApprovarReasonCell *cell = [self.cardTableView cellForRowAtIndexPath:indexPath];
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
        _datePickerView.pickerViewMode = DatePickerViewTimeMode;
    }
    return _datePickerView;
}
-(NSMutableDictionary *)cardDict{
    if (!_cardDict) {
        _cardDict = [NSMutableDictionary dictionary];
    }
    return _cardDict;
}
-(NSMutableDictionary *)dataDcit{
    if (!_dataDcit) {
        _dataDcit = [NSMutableDictionary dictionary];
    }
    return _dataDcit;
}
-(void)setRecordIdStr:(NSString *)recordIdStr{
    _recordIdStr = recordIdStr;
}
- (NSDateFormatter *)requestDateFormatter{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"YYYY.MM.dd";
    }
    return dateFormatter;
}
#pragma mark ----数据相关-----
//申请页审批流程
-(void)requestApprovalMemberData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"type"] = @"3";
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPAPPROVALMEMBER_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSArray class]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            ApprovalPersonCell *cell =[self.cardTableView cellForRowAtIndexPath:indexPath];
            [cell updateCellUINSArr:showdata];
        }
    }];
}
//补卡申请信息
-(void) requesRepairCardInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"recordId"] =self.recordIdStr;
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPREPAICARDINFO_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            SupplementCardTimeCell *cell =[self.cardTableView cellForRowAtIndexPath:indexPath];
            [cell updateTimeType:showdata];
        }
    }];
}
//申请流程提交
-(void) requestSubimtData{
    __weak typeof(self) weakSelf = self;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    ApprovalSelectPhotoCell *cell = [self.cardTableView cellForRowAtIndexPath:indexPath];
    [cell.imageArr removeLastObject];
    [[KRMainNetTool sharedKRMainNetTool]upLoadData:HTTP_ATTAPPADDREPAIRCARD_URL params:self.dataDcit.copy andData:cell.imageArr waitView:self.view complateHandle:^(id showdata, NSString *error) {
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
            detaVC.detaType = recordApproveCardDetaType;
            detaVC.titleStr = [NSString stringWithFormat:@"%@补卡申请",[SDUserInfo obtainWithRealName]];
            detaVC.typeStr = @"3";
            detaVC.isSkipGrade = YES;
            //审核中
            detaVC.chenkStatusStr = @"1";
            detaVC.recordIdStr = showdata[@"id"];
            [weakSelf.navigationController pushViewController:detaVC animated:YES];
        });
    }];
}



@end
