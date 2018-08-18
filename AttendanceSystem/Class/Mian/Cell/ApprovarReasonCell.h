//
//  ApprovarReasonCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApprovarReasonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *cellTextView;
//显示原因lab'
@property (weak, nonatomic) IBOutlet UILabel *showReasonLab;
//显示提示原因
@property (weak, nonatomic) IBOutlet UILabel *showPropentReasonLab;

@property (nonatomic,copy) void(^reasonBlock)(NSString *reasonStr);

@end
