//
//  SDAttendPunchCardController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/18.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SDAttendPunchCardController.h"

#import "SDPhotoCollectController.h"
#import "SDAgainLocatController.h"
#import "FVAppSdk.h"
#import "RecordApproveDetaController.h"
#import "SupplementCardController.h"


#import "DateTimePickerView.h"
#import "ShowTwoTimeDifferBigView.h"
#import "ShowTureSignInView.h"
#import "ShowMarkView.h"
#import "ShowLocatErrorView.h"

#import "AttendCardHeaderView.h"
#import "ShowLocatPromentView.h"
#import "ShowUnkownPhotoPromtView.h"
#import "SDIdentityTestView.h"

#import "AttendCardTableViewCell.h"
#define ATTENDCARDTABLEVIEW_CELL  @"AttendCardTableViewCell"

#import "ShowPunchCardCell.h"
#define SHOWPUNCHCARD_CELL @"ShowPunchCardCell"

#import "ShowUnPunchCardCell.h"
#define SHOWNNPUNCHCARD_CELL @"ShowUnPunchCardCell"

#import "AttendFutureTimeCell.h"
#define ATTENDFUTURETIME_CELL @"AttendFutureTimeCell"

#define HEAHERVIEWHEIGHT  67
@interface SDAttendPunchCardController ()
<
UITableViewDelegate,
UITableViewDataSource,
DateTimePickerViewDelegate,
FVAppSdkControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
AMapLocationManagerDelegate
>

//定位管理器
@property (nonatomic,strong)AMapLocationManager *locationManager;
//头部视图
@property (nonatomic,strong) AttendCardHeaderView *headerView;

@property (nonatomic,strong) UITableView *cardTableView;
//时间选择器
@property (nonatomic, strong) DateTimePickerView *datePickerView;
//提示权限view
@property (nonatomic,strong) ShowLocatPromentView *showLocatView;
//没有留底照片
@property (nonatomic,strong) ShowUnkownPhotoPromtView *showPhotoView;
//定位失败view
@property (nonatomic,strong)ShowLocatErrorView *showLocatErrorView;
//验证view
@property (nonatomic,strong) SDIdentityTestView *testView;
//相差时间大view
@property (nonatomic,strong)ShowTwoTimeDifferBigView *showTimeBigView;
//打卡确认view
@property (nonatomic,strong)ShowTureSignInView *showTureSingInView;
//备注view
@property (nonatomic,strong) ShowMarkView *showMarkView;
//数据源字典
@property (nonatomic,strong) NSDictionary *dataDict;
//打卡次数
@property (nonatomic,strong) NSMutableArray *cardArr;
//图片
@property (nonatomic,strong) UIImage *faceImage;
//记录定位地址
@property (nonatomic,strong)AMapLocationReGeocode *reGeocode;

//记录选择日期
@property (nonatomic,strong) NSString *selectCalendarStr;
//---------------打卡请求数据---------//
@property (nonatomic,strong) NSMutableDictionary *cardDataDict;
//确认信息重新验证人脸
@property (nonatomic,assign) BOOL isTureAgainFace;
//记录要打卡的indexPath
@property (nonatomic,strong) NSIndexPath *attendCardIndexPath;

@end

