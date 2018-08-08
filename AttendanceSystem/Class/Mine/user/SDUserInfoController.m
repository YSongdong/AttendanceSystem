//
//  SDUserInfoController.m
//  SDSafetyManageControl
//
//  Created by tiao on 2018/4/27.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "SDUserInfoController.h"

#import "SDPhotoCollectController.h"
#import "SDLoginController.h"
#import "SDRootNavigationController.h"
#import "BindingPhoneController.h"
#import "AlterPassNumberController.h"
#import "AlterPhoneNumberController.h"

#import "SDLeaveBtnShowView.h"
#import "SDUserLeaveTableViewCell.h"
#import "SDUserInfoTableViewCell.h"

#define SDUSERINFOTABLEVIEW_CELL  @"SDUserInfoTableViewCell"
#define SDUERINFOLEAVE_CELL  @"SDUserLeaveTableViewCell"

@interface SDUserInfoController ()
<UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic,strong) UITableView *userTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;
//退出按钮提示框
@property (nonatomic,strong) SDLeaveBtnShowView *leaveShowView;
//是否显示平台数据  YES 显示  NO 不显示
@property (nonatomic,assign) BOOL isShowPlatform;
//记录删除平台的indexPath
@property (nonatomic,strong) NSIndexPath *delIndexPath;

//审核失败原因
@property (nonatomic,strong) NSString *chenkErrorStr;

@end

