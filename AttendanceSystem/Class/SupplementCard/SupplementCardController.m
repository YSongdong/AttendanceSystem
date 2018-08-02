//
//  SupplementCardController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SupplementCardController.h"

#import "GoOutRecordController.h"
#import "ShowSelectCameraView.h"


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
DateTimePickerViewDelegate
>

@property (nonatomic,strong) UITableView *cardTableView;
//选择相机view
@property (nonatomic,strong)ShowSelectCameraView *showSelectCameraView;
//时间选择器
@property (nonatomic, strong) DateTimePickerView *datePickerView;
@property (nonatomic,strong)NSMutableDictionary *dataDcit;

@end

@implementation SupplementCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createTableView];
    [self requestApprovalMemberData];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SupplementCardTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:SUPPLEMENTCARDTIME_CELL forIndexPath:indexPath];
        return cell;
    }else if (indexPath.row ==1){
        ApprovarReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVARREASON_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row ==2){
        ApprovalSelectPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALSELECTPHONE_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 3){
        ApprovalPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALPERSON_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ApprovalSubintCell *cell = [tableView dequeueReusableCellWithIdentifier:APPOVALSUBIMT_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
   // [cell updateTimeType:self.selectTimeType andTimeStr:date];
    
}
-(void) createTableView{
    self.cardTableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight)];
    [self.view addSubview:self.cardTableView];
    
    self.cardTableView.delegate = self;
    self.cardTableView.dataSource = self;
    self.cardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cardTableView.tableFooterView  =[[UIView alloc]initWithFrame:CGRectZero];
    
    [self.cardTableView registerNib:[UINib nibWithNibName:SUPPLEMENTCARDTIME_CELL bundle:nil] forCellReuseIdentifier:SUPPLEMENTCARDTIME_CELL];
    [self.cardTableView registerNib:[UINib nibWithNibName:APPROVARREASON_CELL bundle:nil] forCellReuseIdentifier:APPROVARREASON_CELL];
    [self.cardTableView registerClass:[ApprovalSelectPhotoCell class] forCellReuseIdentifier:APPROVALSELECTPHONE_CELL];
    [self.cardTableView registerClass:[ApprovalSubintCell class] forCellReuseIdentifier:APPOVALSUBIMT_CELL];
    [self.cardTableView registerClass:[ApprovalPersonCell class] forCellReuseIdentifier:APPROVALPERSON_CELL];
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
        
    }];
}
-(void) requesRepairCardInfo{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"recordId"] = @"3";
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPREPAICARDINFO_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        
    }];
}



//申请流程提交
-(void) requestSubimtData{
    __weak typeof(self) weakSelf = self;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    ApprovalSelectPhotoCell *cell = [self.cardTableView cellForRowAtIndexPath:indexPath];
    [[KRMainNetTool sharedKRMainNetTool]upLoadData:HTTP_ATTAPPLEAVEADDLEAVE_URL params:self.dataDcit.copy andData:cell.imageArr waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        [SDShowSystemPrompView showSystemPrompStr:@"补卡成功"];
        // 自动延迟3秒执行
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            GoOutRecordController *recordVC = [[GoOutRecordController alloc]init];
            recordVC.recordType = ApporvalRecordOutType;
            recordVC.titleStr = @"补卡记录";
            [weakSelf.navigationController pushViewController:recordVC animated:YES];
        });
    }];
    
    
}



@end
