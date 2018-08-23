//
//  AnnouncentViewController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/17.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AnnouncentViewController.h"

#import "AnnouncentTableViewCell.h"
#define ANNOUNCENTTABLEVIEW_CELL  @"AnnouncentTableViewCell"

@interface AnnouncentViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) UITableView *announcentTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) NSInteger page;
@end

@implementation AnnouncentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page =1;
    [self createNavi];
    [self createTableView];
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestBulletinDataList];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnnouncentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ANNOUNCENTTABLEVIEW_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dict = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
//设置navi
-(void) createNavi{
    self.customNavBar.title = @"平台公告";
    self.customNavBar.rightButton.hidden= YES;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
-(void) createTableView{
    
    self.view.backgroundColor = [UIColor colorCommonf2GreyColor];
    
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 12)];
    headerView.backgroundColor =  [UIColor colorCommonf2GreyColor];
    
    self.announcentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
    [self.view addSubview:self.announcentTableView];
    
    self.announcentTableView.backgroundColor = [UIColor colorCommonf2GreyColor];
    self.announcentTableView.delegate = self;
    self.announcentTableView.dataSource = self;
    self.announcentTableView.estimatedRowHeight = 110;
    self.announcentTableView.rowHeight =UITableViewAutomaticDimension;
    self.announcentTableView.tableHeaderView =headerView;
    self.announcentTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.announcentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.announcentTableView registerNib:[UINib nibWithNibName:ANNOUNCENTTABLEVIEW_CELL bundle:nil] forCellReuseIdentifier:ANNOUNCENTTABLEVIEW_CELL];
    
    __weak typeof(self) weakSelf = self;
    self.announcentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page =1;
        [weakSelf requestBulletinDataList];
    }];
    
    self.announcentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requestBulletinDataList];
    }];
    self.announcentTableView.mj_footer.hidden = YES;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark ---数据相关----
//请求公告
-(void) requestBulletinDataList{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"]= [SDUserInfo obtainWithPlafrmId];
    param[@"userId"] =  [SDUserInfo obtainWithUserId];
    param[@"token"] = [SDTool getNewToken];
    param[@"offset"] = [NSNumber numberWithInteger:self.page];
    param[@"num"] = @"10";
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTADMINBULLETINAPPLIST_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            return ;
        }
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
        }
        if (![showdata isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSArray *arr =showdata[@"list"];
        NSString *countStr = [NSString stringWithFormat:@"%@",showdata[@"count"]];
        if ([countStr integerValue] == self.dataArr.count) {
            [SDShowSystemPrompView showSystemPrompStr:@"没有更多数据了"];
            self.announcentTableView.mj_footer.hidden= YES;
            return;
        }
        if (self.dataArr.count > 9) {
            self.announcentTableView.mj_footer.hidden = NO;
        }else{
           self.announcentTableView.mj_footer.hidden = YES;
        }
        self.dataArr = [NSMutableArray arrayWithArray:arr];
        [self.announcentTableView.mj_header endRefreshing];
        [self.announcentTableView.mj_footer endRefreshing];
        [self.announcentTableView reloadData];
    }];
}




@end
