//
//  SDLoginController.h
//  SDSafetyManageControl
//
//  Created by tiao on 2018/4/11.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDBaseController.h"
@interface SDLoginController : SDBaseController

@property (nonatomic,copy) void(^loginDataBlock)(NSDictionary *dict);

//是否回来首页  YES 是  NO 否
@property (nonatomic,assign) BOOL isBackHome;

@end
