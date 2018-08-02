//
//  RecordMapSelectViewController.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDBaseController.h"



// 代理传值方法
@protocol RecordMapSelectViewControllerDelegate <NSObject>

- (void)selectAddressDict:(NSDictionary *)dict;
@end

@interface RecordMapSelectViewController : SDBaseController



@property (nonatomic,weak) id <RecordMapSelectViewControllerDelegate> delegate;


@end
