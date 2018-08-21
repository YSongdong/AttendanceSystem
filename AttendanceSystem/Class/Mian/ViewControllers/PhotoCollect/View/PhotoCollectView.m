//
//  PhotoCollectView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/12.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "PhotoCollectView.h"

@implementation PhotoCollectView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorBgGreyColor];
    
    UIImageView *bgImageV = [[UIImageView alloc]init];
    [self addSubview:bgImageV];
    if (KIsiPhoneX) {
        bgImageV.image = [UIImage imageNamed:@"cjzp_nav_bg"];
    }else{
        bgImageV.image = [UIImage imageNamed:@"nav_bg"];
    }
    [bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf);
        make.height.equalTo(@(KSNaviTopHeight+50));
    }];

    UILabel *titleLab  =[[UILabel alloc]init];
    [self addSubview:titleLab];
    titleLab.textColor = [UIColor colorTextWhiteColor];
    titleLab.text = @"用户留底照片采集";
    titleLab.font = Font(16);
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgImageV.mas_centerX);
        make.top.equalTo(weakSelf).offset(KSStatusHeight+20);
    }];
    
    self.backBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.backBtn];
    [self.backBtn setImage:[UIImage imageNamed:@"nav_ico_back"] forState:UIControlStateNormal];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(5);
        make.centerY.equalTo(titleLab.mas_centerY);
        make.width.height.equalTo(@44);
    }];
    
    UIView *headerView = [[UIView alloc]init];
    [self addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(KSNaviTopHeight+8);
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(25));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(25));
        make.height.equalTo(@(KSIphonScreenH(290)));
    }];
    
    UIImageView *bigHeaderImageV = [[UIImageView alloc]init];
    [headerView addSubview:bigHeaderImageV];
    bigHeaderImageV.image = [UIImage imageNamed:@"zpcj_bg_sbyy"];
    [bigHeaderImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    
    UIImageView *lineImageV = [[UIImageView alloc]init];
    [headerView addSubview:lineImageV];
    lineImageV.image =[UIImage imageNamed:@"line"];
    [lineImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerView).offset(-KSIphonScreenH(50));
        make.centerX.equalTo(headerView.mas_centerX);
    }];
    
    //失败原因
    self.errorLab = [[UILabel alloc]init];
    [headerView addSubview:self.errorLab];
    self.errorLab.text = @"失败原因：";
    self.errorLab.font = Font(12);
    self.errorLab.textColor = [UIColor colorWithHexString:@"#989898"];
    self.errorLab.numberOfLines = 2;
    self.errorLab.textAlignment = NSTextAlignmentCenter;
    [self.errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(KSIphonScreenW(18));
        make.right.equalTo(headerView).offset(-KSIphonScreenW(18));
        make.top.equalTo(lineImageV.mas_bottom).offset(11);
    }];
    self.errorLab.hidden = YES;
    
    self.headerMarkLab = [[UILabel alloc]init];
    [headerView addSubview:self.headerMarkLab];
    self.headerMarkLab.text = @"用户留底照片采集";
    self.headerMarkLab.font = Font(16);
    self.headerMarkLab.textAlignment =  NSTextAlignmentCenter;
    self.headerMarkLab.textColor = [UIColor colorTextBg28BlackColor];
    [self.headerMarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(KSIphonScreenH(22));
        make.left.equalTo(headerView).offset(KSIphonScreenW(5));
        make.right.equalTo(headerView).offset(-KSIphonScreenW(5));
        make.centerX.equalTo(headerView.mas_centerX);
    }];
    
    self.headerImageV = [[UIImageView alloc]init];
    [headerView addSubview:self.headerImageV];
    self.headerImageV.image = [UIImage imageNamed:@"pic-1"];
    [self.headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineImageV.mas_top);
        make.centerX.equalTo(headerView.mas_centerX);
        make.width.height.equalTo(@(KSIphonScreenW(174)));
    }];
    
    self.chenkStatuImageV = [[UIImageView alloc]init];
    [self.headerImageV addSubview:self.chenkStatuImageV];
    self.chenkStatuImageV.image = [UIImage imageNamed:@""];
    [self.chenkStatuImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerImageV.mas_top);
        make.right.equalTo(weakSelf.headerImageV.mas_right);
    }];
   
    UIImageView *markIamgeV = [[UIImageView alloc]init];
    [self addSubview:markIamgeV];
    markIamgeV.image = [UIImage imageNamed:@"photoIco_01"];
    [markIamgeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(KSIphonScreenH(30));
        make.left.equalTo(headerView.mas_left);
        make.width.equalTo(@(KSIphonScreenW(11)));
    }];
    
    UILabel *markLab = [[UILabel alloc]init];
    [self addSubview:markLab];
    markLab.text = @"图片说明";
    markLab.font =Font(16);
    markLab.textColor = [UIColor colorWithHexString:@"#37b682"];
    [markLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markIamgeV.mas_right).offset(7);
        make.centerY.equalTo(markIamgeV.mas_centerY);
    }];
    
    UILabel *oneLab = [[UILabel alloc]init];
    [self addSubview:oneLab];
    oneLab.text = @"1.  请按示例图片要求上传您的留底照片。";
    oneLab.font = Font(14);
    oneLab.textColor = [UIColor colorTextBg98BlackColor];
    [oneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markLab.mas_left);
        make.top.equalTo(markLab.mas_bottom).offset(KSIphonScreenW(15));
    }];
    
    UILabel *twoLab = [[UILabel alloc]init];
    [self addSubview:twoLab];
    twoLab.text = @"2.  该照片将引用于系统考试、考勤签到等重要场景进行身份验证，不可随意修改。";
    twoLab.font = Font(14);
    twoLab.numberOfLines = 0;
    [UILabel changeLineSpaceForLabel:twoLab WithSpace:5];
    twoLab.textColor = [UIColor colorTextBg98BlackColor];
    [twoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markLab.mas_left);
        make.top.equalTo(oneLab.mas_bottom).offset(8);
        make.right.equalTo(headerView.mas_right);
    }];
    
    UILabel *treeLab = [[UILabel alloc]init];
    [self addSubview:treeLab];
    treeLab.text = @"3.  请确保照片清晰有效，谨慎上传。";
    treeLab.font = Font(14);
    treeLab.numberOfLines = 0;
    treeLab.textColor = [UIColor colorTextBg98BlackColor];
    [treeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(markLab.mas_left);
        make.top.equalTo(twoLab.mas_bottom).offset(8);
        make.right.equalTo(twoLab.mas_right);
    }];
    
    self.beginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.beginBtn];
    [self.beginBtn setBackgroundImage:[UIImage imageNamed:@"btn_01"] forState:UIControlStateNormal];
    [self.beginBtn setTitle:@"开始采集" forState:UIControlStateNormal];
    [self.beginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.beginBtn.titleLabel.font = Font(16);
    [self.beginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(treeLab.mas_bottom).offset(KSIphonScreenH(55));
        make.left.equalTo(weakSelf).offset(KSIphonScreenW(25));
        make.right.equalTo(weakSelf).offset(-KSIphonScreenW(25));
        make.height.equalTo(@(KSIphonScreenH(44)));
    }];
    [self.beginBtn addTarget:self action:@selector(beginBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.updataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.updataBtn];
    [self.updataBtn setTitle:@"立即上传" forState:UIControlStateNormal];
    [self.updataBtn setTitleColor:[UIColor colorCommonGreenColor] forState:UIControlStateNormal];
    self.updataBtn.titleLabel.font = Font(16);
    [self.updataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.beginBtn.mas_bottom).offset(KSIphonScreenH(16));
        make.left.height.right.equalTo(weakSelf.beginBtn);
        make.centerX.equalTo(weakSelf.beginBtn.mas_centerX);
    }];
    self.updataBtn.layer.cornerRadius = 22;
    self.updataBtn.layer.masksToBounds = YES;
    self.updataBtn.layer.borderWidth = 1;
    self.updataBtn.layer.borderColor = [UIColor colorCommonGreenColor].CGColor;
    
    [self.updataBtn addTarget:self action:@selector(updateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.updataBtn.hidden = YES;
    
}
//开始采集
-(void)beginBtnAciton:(UIButton *) sender{
    self.beginBlock();
}
//立即上传
-(void)updateBtnAction:(UIButton *) sender{
    self.updateBlock();
}
-(void)setChenkErrorStr:(NSString *)chenkErrorStr{
    _chenkErrorStr = chenkErrorStr;
}
//0: 未上传 1:未审核 2:未通过 3:已审核'
-(void) upatePhotoViewStatu:(NSString *)statu{
    if ([statu isEqualToString:@"1"]) {
        //待审核
        self.chenkStatuImageV.image = [UIImage imageNamed:@"photo_pic"];
        //显示头像
        NSString *url =[SDUserInfo obtainWithPhoto];
        [UIImageView sd_setImageView:self.headerImageV WithURL:url];
        //隐藏失败原因
        self.errorLab.hidden = YES;
        //隐藏采集按钮
        self.beginBtn.hidden = YES;
    
        NSString *nameStr = @"留底照片已提交，等待管理员审核";
        //设置富文本
        NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:nameStr];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, [UIColor colorWithHexString:@"#ffb046"],NSForegroundColorAttributeName,nil];
        [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
        
        //添加图片
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"ico_dsh"];
        attach.bounds = CGRectMake(-5, -5, 20, 20);
        NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
        [attributeStr1 insertAttributedString:attributeStr2 atIndex:0];
        
        self.headerMarkLab.attributedText = attributeStr1;
        
    }else if ([statu isEqualToString:@"3"]) {
        //已通过
        self.chenkStatuImageV.image = [UIImage imageNamed:@"zpcj_pic_ytg"];
        //显示头像
        [UIImageView sd_setImageView:self.headerImageV WithURL:[SDUserInfo obtainWithPhoto]];
        //隐藏失败原因
        self.errorLab.hidden = YES;
        //隐藏采集按钮
        self.beginBtn.hidden = YES;
        
        NSString *nameStr =@"用户留底照片认证已通过";
        //设置富文本
        NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:nameStr];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, [UIColor colorWithHexString:@"#3dbafd"],NSForegroundColorAttributeName,nil];
        [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
        
        //添加图片
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"zpcj_ico_ytg"];
        attach.bounds = CGRectMake(-5, -5, 20, 20);
        NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
        [attributeStr1 insertAttributedString:attributeStr2 atIndex:0];
        
        self.headerMarkLab.attributedText = attributeStr1;
        
    }else if ([statu isEqualToString:@"2"]){
        //未通过
        self.chenkStatuImageV.image = [UIImage imageNamed:@"zpcj_pic_wtg"];
        //显示头像
        [UIImageView sd_setImageView:self.headerImageV WithURL:[SDUserInfo obtainWithPhoto]];
        
        //显示失败原因
        self.errorLab.hidden = NO;
        
         self.errorLab.text = [NSString stringWithFormat:@"失败原因：%@",self.chenkErrorStr];
        
        NSString *nameStr =@"用户留底照片认证未通过";
        //设置富文本
        NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:nameStr];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, [UIColor colorWithHexString:@"#f75254"],NSForegroundColorAttributeName,nil];
        [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];

        //添加图片
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"zpcj_ico_wtg"];
        attach.bounds = CGRectMake(-5, -5, 20, 20);
        NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
        [attributeStr1 insertAttributedString:attributeStr2 atIndex:0];
        
        self.headerMarkLab.attributedText = attributeStr1;
    }
    
    
}
@end
