//
//  MessageChankPhotoStatuCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/8/23.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageChankPhotoStatuCell : UITableViewCell


//计算cell 高度
+(CGFloat) getWithCellHeight:(NSDictionary *) dict;

@property (nonatomic,strong) NSDictionary *dict ;

@end
