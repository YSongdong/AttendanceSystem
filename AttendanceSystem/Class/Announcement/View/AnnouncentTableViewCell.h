//
//  AnnouncentTableViewCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/8/17.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnouncentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic,strong) NSDictionary *dict ;

//计算高度
+(CGFloat) getWithCellHeight:(NSDictionary *) dict;


@end
