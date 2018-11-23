//
//  ZJTwoChildView.m
//  ZJUIKit
//
//  Created by dzj on 2017/12/8.
//  Copyright © 2017年 kapokcloud. All rights reserved.
//

#import "ZJTwoChildView.h"
#import "ZJChooseViewOneLeftCell.h"
#import "ZJCommonKit.h"
@interface ZJTwoChildView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic ,assign) NSInteger seleIndex;

@end

@implementation ZJTwoChildView



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpAllView];
    }
    return self;
}

-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self.mainTable reloadData];
}

-(void)setUpAllView{
    
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.rowHeight = 45;
    [self addSubview:self.mainTable];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJChooseViewOneLeftCell *cell = [ZJChooseViewOneLeftCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.titleLab.text = self.titleArray[indexPath.row];
    cell.titleLab.text = @"111111";
    if (indexPath.row == self.seleIndex) {
        cell.threeIsSelected = YES;
    }else{
        cell.threeIsSelected = NO;
        cell.arrowImgV.hidden = YES;
    }
    
    
//    if (indexPath.row == 0) {
//
//        cell.titleLab.text = @"111111";
//    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.seleIndex = indexPath.row;
    [self.mainTable reloadData];
    if ([self.delegate respondsToSelector:@selector(twoViewTableviewDidSelectedWithIndex:)]) {
        [self.delegate twoViewTableviewDidSelectedWithIndex:indexPath.row];
    }
}

@end
