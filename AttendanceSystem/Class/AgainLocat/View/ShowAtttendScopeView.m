//
//  ShowAtttendScopeView.m
//  AttendanceSystem
//
//  Created by tiao on 2018/7/19.
//  Copyright © 2018年 wutiao. All rights reserved.
//

#import "ShowAtttendScopeView.h"

#import "AtttendScopeTableViewCell.h"
#define ATTENDSCOPETABLEVIEW_CELL @"AtttendScopeTableViewCell"
@interface ShowAtttendScopeView ()
<
UITableViewDelegate,
UITableViewDataSource,
AMapSearchDelegate,
AMapLocationManagerDelegate
>

@property (nonatomic,strong) UITableView *scopeTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation ShowAtttendScopeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}
-(void) createView{
    __weak typeof(self) weakSelf = self;
    
    UIView *bigBgView = [[UIView alloc]init];
    bigBgView.backgroundColor =[UIColor blackColor];
    bigBgView.alpha = 0.35;
    [self addSubview:bigBgView];
    [bigBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectTap)];
    [bigBgView addGestureRecognizer:tap];
    
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor =[UIColor colorTextWhiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(weakSelf);
        make.height.equalTo(@325);
    }];
    
    UIView *headerView = [[UIView alloc]init];
    [bgView addSubview:headerView];
    headerView.backgroundColor =[UIColor colorWithHexString:@"#f4f4f4"];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bgView);
        make.height.equalTo(@45);
    }];
    
    UILabel *showSocpeLab  = [[ UILabel alloc]init];
    [headerView addSubview:showSocpeLab];
    showSocpeLab.text = @"考勤范围列表";
    showSocpeLab.font = BFont(14);
    showSocpeLab.textColor = [UIColor colorTextBg28BlackColor];
    [showSocpeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(12);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    
    UILabel *nomalLab = [[UILabel alloc]init];
    [headerView addSubview:nomalLab];
    nomalLab.text =@"(已默认选中距离最近考勤点)";
    nomalLab.font = Font(12);
    nomalLab.textColor = [UIColor colorTextBg98BlackColor];
    [nomalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showSocpeLab.mas_right).offset(7);
        make.centerY.equalTo(showSocpeLab.mas_centerY);
    }];
    
    UIButton *cecalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerView addSubview:cecalBtn];
    [cecalBtn setImage:[UIImage imageNamed:@"ico_off"] forState:UIControlStateNormal];
    [cecalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-12);
        make.centerY.equalTo(showSocpeLab.mas_centerY);
    }];
    [cecalBtn addTarget:self action:@selector(selectTap) forControlEvents:UIControlEventTouchUpInside];
    
    self.scopeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, KScreenW, 325-45)];
    [bgView addSubview:self.scopeTableView];
    
    self.scopeTableView.delegate = self;
    self.scopeTableView.dataSource = self;
    self.scopeTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.scopeTableView registerNib:[UINib nibWithNibName:ATTENDSCOPETABLEVIEW_CELL bundle:nil] forCellReuseIdentifier:ATTENDSCOPETABLEVIEW_CELL];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AtttendScopeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ATTENDSCOPETABLEVIEW_CELL forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dict = self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(void)selectTap{
    [self removeFromSuperview];
}
//更新数据源
-(void)setCoordinateArr:(NSArray *)coordinateArr{
    _coordinateArr = coordinateArr;
}
-(void)setCoordinateDict:(NSDictionary *)coordinateDict{
    _coordinateDict = coordinateDict;
}
-(void)setUserLocation:(CLLocation *)userLocation{
    _userLocation = userLocation;
    
    //移除之前的数据源
    [self.dataArr removeAllObjects];
    //测量距离
    NSArray *arr = [SDTool getData:self.coordinateDict Locat:userLocation];
    NSMutableArray *mutableArr = [NSMutableArray array];
    if (mutableArr.count !=0) {
        for (NSDictionary *dict in arr) {
            if ([dict[@"isScope"] isEqualToString:@"1"]) {
                [mutableArr insertObject:dict atIndex:0];
            }else{
                [mutableArr addObject:dict];
            }
        }
        self.dataArr =mutableArr;
    }
    [self.scopeTableView reloadData];
}







@end
