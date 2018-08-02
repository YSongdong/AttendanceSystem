//
//  UILabel+SDChangLineSpace.m
//  SDSafetyManageControl
//
//  Created by tiao on 2018/6/11.
//  Copyright © 2018年 tiao. All rights reserved.
//

#import "UILabel+SDChangLineSpace.h"

@implementation UILabel (SDChangLineSpace)

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}


@end
