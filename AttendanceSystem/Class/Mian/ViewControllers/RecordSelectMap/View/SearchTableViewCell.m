//
//  SearchTableViewCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/31.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageV;

@end


@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    self.titleLab.text = dict[@"title"];
    self.subTitleLab.text = dict[@"subTitle"];
    if ([dict[@"isSelect"] isEqualToString:@"1"]) {
        _selectImageV.hidden = NO;
    }else{
        _selectImageV.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
