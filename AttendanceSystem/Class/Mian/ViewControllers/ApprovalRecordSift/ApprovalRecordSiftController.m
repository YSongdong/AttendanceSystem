//
//  ApprovalRecordSiftController.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/30.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ApprovalRecordSiftController.h"

#import "CollectionHeaderView.h"
#define COLLECTIONHEADERVIEW  @"CollectionHeaderView"


#import "RecordSiftCollectionViewCell.h"
#define RECORDSIFTCOLLECTIONVIEW_CELL @"RecordSiftCollectionViewCell"

@interface ApprovalRecordSiftController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong) UICollectionView *siftCollect;

@property (nonatomic,strong) UIView *bottomToolView;

@property (nonatomic,strong) NSMutableArray *dataArr;
//选中IndexPath
@property (nonatomic,strong) NSMutableArray *selectIndexPathArr;

@end

@implementation ApprovalRecordSiftController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorTextWhiteColor];
    [self createNavi];
    [self loadData];
    [self createCollectView];
}
#pragma mark ----按钮点击事件------
//重置
-(void)selectReplaceAction:(UIButton *) sender{
    for (int i=0; i<self.dataArr.count; i++) {
        NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.dataArr[i]];
        for (int j=0; j< mutableArr.count; j++) {
            if (j == 0) {
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:mutableArr[j]];
                mutableDict[@"isSelect"] = @"1";
                //贴换
                [mutableArr replaceObjectAtIndex:j withObject:mutableDict];
            }else{
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:mutableArr[j]];
                mutableDict[@"isSelect"] = @"2";
                //贴换
                [mutableArr replaceObjectAtIndex:j withObject:mutableDict];
            }
        }
        //贴换
        [self.dataArr replaceObjectAtIndex:i withObject:mutableArr];
    }
    
    [self.selectIndexPathArr removeAllObjects];
    for (int i=0; i<2; i++) {
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:i];
        [self.selectIndexPathArr addObject:indexPath];
    }
    [self.siftCollect reloadData];
}
//确定
-(void)selectTrueAction:(UIButton *) sender{
    
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.selectIndexPathArr) {
        NSArray *arr = self.dataArr[indexPath.section];
        NSDictionary *dict = arr[indexPath.row];
        [mutableArr addObject:dict];
    }
    //筛选
    if ([self.delegate respondsToSelector:@selector(selectSiftArr:)]) {
        [self.delegate selectSiftArr:mutableArr.copy];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_siftType == RecordApproveSiftType) {
        return 1;
    }else{
        return self.dataArr.count;
    }
   
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_siftType == RecordApproveSiftType) {
        NSArray *arr = self.dataArr[0];
        return arr.count;
    }else{
        NSArray *arr =self.dataArr[section];
        return arr.count;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecordSiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RECORDSIFTCOLLECTIONVIEW_CELL forIndexPath:indexPath];
    NSArray *arr =self.dataArr[indexPath.section];
    cell.dict =arr[indexPath.row];
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:COLLECTIONHEADERVIEW forIndexPath:indexPath];
        headerView.indexPath = indexPath;
        return headerView;
    }
    return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(KScreenW, 55);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *statuIndexPath = self.selectIndexPathArr[indexPath.section];
    NSMutableArray *mutableArr = self.dataArr[indexPath.section];

    //把上次选中还原
    NSMutableDictionary *oldDict = [NSMutableDictionary dictionaryWithDictionary:mutableArr[statuIndexPath.row]];
    oldDict[@"isSelect"] = @"2";
    //贴换
    [mutableArr replaceObjectAtIndex:statuIndexPath.row withObject:oldDict];
    
    //把当前变为选中状态
    NSMutableDictionary *nowDict = [NSMutableDictionary dictionaryWithDictionary:mutableArr[indexPath.row]];
    nowDict[@"isSelect"] = @"1";
    //贴换
    [mutableArr replaceObjectAtIndex:indexPath.row withObject:nowDict];
    [self.dataArr replaceObjectAtIndex:indexPath.section withObject:mutableArr];

    statuIndexPath = indexPath;
    [self.selectIndexPathArr replaceObjectAtIndex:indexPath.section withObject:statuIndexPath];
  
    //刷新
    [self.siftCollect reloadData];
   
    if (_siftType == RecordApproveSiftType || _siftType ==  RecordTypeSiftType) {
        NSIndexPath *indexPath = self.selectIndexPathArr[0];
        NSDictionary *dict = self.dataArr[indexPath.section][indexPath.row];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:dict];
        //筛选
        if ([self.delegate respondsToSelector:@selector(selectSiftArr:)]) {
            [self.delegate selectSiftArr:arr.copy];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void) loadData{
    [self.dataArr removeAllObjects];
    [self.selectIndexPathArr removeAllObjects];
    
    if (_siftType == RecordApproveSiftType) {
        NSArray *arr =@[@"全部",@"审批完成",@"审批中",@"已撤销"];
        NSMutableArray *mutbleArr = [NSMutableArray array];
        for (int i=0; i<arr.count; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"content"] = arr[i];
            dict[@"isSelect"] = @"2";
            dict[@"status"] = [NSString stringWithFormat:@"%d",i];
            if (self.selelctSiftArr == nil) {
                if (i == 0) {
                    //默认第一个选中
                    dict[@"isSelect"] = @"1";
                }
            }else{
                //选中
                NSDictionary *selectDict = self.selelctSiftArr[0];
                if ([arr[i] isEqualToString:selectDict[@"content"]]) {
                   dict[@"isSelect"] = @"1";
                }
            }
            [mutbleArr addObject:dict];
        }
        [self.dataArr addObject:mutbleArr];
        
        if (self.selelctSiftArr == nil) {
            NSIndexPath *nomalIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.selectIndexPathArr addObject:nomalIndexPath];
        }else{
            //选中
            NSDictionary *selectDict = self.selelctSiftArr[0];
            NSIndexPath *nomalIndexPath = [NSIndexPath indexPathForRow:[selectDict[@"status"]integerValue]inSection:0];
            [self.selectIndexPathArr addObject:nomalIndexPath];
        }
        
    }else if (_siftType == RecordApplyForSiftType) {
        NSArray *arr =@[@"全部",@"审批完成",@"审批中",@"已撤销"];
        NSMutableArray *mutbleArr = [NSMutableArray array];
        for (int i=0; i<arr.count; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"content"] = arr[i];
            dict[@"isSelect"] = @"2";
            dict[@"status"] = [NSString stringWithFormat:@"%d",i];
            if (self.selelctSiftArr == nil) {
                if (i == 0) {
                    //默认第一个选中
                    dict[@"isSelect"] = @"1";
                }
            }else{
                //选中
                NSDictionary *selectDict = self.selelctSiftArr[0];
                if ([arr[i] isEqualToString:selectDict[@"content"]]) {
                    dict[@"isSelect"] = @"1";
                }
            }
            [mutbleArr addObject:dict];
        }
        [self.dataArr addObject:mutbleArr];
        
        
        NSArray *typeArr =@[@"全部",@"请假",@"外出",@"加班"];
        NSMutableArray *mutbleTypeArr = [NSMutableArray array];
        for (int i=0; i<typeArr.count; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"content"] = typeArr[i];
            dict[@"isSelect"] = @"2";
            if (i == typeArr.count-1) {
                dict[@"type"] = [NSString stringWithFormat:@"%d",i+2];
            }else{
                dict[@"type"] = [NSString stringWithFormat:@"%d",i];
            }
            if (self.selelctSiftArr == nil) {
                if (i == 0) {
                    //默认第一个选中
                    dict[@"isSelect"] = @"1";
                }
            }else{
                //选中
                NSDictionary *selectDict = self.selelctSiftArr[1];
                if ([typeArr[i] isEqualToString:selectDict[@"content"]]) {
                    dict[@"isSelect"] = @"1";
                }
            }
            [mutbleTypeArr addObject:dict];
        }
        [self.dataArr addObject:mutbleTypeArr];
        
        if (self.selelctSiftArr == nil) {
            //选择默认第一个
            for (int j=0 ; j<2; j++) {
                NSIndexPath *nomalIndexPath = [NSIndexPath indexPathForRow:0 inSection:j];
                [self.selectIndexPathArr addObject:nomalIndexPath];
            }
        }else{
            for (int j=0 ; j<2; j++) {
                if (j==0) {
                    NSDictionary *selecDict = self.selelctSiftArr[j];
                    NSIndexPath *nomalIndexPath = [NSIndexPath indexPathForRow:[selecDict[@"status"]integerValue] inSection:j];
                    [self.selectIndexPathArr addObject:nomalIndexPath];
                }else{
                    NSDictionary *selecDict = self.selelctSiftArr[j];
                    NSString *typeStr = selecDict[@"type"];
                    if ([typeStr isEqualToString:@"5"]) {
                        NSInteger type =[typeStr integerValue];
                        NSIndexPath *nomalIndexPath = [NSIndexPath indexPathForRow:type-2 inSection:j];
                        [self.selectIndexPathArr addObject:nomalIndexPath];
                    }else{
                        NSIndexPath *nomalIndexPath = [NSIndexPath indexPathForRow:[selecDict[@"type"]integerValue] inSection:j];
                        [self.selectIndexPathArr addObject:nomalIndexPath];
                    }
                    
                }
               
            }
        }
        
    }else if (_siftType == RecordTypeSiftType){
        
        NSArray *typeArr =@[@"全部",@"请假",@"外出",@"加班"];
        NSMutableArray *mutbleTypeArr = [NSMutableArray array];
        for (int i=0; i<typeArr.count; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"content"] = typeArr[i];
            dict[@"isSelect"] = @"2";
            if (i == typeArr.count-1) {
                dict[@"type"] = [NSString stringWithFormat:@"%d",i+2];
            }else{
                dict[@"type"] = [NSString stringWithFormat:@"%d",i];
            }
            if (self.selelctSiftArr == nil) {
                if (i == 0) {
                    //默认第一个选中
                    dict[@"isSelect"] = @"1";
                }
            }else{
                //选中
                NSDictionary *selectDict = self.selelctSiftArr[0];
                if ([typeArr[i] isEqualToString:selectDict[@"content"]]) {
                    dict[@"isSelect"] = @"1";
                }
            }
            [mutbleTypeArr addObject:dict];
        }
        [self.dataArr addObject:mutbleTypeArr];
        
        if (self.selelctSiftArr == nil) {
            NSIndexPath *nomalIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.selectIndexPathArr addObject:nomalIndexPath];
        }else{
            //选中
            NSDictionary *selectDict = self.selelctSiftArr[0];
            NSString *typeStr = selectDict[@"type"];
            if ([typeStr isEqualToString:@"5"]) {
                NSInteger type =[typeStr integerValue];
                NSIndexPath *nomalIndexPath = [NSIndexPath indexPathForRow:type-2 inSection:0];
                [self.selectIndexPathArr addObject:nomalIndexPath];
            }else{
                NSIndexPath *nomalIndexPath = [NSIndexPath indexPathForRow:[selectDict[@"type"]integerValue]inSection:0];
                [self.selectIndexPathArr addObject:nomalIndexPath];
            }
            
        }
    }
}
-(void)setSelelctSiftArr:(NSArray *)selelctSiftArr{
    _selelctSiftArr = selelctSiftArr;
}
-(void) createCollectView{
    self.bottomToolView = [[UIView alloc]init];
    [self.view addSubview:self.bottomToolView];
    __weak typeof(self) weakSelf = self;
    self.bottomToolView.backgroundColor = [UIColor colorTextWhiteColor];
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-KSTabbarH);
        make.height.equalTo(@50);
    }];
    UIView *lineView = [[UIView alloc]init];
    [self.bottomToolView addSubview:lineView];
    lineView.backgroundColor =[UIColor colorWithHexString:@"#e0e0e0"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.bottomToolView);
        make.height.equalTo(@1);
    }];
    
    UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomToolView addSubview:replaceBtn];
    [replaceBtn setTitle:@"重置" forState:UIControlStateNormal];
    [replaceBtn setTitleColor:[UIColor colorTextBg65BlackColor] forState:UIControlStateNormal];
    replaceBtn.titleLabel.font = Font(14);
    replaceBtn.backgroundColor =[UIColor colorWithHexString:@"#f8f8f8"];
    [replaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomToolView).offset(12);
        make.height.equalTo(@33);
        make.centerY.equalTo(weakSelf.bottomToolView.mas_centerY);
    }];
    replaceBtn.layer.cornerRadius = 3;
    replaceBtn.layer.masksToBounds = YES;
    [replaceBtn addTarget:self action:@selector(selectReplaceAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomToolView addSubview:trueBtn];
    [trueBtn setTitle:@"确定" forState:UIControlStateNormal];
    [trueBtn setTitleColor:[UIColor colorTextWhiteColor] forState:UIControlStateNormal];
    trueBtn.titleLabel.font = Font(14);
    trueBtn.backgroundColor =[UIColor colorCommonGreenColor];
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(replaceBtn.mas_right).offset(10);
        make.right.equalTo(weakSelf.bottomToolView).offset(-12);
        make.width.height.equalTo(replaceBtn);
        make.centerY.equalTo(replaceBtn.mas_centerY);
    }];
    trueBtn.layer.cornerRadius = 3;
    trueBtn.layer.masksToBounds = YES;
    [trueBtn addTarget:self action:@selector(selectTrueAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_siftType == RecordApproveSiftType || _siftType == RecordTypeSiftType ) {
        self.bottomToolView.hidden = YES;
    }else{
        self.bottomToolView.hidden = NO;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing =10;
    layout.minimumInteritemSpacing = 12;
    layout.itemSize = CGSizeMake((KScreenW-5*12)/3, 33);
    layout.sectionInset = UIEdgeInsetsMake(0,12, 10, 12);
    
    self.siftCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KSNaviTopHeight, KScreenW, KScreenH-KSNaviTopHeight-50-KSTabbarH) collectionViewLayout:layout];
    [self.view addSubview:self.siftCollect];
    
    self.siftCollect.dataSource= self;
    self.siftCollect.delegate = self;
    self.siftCollect.backgroundColor = [UIColor colorTextWhiteColor];
    
    [self.siftCollect registerClass:[RecordSiftCollectionViewCell class] forCellWithReuseIdentifier:RECORDSIFTCOLLECTIONVIEW_CELL];
    [self.siftCollect registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:COLLECTIONHEADERVIEW];
}
//创建Navi
-(void) createNavi{
    self.customNavBar.title = @"筛选";
    self.customNavBar.rightButton.hidden= YES;
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"nav_ico_back"]];
    __weak typeof(self) weakSelf = self;
    self.customNavBar.onClickLeftButton = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}
-(void)setSiftType:(RecordSiftType)siftType{
    _siftType = siftType;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)selectIndexPathArr{
    if (!_selectIndexPathArr) {
        _selectIndexPathArr  =[NSMutableArray array];
    }
    return _selectIndexPathArr;
    
}
@end
