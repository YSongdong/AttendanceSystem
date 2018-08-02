//
//  AtttendScopeTableViewCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/19.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "AtttendScopeTableViewCell.h"

@interface  AtttendScopeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
//状态图片
@property (weak, nonatomic) IBOutlet UIImageView *statuImageV;

//是否在范围
@property (weak, nonatomic) IBOutlet UILabel *scopeLab;

@end

@implementation AtttendScopeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDict:(NSDictionary *)dict{
    _dict =  dict;
    self.statuImageV.hidden = NO;
    self.leftImageV.hidden = NO;
    
    if ([dict[@"isScope"] isEqualToString:@"1"]) {
        self.leftImageV.hidden = NO;
        self.scopeLab.text = @"在范围内";
    }else{
        self.leftImageV.hidden = YES;
        
        if ([dict[@"distance"]doubleValue]> 1000) {
            self.scopeLab.text = [NSString stringWithFormat:@"不范围内(%.2fkm)",[dict[@"distance"]doubleValue]/1000];
        }else{
            self.scopeLab.text = [NSString stringWithFormat:@"不范围内(%.2fm)",[dict[@"distance"]doubleValue]];
        }

    }
    
    NSString *isGoStr = [NSString stringWithFormat:@"%@",dict[@"isGo"]];
    if ([isGoStr isEqualToString:@"1"]) {
        //正常
        self.statuImageV.hidden = YES;
        
//        [self.addressLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf.leftImageV.mas_right).offset(8);
//            make.centerY.equalTo(weakSelf.leftImageV.mas_centerY);
//        }];

    }else if ([isGoStr isEqualToString:@"2"]){
        //外勤
        self.statuImageV.hidden = NO;
        self.statuImageV.image = [UIImage imageNamed:@"pic_wq"];
        
    }else if([isGoStr isEqualToString:@"3"]){
        //公共
        self.statuImageV.hidden = NO;
        self.statuImageV.image = [UIImage imageNamed:@"pic_GG"];
    }
    self.addressLab.text = dict[@"title"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
