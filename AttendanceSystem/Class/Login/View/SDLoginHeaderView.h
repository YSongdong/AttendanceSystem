//
//  SDLoginHeaderView.h
//  SDSafetyManageControl
//
//  Created by tiao on 2018/4/25.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDLoginHeaderView : UIView

//type  account 账号登录   phone 手机登录
@property (nonatomic,copy) void(^loginTypeBlock)(NSString *type);


@end
