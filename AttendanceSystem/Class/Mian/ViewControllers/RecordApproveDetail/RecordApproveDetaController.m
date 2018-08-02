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

#import "RecordDetaTableViewCell.h"
#define RECORDDETATABLEVIEW_CELL @"RecordDetaTableViewCell"
@interface RecordApproveDetaController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,strong) RecordToolView *toolView;

@property (nonatomic,strong) ShowRevokeMsgView *showRevokeView;

@property (nonatomic,strong) ShowRefuseReasonView *showRfuseReasonView;

@property (nonatomic,strong) UITableView *detaTableView;

@property (nonatomic,strong) NSMutableDictionary *dataDict;
//数据源
@property (nonatomic,strong) NSMutableArray *dataArr;



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
    
    [self.view addSubview:self.toolView];
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
            [weakSelf createShowRefuseReasonView];
            return ;
        }
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showRevokeView];
        if (weakSelf.detaType == RecordApproveGoOutDetaType ) {
            weakSelf.showRevokeView.showLab.text =@"您是否确认撤销该条外出申请?";
        }else if (weakSelf.detaType == RecordApproveLeaveDetaType){
            weakSelf.showRevokeView.showLab.text =@"您是否确认撤销该条请假申请?";
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
            
            return ;
        }
        [weakSelf  requestUrgeDate];
    };
    
    self.detaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-50)style:UITableViewStyleGrouped];
    self.detaTableView.backgroundColor =[UIColor colorTextWhiteColor];
    [self.view addSubview:self.detaTableView];
    
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
    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showRfuseReasonView];
    weakSelf.showRfuseReasonView.trueBlock = ^{
        [weakSelf requestRevokeDate];
        [weakSelf.showRfuseReasonView removeFromSuperview];
    };
}

//创建Navi
-(void) createNavi{
    self.customNavBar.title = self.titleStr;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
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
        _toolView =[[RecordToolView alloc]initWithFrame:CGRectMake(0, KScreenH-50, KScreenW, 50)];
    }
    return _toolView;
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
    dispatch_group_t group = dispatch_group_create();
    //进入这个组
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        //请求
        [weakSelf requestDetaData];
        //这个组的任务完成时离开
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        [weakSelf requestApprovalStatusData];
        dispatch_group_leave(group);
    });
    
    //当所有的任务都完成后会发送这个通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
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
    }
    
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:url params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            self.dataDict = [NSMutableDictionary dictionaryWithDictionary:showdata];
            NSString *statusStr = [NSString stringWithFormat:@"%@",showdata[@"status"]];
            __weak typeof(self)weakSelf = self;
            CGFloat naviHeight =KSNaviTopHeight;
            if (![statusStr isEqualToString:@"1"]) {
                self.toolView.hidden = YES;
                [self.detaTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.bottom.equalTo(weakSelf.view);
                    make.top.equalTo(weakSelf.view).offset(naviHeight);
                }];
            }else{
                 self.toolView.hidden = NO;
                [self.detaTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(weakSelf.view);
                    make.top.equalTo(weakSelf.view).offset(naviHeight);
                    make.bottom.equalTo(weakSelf.view).offset(-50);
                }];
            }
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
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPAPPROVALSTATUS_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSArray class]]) {
            [self.dataArr addObject:showdata];
            [self.detaTableView reloadData];
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
        self.dataDict = nil;
        [self.dataArr removeAllObjects];
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





@end
