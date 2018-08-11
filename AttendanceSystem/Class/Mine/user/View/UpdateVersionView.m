//
//  UpdateVersionView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/10.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "UpdateVersionView.h"

@interface UpdateVersionView ()

@property (nonatomic,strong)  UILabel *promptSubjLab;

@end


@implementation UpdateVersionView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
        [self checkVersion];
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectdTap)];
    [bgView addGestureRecognizer:tap];
    
    
    UIView *samilView = [[UIView alloc]init];
    [self addSubview:samilView];
    samilView.backgroundColor = [UIColor colorWithHexString:@"#e9e9e9"];
    
    [samilView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(60);
        make.right.equalTo(weakSelf).offset(-60);
        make.height.equalTo(@160);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    samilView.layer.cornerRadius = 8;
    samilView.layer.masksToBounds  = YES;
    
    UIView *subView = [[UIView alloc]init];
    [samilView addSubview:subView];
    subView.backgroundColor = [UIColor colorTextWhiteColor];
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(samilView);
        make.height.equalTo(@40);
        make.centerX.equalTo(samilView.mas_centerX);
    }];
    
    self.promptSubjLab = [[UILabel alloc]init];
    [subView addSubview:self.promptSubjLab];
    self.promptSubjLab.font = [UIFont boldSystemFontOfSize:17];
    self.promptSubjLab.textColor =[UIColor colorTextBg28BlackColor];
    [self.promptSubjLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(subView.mas_centerX);
        make.centerY.equalTo(subView.mas_centerY);
    }];
    
    UIView *contentView = [[UIView alloc]init];
    [samilView addSubview:contentView];
    contentView.backgroundColor = [UIColor colorTextWhiteColor];
    
    UILabel *contentLab = [[UILabel alloc]init];
    [contentView addSubview:contentLab];
    contentLab.text = @"1.新增任务中心功能 /n 2.优化用户体验 /n 3.修复已知bug";
    contentLab.textColor = [UIColor colorTextBg28BlackColor];
    contentLab.font = Font(14);
    contentLab.numberOfLines = 0;
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(19);
        make.top.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-19);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subView.mas_bottom).offset(1);
        make.right.left.equalTo(samilView);
        make.bottom.equalTo(contentLab.mas_bottom).offset(-10);
    }];
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [samilView addSubview:updateBtn];
    [updateBtn setTitle:@"立即升级" forState:UIControlStateNormal];
    [updateBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    updateBtn.titleLabel.font = Font(16);
    updateBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(1);
        make.left.bottom.equalTo(samilView);
    }];
    [updateBtn addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [samilView addSubview:nextBtn];
    [nextBtn setTitle:@"下次再说" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = Font(16);
    nextBtn.backgroundColor = [UIColor colorTextWhiteColor];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(updateBtn.mas_top);
        make.left.equalTo(updateBtn.mas_right).offset(1);
        make.right.equalTo(samilView);
        make.width.height.equalTo(updateBtn);
        make.centerY.equalTo(updateBtn.mas_centerY);
    }];
   [nextBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void) selectdTap{
    [self removeFromSuperview];
}
-(void)cancelAction:(UIButton *) sender{
    [self selectdTap];
}
-(void)updateAction:(UIButton *) sender{
    self.updateBlock();
    [self selectdTap];
}
//检查更新
-(void)checkVersion
{
    NSString *newVersion;
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=1422609325"];//这个URL地址是该app在iTunes connect里面的相关配置信息。其中id是该app在app store唯一的ID编号。
    NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    // NSLog(@"通过appStore获取的数据信息：%@",jsonResponseString);
    
    NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
    
    if (data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *array = json[@"results"];
        
        for (NSDictionary *dic in array) {
            
            newVersion = [dic valueForKey:@"version"];
        }
        self.promptSubjLab.text = [NSString stringWithFormat:@"发现新版本%@版",newVersion];
    }
    
}



@end
