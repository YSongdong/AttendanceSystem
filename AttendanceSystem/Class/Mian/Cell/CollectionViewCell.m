//
//  CollectionViewCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/8/1.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *samilBgView;
//层级lab

@property (weak, nonatomic) IBOutlet UILabel *showLevelLab;

@end


@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.coverImageV.layer.cornerRadius = CGRectGetWidth(self.coverImageV.frame)/2;
    self.coverImageV.layer.masksToBounds = YES;
    
    self.samilBgView.layer.cornerRadius = 3;
    self.samilBgView.layer.masksToBounds = YES;
    
    // Initialization code
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    //主管
    self.showLevelLab.text = [NSString stringWithFormat:@"第%@级主管",dict[@"level"]];
    
    NSArray *arr = dict[@"user"];
    if (arr.count == 1) {
        NSDictionary *nameDict = arr[0];
        [UIImageView sd_setImageView:self.coverImageV WithURL:nameDict[@"photo"]];
        NSString *nameStr = nameDict[@"realName"];
        self.nameLab.text = nameStr;
        return;
    }
    NSMutableString *nameStr = [NSMutableString new];
    for (int i=0; i<arr.count; i++) {
        NSDictionary *nameDict = arr[i];
        [nameStr appendString:nameDict[@"realName"]];
        if (i != arr.count-1) {
           [nameStr appendString:@"/"];
        }
        if (i == 0) {
           [UIImageView sd_setImageView:self.coverImageV WithURL:nameDict[@"photo"]];
        }
    }
     self.nameLab.text = nameStr;
}




@end
