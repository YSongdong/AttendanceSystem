//
//  CollectionViewCell.h
//  AttendanceSystem
//
//  Created by tiao on 2018/8/1.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rightImagV;


@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,strong) NSDictionary *dict;


@end
