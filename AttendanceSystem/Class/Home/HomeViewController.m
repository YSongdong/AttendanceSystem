//
//  HomeViewController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/13.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "HomeViewController.h"

#import "SGAdvertScrollView.h"
#import "AppDelegate.h"

#import "SDPhotoCollectController.h"
#import "SDAttendPunchCardController.h"
#import "AttendRecordController.h"
#import "GoOutApprovalController.h"
#import "LeaveApprovalController.h"
#import "SupplementCardController.h"
#import "InitiateApplyForController.h"
#import "MineChenkApplyForController.h"
#import "OverTimeApplyforController.h"


#import "MessageCentreController.h"
#import "AnnouncentViewController.h"
#import "AttendCountController.h"



@interface HomeViewController ()
<
SGAdvertScrollViewDelegate
>
//考勤专区高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attendaceConstraintHeight;
//申请专区高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyForConstraHeight;
//我发起的申请
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goOutConstraintHeight;
//我审批的申请
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *meExamConstrainHeight;
//考勤专区文字间隔
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attendImageVConstrianHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attendTextImageVConstranHeight;
//审批中心， 间隔
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chenkSpaceConstraWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageVHeight;

@property (weak, nonatomic) IBOutlet UIImageView *meChankReightImageV;

@property (weak, nonatomic) IBOutlet UIImageView *NaviBgImageV;

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
//广告imageV
@property (weak, nonatomic) IBOutlet UIImageView *msgImageV;
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

@property (weak, nonatomic) IBOutlet UIButton *meExamBtn;
@property (weak, nonatomic) IBOutlet UIImageView *meExamImageV;
@property (weak, nonatomic) IBOutlet UILabel *meExamLab;

//公告数据源
@property (nonatomic,strong) NSMutableArray *titlsArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //更新ui
    [self updateView];
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf = self;
    //隐藏Tabbar
    self.tabBarController.tabBar.hidden = YES;
    //请求数据
    [weakSelf requestUserInfoData];
    //请求公告
    [weakSelf requestBulletinDataList];
//    if ([[SDUserInfo obtainWithIsCharge] isEqualToString:@"2"]) {
//        weakSelf.meExamBtn.hidden = YES;
//        weakSelf.meExamImageV.hidden = YES;
//        weakSelf.meExamLab.hidden = YES;
//        weakSelf.meChankReightImageV.hidden = YES;
//    }else{
//        weakSelf.meExamBtn.hidden = NO;
//        weakSelf.meExamImageV.hidden = NO;
//        weakSelf.meExamLab.hidden = NO;
//        weakSelf.meChankReightImageV.hidden = NO;
//    }
}
//更新ui
-(void) updateView{
    //计算高度
    self.headerImageVHeight.constant = KSNaviTopHeight+13;
    //考勤专区高
    self.attendaceConstraintHeight.constant = KSIphonScreenH(138);
    //申请专区高
    self.goOutConstraintHeight.constant = KSIphonScreenH(120);
    self.applyForConstraHeight.constant = KSIphonScreenH(50);
    self.meExamConstrainHeight.constant = KSIphonScreenH(50);
    
    //考勤专区文字间隔
    self.attendImageVConstrianHeight.constant = KSIphonScreenH(20);
    self.attendTextImageVConstranHeight.constant = KSIphonScreenH(12);
    //间隔
    self.chenkSpaceConstraWidth.constant = KSIphonScreenW(15);
    
    self.customNavBar.title = @"智能考勤管理系统";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"sy_nav_ico_user"]];
    //左边按钮
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.frostedViewController presentMenuViewController];
    };
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
//    //右边按钮
//    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"sy_nav_ico_news"]];
//    self.customNavBar.onClickRightButton = ^{
//        MessageCentreController *msgVC = [[MessageCentreController alloc]init];
//        [weakSelf.navigationController pushViewController:msgVC animated:YES];
//    };
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
//    //跑马灯
//    _advertView.titles = @[@"京东、天猫等 app 首页常见的广告滚动视图", @"采用代理设计模式进行封装, 可进行事件点击处理", @"建议在 github 上下载"];
//    _advertView.titleColor = [UIColor whiteColor];
//    _advertView.textAlignment = NSTextAlignmentLeft;
//    _advertView.titleFont = [UIFont systemFontOfSize:12];
//    _advertView.delegate = self;
    