@implementation SDAttendPunchCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    [self createNavi];
    [self createPromentView];
    self.isTureAgainFace = NO;
    self.selectCalendarStr = @"";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启定位
    [self mobilePhonePositioning];
    //请求当天的日期
    NSString *dateStr = [[self requestDateFormatter]stringFromDate:[NSDate date]];
    self.selectCalendarStr = dateStr;
    [self requestAttendInfo:self.selectCalendarStr];
}
//设置navi
-(void) createNavi{
    self.customNavBar.title = @"考勤打卡";
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark -----
-(void) createTableView{
    //加载headerView
    [self.view addSubview:self.headerView];
    [self.headerView.selectBtn addTarget:self action:@selector(selectTimeAction:) forControlEvents:UIControlEventTouchUpInside];
   
    self.cardTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame)+20, KScreenW, KScreenH-CGRectGetHeight(self.headerView.frame)-KSNaviTopHeight-20-KSTabbarH)];
    [self.view addSubview:self.cardTableView];
    
    self.cardTableView.delegate = self;
    self.cardTableView.dataSource = self;
    self.cardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cardTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.cardTableView registerClass:[AttendCardTableViewCell class] forCellReuseIdentifier:ATTENDCARDTABLEVIEW_CELL];
    [self.cardTableView registerClass:[ShowPunchCardCell class] forCellReuseIdentifier:SHOWPUNCHCARD_CELL];
    [self.cardTableView registerClass:[ShowUnPunchCardCell class] forCellReuseIdentifier:SHOWNNPUNCHCARD_CELL];
    [self.cardTableView registerClass:[AttendFutureTimeCell class] forCellReuseIdentifier:ATTENDFUTURETIME_CELL];
    if (@available(iOS 11.0, *)) {
        self.cardTableView.estimatedRowHeight = 0;
        self.cardTableView.estimatedSectionFooterHeight = 0;
        self.cardTableView.estimatedSectionHeaderHeight = 0 ;
        self.cardTableView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //相差时间大view
    self.showTimeBigView = [[ShowTwoTimeDifferBigView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, CGRectGetHeight(self.cardTableView.frame))];
    [self.cardTableView addSubview:self.showTimeBigView];
    self.showTimeBigView.hidden = YES;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cardArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *nowStr =[NSString stringWithFormat:@"%@",self.dataDict[@"now"]];
    NSDictionary *dict =  self.cardArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if ([nowStr isEqualToString:@"3"]) {
        //未来时间
        if (indexPath.row == 0) {
            AttendFutureTimeCell *cell =[tableView dequeueReusableCellWithIdentifier:ATTENDFUTURETIME_CELL forIndexPath:indexPath];
            cell.dict = dict;
            return cell;
        }else{
            //还未到打卡时间
            ShowUnPunchCardCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOWNNPUNCHCARD_CELL forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dict = dict;
            return cell;
        }
    }else if ([nowStr isEqualToString:@"2"]){
        //过去
        //有考勤记录
        ShowPunchCardCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOWPUNCHCARD_CELL forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dict = dict;
        //备注
        cell.markBlock = ^{
            __weak typeof(weakSelf) stongSelf = weakSelf;
            [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showMarkView];
            weakSelf.showMarkView.dict = dict;
            weakSelf.showMarkView.addMarkBlock = ^(NSString *markStr) {
                NSMutableDictionary *mutableDict =  [NSMutableDictionary dictionaryWithDictionary:dict];
                mutableDict[@"remark"]= markStr;
                //贴换元素
                [stongSelf.cardArr replaceObjectAtIndex:indexPath.row withObject:mutableDict.copy];
                [stongSelf.cardTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
            };
        };
        //请假
        cell.askForLeaveBlock = ^{
            RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
            //请假
            detaVC.detaType = RecordApproveLeaveDetaType;
            detaVC.typeStr = @"1";
            NSString *leaveInStr = [NSString stringWithFormat:@"%@",dict[@"leaveIn"]];
            if ([leaveInStr isEqualToString:@"2"]) {
                detaVC.recordIdStr = dict[@"leaveInId"];
            }
            detaVC.titleStr = [NSString stringWithFormat:@"%@请假申请",[SDUserInfo obtainWithRealName]];
            //其他
            detaVC.chenkStatusStr = @"2";
            [weakSelf.navigationController pushViewController:detaVC animated:YES];
        };
        //外勤补卡通过
        cell.leaveInBuCardSucceBlock = ^{
            RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
            //补卡
            detaVC.detaType = recordApproveCardDetaType;
            detaVC.typeStr = @"3";
            if ([dict[@"no"] isEqualToString:@"3"]) {
                detaVC.recordIdStr = dict[@"noId"];
            }
            detaVC.titleStr = [NSString stringWithFormat:@"%@补卡申请",[SDUserInfo obtainWithRealName]];
            //其他
            detaVC.chenkStatusStr = @"2";
            [weakSelf.navigationController pushViewController:detaVC animated:YES];
        };
        //外勤通过
        cell.leaveInWorkSuccesBlock = ^{
            RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
            //外出
            detaVC.detaType = RecordApproveGoOutDetaType;
            detaVC.typeStr = @"2";
            if ([dict[@"isGo"] isEqualToString:@"2"]) {
                detaVC.recordIdStr = dict[@"outgoRecordId"];
            }
            detaVC.titleStr = [NSString stringWithFormat:@"%@外勤申请",[SDUserInfo obtainWithRealName]];
            //其他
            detaVC.chenkStatusStr = @"2";
            [weakSelf.navigationController pushViewController:detaVC animated:YES];
        };
        //申请补卡
        cell.timeUnusualUFaceBuCardBlock = ^{
            NSString *recordIdStr =dict[@"Id"];
            SupplementCardController *supplementVC = [[SupplementCardController alloc]init];
            supplementVC.recordIdStr =recordIdStr;
            [weakSelf.navigationController pushViewController:supplementVC animated:YES];
        };
        return cell;
        
    }else{
       
        //判断显示样式(1'上班打卡',2'还未到打卡时间',3有打卡记录)
        NSString *titleStr = [NSString stringWithFormat:@"%@",dict[@"title"]];
        if ([titleStr isEqualToString:@"1"]) {
            //记录要打卡的IndexPath
            self.attendCardIndexPath = indexPath;
            
            AttendCardTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ATTENDCARDTABLEVIEW_CELL forIndexPath:indexPath];
            [cell.contentView removeFromSuperview];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dataDict = self.dataDict;
            cell.dict = dict;
            
            //重新定位
            cell.againLocationBlcok = ^(NSDictionary *dict) {
                SDAgainLocatController *againVC = [[SDAgainLocatController alloc]init];
                againVC.dict = dict;
                againVC.faceTypeStr = [NSString stringWithFormat:@"%@",self.dataDict[@"faceType"]];
                [weakSelf.navigationController pushViewController:againVC animated:YES];
            };
            //打卡
            cell.selectCardBlcok = ^(NSDictionary *addressDict) {
                
                //判断是否开启人脸识别
                if ([dict[@"faceStatus"] isEqualToString:@"1"]) {
                    //判断是否有留底
                    if ([[SDUserInfo obtainWithPotoStatus] isEqualToString:@"4"]) {
                        [weakSelf.view addSubview:weakSelf.showPhotoView];
                        [weakSelf.showPhotoView.selectBtn addTarget:weakSelf action:@selector(selectUPdataPhoto:) forControlEvents:UIControlEventTouchUpInside];
                        return ;
                    }
                }
                weakSelf.cardDataDict = [NSMutableDictionary dictionary];
                weakSelf.cardDataDict[@"abnormalCoordinateIs"] = [NSNumber numberWithInteger:[addressDict[@"abnormalCoordinateIs"] integerValue]];
                weakSelf.cardDataDict[@"coordinate"] = [SDTool convertToJsonData:addressDict];
                weakSelf.cardDataDict[@"coordinateSure"] = [SDTool convertToJsonData:dict[@"coordinate"]];
                weakSelf.cardDataDict[@"agId"] =[SDUserInfo obtainWithProGroupId];
                weakSelf.cardDataDict[@"agName"] =[SDUserInfo obtainWithProGroupName];
                weakSelf.cardDataDict[@"plaformId"] =[SDUserInfo obtainWithPlafrmId];
                weakSelf.cardDataDict[@"unitId"] =[SDUserInfo obtainWithUniId];
                weakSelf.cardDataDict[@"userId"] =[SDUserInfo obtainWithUserId];
                weakSelf.cardDataDict[@"clockinNum"] =dict[@"clockinNum"];
                weakSelf.cardDataDict[@"clockinType"] =dict[@"clockinType"];
                weakSelf.cardDataDict[@"isGo"] =dict[@"isGo"];
                weakSelf.cardDataDict[@"remark"] =@"";
                weakSelf.cardDataDict[@"sureTime"] =dict[@"sureTime"];
                weakSelf.cardDataDict[@"token"] =[SDTool getNewToken];
                //判断是否开启人脸 和地址
                NSString *abnormalCoordinateIsStr = addressDict[@"abnormalCoordinateIs"];
                if ([dict[@"faceStatus"] isEqualToString:@"1"]) {
                    //开启
                    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.testView];
                    [weakSelf.testView.beginTestBtn addTarget:weakSelf action:@selector(selectFaceAction:) forControlEvents:UIControlEventTouchUpInside];
                
                }else{
                    if (![dict[@"abnormalCoordinateIs"] isEqualToString:@"1"] ||[abnormalCoordinateIsStr isEqualToString:@"2"] ) {
                        weakSelf.cardDataDict[@"abnormalIdentityIs"] =[NSNumber numberWithInteger:3];
                        [weakSelf showTureSingView:nil];
                        return ;
                    }
                    //请求数据
                    [weakSelf requsetAttendSignIn];
                }
            };
            //更新地址
            cell.addressBlock = ^(NSString *addreeStr) {
                weakSelf.showTureSingInView.addressStr = addreeStr;
            };
            return cell;
        }else if ([titleStr isEqualToString:@"3"]){
            //有考勤记录
            ShowPunchCardCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOWPUNCHCARD_CELL forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dict = dict;
            //备注
            cell.markBlock = ^{
                __weak typeof(weakSelf) stongSelf = weakSelf;
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showMarkView];
                weakSelf.showMarkView.dict = dict;
                weakSelf.showMarkView.addMarkBlock = ^(NSString *markStr) {
                    NSMutableDictionary *mutableDict =  [NSMutableDictionary dictionaryWithDictionary:dict];
                    mutableDict[@"remark"]= markStr;
                    //贴换元素
                    [stongSelf.cardArr replaceObjectAtIndex:indexPath.row withObject:mutableDict.copy];
                    [stongSelf.cardTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationLeft];
                };
            };
            //请假
            cell.askForLeaveBlock = ^{
                RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
                //请假
                detaVC.detaType = RecordApproveLeaveDetaType;
                detaVC.typeStr = @"1";
                NSString *leaveInStr = [NSString stringWithFormat:@"%@",dict[@"leaveIn"]];
                if ([leaveInStr isEqualToString:@"2"]) {
                    detaVC.recordIdStr = dict[@"leaveInId"];
                }
                detaVC.titleStr = [NSString stringWithFormat:@"%@请假申请",[SDUserInfo obtainWithRealName]];
                //其他
                detaVC.chenkStatusStr = @"2";
                [weakSelf.navigationController pushViewController:detaVC animated:YES];
            };
            //外勤补卡通过
            cell.leaveInBuCardSucceBlock = ^{
                RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
                //补卡
                detaVC.detaType = recordApproveCardDetaType;
                detaVC.typeStr = @"3";
                if ([dict[@"no"] isEqualToString:@"3"]) {
                    detaVC.recordIdStr = dict[@"noId"];
                }
                detaVC.titleStr = [NSString stringWithFormat:@"%@补卡申请",[SDUserInfo obtainWithRealName]];
                //其他
                detaVC.chenkStatusStr = @"2";
                [weakSelf.navigationController pushViewController:detaVC animated:YES];
            };
            //外勤通过
            cell.leaveInWorkSuccesBlock = ^{
                RecordApproveDetaController *detaVC = [[RecordApproveDetaController alloc]init];
                //外出
                detaVC.detaType = RecordApproveGoOutDetaType;
                detaVC.typeStr = @"2";
                if ([dict[@"isGo"] isEqualToString:@"2"]) {
                    detaVC.recordIdStr = dict[@"outgoRecordId"];
                }
                detaVC.titleStr = [NSString stringWithFormat:@"%@外勤申请",[SDUserInfo obtainWithRealName]];
                //其他
                detaVC.chenkStatusStr = @"2";
                [weakSelf.navigationController pushViewController:detaVC animated:YES];
            };
            //申请补卡
            cell.timeUnusualUFaceBuCardBlock = ^{
                NSString *recordIdStr =dict[@"Id"];
                SupplementCardController *supplementVC = [[SupplementCardController alloc]init];
                supplementVC.recordIdStr =recordIdStr;
                [weakSelf.navigationController pushViewController:supplementVC animated:YES];
            };
            return cell;
        }else {
            //还未到打卡时间
            ShowUnPunchCardCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOWNNPUNCHCARD_CELL forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dict = dict;
            return cell;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *nowStr =[NSString stringWithFormat:@"%@",self.dataDict[@"now"]];
    //1 今天 2 过去 3未来
   if ([nowStr isEqualToString:@"3"]) {
       if (indexPath.row == 0) {
          return 230;
       }else{
           return 44;
       }
    }else{
        NSDictionary *dict =  self.cardArr[indexPath.row];
        //判断显示样式(1'上班打卡',2'还未到打卡时间',3有打卡记录)
        NSString *titleStr = [NSString stringWithFormat:@"%@",dict[@"title"]];
        if ([titleStr isEqualToString:@"1"]) {
            return 230;
        }else  if ([titleStr isEqualToString:@"3"])  {
            return 160;
        }else{
            return 44;
        }
    }
}
#pragma mark ---提示-----
-(void) createPromentView{
    //判断有没有开启定位权限
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self.view addSubview:self.showLocatView];
        return ;
    }

    [self createTableView];
}
-(void)selectUPdataPhoto:(UIButton *)sender{
    //用户头像
    SDPhotoCollectController *photoVC = [[SDPhotoCollectController alloc]init];
    photoVC.chenkStatu = [SDUserInfo obtainWithPotoStatus];
    photoVC.isMine = YES;
    [self.navigationController pushViewController:photoVC animated:YES];
}
#pragma mark ----按钮点击事件------
-(void)selectFaceAction:(UIButton *) sender{
    //移除人脸提示view
    [self.testView removeFromSuperview];
    NSString *faceTypeStr = [NSString stringWithFormat:@"%@",self.dataDict[@"faceType"]];
    if ([faceTypeStr isEqualToString:@"2"]) {
        //隐藏textview
        [self.testView removeFromSuperview];
        //获取照片
        [[FVAppSdk sharedManager]gatherWithParentController:self];
        [FVAppSdk sharedManager].fvLanderDelegate =  self;
    }else{
        //眨眼
         [[FVAppSdk sharedManager]livingWithParentController:self mode:FVAppLivingFastMode level:FVAppLivingSafeMiddleMode];
        [FVAppSdk sharedManager].fvLanderDelegate =  self;
    }//确认信息重新验证
    if (self.isTureAgainFace) {
        self.showTureSingInView.hidden= NO;
    }
}
#pragma mark -----人脸-----
/*
 * 活体结束时的委托方法：返回结果及正脸照。
 */
