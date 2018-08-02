//
//  AlertView.h
//  YMDoctorProject
//
//  Created by Ray on 2017/1/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView


@property (nonatomic,strong)NSString *message ;


- (void)show ;

- (void)viewHidden ;

+ (AlertView *)alertViewWithSuperView:(UIView *)view
                              andData:(NSString *)message;


@end
