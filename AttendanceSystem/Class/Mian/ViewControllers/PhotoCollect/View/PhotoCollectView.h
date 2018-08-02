//
//  PhotoCollectView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/12.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectView : UIView

//返回按钮
@property (nonatomic,strong)  UIButton *backBtn;
//头像说明
@property (nonatomic,strong) UILabel *headerMarkLab;
//用户头像
@property (nonatomic,strong) UIImageView *headerImageV;
//审核状态
@property (nonatomic,strong) UIImageView *chenkStatuImageV;
//失败原因
@property (nonatomic,strong) UILabel *errorLab;

//开始采集
@property (nonatomic,strong) UIButton *beginBtn;
//上传
@property (nonatomic,strong) UIButton *updataBtn;

//开始采集
@property (nonatomic,copy) void(^beginBlock)(void);
//立即上传
@property (nonatomic,copy) void(^updateBlock)(void);

//0: 未上传 1:未审核 2:未通过 3:已审核'
- (void)upatePhotoViewStatu:(NSString *)statu;


@end