-(void)FVLivingDetect:(FVAppSdk *)detector didFinishLiving:(FVAppLivingResult)result FrontalFace:(UIImage*)image{
    if (image) {
        [self dismissViewControllerAnimated:YES completion:nil];
        //显示验证view
        self.faceImage = image;
        [self  requestFacePhotoLoad];
    }
}
/*
 * 活体取消时的委托方法。
 */
-(void)FVLivingDetectDidCancel:(FVAppSdk*)detector{
    
    //确认信息重新验证
    if (self.isTureAgainFace) {
        self.showTureSingInView.hidden= NO;
    }
}
/*
 * 采集结束时的委托方法：返回结果照片。
 */
-(void)FVFaceGatherView:(FVAppSdk *)gather didGatherImage:(UIImage*)image{
    if (image) {
        [self dismissViewControllerAnimated:YES completion:nil];
        self.faceImage = image;
        [self  requestFacePhotoLoad];
    }
}
/*
 * 采集取消时的委托方法。
 */
-(void)FVFaceGatherViewDidCancel:(FVAppSdk*)gather{
    //确认信息重新验证
    if (self.isTureAgainFace) {
        self.showTureSingInView.hidden= NO;
    }
}
#pragma mark -----拍照照片处理----
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //显示
    _showTureSingInView.hidden = NO;
    [self.showTureSingInView.imageArr insertObject:image atIndex:0];
    //更新UI
    [self.showTureSingInView updateUI];
    return;
}
//相机或相册的取消代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //显示确认信息view
    self.showTureSingInView.hidden = NO;
}
#pragma mark --------定位相关---------
// 手机定位你当前的位置，并获得你位置的信息
- (void)mobilePhonePositioning{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    //置定位最小更新距离
    self.locationManager.distanceFilter= 10.f;
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //设置定位超时时间
    [self.locationManager setLocationTimeout:5];
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:5];
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //    //设置允许在后台定位
    //    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    //返回逆地理编码信息
    [self.locationManager setLocatingWithReGeocode:YES];
    //开始持续定位
    [self.locationManager startUpdatingLocation];
}
#pragma mark ---定位Delegte----
//返回地理位置
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    if (reGeocode)
    {
        //记录定位地址
        self.reGeocode = reGeocode;
        
        NSString *nowStr =[NSString stringWithFormat:@"%@",self.dataDict[@"now"]];
        if ([nowStr isEqualToString:@"1"]) {
            if (self.cardArr.count > 0) {
                NSDictionary *dict = self.cardArr[self.attendCardIndexPath.row];
                NSString *titleStr = [NSString stringWithFormat:@"%@",dict[@"title"]];
                //1 打卡 2还未到打卡时间 3已过打卡时间
                if ([titleStr isEqualToString:@"1"]) {
                    AttendCardTableViewCell  *cell =[self.cardTableView cellForRowAtIndexPath:self.attendCardIndexPath];
                    //更新UI显示状态
                    [cell updateAddress:reGeocode.formattedAddress location:location];
                }
            }
           
        }
    }
}
//定位失败时
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [self.view addSubview:self.showLocatErrorView];
}
#pragma mark ---时间选择器-----
-(void)selectTimeAction:(UIButton *) sender{
    [self.view addSubview:self.datePickerView];
    [self.datePickerView showDateTimePickerView];
}
#pragma mark - delegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    [self.headerView.selectBtn setTitle:date forState:UIControlStateNormal];
     self.selectCalendarStr = date;
    //请求数据
    [self requestAttendInfo:date];
}
//打卡确认信息
-(void)showTureSingView:(NSString*)faceStatusStr{
     __weak typeof(self) weakSelf = self;
    weakSelf.showTureSingInView = [[ShowTureSignInView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.showTureSingInView];
    if (self.reGeocode != nil) {
        weakSelf.showTureSingInView.addressStr = self.reGeocode.formattedAddress;
    }
    weakSelf.showTureSingInView.faceStatusStr = faceStatusStr;
    weakSelf.showTureSingInView.selectPhotoBlock = ^{
        //隐藏
        weakSelf.showTureSingInView.hidden = YES;
        
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = weakSelf;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设定图像缩放比例
        picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, 1.0, 1.0);
        
        //打开摄像画面作为背景
        [weakSelf presentViewController:picker animated:YES completion:nil];
    };
    
    //确认打卡
    weakSelf.showTureSingInView.trueInfoBlock = ^(NSDictionary *dict) {
        weakSelf.cardDataDict[@"abnormalIdentityIs"] =dict[@"abnormalIdentityIs"];
        weakSelf.cardDataDict[@"remark"] =dict[@"remark"];
        //请求数据
        [weakSelf requsetAttendSignIn];
    };
    
    //重新验证人脸
    weakSelf.showTureSingInView.againFaceBlock = ^{
        //重新验证
        weakSelf.isTureAgainFace = YES;
        //隐藏
        weakSelf.showTureSingInView.hidden = YES;
        
        [weakSelf selectFaceAction:nil];
    };
}

