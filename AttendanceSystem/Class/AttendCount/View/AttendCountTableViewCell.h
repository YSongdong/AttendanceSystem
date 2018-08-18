//
//  AttendCountTableViewCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/8/17.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendCountTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showTimeLab;

@property (nonatomic,strong)NSDictionary *dict;

@end
