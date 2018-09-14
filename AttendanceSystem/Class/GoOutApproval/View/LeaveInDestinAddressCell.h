//
//  LeaveInDestinAddressCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveInDestinAddressCell : UITableViewCell

//显示选择好地址
@property (weak, nonatomic) IBOutlet UIButton *showAddressBtn;
//显示地址
@property (weak, nonatomic) IBOutlet UILabel *showAddressLab;
//重新选择地址
@property (weak, nonatomic) IBOutlet UIButton *againSelectAddressBtn;
//点击选择地点
@property (weak, nonatomic) IBOutlet UIButton *selectSettingAddressBtn;
//设置打卡半径
@property (weak, nonatomic) IBOutlet UILabel *showAttandRadiusLab;


//选择地点
@property (nonatomic,copy) void(^selectAddressBlock)(void);
//添加地点更新UI
-(void) addAddressUpdateUI:(NSString *)addressStr;


@end
