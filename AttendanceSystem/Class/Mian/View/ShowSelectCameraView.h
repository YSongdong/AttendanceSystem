//
//  ShowSelectCameraView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowSelectCameraView : UIView

@property (nonatomic,copy) void(^cameraBlock)(void);

@property (nonatomic,copy) void(^photoBlock)(void);


@end
