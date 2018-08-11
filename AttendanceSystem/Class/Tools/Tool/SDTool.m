//
//  SDTool.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/14.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SDTool.h"
#import <CommonCrypto/CommonDigest.h>
@implementation SDTool

//touken和userid 返回新touken
+(NSString *)getNewToken{
    NSString *str =[SDTool md5:[NSString stringWithFormat:@"%@%@",[SDUserInfo obtainWithUserId],[SDUserInfo obtainWithTonken]]];
    return str;
}
//md5加密
+ (NSString *)md5:(NSString *)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];

    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);

    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}




#pragma mark - 将某个时间戳转化成 时间
//将某个时间戳转化成 时间
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
    
}

//将某个时间转化成 时间戳

#pragma mark - 将某个时间转化成 时间戳

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    return timeSp;
}
#pragma mark - 获取当前时间的 时间戳
//获取当前系统时间的时间戳
+(NSInteger)getNowTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间

    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    
    return timeSp;
    
}

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, KScreenH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}

//返回计算的文本占用位置的大小（含宽，高）
+(CGSize)calStrWith:(NSString*)text andFontSize:(CGFloat)fontsize
{
    CGSize size=[text boundingRectWithSize:CGSizeMake(KScreenW, KScreenH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size;
    return size;
}
//NSDate转换成时间戳
+(NSString *)dateTime:(double)timeStam{
    NSTimeInterval interval    =timeStam;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

//NSDate转换成时间戳
+(NSString *)dateNowTime{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

+ (NSInteger )dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startD =[date dateFromString:startTime];
  
    NSDate *endD = [date dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    
    NSInteger minute = (NSInteger)value /60;
    
    return minute;
}
//计算两个时间的时长 (小时)
+ (CGFloat)calculateWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    
    [date setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    NSDate *startD =[date dateFromString:startTime];
    
    NSDate *endD = [date dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    
    CGFloat minute = (CGFloat)value /(60*60);
    
    return minute;
}
// 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
//输入位置和服务器返回位置做对比    返回一个对比的数组
+(NSArray *) getData:(NSDictionary *)Datadict Locat:(CLLocation *)location{
    NSMutableArray *coordArr  = [NSMutableArray array];
    
    NSArray *coordinateArr = Datadict[@"coordinate"];
    for (int i=0; i<coordinateArr.count; i++) {
        NSDictionary *coorDict = coordinateArr[i];
        NSDictionary *coordinateDict = coorDict[@"coordinate"];
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:coorDict];
        mutableDict[@"index"] = [NSString stringWithFormat:@"%d",i];
        //1.将两个经纬度点转成投影点
        MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([coordinateDict[@"lat"]doubleValue],[coordinateDict[@"lng"]doubleValue]));
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude));
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        
        //newDict
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:coorDict];
        dict[@"distance"] = [NSString stringWithFormat:@"%.2f",distance];
        mutableDict[@"distance"] = [NSString stringWithFormat:@"%.2f",distance];
        //半径（范围）
        NSString *deviationStr =coorDict[@"deviation"];
        if (distance < [deviationStr doubleValue] ) {
            //是否在范围内  1、 是  2 不是
            mutableDict[@"isScope"] = @"1";
        }else{
            mutableDict[@"isScope"] = @"2";
        }
        [coordArr addObject:mutableDict];
    }
    return coordArr.copy;
}

//图片显示
+(void)sd_setImageView:(UIImageView *)imageView WithURL:(NSString *)str
{
    NSURL *url =  [NSURL URLWithString:str];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"nomalImage"]options:SDWebImageRetryFailed];
}


@end
