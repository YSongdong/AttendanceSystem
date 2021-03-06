//
//  SDPhotoCollectController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/12.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SDPhotoCollectController.h"

#import "PhotoCollectView.h"
#import "FVAppSdk.h"

#import "BindingPhoneController.h"
#import "AlterPassNumberController.h"

@interface SDPhotoCollectController ()
<
FVAppSdkControllerDelegate
>
@property (nonatomic,strong) PhotoCollectView *photoView;
//选择图片
@property (nonatomic,strong) UIImage * selecdImage;
//判断是否上传照片
@property (nonatomic,assign) BOOL isUpdatePhoto;
//判断是否重新上传照片
@property (nonatomic,assign) BOOL isAgainPhoto;

@property (nonatomic,assign) BOOL isCollect;
@end

@implementation SDPhotoCollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isUpdatePhoto = NO;
    self.isAgainPhoto =  NO;
    self.isCollect = NO;
    //创建UI
    [self createView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isMine) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.isMine) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
//设置navi
-(void) createNavi{
    self.customNavBar.title = @"用户留底照片采集";
    self.customNavBar.rightButton.hidden= YES;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
#pragma mark   -----创建UI-----
-(void) createView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    scrollView.backgroundColor = [UIColor colorBgGreyColor];
    [self.view addSubview:scrollView];
    
    //系统版本号
    NSString *version= [UIDevice currentDevice].systemVersion;
    NSArray *arr =[version componentsSeparatedByString:@"."];
    NSString *verStr = arr[0];
    if([verStr integerValue] >= 11.0 ) {
         self.photoView = [[PhotoCollectView alloc]initWithFrame:CGRectMake(0, -20, KScreenW, 760)];
    }else{
         self.photoView = [[PhotoCollectView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 760)];
    }
    [scrollView addSubview:self.photoView];
    
    self.photoView.chenkErrorStr = self.chenkErrorStr;
    [self.photoView upatePhotoViewStatu:_chenkStatu];
    
    scrollView.contentSize = CGSizeMake(KScreenW, 760);
    
    __weak typeof(self) weakSelf = self;
    //开始采集
    self.photoView.beginBlock = ^{
        //获取照片
        AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            [SDShowSystemPrompView showSystemPrompStr:@"您还没有开启相机权限"];
            return ;
        }
        [[FVAppSdk sharedManager]gatherWithParentController:weakSelf];
        [FVAppSdk sharedManager].fvLanderDelegate =  weakSelf;
    };
    //立即上传
    self.photoView.updateBlock = ^{
        if (!weakSelf.isUpdatePhoto) {
            if (weakSelf.isCollect) {
                 [weakSelf requestUplacUserData];
                
            }else{
                //获取照片
                AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
                {
                    [SDShowSystemPrompView showSystemPrompStr:@"您还没有开启相机权限"];
                    return ;
                }
                [[FVAppSdk sharedManager]gatherWithParentController:weakSelf];
                [FVAppSdk sharedManager].fvLanderDelegate =  weakSelf;
            }
        }else{
            
            NSString *phoneStr = [SDUserInfo obtainWithBindPhone];
            if ([phoneStr isEqualToString:@"1"]) {
                AlterPassNumberController *passVC = [[AlterPassNumberController alloc]init];
                [weakSelf.navigationController pushViewController:passVC animated:YES];
            }else{
                BindingPhoneController *bindVC = [[BindingPhoneController alloc]init];
                bindVC.isMine = NO;
                [weakSelf.navigationController pushViewController:bindVC animated:YES];
            }
        }
    };
    
    //返回按钮
    if (_isMine) {
        [self.photoView.backBtn addTarget:self action:@selector(selectBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.photoView.backBtn.hidden = YES;
    }
}
/*
 * 采集结束时的委托方法：返回结果照片。
 */
-(void)FVFaceGatherView:(FVAppSdk *)gather didGatherImage:(UIImage*)image{
    if (image) {
        [self dismissViewControllerAnimated:YES completion:nil];
       
        self.selecdImage = image;
        self.photoView.headerImageV.image = image;
        //显示立即上传按钮
        self.photoView.beginBtn.hidden = NO;
        
        self.isCollect =  YES;
        
        if ([self.chenkStatu  isEqualToString:@"2"]) {
            self.isAgainPhoto = YES;
            //未通过
            [self.photoView.updataBtn setTitle:@"立即上传" forState:UIControlStateNormal];

            [self.photoView.beginBtn setTitle:@"重新采集" forState:UIControlStateNormal];
        }else{
            [self.photoView.updataBtn setTitle:@"立即上传" forState:UIControlStateNormal];
            [self.photoView.beginBtn setTitle:@"重新采集" forState:UIControlStateNormal];
        }
        self.photoView.chenkStatuImageV.image = [UIImage imageNamed:@""];
        self.photoView.headerMarkLab.text =  @"用户留底照片采集";
        self.photoView.headerMarkLab.textColor = [UIColor colorTextBg28BlackColor];
    }
}
-(void)setIsMine:(BOOL)isMine{
    _isMine = isMine;
}
-(void)setChenkStatu:(NSString *)chenkStatu{
    _chenkStatu = chenkStatu;
}
-(void)setChenkErrorStr:(NSString *)chenkErrorStr{
    _chenkErrorStr = chenkErrorStr;
}
-(void)selectBackAction:(UIButton *) sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ----数据相关-----
-(void)requestUplacUserData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"]= [SDUserInfo obtainWithUserId];
    param[@"token"]= [SDTool getNewToken];
    NSMutableArray *imageArr = [NSMutableArray array];
    [imageArr addObject:[self.selecdImage fixOrientation]];
    [[KRMainNetTool sharedKRMainNetTool] upLoadData:HTTP_USERUPLOADPHONO_URL params:param.copy andData:imageArr.copy waitView:self.view complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        //跟新保存本地信息
        [SDUserInfo alterNumberPhoto:showdata];
        //更新状态显示信息
        [self.photoView upatePhotoViewStatu:showdata[@"photoStatus"]];
        
        self.isUpdatePhoto = YES;
        if (self.isMine) {
            //显示下一步按钮
            self.photoView.beginBtn.hidden = YES;
            //隐藏上传按钮
            self.photoView.updataBtn.hidden = YES;
        }else{
            //隐藏上传按钮
            self.photoView.beginBtn.hidden = YES;
            //显示下一步按钮
            self.photoView.updataBtn.hidden = NO;
            [self.photoView.updataBtn setTitle:@"下一步" forState:UIControlStateNormal];
            [self.photoView.updataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }];

}





@end
