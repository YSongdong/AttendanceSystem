//
//  ShowMarkView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/25.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowMarkView.h"

@interface ShowMarkView ()
<
UITextViewDelegate
>
//打卡时间
@property (nonatomic,strong)UILabel *showTimeLab;
//打卡地点
@property (nonatomic,strong) UILabel *cardAddressLab;
//人脸状态
@property (nonatomic,strong)UILabel *faceStatuLab;
//提示信息
@property (nonatomic,strong) UILabel *placeStrLab;
//备注textview
@property (nonatomic,strong) UITextView *markTeView;
//
@property (nonatomic,strong)UIButton  *trueSubmitBtn;

@end

@implementation ShowMarkView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    __weak typeof(self) weakSelf = self;
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor =[UIColor blackColor];
    bgView.alpha = 0.35;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selelctBigTap)];
    [bgView addGestureRecognizer:tap];
    
    
    UIView *samilView = [[UIView alloc]init];
    [self addSubview:samilView];
    samilView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    [samilView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(43));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(43));
        make.height.equalTo(@(KSIphonScreenH(340)));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    samilView.layer.cornerRadius = 8;
    samilView.layer.masksToBounds  = YES;
    UITapGestureRecognizer *samilTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selelctTap)];
    [samilView addGestureRecognizer:samilTap];
    
    
    UIView *titleView = [[UIView alloc]init];
    [samilView addSubview:titleView];
    titleView.backgroundColor = [UIColor colorTextWhiteColor];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(samilView);
        make.height.equalTo(@(KSIphonScreenH(45)));
    }];
    
    UILabel *showTitleLab  =[[UILabel alloc]init];
    [titleView addSubview:showTitleLab];
    showTitleLab.text = @"打卡备注";
    showTitleLab.textColor = [UIColor colorTextBg28BlackColor];
    showTitleLab.font = BFont(17);
    [showTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView.mas_centerX);
        make.centerY.equalTo(titleView.mas_centerY);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    [samilView addSubview:bottomView];
    bottomView.backgroundColor = [UIColor colorTextWhiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(samilView);
        make.height.equalTo(@(KSIphonScreenH(53)));
    }];
    
    self.trueSubmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:self.trueSubmitBtn];
    [self.trueSubmitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [self.trueSubmitBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.trueSubmitBtn.titleLabel.font = BFont(16);
    [self.trueSubmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(bottomView);
        make.centerX.equalTo(bottomView.mas_centerX);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    [self.trueSubmitBtn addTarget:self action:@selector(trueSubmitTction:) forControlEvents:UIControlEventTouchUpInside];
    
    //地点view
    UIView *addressConcetView  = [[UIView alloc]init];
    [samilView addSubview:addressConcetView];
    addressConcetView.backgroundColor  =[UIColor colorTextWhiteColor];
    [addressConcetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).offset(1);
        make.left.right.equalTo(samilView);
        make.height.equalTo(@(KSIphonScreenH(100)));
        make.centerX.equalTo(titleView);
    }];
    
    UIImageView *timeImageV = [[UIImageView alloc]init];
    [addressConcetView addSubview:timeImageV];
    timeImageV.image = [UIImage imageNamed:@"qrxx_ico_time"];
    [timeImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressConcetView).offset(KSIphonScreenW(15));
        make.width.equalTo(@(KSIphonScreenW(12)));
        make.top.equalTo(addressConcetView).offset(KSIphonScreenH(24));
    }];
    
    self.showTimeLab = [[UILabel alloc]init];
    [addressConcetView addSubview:self.showTimeLab];
    self.showTimeLab.font = Font(12);
    self.showTimeLab.textColor = [UIColor colorTextBg65BlackColor];
    [self.showTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeImageV.mas_right).offset(KSIphonScreenW(7));
        make.centerY.equalTo(timeImageV.mas_centerY);
    }];
    self.showTimeLab.text = [NSString stringWithFormat:@"打卡时间 "];
    
    UIImageView *addressImageV = [[UIImageView alloc]init];
    [addressConcetView addSubview:addressImageV];
    addressImageV.image = [UIImage imageNamed:@"qrxx_ico_dw"];
    [addressImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeImageV.mas_bottom).offset(KSIphonScreenH(12));
        make.left.equalTo(timeImageV.mas_left);
    }];
    
    self.cardAddressLab = [[UILabel alloc]init];
    [addressConcetView addSubview:self.cardAddressLab];
    self.cardAddressLab.text = @"打卡地点：";
    self.cardAddressLab.font = Font(12);
    self.cardAddressLab.textColor =[UIColor colorTextBg65BlackColor];
    [self.cardAddressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.showTimeLab.mas_left);
        make.centerY.equalTo(addressImageV.mas_centerY);
        make.right.equalTo(addressConcetView).offset(-KSIphonScreenW(15));
    }];
    
    //开启验证
    UIImageView *faceImageV = [[UIImageView alloc]init];
    [addressConcetView addSubview:faceImageV];
    faceImageV.tag = 200;
    faceImageV.image = [UIImage imageNamed:@"qrxx_ico_sfyz"];
    [faceImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressImageV.mas_bottom).offset(KSIphonScreenH(12));
        make.left.equalTo(addressImageV.mas_left);
    }];

    UILabel *showIdentTestLab = [[UILabel alloc]init];
    [addressConcetView  addSubview:showIdentTestLab];
    showIdentTestLab.text =@"身份验证:";
    showIdentTestLab.font = Font(12);
    showIdentTestLab.tag = 201;
    showIdentTestLab.textColor = [UIColor colorTextBg65BlackColor];
    [showIdentTestLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.cardAddressLab.mas_left);
        make.centerY.equalTo(faceImageV.mas_centerY);
    }];

    self.faceStatuLab = [[UILabel alloc]init];
    [addressConcetView addSubview:self.faceStatuLab];
    self.faceStatuLab.text = @"未通过";
    self.faceStatuLab.font = Font(12);
    self.faceStatuLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
    [self.faceStatuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showIdentTestLab.mas_right).offset(KSIphonScreenW(8));
        make.centerY.equalTo(faceImageV.mas_centerY);
    }];
    
    UIView *markView = [[UIView alloc]init];
    [samilView addSubview:markView];
    markView.tag = 300;
    markView.backgroundColor =[UIColor colorTextWhiteColor];
    [markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressConcetView.mas_bottom).offset(1);
        make.right.left.equalTo(samilView);
        make.height.equalTo(@(KSIphonScreenH(139)));
        make.left.equalTo(addressConcetView.mas_left);
        make.centerX.equalTo(addressConcetView.mas_centerX);
    }];
    
    self.placeStrLab = [[UILabel alloc]init];
    [self addSubview:self.placeStrLab];
    self.placeStrLab.text = @"请补充备注信息";
    self.placeStrLab.font = Font(12);
    self.placeStrLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [self.placeStrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(markView).offset(KSIphonScreenH(20));
        make.left.equalTo(markView).offset(KSIphonScreenW(15));
    }];
    
    self.markTeView = [[UITextView alloc]init];
    [markView addSubview:self.markTeView];
    self.markTeView.font =Font(12);
    self.markTeView.delegate = self;
    self.markTeView.returnKeyType = UIReturnKeyDone;
    [self.markTeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(markView).offset(KSIphonScreenH(10));
        make.left.equalTo(markView).offset(KSIphonScreenH(15));
        make.right.equalTo(markView).offset(-KSIphonScreenW(15));
        make.height.equalTo(@(KSIphonScreenH(50)));
    }];
    
    for (int i=0; i<3; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        [markView addSubview:imageV];
        imageV.tag =  400+i;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(markView).offset(KSIphonScreenW(15)+i*KSIphonScreenH(54)+i*KSIphonScreenW(10));
            make.bottom.equalTo(markView.mas_bottom).offset(-KSIphonScreenW(10));
            make.width.height.equalTo(@(KSIphonScreenH(54)));
        }];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chenkImageAciton:)];
        [imageV addGestureRecognizer:tap];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        
        if (textView.text.length == 0) {
            self.placeStrLab.hidden = NO;
        }else{
            self.placeStrLab.hidden = YES;
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
   
    if (text.length > 0) {
         self.placeStrLab.hidden = YES;
    }else{
        if (self.markTeView.text.length == 0) {
            self.placeStrLab.hidden = NO;
        }
    }
    return YES;
}

