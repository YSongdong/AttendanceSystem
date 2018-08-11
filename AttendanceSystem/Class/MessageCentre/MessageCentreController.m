//
//  MessageCentreController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/9.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "MessageCentreController.h"


#import "MessageAttendaceRemindCell.h"
#define MESSAGEATTENDACEREMIND_CELL @"MessageAttendaceRemindCell"

#import "MessageAttendaceCardCell.h"
#define MESSAGEATTENDACECARD_CELL  @"MessageAttendaceCardCell"

#import "MessageAttendaceGoOutCell.h"
#define MESSAGEATTENDACEGOOUT_CELL @"MessageAttendaceGoOutCell"
@interface MessageCentreController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *msgTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MessageCentreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavi];
    [self createTableView];
    [self addNotifition];
}
#pragma mark ----通知回调------
-(void)addChenkMessage:(NSNotification *) tifi{
    NSLog(@"---dict--%@----",tifi.userInfo);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([typeStr isEqualToString:@"3"]) {
        //补卡
        MessageAttendaceCardCell *cell = [tableView dequeueReusableCellWithIdentifier:MESSAGEATTENDACECARD_CELL forIndexPath:indexPath];
        return cell;
    }else  if ([typeStr isEqualToString:@"1"] || [typeStr isEqualToString:@"2"] ){
        MessageAttendaceGoOutCell *cell = [tableView dequeueReusableCellWithIdentifier:MESSAGEATTENDACEGOOUT_CELL forIndexPath:indexPath];
        return cell;
    }else{
        MessageAttendaceRemindCell *cell  = [tableView dequeueReusableCellWithIdentifier:MESSAGEATTENDACEREMIND_CELL forIndexPath:indexPath];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArr[indexPath.row];
    NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"type"]];
    if ([typeStr isEqualToString:@"3"]) {
         //补卡
        return 222;
    }else  if ([typeStr isEqualToString:@"1"] || [typeStr isEqualToString:@"2"] ){
        return 240;
    }else{
         return 168;
    }
}
#pragma mark ----注册通知------
-(void) addNotifition{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addChenkMessage:) name:@"ChenkMessage" object:nil];
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
}
//设置navi
-(void) createNavi{
    self.customNavBar.title = @"消息中心";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //右边
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"wcjl_ico_sx"]];
    self.customNavBar.onClickRightButton = ^{
       
    };
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
