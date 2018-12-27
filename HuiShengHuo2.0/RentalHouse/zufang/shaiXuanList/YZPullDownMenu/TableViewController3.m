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
@property (nonatomic, copy) NSMutableArray *dataArr;
@end

@implementation TableViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedCol = 0;
    
//    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
//    NSDictionary *dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    NSLog(@"dict = %@",dict);
//    NSString *strurl = [API stringByAppendingString:@"secondHouseType/gethousetype"];
//    NSLog(@"strurl = %@",strurl);
//    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"dataStr = %@",dataStr);
//        NSArray *arr = responseObject[@"data"];
//        _dataArr = [NSMutableArray array];
//        for (int i = 0; i<arr.count; i++) {
//            NSString *price = [[arr objectAtIndex:i] objectForKey:@"type"];
//            [_dataArr addObject:price];
//
//        }
//        NSLog(@"_dataArr1 = %@",_dataArr);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"failure--%@",error);
//    }];
//
//    NSLog(@"_dataArr2 = %@",_dataArr);
    _titleArray = @[@"不限", @"一室", @"二室", @"三室", @"四室"];
    
    [self.tableView registerClass:[TableViewCell1 class] forCellReuseIdentifier:ID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedCol inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
