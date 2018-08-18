//
//  ApprovarReasonCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ApprovarReasonCell.h"

@interface ApprovarReasonCell ()<UITextViewDelegate>



@end


@implementation ApprovarReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cellTextView.delegate = self;
    self.cellTextView.returnKeyType = UIReturnKeyDone;

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        
        if (textView.text.length == 0) {
            self.showPropentReasonLab.hidden = NO;
        }else{
            self.showPropentReasonLab.hidden = YES;
        }
        
        self.reasonBlock(textView.text);
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }

    if (text.length > 0) {
        self.showPropentReasonLab.hidden = YES;
    }else{
        if (self.cellTextView.text.length == 0) {
            self.showPropentReasonLab.hidden = NO;
        }
    }
    if (self.cellTextView.text.length > 60) {
        return NO;
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
