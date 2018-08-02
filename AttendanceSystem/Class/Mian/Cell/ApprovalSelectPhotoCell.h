//
//  ApprovalSelectPhotoCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApprovalSelectPhotoCell : UITableViewCell
//图片数组
@property (nonatomic,strong) NSMutableArray *imageArr;

//选择相机
@property (nonatomic,copy) void(^selectPhotoBlock)(void);

//更新UI
-(void)updateUI;
@end
