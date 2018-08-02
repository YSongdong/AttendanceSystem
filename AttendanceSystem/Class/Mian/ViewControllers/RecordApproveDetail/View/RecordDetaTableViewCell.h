//
//  RecordDetaTableViewCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetaTableViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dict;

//计算高度
+(CGFloat) getWithTextCellHeight:(NSDictionary *)dict;

@end
