//
//  HomeViewController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/13.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "HomeViewController.h"

#import "SGAdvertScrollView.h"
#import "CKLeftSlideViewController.h"
#import "AppDelegate.h"

#import "SDPhotoCollectController.h"
#import "SDAttendPunchCardController.h"
#import "AttendRecordController.h"
#import "GoOutApprovalController.h"
#import "LeaveApprovalController.h"
#import "SupplementCardController.h"
#import "InitiateApplyForController.h"
#import "MineChenkApplyForController.h"

@interface HomeViewController ()
<
SGAdvertScrollViewDelegate
>
//头像背景view
@property (weak, nonatomic) IBOutlet UIView *headerBgView;
//头像背景
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
//部门
@property (weak, nonatomic) IBOutlet UILabel *posiLab;
//跑马灯
@property (weak, nonatomic) IBOutlet SGAdvertScrollView *advertView;

/*********考勤专区************/
//考勤专区
- (IBAction)attendPrefecAction:(UIButton *)sender;
//考勤记录
- (IBAction)attendRceodAction:(UIButton *)sender;
//考勤记录
- (IBAction)attendCountAction:(UIButton *)sender;
/*********审批中心************/
//外出
- (IBAction)goOutAction:(UIButton *)sender;
//请假
- (IBAction)leaveBtnAction:(UIButton *)sender;
//补卡
- (IBAction)supplemCardAction:(UIButton *)sender;
/*********申请************/
//我提交的申请
- (IBAction)meSubmitAnAppliction:(UIButton *)sender;
//我审核的申请
- (IBAction)meChenkApplication:(UIButton *)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //更新ui
    [self updateView];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏Tabbar
    self.tabBarController.tabBar.hidden = YES;
    //请求数据
    [self requestUserInfoData];
}
//更新ui
-(void) updateView{
    self.customNavBar.title = @"智能考勤管理系统";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"sy_nav_ico_user"]];
    //左边按钮
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.frostedViewController presentMenuViewController];
    };
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
    //右边按钮
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"sy_nav_ico_news"]];
    self.customNavBar.onClickRightButton = ^{
        
    };
    //设置导航栏透明
    [self.customNavBar wr_setBackgroundAlpha:0];
    
    //头像bgview
    self.headerBgView.layer.cornerRadius =CGRectGetWidth(self.headerBgView.frame)/2;
    self.headerBgView.layer.masksToBounds = YES;
    self.headerBgView.backgroundColor =[UIColor whiteColor];
    
    //用户头像
    [UIImageView sd_setImageView:self.headerImageV WithURL:[SDUserInfo obtainWithPhoto]];
    //用户名字
    self.nameLab.text = [SDUserInfo obtainWithRealName];
    //部门
    self.posiLab.text = [NSString stringWithFormat:@"部门名称:%@",[SDUserInfo obtainWithDepartmentName]];
    //跑马灯
    _advertView.titles = @[@"京东、天猫等 app 首页常见的广告滚动视图", @"采用代理设计模式进行封装, 可进行事件点击处理", @"建议在 github 上下载"];
    _advertView.titleColor = [UIColor whiteColor];
    _advertView.textAlignment = NSTextAlignmentLeft;
    _advertView.titleFont = [UIFont systemFontOfSize:12];
    _advertView.delegate = self;
    
}
//滑动显示侧边栏
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender{
    [self.frostedViewController panGestureRecognized:sender];
}
#pragma mark ----跑马灯代理方法----
/// 代理方法
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    
}
/*********考勤专区************/
//考勤专区
- (IBAction)attendPrefecAction:(UIButton *)sender {
    SDAttendPunchCardController *attenCardVC = [[SDAttendPunchCardController alloc]init];
    [self.navigationController pushViewController:attenCardVC animated:YES];
}
//考勤记录
- (IBAction)attendRceodAction:(UIButton *)sender {
    AttendRecordController *recordVC = [[AttendRecordController alloc]init];
    [self.navigationController pushViewController:recordVC animated:YES];
}
//考勤记录
- (IBAction)attendCountAction:(UIButton *)sender {
}
/*********审批中心************/
//外出
- (IBAction)goOutAction:(UIButton *)sender {
    GoOutApprovalController *goOutVC = [[GoOutApprovalController alloc]init];
    [self.navigationController pushViewController:goOutVC animated:YES];
}
//请假
- (IBAction)leaveBtnAction:(UIButton *)sender {
    LeaveApprovalController *leaveVC = [[LeaveApprovalController alloc]init];
    [self.navigationController pushViewController:leaveVC animated:YES];
}
//补卡
- (IBAction)supplemCardAction:(UIButton *)sender {
    AttendRecordController *recordVC = [[AttendRecordController alloc]init];
    [self.navigationController pushViewController:recordVC animated:YES];
}
/*********申请************/
//我提交的申请
- (IBAction)meSubmitAnAppliction:(UIButton *)sender {
    InitiateApplyForController *applyforVC =[[InitiateApplyForController alloc]init];
    [self.navigationController pushViewController:applyforVC animated:YES];
}
//我审核的申请
- (IBAction)meChenkApplication:(UIButton *)sender {
    MineChenkApplyForController *mineChenkVC = [[MineChenkApplyForController alloc]init];
    [self.navigationController pushViewController:mineChenkVC animated:YES];
}
#pragma mark ----数据相关-----
-(void) requestUserInfoData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] =  [SDUserInfo obtainWithUserId];
    param[@"token"] = [SDTool getNewToken];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPUSERUSERINFO_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        //修改用户保存信息
        [SDUserInfo alterUserInfo:showdata];
    }];
}


@end
