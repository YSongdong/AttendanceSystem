//
//  ShowUnAttendaceMarkView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/9/10.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowUnAttendaceMarkView : UIView

@property (nonatomic,strong) NSDictionary *dict;

@property (nonatomic,strong) NSMutableArray *imageArr;

@property (nonatomic,strong) NSString *idStr;

//是添加备注还是查看备注  YES 查看备注  NO 添加备注
@property (nonatomic,assign) BOOL isLookMark;
//添加mark
@property (nonatomic,copy) void(^addMarkBlock)(void);
//选择相机
@property (nonatomic,copy) void(^selectPhotoBlock)(void);

//更新UI
-(void)updateUI;
@end
