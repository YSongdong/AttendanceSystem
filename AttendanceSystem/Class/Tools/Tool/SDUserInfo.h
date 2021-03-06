//
//  SDUserInfo.h
//  SDSafetyManageControl
//
//  Created by tiao on 2018/4/18.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDUserInfo : NSObject

//保存用户数据
+(void) saveUserData:(NSDictionary *)data;

//删除用户信息
+(void) delUserInfo;

//判断是否登录
+(BOOL) passLoginData;

//保存系统版本数据
+(void) saveSystemVersionData:(NSDictionary *)data;

// 取出保存本地系统版本数据
+(NSDictionary *) takeSystemVersionData;

// ----------------修改数据----------
//修改UserID和identity_id
+(void) alterUserID:(NSDictionary *)dict;
//加入平台修改信息
+(void) selectPlatformAlterMsg:(NSDictionary *)dict;
//修改平台名称
+(void) alterPlaformName:(NSDictionary *)dict;
//修改账号名
+(void) alterUserName:(NSString *)userName;
//修改手机号码
+(void) alterNumberPhone:(NSDictionary *)dict;
//修改头像
+(void) alterNumberPhoto:(NSDictionary *)dict;
//修改用户保存信息
+(void) alterUserInfo:(NSDictionary *)dict;
//修改考勤组
+(void) alterProGroupId:(NSString *)agId;

// -----------------取出数据---------
//获取userId
+(NSString *) obtainWithUserId;
//获取tonken
+(NSString *) obtainWithTonken;
//获取phone
+(NSString *) obtainWithPhone;
//获取bindPhone
+(NSString *) obtainWithBindPhone;
//获取photo
+(NSString *) obtainWithPhoto;
//获取photo状态
+(NSString *) obtainWithPotoStatus;
//获取idcard
+(NSString *) obtainWithidcard;
//获取realName
+(NSString *) obtainWithRealName;
//获取userName
+(NSString *) obtainWithUserName;
//获取jobnumber
+(NSString *) obtainWithJobNumber;
//获取sex
+(NSString *) obtainWithSex;
//获取positionName  职位名称
+(NSString *) obtainWithPositionName;
//获取departmentName  部门名称
+(NSString *) obtainWithDepartmentName;
//获取appListCount  我的待审批数量
+(NSString *) obtainWithAppListCount;
//获取msgCount 未读消息数量
+(NSString *) obtainWithMsgCount;
//获取platformId
+(NSString *) obtainWithPlafrmId;
//获取unitId
+(NSString *) obtainWithUniId;
//获取proGroupId
+(NSString *) obtainWithProGroupId;
//获取proGroupName
+(NSString *) obtainWithProGroupName;
//获取 isCharge  是不是主管
+(NSString *) obtainWithIsCharge;
//获取 recard  1：有补卡流程 2：没有补卡流程
+(NSString *) obtainWithRecard;
//获取  leave  1:有请假流程 2：没有
+(NSString *) obtainWithLeave;
//获取  outgo  1：有外出流程 2：没有
+(NSString *) obtainWithOutGo;
//获取  overtime  1:有加班流程 2：没有
+(NSString *) obtainWithOvertime;
//获取  CardReissue  //1需要补卡 2无需补卡
+(NSString *) obtainWithCardReissue;
@end
