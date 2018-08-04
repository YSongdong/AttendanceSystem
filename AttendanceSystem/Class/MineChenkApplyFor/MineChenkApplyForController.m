//
//  MineChenkApplyForController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "MineChenkApplyForController.h"

#import "ShowBlankSpaceView.h"
#import "ChenkHeaderView.h"
#import "RecordHeaderSearchView.h"
#import "ApprovalRecordSiftController.h"

#import "RecordApproveDetaController.h"

#import "ApprovalRecordCell.h"
#define APPROVALRECORD_CELL @"ApprovalRecordCell"
@interface MineChenkApplyForController ()
<
UITableViewDelegate,
UITableViewDataSource,
ApprovalRecordSiftControllerDelegate
>
//搜索view
@property (nonatomic,strong)RecordHeaderSearchView *headerSearchView;
//空白页
@property (nonatomic,strong)ShowBlankSpaceView *showBlankSpaceView;

@property (nonatomic,strong) UITableView *recordTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

//切换状态
@property (nonatomic,strong) NSString *cutTypeStr;

//申请类型
@property (nonatomic,strong) NSString *typeStr;
//查询
@property (nonatomic,strong) NSString *likeTitleStr;
//分页
@property (nonatomic,assign) NSInteger page;
//状态
@property (nonatomic,strong) NSString *statuStr;
@end

