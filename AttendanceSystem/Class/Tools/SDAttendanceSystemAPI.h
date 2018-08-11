//
//  SDAttendanceSystemAPI.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/11.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#ifndef SDAttendanceSystemAPI_h
#define SDAttendanceSystemAPI_h

#define FT_INLINE static inline
FT_INLINE  NSString  *getRequestPath(NSString *act) ;

//测试域名
//#define PUBLISH_DIMAIN_URL @"http://192.168.3.201:1088/"
#define PUBLISH_DIMAIN_URL @"http://kq.api.cqlanhui.com/"
//#define PUBLISH_DIMAIN_URL @"http://192.168.2.56/"

//---------------------------用户中心-----------------
/*********身份证/手机号登录***********/
#define  HTTP_ATTAPPUSERLOGIN_URL   getRequestPath(@"attendance/Att_app_user/userLogin")
/*********发送验证码***********/
#define  HTTP_ATTAPPUSERSENDSMS_URL   getRequestPath(@"attendance/Att_app_user/sendSms")
/*********手机验证码：第二步：提交验证码登录***********/
#define  HTTP_ATTAPPUSERPHONELOGIN_URL   getRequestPath(@"attendance/Att_app_user/userPhoneLogin")
/*********绑定手机：第二步：提交验证码绑定手机***********/
#define  HTTP_ATTAPPUSERBINGPHONE_URL   getRequestPath(@"attendance/Att_app_user/bingPhone")
/*********上传留底的照片***********/
#define  HTTP_USERUPLOADPHONO_URL   getRequestPath(@"attendance/Att_app_user/userUploadPhoto")
/*********根据旧密码修改新密码***********/
#define  HTTP_ALTERPASSWROD_URL   getRequestPath(@"attendance/Att_app_user/userRePassword")
/*********忘记密码：第二步：提交验证码***********/
#define  HTTP_ATTAPPUSERFORGETPASSWORD_URL   getRequestPath(@"attendance/Att_app_user/userForgetPassword")

/*********修改绑定手机 第二步 验证当前手机号 ***********/
#define  HTTP_ATTAPPUSERISBINGPHONE_URL   getRequestPath(@"attendance/Att_app_user/isBingPhone")
/*********用户详情***********/
#define  HTTP_ATTAPPUSERUSERINFO_URL   getRequestPath(@"attendance/Att_app_user/userInfo")

//---------------------------考勤专区-----------------
/*********人员日期考勤详情***********/
#define  HTTP_APPUSERDAYSATTENDACEGROUINFO_URL   getRequestPath(@"attendance/App_Attendance/sbqAppGetUserDaysAttendanceGroupInfo")
/*********考勤打卡***********/
#define  HTTP_APPATTENDANCEAPPDOSIGNIN_URL   getRequestPath(@"attendance/App_Attendance/sbqAppDoSignIn")
/*********人脸检测***********/
#define  HTTP_APPATTENDFACERECOGNITION_URL   getRequestPath(@"attendance/App_Attendance/sbqAppFaceRecognition")
/*********人员考勤记录备注***********/
#define  HTTP_APPATTENDFACERRECORDREMARK_URL   getRequestPath(@"attendance/App_Attendance/sbqAppEditUserRecordRemark")
/*********获取日历状态值返回接口***********/
#define  HTTP_APPATTENDSTATUSLIST_URL   getRequestPath(@"attendance/App_Attendance/getCalendarStatusList")

//---------------------------审批专区-----------------
/*********申请页审批流程***********/
#define  HTTP_ATTAPPAPPROVALMEMBER_URL   getRequestPath(@"attendance/Att_app_approval/approvalMember")
/*********新增外出***********/
#define  HTTP_ATTAPPAPPADDOUTGO_URL   getRequestPath(@"attendance/Att_app_outgo/addOutgo")
/*********外出列表***********/
#define  HTTP_ATTAPPOUTGOOUTLIST_URL   getRequestPath(@"attendance/Att_app_outgo/outgoList")
/*********外出详情***********/
#define  HTTP_ATTAPPOUTGOOUTGOINFO_URL   getRequestPath(@"attendance/Att_app_outgo/outgoInfo")
/*********外出撤回***********/
#define  HTTP_ATTAPPOUTGOREVOKE_URL   getRequestPath(@"attendance/Att_app_outgo/outgoRevoke")
/*********外出催办***********/
#define  HTTP_ATTAPPOUTGOURGE_URL   getRequestPath(@"attendance/Att_app_outgo/outgoUrge")

/*********新增请假***********/
#define  HTTP_ATTAPPLEAVEADDLEAVE_URL   getRequestPath(@"attendance/Att_app_leave/addLeave")
/*********我的请假记***********/
#define  HTTP_ATTAPPLEAVELIST_URL   getRequestPath(@"attendance/Att_app_leave/leaveList")
/*********我的请假记***********/
#define  HTTP_ATTAPPLEAVEINFO_URL   getRequestPath(@"attendance/Att_app_leave/leaveInfo")
/*********请假撤销***********/
#define  HTTP_ATTAPPLEAVEREVOKE_URL   getRequestPath(@"attendance/Att_app_leave/leaveRevoke")
/*********请假催办***********/
#define  HTTP_ATTAPPLEAVEURGE_URL   getRequestPath(@"attendance/Att_app_leave/leaveUrge")


/*********补卡申请信息***********/
#define  HTTP_ATTAPPREPAICARDINFO_URL   getRequestPath(@"attendance/Att_app_repaircard/cardInfo")
/*********添加补卡***********/
#define  HTTP_ATTAPPADDREPAIRCARD_URL   getRequestPath(@"attendance/Att_app_repaircard/addRepaircard")
/*********补卡详情***********/
#define  HTTP_ATTAPPRREPAICARDEPAICARDINFO_URL   getRequestPath(@"attendance/Att_app_repaircard/repaircardInfo")
/*********补卡列表***********/
#define  HTTP_ATTAPPREPAICARDLIST_URL   getRequestPath(@"attendance/Att_app_repaircard/repaircardList")
/*********补卡撤销***********/
#define  HTTP_ATTAPPREPAIRCARDREVOKE_URL   getRequestPath(@"attendance/Att_app_repaircard/repaircardRevoke")
/*********补卡催办***********/
#define  HTTP_ATTAPPREPAIRCARDURGE_URL   getRequestPath(@"attendance/Att_app_repaircard/repaircardUrge")


/*********我的申请***********/
#define  HTTP_ATTAPPAPPLYLIST_URL   getRequestPath(@"attendance/Att_app_approval/applyList")
/*********待我审批的申请***********/
#define  HTTP_ATTAPPAPPROVALLIST_URL   getRequestPath(@"attendance/Att_app_approval/approvalList")
/*********审批状态：我的视角***********/
#define  HTTP_ATTAPPAPPROVALSTATUS_URL   getRequestPath(@"attendance/Att_app_approval/approvalStatus")
/********审批状态：第三方视角***********/
#define  HTTP_ATTAPPSHOWAPPROVALSTATUS_URL   getRequestPath(@"attendance/Att_app_approval/showApprovalStatus")
/********审批申请***********/
#define  HTTP_ATTAPPEXAMINEAPPROVAL_URL   getRequestPath(@"attendance/Att_app_approval/examineApproval")




FT_INLINE  NSString  * getRequestPath(NSString *op) {
    return [PUBLISH_DIMAIN_URL stringByAppendingFormat:@"%@",op];
}

#endif /* SDAttendanceSystemAPI_h */
