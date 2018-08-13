//
//  SDUserInfoTableViewCell.m
//  SDSafetyManageControl
//
//  Created by tiao on 2018/4/27.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "SDUserInfoTableViewCell.h"

@interface SDUserInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *tittleLab;
//副标题
@property (weak, nonatomic) IBOutlet UILabel *subheadLab;
//右边Image'
@property (weak, nonatomic) IBOutlet UIImageView *reihtImageV;

@property (weak, nonatomic) IBOutlet UIImageView *tableViewReihtImageV;
//表示性别

@property (weak, nonatomic) IBOutlet UIImageView *sixImageV;
//留底照片状态
@property (weak, nonatomic) IBOutlet UIImageView *photoStatuImageV;
@end


@implementation SDUserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.reihtImageV.layer.cornerRadius = CGRectGetWidth(self.reihtImageV.frame)/2;
    self.reihtImageV.layer.masksToBounds = YES;
}

-(void)setDict:(NSDictionary *)dict{
    _dict =  dict;

    self.tittleLab.text = dict[@"name"];

    [UIImageView sd_setImageView:self.reihtImageV WithURL:dict[@"desc"]];
    self.subheadLab.text = dict[@"desc"];
    NSString *isBindPhoneStr = [SDUserInfo obtainWithBindPhone];
    
    if (self.indexPath.section ==1 && self.indexPath.row == 5) {
        if ([isBindPhoneStr isEqualToString:@"2"]) {
            //未绑定
            self.subheadLab.textColor =[UIColor colorTextBg98BlackColor];
        }else{
            self.subheadLab.textColor =[UIColor colorTextBg65BlackColor];
        }
    }

    if (self.indexPath.section == 0) {
        NSString *photoStatu = [NSString stringWithFormat:@"%@",dict[@"photoStatus"]];
        if ([photoStatu isEqualToString:@"1"]) {
            //待审核
            self.photoStatuImageV.image = [UIImage imageNamed:@"grzx_ico_shz"];
        }else if ([photoStatu isEqualToString:@"2"]){
            //未通过
             self.photoStatuImageV.image = [UIImage imageNamed:@"grzx_ico_wtg"];
        }else if ([photoStatu isEqualToString:@"3"]){
            //审核通过
            self.photoStatuImageV.image = [UIImage imageNamed:@"grzx_ico_ytg"];
        }else{
            //未采集
            self.photoStatuImageV.image = [UIImage imageNamed:@"grzx_ico_wcj"];
        }
    }
    if (self.indexPath.section == 1 && self.indexPath.row == 0) {
        NSString *photoStatu = [NSString stringWithFormat:@"%@",dict[@"photoStatus"]];
        if ([photoStatu isEqualToString:@"0"]) {
           //未填写身份证
            self.sixImageV.hidden = YES;
        }else  if ([photoStatu isEqualToString:@"1"]) {
             self.sixImageV.hidden = NO;
            //女
            self.sixImageV.image = [UIImage imageNamed:@"grzx_pic_ns"];
        }else  if ([photoStatu isEqualToString:@"2"]) {
             self.sixImageV.hidden = NO;
            //男
            self.sixImageV.image = [UIImage imageNamed:@"grzx_pic_nh"];
        }
    }
   
}
-(void)setIsShowPlatform:(BOOL)isShowPlatform{
    _isShowPlatform = isShowPlatform;
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    //头像
    if (indexPath.section == 0 && indexPath.row == 0) {
        self.reihtImageV.hidden =  NO;
        self.subheadLab.hidden = YES;
        self.sixImageV.hidden = YES;
        self.photoStatuImageV.hidden = NO;
    }else{
        self.reihtImageV.hidden =  YES;
        self.sixImageV.hidden = YES;
        self.photoStatuImageV.hidden = YES;
    }
    
    if (indexPath.section == 1) {
        self.reihtImageV.hidden =  YES;
        self.photoStatuImageV.hidden = YES;
        if (indexPath.row == 0) {
            self.sixImageV.hidden = NO;
        }else{
             self.sixImageV.hidden = YES;
        }
        if (indexPath.row == 5 || indexPath.row ==6) {
            self.tableViewReihtImageV.hidden = NO;
        }else{
            self.tableViewReihtImageV.hidden = YES;
        }
    }
}
-(void)alterVipNameStr:(NSString *)nameStr{
    self.subheadLab.text = nameStr;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
