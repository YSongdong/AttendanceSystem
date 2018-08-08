//
//  RecordApproveDetaController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "RecordApproveDetaController.h"

#import "LoockGoOutAddressController.h"

#import "RecordDetailHeaderView.h"
#import "RecordToolView.h"
#import "ShowRevokeMsgView.h"
#import "ShowRefuseReasonView.h"
#import "ShowPromptMsgView.h"


#import "RecordDetaTableViewCell.h"
#define RECORDDETATABLEVIEW_CELL @"RecordDetaTableViewCell"
@interface RecordApproveDetaController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,strong)ShowPromptMsgView *showPromptMsgView;

@property (nonatomic,strong) RecordToolView *toolView;

@property (nonatomic,strong) ShowRevokeMsgView *showRevokeView;

@property (nonatomic,strong) ShowRefuseReasonView *showRfuseReasonView;

@property (nonatomic,strong) UITableView *detaTableView;

@property (nonatomic,strong) NSMutableDictionary *dataDict;
//数据源
@property (nonatomic,strong) NSMutableArray *dataArr;
//创建队列组
@property (nonatomic,strong) dispatch_group_t group;
//审批申请数据字典
@property (nonatomic,strong) NSMutableDictionary *examiDict;

@end

@implementation RecordApproveDetaController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    [self createNavi];
    [self createTableView];
    [self createGCDGroup];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[section];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordDetaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RECORDDETATABLEVIEW_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.topLineView.hidden = YES ;
    }else{
        cell.topLineView.hidden = NO;
    }
    NSArray *array = self.dataArr[indexPath.section];
    if (array.count-1 == indexPath.row) {
        cell.bottomLineView.hidden = YES;
    }else{
        cell.bottomLineView.hidden = NO;
    }
    NSArray *arr =  self.dataArr[indexPath.section];
    cell.dict = arr[indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    RecordDetailHeaderView *headerView = [[RecordDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 435)];
    headerView.backgroundColor =[UIColor colorTextWhiteColor];
    if (_detaType == RecordApproveGoOutDetaType) {
        headerView.headerType = RecordDetailHeaderGoOutType;
    }else if (_detaType == RecordApproveLeaveDetaType){
         headerView.headerType = RecordDetailHeaderLeaveType;
    }else if (_detaType == recordApproveCardDetaType){
        headerView.headerType = RecordDetailHeaderCardType;
    }
    headerView.dict =self.dataDict;
    
    __weak typeof(self) weakSelf = self;
    //点击地址
    headerView.selectAddressBlock = ^{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"address"] = weakSelf.dataDict[@"address"];
        dict[@"lat"] = weakSelf.dataDict[@"lat"];
        dict[@"lng"] = weakSelf.dataDict[@"lng"];
        dict[@"radius"] = weakSelf.dataDict[@"radius"];
        LoockGoOutAddressController *goOutVC = [[LoockGoOutAddressController alloc]init];
        goOutVC.dict = dict.copy;
        [weakSelf.navigationController pushViewController:goOutVC animated:YES];
    };
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_detaType == RecordApproveGoOutDetaType) {
        // 2 外出
       CGFloat height = [RecordDetailHeaderView getWithTextHeaderViewHeight:self.dataDict headerType:@"2"];
       return height;
    }else if (_detaType == RecordApproveLeaveDetaType) {
        // 1 请假
        CGFloat height = [RecordDetailHeaderView getWithTextHeaderViewHeight:self.dataDict headerType:@"1"];
        return height;
    }else if (_detaType == recordApproveCardDetaType) {
        // 3 补卡
        CGFloat height = [RecordDetailHeaderView getWithTextHeaderViewHeight:self.dataDict headerType:@"3"];
        return height;
    }
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.dataArr[indexPath.section];
    NSDictionary *dict =arr[indexPath.row];
    CGFloat height =  [RecordDetaTableViewCell getWithTextCellHeight:dict];
    if (height < 95) {
        return 95;
    }else{
        return height;
    }
}
-(void) createTableView{
    __weak typeof(self) weakSelf = self;
    
    if ([self.chenkStatusStr isEqualToString:@"1"]) {
        [self.view addSubview:self.toolView];
        self.toolView.hidden = YES;
        if (self.isApplyFor) {
            [self.toolView.revokeBtn setTitle:@"拒绝" forState:UIControlStateNormal];
            [self.toolView.revokeBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
            
            [self.toolView.urgentBtn setTitle:@"同意" forState:UIControlStateNormal];
            [self.toolView.urgentBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
        }else{
            [self.toolView.revokeBtn setTitle:@"撤销" forState:UIControlStateNormal];
            [self.toolView.revokeBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
            
            [self.toolView.urgentBtn setTitle:@"催办" forState:UIControlStateNormal];
            [self.toolView.urgentBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
        }
        //撤销
        self.toolView.RevokeBlock  = ^{
            if (weakSelf.isApplyFor) {
                weakSelf.examiDict[@"status"] = @"1";
                [weakSelf createShowRefuseReasonView];
                return ;
            }
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showRevokeView];
            if (weakSelf.detaType == RecordApproveGoOutDetaType ) {
                weakSelf.showRevokeView.showLab.text =@"您是否确认撤销该条外出申请?";
            }else if (weakSelf.detaType == RecordApproveLeaveDetaType){
                weakSelf.showRevokeView.showLab.text =@"您是否确认撤销该条请假申请?";
            }else if (weakSelf.detaType == recordApproveCardDetaType){
                weakSelf.showRevokeView.showLab.text =@"您是否确认撤销该条补卡申请?";
            }
            __weak typeof(weakSelf) stongSelf = weakSelf;
            //确定
            stongSelf.showRevokeView.trueBlock = ^{
                [stongSelf requestRevokeDate];
            };
        };
        //催办
        self.toolView.UrgentBlock = ^{
            if (weakSelf.isApplyFor) {
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showRevokeView];
                [weakSelf.showRevokeView.trueBtn setTitle:@"确定" forState:UIControlStateNormal];
                [weakSelf.showRevokeView.trueBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
                weakSelf.showRevokeView.showLab.text =[NSString stringWithFormat:@"您是否确认同意%@?",weakSelf.titleStr];
                __weak typeof(weakSelf) stongSelf = weakSelf;
                //确定
                stongSelf.showRevokeView.trueBlock = ^{
                    weakSelf.examiDict[@"status"] = @"2";
                    weakSelf.examiDict[@"info"] = @"";
                    [stongSelf requestExamineApproval];
                };
                return ;
            }
            [weakSelf  requestUrgeDate];
        };
        
        self.detaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-50-KSTabbarH)style:UITableViewStyleGrouped];
        self.detaTableView.backgroundColor =[UIColor colorTextWhiteColor];
        [self.view addSubview:self.detaTableView];
    }else{
        self.detaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)style:UITableViewStyleGrouped];
        self.detaTableView.backgroundColor =[UIColor colorTextWhiteColor];
        [self.view addSubview:self.detaTableView];
    }
    if (@available(iOS 11.0, *)) {
        self.detaTableView.estimatedRowHeight = 0;
        self.detaTableView.estimatedSectionFooterHeight = 0;
        self.detaTableView.estimatedSectionHeaderHeight = 0 ;
        self.detaTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.detaTableView.delegate = self;
    self.detaTableView.dataSource = self;

    self.detaTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.detaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.detaTableView registerClass:[RecordDetaTableViewCell class] forCellReuseIdentifier:RECORDDETATABLEVIEW_CELL
     ];
}
-(void) createShowRefuseReasonView{
    __weak typeof(self) weakSelf = self;
    weakSelf.showRfuseReasonView  =[[ShowRefuseReasonView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    weakSelf.showRfuseReasonView.showLab.text = [NSString stringWithFormat:@"您是否确认拒绝%@?",self.titleStr];
    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showRfuseReasonView];
    weakSelf.showRfuseReasonView.trueBlock = ^{
        weakSelf.examiDict[@"info"] = weakSelf.showRfuseReasonView.refuesTextView.text;
        [weakSelf requestExamineApproval];
        [weakSelf.showRfuseReasonView removeFromSuperview];
    };
}
//创建Navi
-(void) createNavi{
    self.customNavBar.title = self.titleStr;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        if (weakSelf.isSkipGrade) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
}
#pragma mark ----懒加载-----
-(ShowRevokeMsgView *)showRevokeView{
    if (!_showRevokeView) {
        _showRevokeView = [[ShowRevokeMsgView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showRevokeView;
}
-(RecordToolView *)toolView{
    if (!_toolView) {
        _toolView =[[RecordToolView alloc]initWithFrame:CGRectMake(0, KScreenH-50-KSTabbarH, KScreenW, 50+KSTabbarH)];
    }
    return _toolView;
}
-(ShowPromptMsgView *)showPromptMsgView{
    if (!_showPromptMsgView) {
        _showPromptMsgView = [[ShowPromptMsgView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showPromptMsgView;
}
-(void)setChenkStatusStr:(NSString *)chenkStatusStr{
    _chenkStatusStr = chenkStatusStr;
}
-(NSMutableDictionary *)examiDict{
    if (!_examiDict) {
        _examiDict  =[NSMutableDictionary dictionary];
    }
    return _examiDict;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableDictionary *)dataDict{
    if (!_dataDict) {
        _dataDict  =[NSMutableDictionary dictionary];
    }
    return _dataDict;
}
-(void)setIsSkipGrade:(BOOL)isSkipGrade{
    _isSkipGrade = isSkipGrade;
}
-(void)setRecordIdStr:(NSString *)recordIdStr{
    _recordIdStr = recordIdStr;
}
-(void)setDetaType:(RecordApproveDetaType)detaType{
    _detaType = detaType;
}
-(void)setTypeStr:(NSString *)typeStr{
    _typeStr = typeStr;
}
-(void)setIsApplyFor:(BOOL)isApplyFor{
    _isApplyFor = isApplyFor;
}
#pragma mark ----数据相关------
//创建一个多线程任务组
-(void)createGCDGroup{
    __weak typeof(self) weakSelf = self;
   
    //创建队列组
   self.group = dispatch_group_create();
    //进入这个组
    dispatch_group_enter(self.group);
    dispatch_group_async(self.group, dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        //详情
        [weakSelf requestDetaData];
    });
    dispatch_group_enter(_group);
    dispatch_group_async(_group, dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        //我的视角
        [weakSelf requestApprovalStatusData];
    });
    
    //当所有的任务都完成后会发送这个通知
    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        if ([weakSelf.chenkStatusStr isEqualToString:@"1"]) {
            weakSelf.toolView.hidden = NO;
        }else{
            [weakSelf.showPromptMsgView removeFromSuperview];
            weakSelf.toolView.hidden = YES;
            [weakSelf.detaTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.view).offset(KSNaviTopHeight);
                make.left.right.bottom.equalTo(weakSelf.view);
                make.bottom.equalTo(weakSelf.view);
            }];
        }
        [weakSelf.detaTableView reloadData];
    });
}
//详情
-(void) requestDetaData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"recordId"] = self.recordIdStr;
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    if (self.isApplyFor) {
       param[@"cardId"] = self.cardIdStr;
    }
    NSString *url ;
    if (_detaType == RecordApproveGoOutDetaType ) {
        url =HTTP_ATTAPPOUTGOOUTGOINFO_URL ;
    }else if (_detaType == RecordApproveLeaveDetaType){
        url = HTTP_ATTAPPLEAVEINFO_URL;
    }else if (_detaType == recordApproveCardDetaType){
        url = HTTP_ATTAPPRREPAICARDEPAICARDINFO_URL;
    }
    
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:url params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        //这个组的任务完成时离开
        dispatch_group_leave(self.group);
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            self.dataDict = [NSMutableDictionary dictionaryWithDictionary:showdata];
        }
    }];
}
//我的视角
-(void) requestApprovalStatusData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"recordId"] = self.recordIdStr;
    param[@"type"] = self.typeStr;
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    NSString *url ;
    if (self.isApplyFor) {
        url = HTTP_ATTAPPSHOWAPPROVALSTATUS_URL ;
    }else{
        url =HTTP_ATTAPPAPPROVALSTATUS_URL;
    }
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:url params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        //这个组的任务完成时离开
        dispatch_group_leave(self.group);
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSArray class]]) {
            [self.dataArr addObject:showdata];
        }
    }];
}
//撤销
-(void) requestRevokeDate{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    NSString *url;
    if (_detaType == RecordApproveGoOutDetaType ) {
        url =HTTP_ATTAPPOUTGOREVOKE_URL ;
    }else if (_detaType == RecordApproveLeaveDetaType){
        url = HTTP_ATTAPPLEAVEREVOKE_URL;
    }else if (_detaType == recordApproveCardDetaType){
        url = HTTP_ATTAPPREPAIRCARDREVOKE_URL;
    }
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"recordId"] = self.recordIdStr;
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:url params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        [[UIApplication sharedApplication].keyWindow addSubview:self.showPromptMsgView];
        self.dataDict = nil;
        [self.dataArr removeAllObjects];
        self.chenkStatusStr = @"2";
        [self createGCDGroup];
    }];
}
//催办
-(void) requestUrgeDate{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    NSString *url;
    if (_detaType == RecordApproveGoOutDetaType ) {
        url =HTTP_ATTAPPOUTGOURGE_URL ;
    }else if (_detaType == RecordApproveLeaveDetaType){
        url = HTTP_ATTAPPLEAVEURGE_URL;
    }else if (_detaType == recordApproveCardDetaType){
        url = HTTP_ATTAPPREPAIRCARDURGE_URL;
    }
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"recordId"] = self.recordIdStr;
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:url params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        [SDShowSystemPrompView showSystemPrompStr:@"催办提醒已发送"];
    }];
}
//审批申请
-(void)requestExamineApproval{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"recordId"] = self.recordIdStr;
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    param[@"cardId"] = self.cardIdStr;
    param[@"status"] =self.examiDict[@"status"];
    param[@"info"] =self.examiDict[@"info"];
    if (_detaType == RecordApproveGoOutDetaType ) {
         param[@"type"] = @"2";
    }else if (_detaType == RecordApproveLeaveDetaType){
        param[@"type"] = @"1";
    }else if (_detaType == recordApproveCardDetaType){
        param[@"type"] = @"3";
    }
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPEXAMINEAPPROVAL_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        
        [self.dataArr removeAllObjects];
        self.dataDict = nil;
        self.chenkStatusStr = @"2";
        [[UIApplication sharedApplication].keyWindow addSubview:self.showPromptMsgView];
        [self createGCDGroup];
    }];
}




@end
