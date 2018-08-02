//
//  ApprovalSelectPhotoCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ApprovalSelectPhotoCell.h"

@implementation ApprovalSelectPhotoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView{
    
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.tag = 300;
    bgView.backgroundColor = [UIColor colorTextWhiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(9);
        make.right.left.bottom.equalTo(weakSelf);
    }];
    
    UILabel *showLab = [[UILabel alloc]init];
    [bgView addSubview:showLab];
    showLab.textColor = [UIColor colorTextBg28BlackColor];
    showLab.font = Font(16);
    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(12);
        make.top.equalTo(weakSelf).offset(22);
    }];
    NSString *str = @"图片 (选填)";
    NSMutableAttributedString *attribuStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attribuStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#c3c3c3"] range:NSMakeRange(3, str.length-3)];
    showLab.attributedText =  attribuStr;
    
    _imageArr  =[NSMutableArray array];
    //添加默认图片
    [self.imageArr addObject:[UIImage imageNamed:@"att_attendance_dialogmsg_add"]];
    for (int i=0; i<self.imageArr.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        [bgView addSubview:imageV];
        imageV.image = self.imageArr[i];
        imageV.tag =  200+i;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(12+i*54+i*10);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-17);
            make.width.height.equalTo(@54);
        }];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImageAciton:)];
        [imageV addGestureRecognizer:tap];
    }

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
//更新UI
-(void)updateUI{
    
    UIView *markView =  [self viewWithTag:300];
    for (int i=0; i<self.imageArr.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        [markView addSubview:imageV];
        imageV.image = self.imageArr[i];
        imageV.tag =  200+i;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(markView).offset(12+i*54+i*10);
            make.bottom.equalTo(markView.mas_bottom).offset(-17);
            make.width.height.equalTo(@54);
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
    for(UIView *view in [markView subviews])
    {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView*)view;
            [imageView removeFromSuperview];
        }
        
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)view;
            [btn removeFromSuperview];
        }
        
    }
    [self updateUI];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
