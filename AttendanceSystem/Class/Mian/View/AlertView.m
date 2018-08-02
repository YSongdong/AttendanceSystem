//
//  AlertView.m
//  YMDoctorProject
//
//  Created by Ray on 2017/1/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AlertView.h"
@interface AlertView()
@property (nonatomic,strong)UILabel *textLable;
@property (nonatomic,strong)UIView *loadView;

@end

@implementation AlertView


+ (AlertView *)alertViewWithSuperView:(UIView *)view
                              andData:(NSString *)message {
    AlertView *alert = [[AlertView alloc]initWithSuperView:view];
    alert.message = message ;
    return alert;
}

- (instancetype)initWithSuperView:(UIView *)view{
    self = [super init];
    self.frame = view.frame ;
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addLoadView];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    return self;
}

- (void)addLoadView {
    _loadView = [UIView new];
    _loadView.backgroundColor = [UIColor blackColor];
    _loadView.center = CGPointMake(KScreenW/2, KScreenH/2);
    _loadView.alpha = 0.35;
    _textLable = [UILabel new];
    _textLable.font = [UIFont systemFontOfSize:14];
    _textLable.numberOfLines = 0 ;
    _textLable.center = CGPointMake(KScreenW/2, KScreenH/2);
    [_loadView addSubview:_textLable];
    [self addSubview:_loadView];
}

- (void)show {
    CGSize size = [_message sizeWithBoundingSize:CGSizeMake(self.frame.size.width * 0.8,0) font:[UIFont systemFontOfSize:14 weight:1]];
    _textLable.text = _message ;
    [UIView animateWithDuration:0.2 animations:^{
        
        self->_loadView.bounds = CGRectMake(0, 0, size.width + 60 *KScreenW, size.height + 40);
        self->_textLable.bounds = CGRectMake(0, 0, size.width, size.height );
        self->_loadView.layer.cornerRadius = 8 ;
        self->_loadView.layer.masksToBounds = YES ;
        self->_textLable.center = CGPointMake(KScreenW/2, KScreenH/2);
        
    } completion:^(BOOL finished) {
        [self performSelector:@selector(viewHidden) withObject:nil afterDelay:1.0f];
    }];
}

- (void)viewHidden {
    [UIView animateWithDuration:0.1 animations:^{
        self->_textLable.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self->_loadView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        [self->_textLable removeFromSuperview];
        [self->_loadView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
