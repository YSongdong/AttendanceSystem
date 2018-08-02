//
//  CustomAnnotationView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/20.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "CustomAnnotationView.h"



#define kCalloutWidth       148.0
#define kCalloutHeight      37.0
@interface CustomAnnotationView ()

@end

@implementation CustomAnnotationView
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    if (self.selected == selected)
//    {
//        return;
//    }
//
//    if (selected)
//    {
//        if (self.calloutView == nil)
//        {
//            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
//        }
//
//        self.calloutView.leftImageV.image = [UIImage imageNamed:@"dqdw_pic-xz"];
//        self.calloutView.concetLab.text = @"已进入考勤范围";
//
//        [self addSubview:self.calloutView];
//    }
//    else
//    {
//        [self.calloutView removeFromSuperview];
//    }
//
//    [super setSelected:selected animated:animated];
//}

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];

    if (self)
    {
        self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x+18,
                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        self.calloutView.leftImageV.image = [UIImage imageNamed:@"dqdw_pic-xz"];
        self.calloutView.concetLab.text = @"已进入考勤范围";

        [self addSubview:self.calloutView];
    }

    return self;
}


@end
