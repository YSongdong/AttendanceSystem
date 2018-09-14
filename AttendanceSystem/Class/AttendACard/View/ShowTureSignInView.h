//
//  ShowTureSignInView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/21.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowTureSignInView : UIView
@property (nonatomic,strong)UIButton *cardBtn;
//是否有人脸认证
@property (nonatomic,strong) NSString *faceStatusStr;
//打卡地址
@property (nonatomic,strong) NSString *addressStr;

@property (nonatomic,strong) NSMutableArray *imageArr;
//重新验证人脸更新通过
@property (nonatomic,strong)NSString *againFaceStr;

//选择相机
@property (nonatomic,copy) void(^selectPhotoBlock)(void);

//确认打卡
@property (nonatomic,copy) void(^trueInfoBlock)(NSDictionary *dict);
//重新验证人脸
@property (nonatomic,copy) void(^againFaceBlock)(void);

//更新UI
-(void)updateUI;

-(void)updateAddress:(NSString *) addressStr andAddressStaute:(BOOL)addressStatu;

@end
