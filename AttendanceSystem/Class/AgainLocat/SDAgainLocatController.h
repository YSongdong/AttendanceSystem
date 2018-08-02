//
//  SDAgainLocatController.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/19.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDBaseController.h"
@interface SDAgainLocatController : SDBaseController

//数据源
@property (nonatomic,strong) NSDictionary *dict;
//人脸类型
@property (nonatomic,strong) NSString *faceTypeStr;
@end
