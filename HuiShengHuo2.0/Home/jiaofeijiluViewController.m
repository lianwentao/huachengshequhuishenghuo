//
//  jiaofeijiluViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/31.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "jiaofeijiluViewController.h"
#import <AFNetworking.h>
#import "UITableView+PlaceHolderView.h"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface jiaofeijiluViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    NSMutableArray *_DataArr;
}

@end

@implementation jiaofeijiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费记录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self post];
    [self Createtableview];
    // Do any additional setup after loading the view.
}
- (void)Createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screen_Width, screen_Height-64-64) ];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.backgroundColor = [UIColor whiteColor];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
    _TableView.enablePlaceHolderView = YES;
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = [[NSDictionary alloc] init];
    dict = @{@"room_id":_room_id};
    NSLog(@"%@",_room_id);
    NSString *strurl = [API stringByAppendingString:@"property/get_property_order"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        _DataArr = [NSMutableArray arrayWithCapacity:0];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
        }else{
            _DataArr = nil;
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_DataArr isKindOfClass:[NSMutableArray class]]) {
        return _DataArr.count;
    }else{
        return 0;
    }
    
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screen_Width-20, 20)];
    timelabel.text = [NSString stringWithFormat:@"%@-%@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"startdate"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"enddate"]];
    timelabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:timelabel];
    
    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, screen_Width-20, 20)];
    contentlabel.text = [NSString stringWithFormat:@"本期费用合计:¥ %@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"sumvalue"]];
    contentlabel.alpha = 0.5;
    contentlabel.font = [UIFont systemFontOfSize:18];
    [cell.contentView addSubview:contentlabel];
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 69, screen_Width, 0.5)];
    lineview.backgroundColor = HColor(244, 247, 248);
    [cell.contentView addSubview:lineview];
    tableView.rowHeight = 70;
    return  cell;
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
