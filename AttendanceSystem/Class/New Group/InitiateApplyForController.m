//
//  InitiateApplyForController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "InitiateApplyForController.h"
#import "ApprovalRecordSiftController.h"

#import "RecordHeaderSearchView.h"
#import "RecordApproveDetaController.h"

#import "ApprovalRecordCell.h"
#define APPROVALRECORD_CELL @"ApprovalRecordCell"

@interface InitiateApplyForController ()
<
UITableViewDelegate,
UITableViewDataSource,
ApprovalRecordSiftControllerDelegate
>
//搜索view
@property (nonatomic,strong)RecordHeaderSearchView *headerSearchView;

@property (nonatomic,strong) UITableView *recordTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
//申请类型
@property (nonatomic,strong) NSString *typeStr;
//状态类型
@property (nonatomic,strong) NSString *statuStr;
//查询
@property (nonatomic,strong) NSString *likeTitleStr;
//分页
@property (nonatomic,assign) NSInteger page;

@end

@implementation InitiateApplyForController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.typeStr = @"0";
    self.statuStr = @"0";
    [self createNavi];
    [self createSearchView];
    [self requestApprovalList];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApprovalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALRECORD_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict =self.dataArr[indexPath.row];
    NSString *typeStr =[NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([typeStr isEqualToString:@"1"]) {
         cell.cellType = RecordCellLeaveType;
    }else if ([typeStr isEqualToString:@"2"]){
        cell.cellType = RecordCellOutType;
    }else if ([typeStr isEqualToString:@"3"]){
        cell.cellType = RecordCellCardType;
    }
    cell.dict =dict;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ApprovalRecordCell *cell = [self.recordTableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"type"]];
    RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
    detaVC.titleStr = cell.showNameLab.text;
    if ([typeStr isEqualToString:@"2"]) {
        //外出
        detaVC.detaType = RecordApproveGoOutDetaType;
        detaVC.typeStr = @"2";
        detaVC.recordIdStr = dict[@"id"];
    }else if ([typeStr isEqualToString:@"1"]){
        //请假
        detaVC.detaType = RecordApproveLeaveDetaType;
        detaVC.typeStr = @"1";
        detaVC.recordIdStr = dict[@"id"];
    }
    [self.navigationController pushViewController:detaVC animated:YES];
}

#pragma mark ----ApprovalRecordSiftControllerDelegate---
- (void)selectSiftArr:(NSArray *)arr{
    
    
}
-(void) createSearchView{
    __weak typeof(self) weakSelf = self;
    self.headerSearchView = [[RecordHeaderSearchView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, 60)];
    [self.view addSubview:self.headerSearchView];
    self.headerSearchView.searchBlock = ^(NSString *searchStr) {
        weakSelf.likeTitleStr = searchStr;
        [weakSelf requestApprovalList];
    };
    
    self.recordTableView =  [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+60, KScreenW, KScreenH-KSNaviTopHeight-60)];
    [self.view addSubview:self.recordTableView];
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.recordTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.recordTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.recordTableView registerNib:[UINib nibWithNibName:APPROVALRECORD_CELL bundle:nil] forCellReuseIdentifier:APPROVALRECORD_CELL];
}

//设置navi
-(void) createNavi{
    self.customNavBar.title = @"我发起的";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //右边
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"wcjl_ico_sx"]];
    self.customNavBar.onClickRightButton = ^{
        ApprovalRecordSiftController *siftVC = [[ApprovalRecordSiftController alloc]init];
        siftVC.siftType = RecordApplyForSiftType;
        siftVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:siftVC animated:YES];
    };
}
#pragma mark ----懒加载-----
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr  =[NSMutableArray array];
    }
    return  _dataArr;
}

#pragma mark ----数据相关-----
//申请页审批流程
-(void)requestApprovalList{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"type"] = self.typeStr;
    param[@"status"] = self.statuStr;
    param[@"likeTitle"] = self.likeTitleStr;
    param[@"offset"] = [NSString stringWithFormat:@"%ld",(long)self.page];
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPAPPLYLIST_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        
        if ([showdata isKindOfClass:[NSArray class]])  {
            [self.dataArr addObjectsFromArray:showdata];
            [self.recordTableView reloadData];
        }
        
    }];
}



@end
