//
//  ShowTureSignInView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/21.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowTureSignInView.h"

@interface ShowTureSignInView ()
<
UITextViewDelegate
>
//打卡地点
@property (nonatomic,strong) UILabel *cardAddressLab;
//人脸状态
@property (nonatomic,strong)UILabel *faceStatuLab;
//重新验证
@property (nonatomic,strong) UIButton *againTextBtn;
//提示信息
@property (nonatomic,strong) UILabel *placeStrLab;
//备注textview
@property (nonatomic,strong) UITextView *markTeView;

@end


@implementation ShowTureSignInView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView{
    __weak typeof(self) weakSelf = self;
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor =[UIColor blackColor];
    bgView.alpha = 0.35;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selelctTap)];
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
    showTitleLab.text = @"确认签到信息";
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
    
    UIButton *uCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:uCardBtn];
    [uCardBtn setTitle:@"不打卡" forState:UIControlStateNormal];
    [uCardBtn setTitleColor:[UIColor colorWithHexString:@"#d3d3d3"] forState:UIControlStateNormal];
    uCardBtn.titleLabel.font = Font(16);
    [uCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(bottomView);
    }];
    [uCardBtn addTarget:self action:@selector(selecCencalAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.cardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:_cardBtn];
    [self.cardBtn setTitle:@"确认打卡" forState:UIControlStateNormal];
    [self.cardBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.cardBtn.titleLabel.font = BFont(16);
    [self.cardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(uCardBtn.mas_right).offset(1);
        make.right.equalTo(bottomView);
        make.width.height.equalTo(uCardBtn);
        make.centerY.equalTo(uCardBtn.mas_centerY);
    }];
    [self.cardBtn addTarget:self action:@selector(trueCardAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottomLineView = [[UIView alloc]init];
    [bottomView addSubview:bottomLineView];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(uCardBtn.mas_right);
        make.width.equalTo(@1);
        make.height.equalTo(@(KSIphonScreenH(21)));
        make.centerY.equalTo(uCardBtn.mas_centerY);
    }];
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
    
    UILabel *showTimeLab = [[UILabel alloc]init];
    [addressConcetView addSubview:showTimeLab];
    showTimeLab.font = Font(12);
    showTimeLab.textColor = [UIColor colorTextBg65BlackColor];
    [showTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeImageV.mas_right).offset(7);
        make.centerY.equalTo(timeImageV.mas_centerY);
    }];
    showTimeLab.text = [NSString stringWithFormat:@"打卡时间  %@",[self dateNowTime]];
    
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
        make.left.equalTo(showTimeLab.mas_left);
        make.centerY.equalTo(addressImageV.mas_centerY);
        make.right.equalTo(addressConcetView).offset(-KSIphonScreenW(15));
    }];
    
    //开启验证
    UIImageView *faceImageV = [[UIImageView alloc]init];
    [addressConcetView addSubview:faceImageV];
    faceImageV.tag = 200;
    faceImageV.image = [UIImage imageNamed:@"qrxx_ico_sfyz"];
    [faceImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressImageV.mas_bottom).offset(12);
        make.left.equalTo(addressImageV.mas_left);
    }];
    
    UILabel *showIdentTestLab = [[UILabel alloc]init];
    [addressConcetView  addSubview:showIdentTestLab];
    showIdentTestLab.text =@"身份验证:";
    showIdentTestLab.tag = 201;
    showIdentTestLab.font = Font(12);
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
        make.left.equalTo(showIdentTestLab.mas_right).offset(8);
        make.centerY.equalTo(faceImageV.mas_centerY);
    }];
    
    self.againTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressConcetView addSubview:self.againTextBtn];
    [self.againTextBtn setTitle:@"重新验证 >" forState:UIControlStateNormal];
    [self.againTextBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.againTextBtn.titleLabel.font = Font(12);
    [self.againTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.faceStatuLab.mas_right).offset(22);
        make.centerY.equalTo(weakSelf.faceStatuLab.mas_centerY);
    }];
    [self.againTextBtn addTarget:self action:@selector(selectAgainFace:) forControlEvents:UIControlEventTouchUpInside];
   
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
    self.placeStrLab.text = @"请输入打卡备注信息(选填)";
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
    [self.markTeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(markView).offset(KSIphonScreenH(14));
        make.left.equalTo(markView).offset(KSIphonScreenW(15));
        make.right.equalTo(markView).offset(-KSIphonScreenW(15));
        make.height.equalTo(@(KSIphonScreenH(50)));
    }];
    
     _imageArr  =[NSMutableArray array];
    //添加默认图片
    [self.imageArr addObject:[UIImage imageNamed:@"att_attendance_dialogmsg_add"]];
    for (int i=0; i<self.imageArr.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        [markView addSubview:imageV];
        imageV.image = self.imageArr[i];
        imageV.tag =  200+i;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(markView).offset(KSIphonScreenW(15)+i*KSIphonScreenW(54)+i*KSIphonScreenW(10));
            make.bottom.equalTo(markView.mas_bottom).offset(-KSIphonScreenW(10));
            make.width.height.equalTo(@(KSIphonScreenH(54)));
        }];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageAciton:)];
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
-(void)setFaceStatusStr:(NSString *)faceStatusStr{
    _faceStatusStr = faceStatusStr;
     UIImageView *faceImageV = [self viewWithTag:200];
      UILabel *showIdentTestLab =[self viewWithTag:201];
    if (faceStatusStr == nil) {
        faceImageV.hidden = YES;
        showIdentTestLab.hidden = YES;
        self.faceStatuLab.hidden = YES;
        self.againTextBtn.hidden = YES;
    }else if([faceStatusStr isEqualToString:@"2"])  {
        //未通过
        faceImageV.hidden = NO;
        showIdentTestLab.hidden = NO;
        self.faceStatuLab.hidden = NO;
        self.againTextBtn.hidden = NO;
        self.faceStatuLab.text = @"未通过";
    }else if ([faceStatusStr isEqualToString:@"1"]){
        //通过
        faceImageV.hidden = NO;
        showIdentTestLab.hidden = NO;
        self.faceStatuLab.hidden = NO;
        self.againTextBtn.hidden = NO;
        self.faceStatuLab.text = @"已通过";
        self.faceStatuLab.textColor =[UIColor colorCommonGreenColor];
    }
}
-(void)setAddressStr:(NSString *)addressStr{
    _addressStr = addressStr;
    self.cardAddressLab.text = [NSString stringWithFormat:@"打卡地点  %@",addressStr];
}
-(void)setAgainFaceStr:(NSString *)againFaceStr{
    _againFaceStr = againFaceStr;
    self.faceStatuLab.text = @"已通过";
    self.faceStatuLab.textColor = [UIColor colorCommonGreenColor];
}
//获取手机时间
-(NSString*) dateNowTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH: mm"];
    NSString *dateString       = [formatter stringFromDate: [NSDate date]];
    return dateString;
}
-(void)selecCencalAction:(UIButton *) sender{
    [self removeFromSuperview];
}
-(void)addImageAciton:(UITapGestureRecognizer *) tap{
    if (self.imageArr.count <5) {
        NSInteger index = tap.view.tag - 200;
        if (index != self.imageArr.count-1) {
            UIImageView *imageV = (UIImageView *)tap.view;
            [XWScanImage scanBigImageWithImageView:imageV];
        }else{
           self.selectPhotoBlock();
        }
    }
}
-(void)selelctTap{
    [self endEditing:YES];
}
//重新验证人脸
-(void)selectAgainFace:(UIButton *) sender{
    self.againFaceBlock();
}
//确认打卡
-(void)trueCardAction:(UIButton *) sender{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if ( [self.faceStatuLab.text isEqualToString:@"未通过"]) {
        param[@"abnormalIdentityIs"] = @"2";
    }else if ( [self.faceStatuLab.text isEqualToString:@"已通过"]) {
        param[@"abnormalIdentityIs"] = @"1";
    }else{
         param[@"abnormalIdentityIs"] = @"3";
    }
    param[@"remark"] = self.markTeView.text;
    
    self.trueInfoBlock(param.copy);
}
//更新UI
-(void)updateUI{
    UIView *markView =  [self viewWithTag:300];
    for (int i=0; i<self.imageArr.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        [markView addSubview:imageV];
        imageV.image = self.imageArr[i];
        imageV.tag =  200+i;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(markView).offset(KSIphonScreenW(15)+i*KSIphonScreenW(54)+i*KSIphonScreenW(10));
            make.bottom.equalTo(markView.mas_bottom).offset(-KSIphonScreenW(10));
            make.width.height.equalTo(@(KSIphonScreenH(54)));
        }];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageAciton:)];
        [imageV addGestureRecognizer:tap];
        
        if (self.imageArr.count > 3) {
            if (i == self.imageArr.count-1) {
                 imageV.hidden = YES;
            }
           
        }
        
        if ( i != self.imageArr.count-1) {
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [markView addSubview:delBtn];
            delBtn.tag = 250+i;
            [delBtn setImage:[UIImage imageNamed:@"ico_off"] forState:UIControlStateNormal];
            [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageV.mas_top);
                make.right.equalTo(imageV.mas_right);
            }];
            [delBtn addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
}
//删除
-(void)delImage:(UIButton *) sender{
    
    NSInteger delIndex = sender.tag-250;
    
    [self.imageArr removeObjectAtIndex:delIndex];
    
    UIView *markView =  [self viewWithTag:300];
    for(UIImageView *imageView in [markView subviews])
    {
        [imageView removeFromSuperview];
    }
    [self updateUI];
}



@end
