//
//  GoOutRecordController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "GoOutRecordController.h"

#import "ApprovalRecordSiftController.h"
#import "RecordApproveDetaController.h"

#import "RecordHeaderSearchView.h"

#import "ShowBlankSpaceView.h"

#import "ApprovalRecordCell.h"
#define APPROVALRECORD_CELL @"ApprovalRecordCell"

@interface GoOutRecordController ()
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
//分页
@property (nonatomic,assign) NSInteger page;
//模糊查寻
@property (nonatomic,strong) NSString *likeTitleStr;
//状态
@property (nonatomic,strong) NSString *statuStr;
//选中筛选条件
@property (nonatomic,strong) NSMutableArray *selelctSiftArr;
@end

@implementation GoOutRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    self.page =1;
    self.likeTitleStr = @"";
    self.statuStr = @"0";
    [self createNavi];
    [self createSearchView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.page = 1;
    [self.dataArr removeAllObjects];
    [self requestLoadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApprovalRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:APPROVALRECORD_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.reasonTypeStr = @"2";
    if (self.recordType == ApporvalRecordOutType) {
         cell.cellType = RecordCellOutType;
    }else if (self.recordType == ApporvalRecordLeaveType){
         cell.cellType = RecordCellLeaveType;
    }else if (self.recordType == ApporvalRecordCardType){
        cell.cellType = RecordCellCardType;
    } else if (self.recordType == ApporvalRecordOverTimeType){
        cell.cellType = RecordCellOverTimeType;
    }
    
    cell.cutTypeStr = @"2";
    cell.dict = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.recordType == ApporvalRecordCardType) {
        return 115;
    }else{
        return 140;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消键盘效应
    [self.headerSearchView.searchTextField resignFirstResponder];
    
    NSDictionary *dict = self.dataArr[indexPath.row];
    RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
    detaVC.recordIdStr = dict[@"id"];
    NSString *statusStr  =[NSString stringWithFormat:@"%@",dict[@"status"]];
    if ([statusStr isEqualToString:@"1"]) {
        //审核中
        detaVC.chenkStatusStr = @"1";
    }else  if ([statusStr isEqualToString:@"2"]) {
        //审批通过
        detaVC.chenkStatusStr = @"3";
    }else{
        //其他
        detaVC.chenkStatusStr = @"2";
    }
    if (self.recordType == ApporvalRecordOutType) {
        detaVC.detaType = RecordApproveGoOutDetaType;
        detaVC.typeStr = @"2";
        detaVC.titleStr = [NSString stringWithFormat:@"%@外出申请",[SDUserInfo obtainWithRealName]];
    }else if (self.recordType == ApporvalRecordLeaveType){
        detaVC.detaType = RecordApproveLeaveDetaType;
        detaVC.titleStr = [NSString stringWithFormat:@"%@请假申请",[SDUserInfo obtainWithRealName]];
        detaVC.typeStr = @"1";
    }else if (self.recordType == ApporvalRecordCardType){
        detaVC.detaType = recordApproveCardDetaType;
        detaVC.titleStr = [NSString stringWithFormat:@"%@补卡申请",[SDUserInfo obtainWithRealName]];
        detaVC.typeStr = @"3";
    }else if (self.recordType == ApporvalRecordOverTimeType){
        detaVC.detaType = recordApproveOverTimeDetaType;
        detaVC.titleStr = [NSString stringWithFormat:@"%@加班申请",[SDUserInfo obtainWithRealName]];
        detaVC.typeStr = @"5";
    }
    [self.navigationController pushViewController:detaVC animated:YES];
}
-(void) createSearchView{
    __weak typeof(self) weakSelf = self;
    self.headerSearchView = [[RecordHeaderSearchView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, 60)];
    [self.view addSubview:self.headerSearchView];
    self.headerSearchView.searchBlock = ^(NSString *searchStr) {
        weakSelf.statuStr = @"0";
        [weakSelf.dataArr removeAllObjects];
        weakSelf.likeTitleStr = searchStr;
        [weakSelf requestLoadData];
    };
    
    self.recordTableView =  [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+60, KScreenW, KScreenH-KSNaviTopHeight-60)];
    [self.view addSubview:self.recordTableView];
    self.recordTableView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.recordTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.recordTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.recordTableView registerNib:[UINib nibWithNibName:APPROVALRECORD_CELL bundle:nil] forCellReuseIdentifier:APPROVALRECORD_CELL];

    //空白页
    self.showBlankSpaceView = [[ShowBlankSpaceView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight+60, KScreenW, KScreenH-KSNaviTopHeight-60)];
    [self.view addSubview:self.showBlankSpaceView];
    
    self.recordTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestLoadData];
    }];
    self.recordTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requestLoadData];
    }];
}