@implementation MineChenkApplyForController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cutTypeStr =@"1";
    self.page = 1;
    self.typeStr = @"0";
    self.statuStr = @"0";
    [self createNavi];
    [self createChenkHeaderView];
    [self createSearchView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.dataArr removeAllObjects];
    [self requestDataList];
}
#pragma mark ------ApprovalRecordSiftControllerDelegate----
//筛选
- (void)selectSiftArr:(NSArray *)arr{
    NSMutableString *mutablStr = [NSMutableString string];
    //cuttype 1 待我审批的  2我已审批的
    if ([self.cutTypeStr isEqualToString:@"1"]) {
        //移除数据源
        [self.dataArr removeAllObjects];
        if (arr.count == 1) {
            NSDictionary *dict = arr[0];
            self.typeStr= dict[@"type"];
            self.headerSearchView.searchTextField.text = dict[@"content"];
        }
    }else{
        for (int i=0; i<arr.count; i++) {
            NSDictionary *dict = arr[i];
            if (i== 0) {
                self.statuStr = dict[@"status"];
                [mutablStr appendString:dict[@"content"]];
            }else{
                self.typeStr = dict[@"type"];
                [mutablStr appendString:dict[@"content"]];
            }
        }
        self.headerSearchView.searchTextField.text = mutablStr.copy;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApprovalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALRECORD_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict =self.dataArr[indexPath.row];
    NSString *typeStr =[NSString stringWithFormat:@"%@",dict[@"type"]];
    cell.reasonTypeStr = @"1";
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
    NSDictionary *dict =self.dataArr[indexPath.row];
    NSString *typeStr =[NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([typeStr isEqualToString:@"3"]){
        return 115;
    }else{
        return 135;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消键盘效应
    [self.headerSearchView.searchTextField resignFirstResponder];
    
    ApprovalRecordCell *cell = [self.recordTableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"type"]];
    RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
    detaVC.titleStr = cell.showNameLab.text;
    detaVC.recordIdStr = dict[@"recordId"];
    detaVC.cardIdStr = dict[@"cardId"];
    detaVC.isApplyFor = YES;
    NSString *statusStr  =[NSString stringWithFormat:@"%@",dict[@"status"]];
    if ([statusStr isEqualToString:@"1"]) {
        //审核中
        detaVC.chenkStatusStr = @"1";
    }else{
        //其他
        detaVC.chenkStatusStr = @"2";
    }
    if ([typeStr isEqualToString:@"2"]) {
        //外出
        detaVC.detaType = RecordApproveGoOutDetaType;
        detaVC.typeStr = @"2";
    }else if ([typeStr isEqualToString:@"1"]){
        //请假
        detaVC.detaType = RecordApproveLeaveDetaType;
        detaVC.typeStr = @"1";
    }else if ([typeStr isEqualToString:@"3"]){
        //补卡
        detaVC.detaType = recordApproveCardDetaType;
        detaVC.typeStr = @"3";
    }
    [self.navigationController pushViewController:detaVC animated:YES];
}
-(void) createSearchView{
    __weak typeof(self) weakSelf = self;
    self.headerSearchView = [[RecordHeaderSearchView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+50, KScreenW, 60)];
    [self.view addSubview:self.headerSearchView];
    self.headerSearchView.searchBlock = ^(NSString *searchStr) {
        weakSelf.statuStr = @"0";
        weakSelf.typeStr = @"0";
        [weakSelf.dataArr removeAllObjects];
        weakSelf.likeTitleStr = searchStr;
        [weakSelf requestDataList];
    };
    self.recordTableView =  [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+60+50, KScreenW, KScreenH-KSNaviTopHeight-60-50)];
    [self.view addSubview:self.recordTableView];
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.recordTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.recordTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.recordTableView registerNib:[UINib nibWithNibName:APPROVALRECORD_CELL bundle:nil] forCellReuseIdentifier:APPROVALRECORD_CELL];
    
    //空白页
    self.showBlankSpaceView = [[ShowBlankSpaceView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-KSNaviTopHeight-60-50)];
    [self.recordTableView addSubview:self.showBlankSpaceView];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.headerSearchView.searchTextField resignFirstResponder];
}
-(void) createChenkHeaderView{
    ChenkHeaderView *chenkHeaderView = [[ChenkHeaderView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, 50)];
    [self.view addSubview:chenkHeaderView];
    __weak typeof(self) weakSelf = self;
    chenkHeaderView.typeBlock = ^(NSString *typeStr) {
        weakSelf.statuStr =@"0";
        weakSelf.typeStr = @"0";
        weakSelf.cutTypeStr = typeStr;
        //清空当前搜索
        weakSelf.headerSearchView.searchTextField.text = nil;
        //清空数据源
        [weakSelf.dataArr removeAllObjects];
        //请求数据源
        [weakSelf requestDataList];
    };
}
//设置navi
-(void) createNavi{
    self.customNavBar.title = @"我审批的";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //右边
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"wcjl_ico_sx"]];
    self.customNavBar.onClickRightButton = ^{
        //取消键盘效应
        [weakSelf.headerSearchView.searchTextField resignFirstResponder];
        
        ApprovalRecordSiftController *siftVC = [[ApprovalRecordSiftController alloc]init];
        if ([weakSelf.cutTypeStr isEqualToString:@"1"]) {
            siftVC.siftType = RecordTypeSiftType;
        }else{
           siftVC.siftType = RecordApplyForSiftType;
        }
        siftVC.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:siftVC animated:YES];
    };
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr =[NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark ---数据相关-----
-(void) requestDataList{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //cuttype 1 待我审批的  2我已审批的
    if ([self.cutTypeStr isEqualToString:@"1"]) {
        param[@"status"] = @"1";
    }else{
        param[@"status"] = @"2";
    }
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"type"] = self.typeStr;
    param[@"adopt"] = self.statuStr;
    param[@"likeTitle"] = self.likeTitleStr;
    param[@"offset"] = [NSString stringWithFormat:@"%ld",(long)self.page];
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPAPPROVALLIST_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSArray class]])  {
            [self.dataArr addObjectsFromArray:showdata];
            if (self.dataArr.count > 0) {
                self.showBlankSpaceView.hidden = YES;
            }else{
                self.showBlankSpaceView.hidden = NO;
            }
            [self.recordTableView reloadData];
        }
        
    }];
    
    
    
}





@end
