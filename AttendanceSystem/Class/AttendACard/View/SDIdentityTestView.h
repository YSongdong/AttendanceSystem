//
//  SDIdentityTestView.h
//  SDSafetyManageControl
//
//  Created by tiao on 2018/5/24.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    SDIdentityTypeStyleBegin = 0,  //开始验证
    SDIdentityTypeStyleError,    //验证失败
    SDIdentityTypeStyleErrorOrExam //验证失败跳过
} SDIdentityTypeStyle;

@interface SDIdentityTestView : UIView

;
//验证图片
@property (nonatomic,strong) UIImageView *testImageV;
//开始身份验证
@property (nonatomic,strong) UILabel *beginTestLab;
//失败原因
@property (nonatomic,strong) UILabel *errorLab;
//显示失败提示
@property (nonatomic,strong) UILabel *showErrorLab;

//开始验证按钮'
@property (nonatomic,strong) UIButton *beginTestBtn;
//取消按钮
@property (nonatomic,strong) UIButton *cancelBtn;

//跟新信息
-(void) updateTestViewSucces:(BOOL)isSucces isEnd:(BOOL) isEnd;


@end
