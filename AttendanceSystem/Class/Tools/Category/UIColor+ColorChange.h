//
//  UIColor+ColorChange.h
//  PlayDemo
//
//  Created by tiao on 2018/1/12.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

//文字白色
+ (UIColor *) colorTextWhiteColor;
//线条颜色
+ (UIColor*) lineBackGrounpColor;
//view背景色
+ (UIColor *)viewBackGrounpColor;
//背景灰色
+ (UIColor *) colorBgGreyColor;
//文字黑色2828
+ (UIColor *) colorTextBg28BlackColor;
//文字黑色9898
+ (UIColor *) colorTextBg98BlackColor;
//文字黑色6565
+ (UIColor *) colorTextBg65BlackColor;

//常用绿色
+ (UIColor *) colorCommonGreenColor;
//常用线条灰色
+ (UIColor *) colorLineGreyColor;
//常用背景灰
+ (UIColor *) colorCommonf2GreyColor;

+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat) alpha;
@end
