//
//  SDUserLeaveTableViewCell.h
//  SDSafetyManageControl
//
//  Created by tiao on 2018/4/27.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDUserLeaveTableViewCell : UITableViewCell

//退出按钮
@property (nonatomic,copy) void(^leaveBtnBlock)(void);

@end
