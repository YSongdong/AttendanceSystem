//
//  CustomAnnotationView.h
//  AttendanceSystem
//
//  Created by tiao on 2018/7/20.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

#import "CustomCalloutView.h"
@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, strong) CustomCalloutView *calloutView;

@end
