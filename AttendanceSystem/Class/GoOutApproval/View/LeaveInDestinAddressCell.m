//
//  LeaveInDestinAddressCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "LeaveInDestinAddressCell.h"

@interface LeaveInDestinAddressCell ()

//点击选择地点
@property (weak, nonatomic) IBOutlet UIButton *selectSettingAddressBtn;


//重新选择地址
@property (weak, nonatomic) IBOutlet UIButton *againSelectAddressBtn;

@end

@implementation LeaveInDestinAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectSettingAddressBtn.layer.cornerRadius =3;
    self.selectSettingAddressBtn.layer.masksToBounds = YES;
    self.selectSettingAddressBtn.layer.borderWidth = 1;
    self.selectSettingAddressBtn.layer.borderColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    
    //开始设置地点
    [self.selectSettingAddressBtn addTarget:self action:@selector(selectSettingAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.againSelectAddressBtn addTarget:self action:@selector(selectSettingAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.showAddressLab.text isEqualToString:@""]) {
        self.selectSettingAddressBtn.hidden = NO;
        self.showAddressLab.hidden = YES;
        self.showAddressBtn.hidden = YES;
        self.againSelectAddressBtn.hidden = YES;
    }else{
        self.selectSettingAddressBtn.hidden = YES;
        self.showAddressLab.hidden = NO;
        self.showAddressBtn.hidden = NO;
        self.againSelectAddressBtn.hidden = NO;
    }
}
//选择地点
-(void)selectSettingAddressAction:(UIButton *) sender{
    self.selectAddressBlock();
}

-(void)addAddressUpdateUI:(NSString *)addressStr{
    self.selectSettingAddressBtn.hidden = YES;
    self.showAddressLab.hidden = NO;
    self.showAddressBtn.hidden = NO;
    self.againSelectAddressBtn.hidden = NO;
    self.showAddressLab.text = addressStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