//设置navi
-(void) createNavi{
    
    self.customNavBar.title =_titleStr;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //右边
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"wcjl_ico_sx"]];
    self.customNavBar.onClickRightButton = ^{
         [weakSelf.headerSearchView.searchTextField resignFirstResponder];
        
        ApprovalRecordSiftController *siftVC = [[ApprovalRecordSiftController alloc]init];
        siftVC.siftType = RecordApproveSiftType;
        siftVC.delegate = weakSelf;
        siftVC.selelctSiftArr = weakSelf.selelctSiftArr.copy;
        [weakSelf.navigationController pushViewController:siftVC animated:YES];
    };
}
#pragma mark -------ApprovalRecordSiftControllerDelegate----
- (void)selectSiftArr:(NSArray *)arr{
     self.likeTitleStr = @"";
    //移除数据源
    [self.dataArr removeAllObjects];
    if (arr.count == 1) {
        NSDictionary *dict = arr[0];
        self.statuStr = dict[@"status"];
        self.headerSearchView.searchTextField.text = dict[@"content"];
    }
    self.selelctSiftArr = [NSMutableArray arrayWithArray:arr];
}
-(void)setRecordType:(ApporvalRecordType)recordType{
    _recordType = recordType;
}
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr  =[NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark ---数据相关----
-(void) requestLoadData{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *url;
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"offset"] = [NSString stringWithFormat:@"%ld",(long)self.page];
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    param[@"likeTitle"] = self.likeTitleStr;
    param[@"status"] = self.statuStr;
    if (_recordType == ApporvalRecordOutType) {
        url = HTTP_ATTAPPOUTGOOUTLIST_URL;
    }else if (_recordType == ApporvalRecordLeaveType){
        url = HTTP_ATTAPPLEAVELIST_URL;
    }else if (_recordType == ApporvalRecordCardType){
        url = HTTP_ATTAPPREPAICARDLIST_URL;
    }else if (_recordType == ApporvalRecordOverTimeType){
        url = HTTP_ATTAPPOVERTIMELIST_URL;
    }
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:url params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
            self.recordTableView.mj_footer.hidden = NO;
        }
        if ([showdata isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *) showdata;
            if (arr.count == 0) {
                self.recordTableView.mj_footer.hidden = YES;
                [self.recordTableView.mj_header endRefreshing];
                [self.recordTableView.mj_footer endRefreshing];
                if (self.dataArr.count > 0) {
                    self.showBlankSpaceView.hidden = YES;
                    [SDShowSystemPrompView showSystemPrompStr:@"没有更多的数据"];
                }else{
                    self.showBlankSpaceView.hidden = NO;
                }
                return;
            }
            [self.dataArr addObjectsFromArray:arr];
            if (self.dataArr.count > 9) {
                self.recordTableView.mj_footer.hidden = NO;
            }else{
                self.recordTableView.mj_footer.hidden = YES;
            }
            if (self.dataArr.count > 0) {
                self.showBlankSpaceView.hidden = YES;
            }else{
                self.showBlankSpaceView.hidden = NO;
            }
            [self.recordTableView reloadData];
            [self.recordTableView.mj_header endRefreshing];
            [self.recordTableView.mj_footer endRefreshing];
        }
    }];
}





@end
