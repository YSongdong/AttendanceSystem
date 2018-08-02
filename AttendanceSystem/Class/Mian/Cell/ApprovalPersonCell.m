//
//  ApprovalPersonCell.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ApprovalPersonCell.h"

#import "CollectionViewCell.h"
#define COLLECTIONVIEW_CELL @"CollectionViewCell"

@interface ApprovalPersonCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong) UICollectionView *cellCollcet;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end


@implementation ApprovalPersonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void) createView{
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorTextWhiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(9);
        make.right.left.bottom.equalTo(weakSelf);
    }];
    
    UILabel *showPersonLab = [[UILabel alloc]init];
    [bgView addSubview:showPersonLab];
    showPersonLab.text = @"审批人";
    showPersonLab.font = Font(16);
    showPersonLab.textColor = [UIColor colorTextBg28BlackColor];
    [showPersonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(22);
        make.left.equalTo(bgView).offset(12);
    }];
    
    UILabel *lab = [[UILabel alloc]init];
    [bgView addSubview:lab];
    lab.textColor = [UIColor colorTextBg98BlackColor];
    lab.font = Font(14);
    lab.text = @"审批人由管理员预置，并自动去重";
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showPersonLab.mas_right).offset(12);
        make.centerY.equalTo(showPersonLab.mas_centerY);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.cellCollcet = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, KScreenW, 118) collectionViewLayout:layout];
    [bgView addSubview:self.cellCollcet];
    
    self.cellCollcet.backgroundColor = [UIColor colorTextWhiteColor];
    self.cellCollcet.delegate = self;
    self.cellCollcet.dataSource = self;
    
    [self.cellCollcet registerNib:[UINib nibWithNibName:COLLECTIONVIEW_CELL bundle:nil] forCellWithReuseIdentifier:COLLECTIONVIEW_CELL];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTIONVIEW_CELL forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.dict = self.dataArr[indexPath.row];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return  CGSizeMake(90, 118);
}

-(void)updateCellUINSArr:(NSArray *)arr{
    self.dataArr = [NSMutableArray arrayWithArray:arr];
    [self.cellCollcet reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
