//
//  SDTool.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/14.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDTool : NSObject

//touken和userid 返回新touken
+(NSString *)getNewToken;

//获取当前系统时间的时间戳
+(NSInteger)getNowTimestamp;

//将某个时间戳转化成 时间
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

//将某个时间转化成 时间戳
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font;
//返回计算的文本占用位置的大小（含宽，高）
+(CGSize)calStrWith:(NSString*)text andFontSize:(CGFloat)fontsize;

//时间戳转换为时间
+(NSString *)dateTime:(double)timeStam;

//NSDate转换成时间戳
+(NSString *)dateNowTime;

//IOS算两个时间差
+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

//计算两个时间的时长 (小时)
+ (CGFloat)calculateWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

// 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict;
//输入位置和服务器返回位置做对比    返回一个对比的数组
+(NSArray *) getData:(NSDictionary *)Datadict Locat:(CLLocation *)location;

//图片显示
+(void)sd_setImageView:(UIImageView *)imageView WithURL:(NSString*)str;


@end