#pragma mark ---懒加载-----
-(AttendCardHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[AttendCardHeaderView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, HEAHERVIEWHEIGHT)];
    }
    return _headerView;
}
-(DateTimePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView =[[DateTimePickerView alloc] init];
        _datePickerView.delegate = self;
        _datePickerView.pickerViewMode = DatePickerViewDateMode;
    }
    return _datePickerView;
}
-(ShowLocatPromentView *)showLocatView{
    if (!_showLocatView) {
        _showLocatView  = [[ShowLocatPromentView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showLocatView;
}
-(ShowUnkownPhotoPromtView *)showPhotoView{
    if (!_showPhotoView) {
        _showPhotoView = [[ShowUnkownPhotoPromtView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showPhotoView;
}
-(ShowLocatErrorView *)showLocatErrorView{
    if (!_showLocatErrorView) {
        _showLocatErrorView = [[ShowLocatErrorView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showLocatErrorView;
}
-(SDIdentityTestView *)testView{
    if (!_testView) {
        _testView = [[SDIdentityTestView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _testView;
}
-(ShowMarkView *)showMarkView{
    if (!_showMarkView) {
        _showMarkView = [[ ShowMarkView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    }
    return _showMarkView;
}

- (NSDateFormatter *)requestDateFormatter{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"YYYY.MM.dd";
    }
    return dateFormatter;
}
-(NSDictionary *)dataDict{
    if (!_dataDict) {
        _dataDict  = [NSDictionary dictionary];
    }
    return _dataDict;
}
-(NSMutableArray *)cardArr{
    if (!_cardArr) {
        _cardArr = [NSMutableArray array];
    }
    return _cardArr;
}
-(void)dealloc{
    //销毁时钟
    for (int i=0; i<self.cardArr.count; i++) {
        NSDictionary *dict =  self.cardArr[i];
        NSString *titleStr = [NSString stringWithFormat:@"%@",dict[@"title"]];
        if ([titleStr isEqualToString:@"1"]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            AttendCardTableViewCell  *cell = [self.cardTableView cellForRowAtIndexPath:indexPath];
            [cell.timer invalidate];
            cell.timer = nil;
        }
    }
}
#pragma mark ----数据相关------
-(void) requestAttendInfo:(NSString *) dateStr{
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    param[@"date"] = dateStr;
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"token"] = [SDTool getNewToken];
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_APPUSERDAYSATTENDACEGROUINFO_URL params:param.copy withModel:nil waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            //移除数据源
            self.dataDict = nil;
            [self.cardArr removeAllObjects];
            
            self.dataDict = showdata;
            //计算当前时间戳
            NSString *startStr =[SDTool dateTime:[showdata[@"time"]doubleValue]];
            NSString *endStr =[SDTool dateNowTime];
            NSTimeInterval value = [startStr doubleValue] - [endStr doubleValue];
            int minute = (int)value /60;
            if (minute > 5) {
                self.showTimeBigView.standTime = [showdata[@"time"] doubleValue];
                self.showTimeBigView.hidden = NO;
                return;
            }
            //隐藏时间相差大view
            self.showTimeBigView.hidden = YES;
            
           // 1 有考勤记录
           self.cardArr = [NSMutableArray arrayWithArray:showdata[@"data"]];
           [self.cardTableView reloadData];
        }
    }];
}
//图片对比接口
-(void)requestFacePhotoLoad{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    param[@"userName"] = [SDUserInfo obtainWithidcard];
    param[@"userIdcard"] = [SDUserInfo obtainWithUserName];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    param[@"unitId"] = [SDUserInfo obtainWithUniId];
    param[@"truename"] =[SDUserInfo obtainWithRealName];
    param[@"token"] =[SDTool getNewToken];
    param[@"platformId"] = [SDUserInfo obtainWithPlafrmId];
    param[@"photoStatus"] = [SDUserInfo obtainWithPotoStatus];
    param[@"photo"] = [SDUserInfo obtainWithPhoto];
    param[@"agName"] = [SDUserInfo obtainWithPositionName];
    param[@"agId"] = [SDUserInfo obtainWithProGroupId];
    NSMutableArray *dataArr= [NSMutableArray array];
    //图片旋转90度
    [dataArr addObject:[self.faceImage fixOrientation]];
 
    [[KRMainNetTool sharedKRMainNetTool] upLoadData:HTTP_APPATTENDFACERECOGNITION_URL params:param.copy andData:dataArr.copy waitView:self.view complateHandle:^(id showdata, NSString *error) {
     
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        if ([showdata isKindOfClass:[NSDictionary class]]) {
            NSString *succStr = [NSString stringWithFormat:@"%@",showdata[@"succ"]];
           
            // 1人脸验证通过 0未通过
            if ([succStr isEqualToString:@"1"]) {
                //确认信息重新验证
                if (self.isTureAgainFace) {
                    self.showTureSingInView.againFaceStr = succStr;
                }else{
                    self.cardDataDict[@"abnormalIdentityIs"] = [NSNumber numberWithInteger:1];
                    self.cardDataDict[@"vioLationId"] = showdata[@"id"];
                    //请求数据
                    [self requsetAttendSignIn];
                }
            }else{
                //确认信息重新验证
                if (!self.isTureAgainFace) {
                    self.cardDataDict[@"abnormalIdentityIs"] = [NSNumber numberWithInteger:1];
                    self.cardDataDict[@"vioLationId"] = showdata[@"id"];
                    [self showTureSingView:@"2"];
                }else{
                    self.showTureSingInView.faceStatusStr = @"2";
                }
            }
        }
    }];
}
//打卡
-(void) requsetAttendSignIn{
    //照片数据源
    NSMutableArray *imageArr = self.showTureSingInView.imageArr;
    //移除最后一个
    [imageArr removeLastObject];

    [[KRMainNetTool sharedKRMainNetTool]upLoadData:HTTP_APPATTENDANCEAPPDOSIGNIN_URL params:self.cardDataDict.copy andData:imageArr.copy waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        [SDShowSystemPrompView showSystemPrompStr:@"打卡成功"];
        
        [self.showTureSingInView removeFromSuperview];
        //请求数据
        [self requestAttendInfo:self.selectCalendarStr];
    }];
   
}




@end
