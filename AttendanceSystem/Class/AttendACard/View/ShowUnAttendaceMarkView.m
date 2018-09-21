//
//  ShowUnAttendaceMarkView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/9/10.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowUnAttendaceMarkView.h"

@interface ShowUnAttendaceMarkView ()
<
UITextViewDelegate
>
//提示信息
@property (nonatomic,strong) UILabel *placeStrLab;
//备注textview
@property (nonatomic,strong) UITextView *markTeView;
//
@property (nonatomic,strong)UIButton  *trueSubmitBtn;

@end


@implementation ShowUnAttendaceMarkView

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
        make.height.equalTo(@(KSIphonScreenH(240)));
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
    
    UIView *markView = [[UIView alloc]init];
    [samilView addSubview:markView];
    markView.tag = 300;
    markView.backgroundColor =[UIColor colorTextWhiteColor];
    [markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom).offset(1);
        make.right.left.equalTo(samilView);
        make.height.equalTo(@(KSIphonScreenH(139)));
        make.left.equalTo(titleView.mas_left);
        make.centerX.equalTo(titleView.mas_centerX);
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
    if (self.markTeView.text.length > 60) {
        return NO;
    }
    return YES;
}

-(void)selelctBigTap{
    [self removeFromSuperview];
}
-(void)selelctTap{
    [self.markTeView resignFirstResponder];
}
-(void)setIsLookMark:(BOOL)isLookMark{
    _isLookMark = isLookMark;
}
-(void)setIdStr:(NSString *)idStr{
    _idStr = idStr;
}
-(void)addImageAciton:(UITapGestureRecognizer *) tap{
    if (self.imageArr.count <5) {
        if (self.dict != nil) {
            UIImageView *imageV = (UIImageView *)tap.view;
            [XWScanImage scanBigImageWithImageView:imageV];
        }else{
            NSInteger index = tap.view.tag - 200;
            if (index != self.imageArr.count-1) {
                UIImageView *imageV = (UIImageView *)tap.view;
                [XWScanImage scanBigImageWithImageView:imageV];
            }else{
                self.selectPhotoBlock();
            }
        }
    }
}
//确定按钮
-(void)trueSubmitTction:(UIButton *) sender{
    //查看备注
    if (self.isLookMark) {
        [self removeFromSuperview];
        return;
    }else{
        //添加备注
        if (self.markTeView.text.length == 0 && _imageArr.count -1 == 0) {
            [SDShowSystemPrompView showSystemPrompStr:@"请补充备注信息"];
            return;
        }
        //添加备注
        [self requestAddMarkData];
    }

   
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
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    UIView *markView = [self viewWithTag:300];
    //照片
    NSArray *photoArr = dict[@"photo"];
    if (photoArr.count != 0) {
        for (int i=1; i<photoArr.count; i++) {
            UIImageView *imageV = [[UIImageView alloc]init];
            [markView addSubview:imageV];
            imageV.tag =  200+i;
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(markView).offset(KSIphonScreenW(15)+i*KSIphonScreenH(54)+i*KSIphonScreenW(10));
                make.bottom.equalTo(markView.mas_bottom).offset(-KSIphonScreenW(10));
                make.width.height.equalTo(@(KSIphonScreenH(54)));
            }];
            imageV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageAciton:)];
            [imageV addGestureRecognizer:tap];
        }
    }
    //移除imageV 的内容
    for (int i=0; i<3; i++) {
        UIImageView *imageV = [self viewWithTag:(200+i)];
        imageV.image = nil;
    }
    
    if (photoArr.count != 0) {
        for (int i=0; i<photoArr.count; i++) {
            NSString *photoUrl = photoArr[i];
            UIImageView *imageV = [self viewWithTag:(200+i)];
            [SDTool sd_setImageView:imageV WithURL:photoUrl];
        }
    }else{
        for (int i=0; i<3; i++) {
            UIImageView *imageV = [self viewWithTag:(200+i)];
            imageV.image = nil;
        }
    }
    //备注类型，
    self.markTeView.text = @"";
    self.markTeView.editable = YES;
    NSString *markStr = dict[@"remark"];
    
    for (int i=0; i<3; i++) {
        UIImageView *imageV = [self viewWithTag:(200+i)];
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
   
//        if (photoArr.count > 0) {
//            for (int i=0; i < photoArr.count; i++) {
//                UIImageView *imageV = [self viewWithTag:(200+i)];
//                imageV.userInteractionEnabled = YES;
//                NSString *photoUrl = photoArr[i];
//                [SDTool sd_setImageView:imageV WithURL:photoUrl];
//                imageV.hidden = YES;
//            }
//        }
        for (int i=0; i<3; i++) {
            UIImageView *imageV = [self viewWithTag:(200+i)];
            if (photoArr.count > 0) {
                imageV.userInteractionEnabled = YES;
            }else{
                imageV.userInteractionEnabled = NO;
                
            }
        }
        [self.trueSubmitBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [self.trueSubmitBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
        
    }else{
        
        //添加备注
        self.placeStrLab.hidden = NO;
        [self.trueSubmitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        [self.trueSubmitBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    }
}
#pragma mark ----数据相关-----
-(void) requestAddMarkData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"id"] = self.idStr;
    param[@"remark"] = self.markTeView.text;
    param[@"token"] = [SDTool getNewToken];
    param[@"userId"] = [SDUserInfo obtainWithUserId];
    //移除最后一个
    [_imageArr removeLastObject];
    
    [[KRMainNetTool sharedKRMainNetTool]upLoadData:HTTP_APPATTENDFACERRECORDREMARK_URL params:param.copy andData:_imageArr waitView:self complateHandle:^(id showdata, NSString *error) {
        
        if (error) {
            [SDShowSystemPrompView showSystemPrompStr:error];
            return ;
        }
//        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
//        mutableDict[@"remark"] =self.markTeView.text;
        
        self.addMarkBlock();
        [self removeFromSuperview];
    }];
    
}


@end
