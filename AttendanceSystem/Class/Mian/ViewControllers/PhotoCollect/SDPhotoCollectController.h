//
//  SDPhotoCollectController.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/12.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDBaseController.h"
@interface SDPhotoCollectController : SDBaseController

//判断是否从个人中心跳转
@property (nonatomic,assign) BOOL isMine;
//审核状态
@property (nonatomic,strong) NSString *chenkStatu;
//审核失败原因
@property (nonatomic,strong) NSString *chenkErrorStr;

@end
