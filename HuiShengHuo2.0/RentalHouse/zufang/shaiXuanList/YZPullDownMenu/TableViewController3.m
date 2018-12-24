//
//  TableViewController3.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/24.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "TableViewController3.h"
#import "TableViewCell1.h"
extern NSString * const YZUpdateMenuTitleNote3;
static NSString * const ID = @"cell";
@interface TableViewController3 ()
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, assign) NSInteger selectedCol;
@end

@implementation TableViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedCol = 0;
    
    _titleArray = @[@"不限", @"一室", @"二室", @"三室", @"四室"];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:YZUpdateMenuTitleNote3 object:self userInfo:@{@"title":cell.textLabel.text}];
}

@end
