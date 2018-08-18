//
//  AnnouncentTableViewCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/17.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AnnouncentTableViewCell.h"

@implementation AnnouncentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    //时间
    self.timeLab.text = dict[@"updateTime"];
    
    //内容
    NSString *contentStr = [NSString stringWithFormat:@"【通知】: %@",dict[@"content"]];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString: contentStr];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"ico_ad"]; //设置图片源
    textAttachment.bounds = CGRectMake(0, -8, 27, 27);                 //设置图片位置和大小
    NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment: textAttachment];
    [attributedStr insertAttributedString: attrStr atIndex: 0]; //NSTextAttachment占用一个字符长度，插入后原字符串长度增加1
    
    //设置字体
    [attributedStr addAttribute:NSFontAttributeName value:
     BFont(14) range:NSMakeRange(0, 7)];
    //设置字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:
     [UIColor colorTextBg28BlackColor] range:NSMakeRange(0, 7)];
    
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
    
    self.contentLab.attributedText = attributedStr;
    
}
//计算高度
+(CGFloat) getWithCellHeight:(NSDictionary *) dict{
    CGFloat heigth = 22+21+22+17;
   
    
    
    return heigth;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
