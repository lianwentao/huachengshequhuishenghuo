//
//  TableViewController4.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/24.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "TableViewController4.h"
#import "TableViewCell1.h"
extern NSString * const YZUpdateMenuTitleNote4;
static NSString * const ID = @"cell";
@interface TableViewController4 ()
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, assign) NSInteger selectedCol;
@end

@implementation TableViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedCol = 0;
    
    _titleArray = @[@"默认排序", @"最新发布", @"价格从低到高", @"价格从高到低", @"面积从大到小"];
    
    [self.tableView registerClass:[TableViewCell1 class] forCellReuseIdentifier:ID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (indexPath.row == 0) {
        [cell setSelected:YES animated:NO];
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedCol = indexPath.row;
    
    // 选中当前
    TableViewCell1 *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 更新菜单标题
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote4 object:self userInfo:@{@"title":cell.textLabel.text}];
    
    
}

@end
