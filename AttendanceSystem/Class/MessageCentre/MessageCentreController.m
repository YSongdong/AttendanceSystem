//
//  MessageCentreController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/9.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "MessageCentreController.h"

#import "SDRootNavigationController.h"
#import "LeftUserController.h"
#import "HomeViewController.h"

#import "ShowBlankSpaceView.h"

#import "ShowSiftMessageTypeView.h"
#import "RecordApproveDetaController.h"
#import "SDPhotoCollectController.h"

#import "MessageAttendaceRemindCell.h"
#define MESSAGEATTENDACEREMIND_CELL @"MessageAttendaceRemindCell"

#import "MessageAttendaceCardCell.h"
#define MESSAGEATTENDACECARD_CELL  @"MessageAttendaceCardCell"

#import "MessageAttendaceGoOutCell.h"
#define MESSAGEATTENDACEGOOUT_CELL @"MessageAttendaceGoOutCell"

#import "MessageChankPhotoStatuCell.h"
#define MESSAGECHANKPHOTOSTATU_CELL  @"MessageChankPhotoStatuCell"

@interface MessageCentreController ()<UITableViewDelegate,UITableViewDataSource,REFrostedViewControllerDelegate>
@property (nonatomic,strong) UITableView *msgTableView;
//空白页
@property (nonatomic,strong)ShowBlankSpaceView *showBlankSpaceView;
@property (nonatomic,strong) NSMutableArray *dataArr;
//消息筛选
@property (nonatomic,strong)ShowSiftMessageTypeView *msgTypeView;
//筛选类型
@property (nonatomic,strong) NSString *typeStr;
@property (nonatomic,assign) NSInteger page;

@end