@implementation SDUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor colorWithHexString:@"#f2f2f2"];
    //设置导航栏透明
    [self.customNavBar wr_setBackgroundAlpha:1];
    self.isShowPlatform = NO;
    //设置导航栏
    [self createNavi];
    //创建tableView
    [self createTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //加载数据源
    [self requestUserInfoData];
}
//设置导航栏
-(void) createNavi{
    self.customNavBar.title = @"个人资料";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
     __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark  ------ 创建TableVIew------
//网络请求失败， 加载本地数据
-(void) loadData{
    //移除数据源
    [self.dataArr removeAllObjects];
    
    NSString *isBindPhoneStr = [SDUserInfo obtainWithPotoStatus];
    //判断手机绑定状态
    NSString *phoneStr=[isBindPhoneStr isEqualToString:@"2"] ? @"未绑定":[SDUserInfo obtainWithPhone];
    //头像
    NSArray *headerArr = @[@{@"name":@"用户头像",@"desc":[SDUserInfo obtainWithPhoto],@"photoStatus":[SDUserInfo obtainWithPotoStatus]}];
    NSArray *infoArr = @[@{@"name":@"真实姓名",@"desc":[SDUserInfo obtainWithRealName],@"photoStatus":[SDUserInfo obtainWithSex]},
                         @{@"name":@"身份证号",@"desc":[SDUserInfo obtainWithidcard]},
                         @{@"name":@"所属部门",@"desc":[SDUserInfo obtainWithDepartmentName]},
                         @{@"name":@"员工职位",@"desc":[SDUserInfo obtainWithPositionName]},
                         @{@"name":@"员工工号",@"desc":[SDUserInfo obtainWithJobNumber]},
                         @{@"name":@"手机号码",@"desc":phoneStr},
                         @{@"name":@"修改登录密码",@"desc":@""}];
    [self.dataArr addObject:headerArr];
    [self.dataArr addObject:infoArr];
    [self.dataArr addObject:@[@{}]];
    
    [self.userTableView reloadData];
}
//创建tableView
-(void) createTableView{
    
    self.userTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH) style:UITableViewStyleGrouped];
    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.userTableView.rowHeight = 60;
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    
    [self.view addSubview:self.userTableView];
    //设置分割线位置
    self.userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.userTableView registerNib:[UINib nibWithNibName:SDUSERINFOTABLEVIEW_CELL bundle:nil] forCellReuseIdentifier:SDUSERINFOTABLEVIEW_CELL];
    [self.userTableView registerNib:[UINib nibWithNibName:SDUERINFOLEAVE_CELL bundle:nil] forCellReuseIdentifier:SDUERINFOLEAVE_CELL];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.userTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[section];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    __weak typeof(self) weakSelf = self;
    if (indexPath.section == self.dataArr.count-1) {
        SDUserLeaveTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:SDUERINFOLEAVE_CELL forIndexPath:indexPath];
        //退出按钮
        cell.leaveBtnBlock = ^{
            //删除用户信息
            [SDUserInfo delUserInfo];
            
            SDLoginController *loginVC = [[SDLoginController alloc]init];
            [weakSelf.navigationController pushViewController:loginVC animated:YES];
        };
        return cell;
    }else{

        SDUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SDUSERINFOTABLEVIEW_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *arr = self.dataArr[indexPath.section];
        
        cell.isShowPlatform = self.isShowPlatform;
        cell.indexPath =  indexPath;
        cell.dict = arr[indexPath.row];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else {
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0 && indexPath.row == 0) {
        //用户头像
        SDPhotoCollectController *photoVC = [[SDPhotoCollectController alloc]init];
        photoVC.chenkStatu = [SDUserInfo obtainWithPotoStatus];
        photoVC.isMine = YES;
        photoVC.chenkErrorStr = self.chenkErrorStr;
        [self.navigationController pushViewController:photoVC animated:YES];
    }
    if (indexPath.section == 1){
        if (indexPath.row == 5) {
            NSString *bindPhoneStr = [SDUserInfo obtainWithBindPhone];
            if ([bindPhoneStr isEqualToString:@"1"]) {
                //已绑定
                AlterPhoneNumberController *alterPhoneVC =[[AlterPhoneNumberController alloc]init];
                alterPhoneVC.isMine = YES;
                [self.navigationController pushViewController:alterPhoneVC animated:YES];
                
            }else{
                //未绑定
                BindingPhoneController *bindVC = [[BindingPhoneController alloc]init];
                bindVC.isMine = YES;
                bindVC.numberBlock = ^(NSString *numberStr) {
                    NSMutableArray  *arr = [NSMutableArray arrayWithArray:weakSelf.dataArr[indexPath.section]];
                    NSMutableDictionary *mutaleDict = [NSMutableDictionary dictionaryWithDictionary:arr[indexPath.row]];
                    mutaleDict[@"desc"] = numberStr;
                    [arr replaceObjectAtIndex:indexPath.row withObject:mutaleDict.copy];
                    [weakSelf.dataArr replaceObjectAtIndex:indexPath.section withObject:arr.copy];
                    [weakSelf.userTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                };
                [self.navigationController pushViewController:bindVC animated:YES];
            }
        }
        if (indexPath.row == 6) {
            AlterPassNumberController *passVC = [[AlterPassNumberController alloc]init];
            passVC.isMine = YES;
            [self.navigationController pushViewController:passVC animated:YES];
            
        }
    }
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark ----数据相关-----
-(void) requestUserInfoData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] =  [SDUserInfo obtainWithUserId];
    param[@"token"] = [SDTool getNewToken];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPUSERUSERINFO_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            //网络请求失败， 加载本地数据
            [self loadData];
            return ;
        }
        //修改用户保存信息
        [SDUserInfo alterUserInfo:showdata];
        if ([showdata[@"photoStatus"] isEqualToString:@"2"]) {
            self.chenkErrorStr =  showdata[@"photoInfo"];
        }
        //移除当前data信息
        [self.dataArr removeAllObjects];
        
        NSString *isBindPhoneStr = [NSString stringWithFormat:@"%@",showdata[@"isBindPhone"]];
        //判断手机绑定状态
        NSString *phoneStr=[isBindPhoneStr isEqualToString:@"2"] ? @"未绑定":[SDUserInfo obtainWithPhone];
        //修改用户列表
        //头像
        NSArray *headerArr = @[@{@"name":@"用户头像",@"desc":showdata[@"photo"],@"photoStatus":showdata[@"photoStatus"]}];
        NSArray *infoArr = @[@{@"name":@"真实姓名",@"desc":showdata[@"realName"],@"photoStatus":showdata[@"sex"]},
                             @{@"name":@"身份证号",@"desc":showdata[@"idcard"]},
                             @{@"name":@"所属部门",@"desc":showdata[@"departmentName"]},
                             @{@"name":@"员工职位",@"desc":showdata[@"positionName"]},
                             @{@"name":@"员工工号",@"desc":showdata[@"jobnumber"]},
                             @{@"name":@"手机号码",@"desc":phoneStr},
                             @{@"name":@"修改登录密码",@"desc":@""}];
        [self.dataArr addObject:headerArr];
        [self.dataArr addObject:infoArr];
        [self.dataArr addObject:@[@{}]];
        
        [self.userTableView reloadData];
    }];
}






@end
