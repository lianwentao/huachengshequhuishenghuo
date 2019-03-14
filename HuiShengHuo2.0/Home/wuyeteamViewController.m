//
//  wuyeteamViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/15.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "wuyeteamViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "wuyeTableViewCell.h"

#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
#import "PrefixHeader.pch"
@interface wuyeteamViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_DataArr;
    UITableView *_TableView;
}

@end

@implementation wuyeteamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self post];
    [self Createtableview];
    // Do any additional setup after loading the view.
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    dict = @{@"c_id":[user objectForKey:@"community_id"]};
    
    NSString *strurl = [API stringByAppendingString:@"site/pro_work_team"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        arr = [responseObject objectForKey:@"data"];
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = arr;
        }else{
            _DataArr = nil;
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)Createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height)];
    [self.view addSubview:_TableView];
    _TableView.delegate = self;
    _TableView.dataSource = self;
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataArr.count;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    // 从重用队列里查找可重用的cell
    wuyeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (cell==nil) {
        cell = [[wuyeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.name.text = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"fullname"];
    cell.content.text = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"position"];
    NSString *strurl = [API_img stringByAppendingString:[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"avatars"]];
    [cell.avaimageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
    tableView.rowHeight = 75;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
