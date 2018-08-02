//
//  UIButton+LZCategory.h
//  LZButtonCategory
//
//  Created by Artron_LQQ on 16/5/5.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LZCategoryType) {
    LZCategoryTypeLeft = 0,//文字在左
    LZCategoryTypeBottom,//文字在下
    LZCategoryTypeRight, //文字在右
};
@interface UIButton (LZCategory)

- (void)LZSetbuttonType:(LZCategoryType)lzType;
@end
