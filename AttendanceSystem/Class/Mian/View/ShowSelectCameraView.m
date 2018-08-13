//
//  ShowSelectCameraView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowSelectCameraView.h"

#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>


@implementation ShowSelectCameraView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    __weak typeof(self) weakSelf = self;
    
    UIView *bigBgView = [[UIView alloc]init];
    [self addSubview:bigBgView];
    bigBgView.backgroundColor = [UIColor blackColor];
    bigBgView.alpha = 0.35;
    [bigBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [bigBgView addGestureRecognizer:tap];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(weakSelf);
        make.height.equalTo(@143);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorTextBg28BlackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Font(18);
    cancelBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bgView);
        make.height.equalTo(@44);
    }];
    [cancelBtn addTarget:self action:@selector(selectCancelActtion:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:photoBtn];
    [photoBtn setTitle:@"从相册中选择" forState:UIControlStateNormal];
    [photoBtn setTitleColor:[UIColor colorTextBg28BlackColor] forState:UIControlStateNormal];
    photoBtn.titleLabel.font = Font(18);
    photoBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.width.height.equalTo(cancelBtn);
        make.centerX.equalTo(cancelBtn.mas_centerX);
    }];
    [photoBtn addTarget:self action:@selector(selectPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:cameraBtn];
    [cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [cameraBtn setTitleColor:[UIColor colorTextBg28BlackColor] forState:UIControlStateNormal];
    cameraBtn.titleLabel.font = Font(18);
    cameraBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoBtn.mas_bottom).offset(1);
        make.width.height.equalTo(cancelBtn);
        make.centerX.equalTo(cancelBtn.mas_centerX);
    }];
    [cameraBtn addTarget:self action:@selector(selectCameraAction:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)selectTap{
    [self removeFromSuperview];
}

-(void)selectCancelActtion:(UIButton *) sender{
    [self removeFromSuperview];
}
-(void)selectCameraAction:(UIButton *) sender{
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        [SDShowSystemPrompView showSystemPrompStr:@"您还没有开启相机权限"];
        return ;
    }
    self.cameraBlock();
}
-(void)selectPhotoAction:(UIButton *) sender{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        [SDShowSystemPrompView showSystemPrompStr:@"您还没有开启相册权限"];
        return ;
    }
    self.photoBlock();
}


@end
