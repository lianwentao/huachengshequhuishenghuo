//
//  mywuyegongdanchildViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "mywuyegongdanchildViewController.h"
#import "wuyegongdanmodel.h"
#import "wuyegongdanTableViewCell.h"
@interface mywuyegongdanchildViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_TableView;
    NSMutableArray *modelArr;
    NSMutableArray *_dataArr;
    int _pnum;
}

@end

@implementation mywuyegongdanchildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)getdata
{
    modelArr = [NSMutableArray arrayWithCapacity:0];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"state":_state,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"propertyWork/getWorkList"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        //dataarr = [[NSArray alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [modelArr removeAllObjects];
            [_dataArr removeAllObjects];
            NSArray *arr = [NSArray array];
            arr = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
            for (int i=0; i<arr.count; i++) {
                wuyegongdanmodel *model = [[wuyegongdanmodel alloc] init];
                model.type = [[arr objectAtIndex:i] objectForKey:@"type_name"];
                NSString *timestring = [[arr objectAtIndex:i] objectForKey:@"release_at"];
                NSTimeInterval interval   =[timestring doubleValue];
                NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd HH:mm"];
                NSString *dateString = [formatter stringFromDate: date];
                model.time = dateString;
                model.erjitype = [[arr objectAtIndex:i] objectForKey:@"work_type_cn"];
                model.status = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"work_status"]];
                model.status_cn = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"work_status_cn"]];
                [modelArr addObject:model];
            }
            [_dataArr addObjectsFromArray:arr];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WBLog(@"failure--%@",error);
        [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
    }];
    
    
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height-RECTSTATUS.size.height-44-50)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        [_TableView.mj_header endRefreshing];
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
    return 93;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"myhousecell";
    
    wuyegongdanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[wuyegongdanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
        cell.model = [modelArr objectAtIndex:indexPath.row];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
