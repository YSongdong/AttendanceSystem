//
//  SDLeaveBtnShowView.h
//  SDSafetyManageControl
//
//  Created by tiao on 2018/5/2.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDLeaveBtnShowView : UIView

//确定按钮
@property(nonatomic,copy)void(^trueBtnBlock)(void);

//关闭显示view
-(void) closeShowView;
//提示内容
@property (nonatomic,strong)  UILabel *titleLab;

@end
