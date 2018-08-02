//
//  SDUserInfo.m
//  SDSafetyManageControl
//
//  Created by tiao on 2018/4/18.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "SDUserInfo.h"

@implementation SDUserInfo

//保存用户数据
+(void) saveUserData:(NSDictionary *)data{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:data forKey:@"Login"];
    //3.强制让数据立刻保存
    [userD synchronize];
}
//删除用户信息
+(void) delUserInfo{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    //用户信息
    [userD removeObjectForKey:@"Login"];
    //删除本地字号
    [userD removeObjectForKey:@"Font"];
    
    //3.强制让数据立刻保存
    [userD synchronize];
}
//判断是否登录
+(BOOL) passLoginData{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"Login"]) {
        return YES;
    }else{
        return NO;
    }
}
// ----------------修改数据----------
//修改UserID和identity_id
+(void) alterUserID:(NSDictionary *)dict{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict1 = [userD objectForKey:@"Login"];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    mutableDict[@"userid"] = dict[@"userid"];
    mutableDict[@"identity_id"] = dict[@"identity_id"];
    
    [SDUserInfo saveUserData:mutableDict.copy];
}
//加入平台修改信息
+(void) selectPlatformAlterMsg:(NSDictionary *)dict{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict1 = [userD objectForKey:@"Login"];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    mutableDict[@"gdl_userid"] = dict[@"gdl_userid"];
    mutableDict[@"identity_id"] = dict[@"identity_id"];
    mutableDict[@"plaform_id"] = dict[@"plaform_id"];
    mutableDict[@"userid"] = dict[@"userid"];
    mutableDict[@"plaformName"] = dict[@"plaformName"];
    [SDUserInfo saveUserData:mutableDict.copy];
}
//修改平台名称
+(void) alterPlaformName:(NSDictionary *)dict{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict1 = [userD objectForKey:@"Login"];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    mutableDict[@"plaform_id"] = dict[@"id"];
    mutableDict[@"plaformName"] = dict[@"name"];
    mutableDict[@"identity_id"] = dict[@"identity_id"];
    [SDUserInfo saveUserData:mutableDict.copy];
}
//修改账号名
+(void) alterUserName:(NSString *)userName{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict1 = [userD objectForKey:@"Login"];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    mutableDict[@"username"] = userName;
    [SDUserInfo saveUserData:mutableDict.copy];
}
//修改手机号码
+(void) alterNumberPhone:(NSDictionary *)dict{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict1 = [userD objectForKey:@"Login"];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    mutableDict[@"phone"] = dict[@"phone"];
    mutableDict[@"isBindPhone"] = dict[@"isBind"];
    mutableDict[@"userId"] = dict[@"userId"];
    [SDUserInfo saveUserData:mutableDict.copy];
}
//修改头像
+(void) alterNumberPhoto:(NSDictionary *)dict{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict1 = [userD objectForKey:@"Login"];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    mutableDict[@"photo"] = dict[@"url"];
    mutableDict[@"photoStatus"] = dict[@"photoStatus"];
    mutableDict[@"userId"] = dict[@"userId"];
    [SDUserInfo saveUserData:mutableDict.copy];
}
//修改用户保存信息
+(void) alterUserInfo:(NSDictionary *)dict{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict1 = [userD objectForKey:@"Login"];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict1];
    mutableDict[@"departmentName"] = dict[@"departmentName"];
    mutableDict[@"idcard"] = dict[@"idcard"];
    mutableDict[@"isBindPhone"] = dict[@"isBindPhone"];
    mutableDict[@"isCharge"] = dict[@"isCharge"];
    mutableDict[@"isFirstLogin"] = dict[@"isFirstLogin"];
    mutableDict[@"jobnumber"] = dict[@"jobnumber"];
    mutableDict[@"phone"] = dict[@"phone"];
    mutableDict[@"photo"] = dict[@"photo"];
    mutableDict[@"photoStatus"] = dict[@"photoStatus"];
    mutableDict[@"plaformId"] = dict[@"plaformId"];
    mutableDict[@"positionName"] = dict[@"positionName"];
    mutableDict[@"proGroupId"] = dict[@"proGroupId"];
    mutableDict[@"proGroupName"] = dict[@"proGroupName"];
    mutableDict[@"realName"] = dict[@"realName"];
    mutableDict[@"sex"] = dict[@"sex"];
    mutableDict[@"unitId"] = dict[@"unitId"];
    mutableDict[@"userId"] = dict[@"userId"];
    mutableDict[@"userName"] = dict[@"userName"];
    [SDUserInfo saveUserData:mutableDict.copy];
}
// -----------------取出数据---------
//获取userId
+(NSString *) obtainWithUserId{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"userId"];
}
//获取tonken
+(NSString *) obtainWithTonken{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"token"];
}
//获取phone
+(NSString *) obtainWithPhone{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"phone"];
}
//获取bindPhone状态
+(NSString *) obtainWithBindPhone{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"isBindPhone"];
}
//获取photo
+(NSString *) obtainWithPhoto{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"photo"];
}
//获取photo状态
+(NSString *) obtainWithPotoStatus{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"photoStatus"];
}
//获取idcard
+(NSString *) obtainWithidcard{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"idcard"];
}
//获取realName
+(NSString *) obtainWithRealName{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"realName"];
}
//获取userName
+(NSString *) obtainWithUserName{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"userName"];
}
//获取jobnumber
+(NSString *) obtainWithJobNumber{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"jobnumber"];
}
//获取sex
+(NSString *) obtainWithSex{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"sex"];
}
//获取positionName
+(NSString *) obtainWithPositionName{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"positionName"];
}


//获取departmentName  部门名称
+(NSString *) obtainWithDepartmentName{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"departmentName"];
}
//获取plaformId
+(NSString *) obtainWithPlafrmId{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"platformId"];
}

//获取unitId
+(NSString *) obtainWithUniId{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"unitId"];
}
//获取proGroupId
+(NSString *) obtainWithProGroupId{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"proGroupId"];
}
//获取proGroupName
+(NSString *) obtainWithProGroupName{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userD objectForKey:@"Login"];
    return dict[@"proGroupName"];
}
@end