-(void)selelctBigTap{
    [self removeFromSuperview];
}
-(void)selelctTap{
    [self.markTeView resignFirstResponder];
}
-(void)chenkImageAciton:(UITapGestureRecognizer *) sender{
    UIImageView *imageV = (UIImageView *)sender.view;
    [XWScanImage scanBigImageWithImageView:imageV];
}
//确定按钮
-(void)trueSubmitTction:(UIButton *) sender{
    NSString *markStr = self.dict[@"remark"];
    //照片
    NSArray *photoArr = self.dict[@"photo"];
    //查看备注
    if (![markStr isEqualToString:@""] || photoArr.count > 0 ) {
        [self removeFromSuperview];
        return;
    }
    
    //添加备注
    if (self.markTeView.text.length == 0) {
        [SDShowSystemPrompView showSystemPrompStr:@"请补充备注信息"];
        return;
    }
    //添加备注
    [self requestAddMarkData];
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    //打卡时间
     self.showTimeLab.text = [NSString stringWithFormat:@"打卡时间 %@",dict[@"timeClockinHi"]];
    //打卡地点
    self.cardAddressLab.text = [NSString stringWithFormat:@"打卡地点 %@",dict[@"clockinCoordinate"][@"title"]];
    //身份验证
    NSString *faceStatuStr = [NSString stringWithFormat:@"%@",dict[@"faceStatus"]];
    UIImageView *faceImageV  = [self viewWithTag:200];
    UILabel *showIdentTestLab = [self viewWithTag:201];
    UIView *markView = [self viewWithTag:300];
    if ([faceStatuStr isEqualToString:@"2"]) {
        faceImageV.image = [UIImage imageNamed:@""];
        showIdentTestLab.hidden = YES;
        self.faceStatuLab.hidden= YES;
    }else{
        faceImageV.image = [UIImage imageNamed:@"qrxx_ico_sfyz"];
        showIdentTestLab.hidden = NO;
        self.faceStatuLab.hidden= NO;
         NSString *faceTestStatuStr  =[NSString stringWithFormat:@"%@",dict[@"abnormalIdentityIs"]];
        if ([faceTestStatuStr isEqualToString:@"2"]) {
            self.faceStatuLab.text= @"未通过";
            self.faceStatuLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
        }else{
            self.faceStatuLab.text= @"已通过";
            self.faceStatuLab.textColor = [UIColor colorCommonGreenColor];
        }
    }
    //照片
    //移除imageV 的内容
    for (int i=0; i<3; i++) {
        UIImageView *imageV = [self viewWithTag:(400+i)];
        imageV.image = nil;
    }
    
    NSArray *photoArr = dict[@"photo"];
    if (photoArr.count != 0) {
        for (int i=0; i<photoArr.count; i++) {
            NSString *photoUrl = photoArr[i];
            UIImageView *imageV = [self viewWithTag:(400+i)];
            [SDTool sd_setImageView:imageV WithURL:photoUrl];
        }
    }else{
        for (int i=0; i<3; i++) {
            UIImageView *imageV = [self viewWithTag:(400+i)];
            imageV.image = nil;
        }
    }
    //备注类型，
    self.markTeView.text = @"";
    self.markTeView.editable = YES;
    NSString *markStr = dict[@"remark"];
    
    for (int i=0; i<3; i++) {
        UIImageView *imageV = [self viewWithTag:(400+i)];
        [imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(markView).offset(KSIphonScreenW(15)+i*KSIphonScreenH(54)+i*KSIphonScreenW(10));
            make.bottom.equalTo(markView.mas_bottom).offset(-KSIphonScreenW(10));
            make.width.height.equalTo(@(KSIphonScreenH(54)));
        }];
    }
    
    [self.markTeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(markView).offset(KSIphonScreenH(10));
        make.left.equalTo(markView).offset(KSIphonScreenH(15));
        make.right.equalTo(markView).offset(-KSIphonScreenW(15));
        make.height.equalTo(@(KSIphonScreenH(50)));
    }];
    
    if (![markStr isEqualToString:@""] || photoArr.count > 0) {
        //查看备注
        self.placeStrLab.hidden = YES;
        
        self.markTeView.text = dict[@"remark"];
        self.markTeView.editable = NO;
      
//        if ([markStr isEqualToString:@""]) {
//            for (int i=0; i<3; i++) {
//                UIImageView *imageV = [self viewWithTag:(400+i)];
//                [imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(markView).offset(KSIphonScreenW(10)+i*KSIphonScreenH(80)+i*KSIphonScreenW(10));
//                    make.centerY.equalTo(markView.mas_centerY);
//                    make.width.height.equalTo(@(KSIphonScreenH(80)));
//                }];
//            }
//        }

        for (int i=0; i<3; i++) {
            UIImageView *imageV = [self viewWithTag:(400+i)];
            if (photoArr.count > 0) {
               imageV.userInteractionEnabled = YES;
            }else{
                imageV.userInteractionEnabled = NO;
//                [imageV mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.height.width.equalTo(@0);
//                }];
//                imageV.image = nil;
//                [self.markTeView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(markView).offset(KSIphonScreenH(10));
//                    make.left.equalTo(markView).offset(KSIphonScreenW(15));
//                    make.right.equalTo(markView).offset(-KSIphonScreenW(15));
//                    make.bottom.equalTo(markView).offset(-KSIphonScreenH(10));
//                }];
//               imageV.userInteractionEnabled = NO;
            }
        }
        [self.trueSubmitBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [self.trueSubmitBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    
    }else{
        
        for (int i=0; i<3; i++) {
            UIImageView *imageV = [self viewWithTag:(400+i)];
            imageV.userInteractionEnabled = NO;
        }
        //添加备注
        self.placeStrLab.hidden = NO;
        [self.trueSubmitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.trueSubmitBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    }
}
#pragma mark ----数据相关-----
-(void) requestAddMarkData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.dict[@"Id"];
    param[@"remark"] = self.markTeView.text;
    param[@"token"] = [SDTool getNewToken];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    [[KRMainNetTool sharedKRMainNetTool]postRequstWith:HTTP_APPATTENDFACERRECORDREMARK_URL params:param.copy withModel:nil waitView:self complateHandle:^(id showdata, NSString *error) {
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
        self.addMarkBlock(self.markTeView.text);
        [self removeFromSuperview];
    }];
    
}





@end
