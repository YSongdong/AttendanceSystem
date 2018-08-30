//
//  ShowSiftMessageTypeView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/9.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowSiftMessageTypeView.h"

@implementation ShowSiftMessageTypeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    __weak typeof(self) weakSelf = self;
    
    UIView *bigBgView = [[UIView alloc]init];
    [self addSubview:bigBgView];
    bigBgView.backgroundColor = [UIColor blackColor];
    bigBgView.alpha = 0.35;
    [bigBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [bigBgView addGestureRecognizer:tap];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(weakSelf);
        make.height.equalTo(@(KSIphonScreenH(362)));
    }];
    
    NSArray *arr = @[@"请选择需要筛选的消息类型",@"全部消息",@"考勤打卡",@"外出审批",@"请假审批",@"加班审批",@"其他"];
    for (int i=0; i<arr.count ; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgView addSubview:btn];
        btn.frame = CGRectMake(0, i*KSIphonScreenH(44)+i*1, KScreenW, KSIphonScreenH(44));
        btn.titleLabel.font = Font(18);
        btn.titleLabel.textAlignment  = NSTextAlignmentCenter;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        if (i == 0) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
        }else{
            btn.backgroundColor = [UIColor colorTextWhiteColor];
            [btn setTitleColor:[UIColor colorTextBg28BlackColor] forState:UIControlStateNormal];
        }
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(selectdBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorTextBg28BlackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Font(18);
    cancelBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bgView);
        make.height.equalTo(@(KSIphonScreenH(44)));
    }];
    [cancelBtn addTarget:self action:@selector(selectCancelActtion:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)selectTap{
    [self removeFromSuperview];
}

-(void)selectCancelActtion:(UIButton *) sender{
    [self removeFromSuperview];
}
//选择筛选条件
-(void)selectdBtnAction:(UIButton *) sender{
    switch (sender.tag - 200) {
        case 1:{
            self.selectType(@"0");
            break;
        }
        case 2:{
            self.selectType(@"1");
            break;
        }
        case 3:{
            self.selectType(@"2");
            break;
        }
        case 4:{
            self.selectType(@"3");
            break;
        }
        case 5:{
             self.selectType(@"5");
            break;
        }
        case 6:{
             self.selectType(@"6");
            break;
        }
        default:
            break;
    }
   [self removeFromSuperview];
}



@end
