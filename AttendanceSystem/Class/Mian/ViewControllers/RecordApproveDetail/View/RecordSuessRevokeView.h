//
//  RecordSuessRevokeView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/9/4.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordSuessRevokeView : UIView

@property (nonatomic,strong)UIButton *revokeBtn;

//撤销
@property (nonatomic,copy) void(^suessRevokeBlock)(void);

@end