//    //隐藏广告
//    self.msgImageV.hidden = YES;
//    self.advertView.hidden = YES;
    
    if (KIsiPhoneX) {
        self.NaviBgImageV.image = [UIImage imageNamed:@"sy_bg"];
    }else{
        self.NaviBgImageV.image = [UIImage imageNamed:@"sy_nav_bg"];
    }
}
//滑动显示侧边栏
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender{
    [self.frostedViewController panGestureRecognized:sender];
}
#pragma mark ----跑马灯代理方法----
/// 代理方法
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    AnnouncentViewController  *announcentVC = [[AnnouncentViewController alloc]init];
    [self.navigationController pushViewController:announcentVC animated:YES];
}
/*********考勤专区************/
//考勤专区
- (IBAction)attendPrefecAction:(UIButton *)sender {
    if ([[SDUserInfo obtainWithProGroupId] isEqualToString:@"0"]) {
        [SDShowSystemPrompView showSystemPrompStr:@"未添加考勤组,无需打卡"];
        return;
    }
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
//    //删除
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"暂无开放" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }]];
//    [self presentViewController:alertController animated:YES completion:nil];
    AttendCountController *countVC = [[AttendCountController alloc]init];
    [self.navigationController pushViewController:countVC animated:YES];
}
/*********审批中心************/
//外出
- (IBAction)goOutAction:(UIButton *)sender {
    NSString *outgoStr = [NSString stringWithFormat:@"%@",[SDUserInfo obtainWithOutGo]];
    if ([outgoStr isEqualToString:@"2"]) {
        [SDShowSystemPrompView showSystemPrompStr:@"请先联系管理员设置审批规则"];
        return;
    }
    GoOutApprovalController *goOutVC = [[GoOutApprovalController alloc]init];
    [self.navigationController pushViewController:goOutVC animated:YES];
}
//请假
- (IBAction)leaveBtnAction:(UIButton *)sender {
    NSString *leaveStr = [NSString stringWithFormat:@"%@",[SDUserInfo obtainWithLeave]];
    if ([leaveStr isEqualToString:@"2"]) {
        [SDShowSystemPrompView showSystemPrompStr:@"请先联系管理员设置审批规则"];
        return;
    }
    LeaveApprovalController *leaveVC = [[LeaveApprovalController alloc]init];
    [self.navigationController pushViewController:leaveVC animated:YES];
}
//补卡
- (IBAction)supplemCardAction:(UIButton *)sender {
    NSString *recardStr = [NSString stringWithFormat:@"%@",[SDUserInfo obtainWithRecard]];
    if ([recardStr isEqualToString:@"2"]) {
        [SDShowSystemPrompView showSystemPrompStr:@"请先联系管理员设置审批规则"];
        return;
    }
    OverTimeApplyforController *overTimeVC  =[[OverTimeApplyforController alloc]init];
//    AttendRecordController *recordVC = [[AttendRecordController alloc]init];
    [self.navigationController pushViewController:overTimeVC animated:YES];
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
        
        [UIImageView sd_setImageView:self.headerImageV WithURL:[SDUserInfo obtainWithPhoto]];
    }];
}
//请求公告
-(void) requestBulletinDataList{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platformId"]= [SDUserInfo obtainWithPlafrmId];
    param[@"userId"] =  [SDUserInfo obtainWithUserId];
    param[@"token"] = [SDTool getNewToken];
    
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTADMINBULLETINAPPLIST_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            return ;
        }
        
        if (![showdata isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        NSMutableArray *mutableArr = [NSMutableArray array];
        NSArray *arr =  showdata[@"list"];
        for (NSDictionary *dict in arr) {
            [mutableArr  addObject:dict[@"content"]];
        }
        //跑马灯
        self.advertView.titles = mutableArr;
        self.advertView.titleColor = [UIColor whiteColor];
        self.advertView.textAlignment = NSTextAlignmentLeft;
        self.advertView.titleFont = [UIFont systemFontOfSize:12];
        self.advertView.delegate = self;
    }];
}


@end
