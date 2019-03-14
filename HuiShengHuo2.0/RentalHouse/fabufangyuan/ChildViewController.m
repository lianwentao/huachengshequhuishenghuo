//
//  ChildViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/20.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "ChildViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "MJRefresh.h"
#import "myhouseTableViewCell.h"
#import "myhousemodel.h"
#import "shouFangDetailViewController.h"
#import "zuFangDetailViewController.h"
@interface ChildViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    NSMutableArray *modelArr;
    NSMutableArray *_dataarr;
    int _pnum;
}

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    modelArr = [[NSMutableArray alloc] init];
    NSLog(@"house_type==%@",_house_type);
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    //_TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
    __weak typeof(self) weakSelf = self;
    _TableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    [_TableView.mj_header beginRefreshing];
    [self.view addSubview:_TableView];
}
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[_TableView.mj_header endRefreshing];
        [self getdata];
    });
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArr.count;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"   ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"myhousecell";
    
    myhouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[myhouseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    cell.model = [modelArr objectAtIndex:indexPath.row];
    return cell;
}
- (void)getdata
{
    _dataarr = [NSMutableArray arrayWithCapacity:0];
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"user_id":[userinfo objectForKey:@"uid"],@"house_type":_house_type};
    
    NSString *strurl = [API stringByAppendingString:@"personalHouse/personalHouse"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSArray *arr = [[NSArray alloc] init];
            [modelArr removeAllObjects];
            arr = [[responseObject objectForKey:@"data"] objectForKey:@"houseList"];
            [_dataarr addObjectsFromArray:arr];
            for (int i=0; i<arr.count; i++) {
                
                myhousemodel *model = [[myhousemodel alloc] init];
                model.details = [NSString stringWithFormat:@"%@-%@室%@厅%@卫-面积%@平米|%@/%@层",[[arr objectAtIndex:i] objectForKey:@"community_name"],[[arr objectAtIndex:i] objectForKey:@"room"],[[arr objectAtIndex:i] objectForKey:@"office"],[[arr objectAtIndex:i] objectForKey:@"guard"],[[arr objectAtIndex:i] objectForKey:@"area"],[[arr objectAtIndex:i] objectForKey:@"house_floor"],[[arr objectAtIndex:i] objectForKey:@"floor"]];
                model.house_type = _house_type;
                if ([_house_type isEqualToString:@"1"]) {
                    model.price = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"unit_price"]];
                }else{
                    model.price = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"total_price"]];
                }
                model.status = [[arr objectAtIndex:i] objectForKey:@"status"];
                model.imgstring = [[arr objectAtIndex:i] objectForKey:@"head_img"];
                model.name = [[arr objectAtIndex:i] objectForKey:@"name"];
                model.phone = [[arr objectAtIndex:i] objectForKey:@"phone"];
                model.jingjirenimg = [[arr objectAtIndex:i] objectForKey:@"administrator_img"];
                [modelArr addObject:model];
            }
        }else{
            
        }
        [_TableView.mj_header endRefreshing];
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_house_type isEqualToString:@"1"]) {
        zuFangDetailViewController *vc = [[zuFangDetailViewController alloc] init];
        vc.zfID  = [[_dataarr objectAtIndex:indexPath.row] objectForKey:@"houseid"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        shouFangDetailViewController *vc = [[shouFangDetailViewController alloc] init];
        vc.sfID  = [[_dataarr objectAtIndex:indexPath.row] objectForKey:@"houseid"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
