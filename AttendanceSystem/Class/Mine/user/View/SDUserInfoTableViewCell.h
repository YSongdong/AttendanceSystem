//
//  SDUserInfoTableViewCell.h
//  SDSafetyManageControl
//
//  Created by tiao on 2018/4/27.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDUserInfoTableViewCell : UITableViewCell

//是否显示平台数据  YES 显示  NO 不显示
@property (nonatomic,assign) BOOL isShowPlatform;

@property (nonatomic,strong) NSDictionary *dict;

@property (nonatomic,strong) NSIndexPath *indexPath;

//点击退出按钮
@property (nonatomic,copy) void(^leaveBtnBlock)(NSIndexPath *indexPath);

//修改会员账号
-(void) alterVipNameStr:(NSString *) nameStr;


@end
