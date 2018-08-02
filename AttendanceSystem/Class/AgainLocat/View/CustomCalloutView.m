//
//  CustomCalloutView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/20.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "CustomCalloutView.h"


#define kArrorHeight        10

@interface  CustomCalloutView ()


@end


@implementation CustomCalloutView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}
-(void) createView{
    
    __weak typeof(self) weakSelf = self;
    
    self.leftImageV = [[UIImageView alloc]init];
    [self addSubview:self.leftImageV];
    self.leftImageV.image  = [UIImage imageNamed:@"dqdw_pic-xz"];
    [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(16);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(-5);
    }];
    
    self.concetLab =  [[UILabel alloc]init];
    [self addSubview:self.concetLab];
    self.concetLab.text = @"已进入考勤范围";
    self.concetLab.textColor = [UIColor colorTextWhiteColor];
    self.concetLab.font = Font(13);
    [self.concetLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImageV.mas_right).offset(7);
        make.centerY.equalTo(weakSelf.leftImageV.mas_centerY);
        make.right.equalTo(weakSelf).offset(-16);
    }];
}

-(void)drawRect:(CGRect)rect{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor colorCommonGreenColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}
- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorCommonGreenColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}



@end
