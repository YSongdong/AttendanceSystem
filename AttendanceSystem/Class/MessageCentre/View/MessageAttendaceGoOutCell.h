//
//  MessageAttendaceGoOutCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/8/9.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageAttendaceGoOutCell : UITableViewCell

//计算cell 高度
+(CGFloat) getWithCellHeight:(NSDictionary *) dict;

@property (nonatomic,strong) NSDictionary *dict ;



@end