@implementation MessageCentreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.typeStr = @"0";
    self.page = 1;
    [self.dataArr removeAllObjects];
    [self requestLoadMsgData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSString *allTypeStr = [NSString stringWithFormat:@"%@",dict[@"allType"]];
    if ([allTypeStr isEqualToString:@"2"]) {
        //照片审核
        MessageChankPhotoStatuCell *cell = [tableView dequeueReusableCellWithIdentifier:MESSAGECHANKPHOTOSTATU_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dict = dict;
        return cell;
    }else  if ([allTypeStr isEqualToString:@"3"]){
        //申请提交'
        MessageAttendaceGoOutCell *cell = [tableView dequeueReusableCellWithIdentifier:MESSAGEATTENDACEGOOUT_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dict = dict;
        return cell;
    }else{
       //  1：考勤打卡
        MessageAttendaceRemindCell *cell  = [tableView dequeueReusableCellWithIdentifier:MESSAGEATTENDACEREMIND_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dict = dict;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSString *allTypeStr = [NSString stringWithFormat:@"%@",dict[@"allType"]];
    if ([allTypeStr isEqualToString:@"2"]) {
         //照片审核
        return [MessageChankPhotoStatuCell getWithCellHeight:dict];
    }else  if ([allTypeStr isEqualToString:@"3"]){
         //申请提交'
        return [MessageAttendaceGoOutCell getWithCellHeight:dict];
    }else{
         //1：考勤打卡
         return KSIphonScreenH(168);
    }
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView.contentSize.height < tableView.frame.size.height)
//    {
//        tableView.contentInset = UIEdgeInsetsMake(tableView.frame.size.height - tableView.contentSize.height , 0, 0, 0);
//    }
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSString *allTypeStr = [NSString stringWithFormat:@"%@",dict[@"allType"]];
    RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
    if ([allTypeStr isEqualToString:@"3"]) {
         NSInteger type =[dict[@"type"] integerValue];
        if (type > 0 && type < 9) {
            detaVC.cardIdStr = dict[@"approvalId"];
            detaVC.isApplyFor = YES;
        }
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
        detaVC.recordIdStr = dict[@"recordId"];
        NSString *typeStr  =[NSString stringWithFormat:@"%@",dict[@"type"]];
        if ([typeStr isEqualToString:@"1"] || [typeStr isEqualToString:@"5"] || [typeStr isEqualToString:@"9"] || [typeStr isEqualToString:@"13"]) {
            //请假
            detaVC.detaType = RecordApproveLeaveDetaType;
            detaVC.typeStr = @"1";
            detaVC.titleStr = [NSString stringWithFormat:@"%@请假申请",dict[@"userName"]];
        }else  if ([typeStr isEqualToString:@"2"] || [typeStr isEqualToString:@"6"] || [typeStr isEqualToString:@"10"] || [typeStr isEqualToString:@"14"]) {
            //外出
            detaVC.detaType = RecordApproveGoOutDetaType;
            detaVC.typeStr = @"2";
            detaVC.titleStr = [NSString stringWithFormat:@"%@外出申请",dict[@"userName"]];
        }else  if ([typeStr isEqualToString:@"3"] || [typeStr isEqualToString:@"7"] || [typeStr isEqualToString:@"11"] || [typeStr isEqualToString:@"15"]) {
            //加班
            detaVC.detaType = recordApproveOverTimeDetaType;
            detaVC.titleStr = [NSString stringWithFormat:@"%@加班申请",dict[@"userName"]];
            detaVC.typeStr = @"5";
        }
         [self.navigationController pushViewController:detaVC animated:YES];
    }else  if ([allTypeStr isEqualToString:@"2"]) {
        //照片审核
        NSString *typeStr  =[NSString stringWithFormat:@"%@",dict[@"type"]];
        SDPhotoCollectController *photoVC = [[SDPhotoCollectController alloc]init];
        if ([typeStr isEqualToString:@"1"]) {
            //通过
             photoVC.chenkStatu =@"3";
        }else{
            NSString *titleStr = [NSString stringWithFormat:@"%@",dict[@"title"]];
            NSString *chenkStatuErrorStr = @"";
            if ([titleStr rangeOfString:@"拒绝原因："].location !=NSNotFound ) {
                NSArray *arr = [titleStr componentsSeparatedByString:@"，"];
                NSString *errorStr = arr[1];
                NSArray *errorArr = [errorStr componentsSeparatedByString:@"："];
                chenkStatuErrorStr = errorArr[1];
            }
            //未通过
            photoVC.chenkStatu =@"2";
            if (![chenkStatuErrorStr isEqualToString:@""]) {
                photoVC.chenkErrorStr = chenkStatuErrorStr;
            }else{
                photoVC.chenkErrorStr = @"";
            }
        }
        photoVC.isMine = YES;
        [self.navigationController pushViewController:photoVC animated:YES];
    }
}
-(void) createTableView{
    self.msgTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
    [self.view addSubview:self.msgTableView];
    
    self.msgTableView.delegate = self;
    self.msgTableView.dataSource = self;
    self.msgTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.msgTableView.backgroundColor = [UIColor colorCommonf2GreyColor];
    
    [self.msgTableView registerClass:[MessageAttendaceRemindCell class] forCellReuseIdentifier:MESSAGEATTENDACEREMIND_CELL];
    [self.msgTableView registerClass:[MessageAttendaceCardCell class] forCellReuseIdentifier:MESSAGEATTENDACECARD_CELL];
    [self.msgTableView registerClass:[MessageAttendaceGoOutCell class] forCellReuseIdentifier:MESSAGEATTENDACEGOOUT_CELL];
    [self.msgTableView registerClass:[MessageChankPhotoStatuCell  class] forCellReuseIdentifier:MESSAGECHANKPHOTOSTATU_CELL];
    
    //空白页
    self.showBlankSpaceView = [[ShowBlankSpaceView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-KSTabbarH)];
    [self.view addSubview:self.showBlankSpaceView];
    
    
    __weak typeof(self) weakSelf = self;
    self.msgTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf requestLoadMsgData];
    }];
    self.msgTableView.mj_header.hidden = YES;
}
-(void)setIsAppDelegate:(BOOL)isAppDelegate{
    _isAppDelegate = isAppDelegate;
}
//设置navi
-(void) createNavi{
    self.customNavBar.title = @"消息中心";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        if (weakSelf.isAppDelegate) {
            [weakSelf backHome];
            return ;
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //右边
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"wcjl_ico_sx"]];
    self.customNavBar.onClickRightButton = ^{
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.msgTypeView];
        __weak typeof(weakSelf) strongSelf = weakSelf;
        weakSelf.msgTypeView.selectType = ^(NSString *typeStr) {
            strongSelf.typeStr = typeStr;
            strongSelf.page =1;
            [strongSelf.dataArr  removeAllObjects];
            [strongSelf requestLoadMsgData];
        };
    };
}
-(void)backHome{
    //否则直接进入应用
    SDRootNavigationController *leftVC = [[SDRootNavigationController alloc]initWithRootViewController:[LeftUserController new]];
    
    SDRootNavigationController *rootVC = [[SDRootNavigationController alloc]initWithRootViewController:[HomeViewController new]];
    
    UITabBarController *tarBarCtr=[[UITabBarController alloc]init];
    [tarBarCtr setViewControllers:[NSArray arrayWithObjects:rootVC, nil]];
    //侧边栏
    REFrostedViewController *rostedViewController = [[REFrostedViewController alloc] initWithContentViewController:tarBarCtr menuViewController:leftVC];
    rostedViewController.direction = REFrostedViewControllerDirectionLeft;
    rostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleDark;
    rostedViewController.liveBlur = YES;
    rostedViewController.limitMenuViewSize = YES;
    rostedViewController.backgroundFadeAmount=0.5;
    rostedViewController.delegate = self;
    rostedViewController.menuViewSize=CGSizeMake(leftSideMeunWidth, ScreenHeight);
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.rootTabbarCtrV = tarBarCtr;
    appdel.window.rootViewController =rostedViewController;
}
#pragma mark -----------懒加载--------
-(ShowSiftMessageTypeView *)msgTypeView{
    if (!_msgTypeView) {
        _msgTypeView = [[ShowSiftMessageTypeView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _msgTypeView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark --------数据相关-------
-(void)requestLoadMsgData{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"type"] =self.typeStr;
    param[@"offset"] = [NSNumber numberWithInteger:self.page];
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_ATTAPPMSGLIST_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
    
        if (error) {
            [self.msgTableView.mj_header endRefreshing];
            if (![error isKindOfClass:[NSNull class]]) {
                [SDShowSystemPrompView showSystemPrompStr:error];
            }else{
                [SDShowSystemPrompView showSystemPrompStr:@"网络错误"];
            }
            return ;
        }
        
        if (![showdata isKindOfClass:[NSArray class]]) {
            return;
        }
     
        //让UITableView的最后一行滚动到最上面
        NSArray *arr  = (NSArray *) showdata;
        if (arr.count == 0) {
            [self.msgTableView.mj_header endRefreshing];
            [self.msgTableView reloadData];
            if (self.dataArr.count == 0) {
                self.showBlankSpaceView.hidden = NO;
            }else{
                self.showBlankSpaceView.hidden = YES;
            }
            return ;
        }
        for (int i =0; i< arr.count; i++) {
            NSDictionary *dict = arr[i];
            [self.dataArr insertObject:dict atIndex:0];
        }
        [self.msgTableView reloadData];
        [self.msgTableView.mj_header endRefreshing];
        if (self.dataArr.count > 3) {
            self.msgTableView.mj_header.hidden = NO;
        }else{
            self.msgTableView.mj_header.hidden = YES;
        }
       
        if (self.dataArr.count == 0) {
            self.showBlankSpaceView.hidden = NO;
        }else{
            self.showBlankSpaceView.hidden = YES;
        }
        if (self.page ==1) {
           NSIndexPath *lastRowindexPath = [NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0];
           [self.msgTableView scrollToRowAtIndexPath:lastRowindexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        
    }];
    
}







@end
