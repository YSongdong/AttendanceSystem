//
//  ApprovalRecordCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ApprovalRecordCell.h"

@interface ApprovalRecordCell ()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *coverImageV;

//审核状态
@property (weak, nonatomic) IBOutlet UILabel *chenkStatuLab;
//显示时间
@property (weak, nonatomic) IBOutlet UILabel *showTimeLab;
//开始时间
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLab;
//结束时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
//原因
@property (weak, nonatomic) IBOutlet UILabel *cellReasonLab;

@end

@implementation ApprovalRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.coverImageV.layer.cornerRadius = CGRectGetWidth(self.coverImageV.frame)/2;
    self.coverImageV.layer.masksToBounds = YES;
    
}

-(void)setCellType:(RecordCellType)cellType{
    _cellType = cellType;
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.cellReasonLab.hidden=  NO;
    
    //头像
    [UIImageView sd_setImageView:self.coverImageV WithURL:[SDUserInfo obtainWithPhoto]];
   
    //申请状态
    NSString *statusStr = [NSString stringWithFormat:@"%@",dict[@"status"]];
    
    if ([statusStr isEqualToString:@"2"]) {
        //不通过
        self.chenkStatuLab.text = @"审核未通过";
        self.chenkStatuLab.textColor = [UIColor colorWithHexString:@"#f75354"];
    }else if ([statusStr isEqualToString:@"3"]){
        //通过
        self.chenkStatuLab.text = @"审核通过";
        self.chenkStatuLab.textColor = [UIColor colorCommonGreenColor];
    }else if ([statusStr isEqualToString:@"4"]){
        // 4：用户撤回
        self.chenkStatuLab.text = @"申请已撤销";
        self.chenkStatuLab.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    }else if ([statusStr isEqualToString:@"1"]){
        //审核中
        NSArray *arr = dict[@"approvalUser"];
        NSMutableString *mutaleStr = [NSMutableString new];
        if (arr.count > 0) {
            for (int i=0; i< arr.count; i++) {
                NSDictionary *dic = arr[i];
                NSString *str =dic[@"realName"];
                [mutaleStr appendString:str];
                if (i!=arr.count-1) {
                    [mutaleStr appendString:@"/"];
                }
            }
        }
        self.chenkStatuLab.text = [NSString stringWithFormat:@"等待%@审批",mutaleStr];
        self.chenkStatuLab.textColor = [UIColor colorWithHexString:@"#ffb046"];
    }
    //显示时间
    self.showTimeLab.text = dict[@"createTime"];
    
    if (_cellType == RecordCellOutType) {
        //外出
        //开始时间
        NSArray *arr = dict[@"startTime"];
        NSString *startTimeStr;
        if (arr.count > 0) {
            startTimeStr = arr[0];
        }
        //开始时间
        self.endTimeLab.text =[NSString stringWithFormat:@"开始时间: %@",startTimeStr];

        //结束时间
        self.endTimeLab.text =[NSString stringWithFormat:@"结束时间: %@",dict[@"endTime"]];
        //外出原因
        self.cellReasonLab.text =[NSString stringWithFormat:@"外出事由: %@",dict[@"outGo"]];
        
        //发起申请者
        self.showNameLab.text = [NSString stringWithFormat:@"%@的外出申请",[SDUserInfo obtainWithRealName]];
        
    }else if (_cellType == RecordCellLeaveType){
         //请假
        //请假类型
        NSString *typeStr = [NSString stringWithFormat:@"%@",dict[@"leaveType"]];
        NSString *type ;
        if ([typeStr isEqualToString:@"1"]) {
            type = @"年假";
        }else if ([typeStr isEqualToString:@"2"]){
            type = @"事假";
        }else if ([typeStr isEqualToString:@"3"]){
            type = @"调休";
        }else if ([typeStr isEqualToString:@"4"]){
            type = @"产假";
        }else if ([typeStr isEqualToString:@"5"]){
            type = @"婚假";
        }else if ([typeStr isEqualToString:@"6"]){
            type = @"丧假";
        }else if ([typeStr isEqualToString:@"0"]){
            type = @"其他";
        }
        self.beginTimeLab.text =[NSString stringWithFormat:@"请假类型: %@",type];
        NSArray *arr = dict[@"startTime"];
        NSString *startTimeStr;
        if (arr.count > 0) {
            startTimeStr = arr[0];
        }
        //开始时间
        self.endTimeLab.text =[NSString stringWithFormat:@"开始时间: %@",startTimeStr];
        //结束时间
        self.cellReasonLab.text =[NSString stringWithFormat:@"结束时间: %@",dict[@"endTime"]];
        //发起申请者
        self.showNameLab.text = [NSString stringWithFormat:@"%@的请假申请",[SDUserInfo obtainWithRealName]];
        
    }else if (_cellType == RecordCellCardType){
        //补卡
        //补卡班次
        NSArray *arr = dict[@"startTime"];
        NSMutableString *startTimeStr = [NSMutableString string];
        for (int i=0; i< arr.count; i++) {
            NSString *str = arr[i];
            [startTimeStr appendString:str];
            if (i != arr.count-1) {
               [startTimeStr appendString:@","];
            }
        }
        self.beginTimeLab.text =[NSString stringWithFormat:@"补卡班次: %@",startTimeStr];
        //开始时间
        self.endTimeLab.text =[NSString stringWithFormat:@"缺卡原因: %@",dict[@"endTime"]];
        //结束时间
        self.cellReasonLab.hidden=  YES;
        
        //发起申请者
        self.showNameLab.text = [NSString stringWithFormat:@"%@的补卡申请",[SDUserInfo obtainWithRealName]];
    }
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
