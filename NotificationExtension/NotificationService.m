//
//  NotificationService.m
//  NotificationExtension
//
//  Created by tiao on 2018/9/13.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "NotificationService.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.cqlanhui.AttendanceSystem"];
    //判断是否开启提示语音
    if ([sharedDefaults boolForKey:@"SpeechRemdin"]) {
        //语音播报
        [self playLocalMusic:self.bestAttemptContent.userInfo];
    }
    
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}
#pragma mark ----播放本地音频--------
-(void) playLocalMusic:(NSDictionary *)dict{
    // 2.播放本地音频文件
    NSString *patyName ;
    NSString *allTypeStr = [NSString stringWithFormat:@"%@",dict[@"allType"]];
    if ([allTypeStr isEqualToString:@"1"]) {
        //1：考勤打卡
        NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"type"]];
        patyName = [typeStr isEqualToString:@"1"] ? @"music_goToWork" : @"music_getOffWork";
    }else if ([allTypeStr isEqualToString:@"2"]){
        // 2：照片审核
        NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"type"]];
        patyName = [typeStr isEqualToString:@"1"] ? @"music_succeePhoto" : @"music_unPhoto";
    }else if ([allTypeStr isEqualToString:@"3"]){
        //3申请提交
        NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"type"]];
        if ([typeStr integerValue] > 0 && [typeStr integerValue] < 5 ) {
            patyName = @"music_newApplyOf";
        }
        if ([typeStr integerValue] > 8 && [typeStr integerValue] < 13 ) {
            patyName = @"music_yourSuccessApply";
        }
    }
    if (patyName == nil) {
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:patyName ofType:@"mp3"];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    
    AudioServicesPlaySystemSound(soundID);
    // 震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
@end
