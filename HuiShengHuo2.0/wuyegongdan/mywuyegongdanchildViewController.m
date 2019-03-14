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
#import "orderDetailsViewController.h"
@interface mywuyegongdanchildViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_TableView;
    NSMutableArray *modelArr;
    NSMutableArray *_dataArr;
    int _pagenum;
    AppDelegate *myDelegate;
}

@end

@implementation mywuyegongdanchildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)getdata
{
    _pagenum = 1;
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
                model.time = [NSString stringWithFormat:@"下单时间:%@",dateString];
                model.erjitype = [[arr objectAtIndex:i] objectForKey:@"work_type_cn"];
                model.status = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"work_status"]];
                model.status_cn = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"work_status_cn"]];
                model.evaluate_status = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"evaluate_status"]];
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
- (void)postup
{
    _pagenum = _pagenum+1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"state":_state,@"p":[NSString stringWithFormat:@"%d",_pagenum],@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    //3.发送GET请求
    /*
     第一个参数:请求路径(NSString)+ 不需要加参数
     第二个参数:发送给服务器的参数数据
     第三个参数:progress 进度回调
     第四个参数:success  成功之后的回调(此处的成功或者是失败指的是整个请求)
     task:请求任务
     responseObject:注意!!!响应体信息--->(json--->oc))
     task.response: 响应头信息
     第五个参数:failure 失败之后的回调
     */
   
    NSString *strurl = [API stringByAppendingString:@"propertyWork/getWorkList"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            arr = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
            NSString *stringnumber = [[responseObject objectForKey:@"data"] objectForKey:@"CountPage"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum>i) {
                _TableView.mj_footer.state = MJRefreshStateNoMoreData;
                [_TableView.mj_footer resetNoMoreData];
            }else{
                for (int i=0; i<arr.count; i++) {
                    wuyegongdanmodel *model = [[wuyegongdanmodel alloc] init];
                    model.type = [[arr objectAtIndex:i] objectForKey:@"type_name"];
                    NSString *timestring = [[arr objectAtIndex:i] objectForKey:@"release_at"];
                    NSTimeInterval interval   =[timestring doubleValue];
                    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"MM/dd HH:mm"];
                    NSString *dateString = [formatter stringFromDate: date];
                    model.time = [NSString stringWithFormat:@"下单时间:%@",dateString];
                    model.erjitype = [[arr objectAtIndex:i] objectForKey:@"work_type_cn"];
                    model.status = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"work_status"]];
                    model.status_cn = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"work_status_cn"]];
                    model.evaluate_status = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"evaluate_status"]];
                    [modelArr addObject:model];
                }
                [_dataArr addObjectsFromArray:arr];
            }
            [_TableView.mj_footer endRefreshing];
            [_TableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height-RECTSTATUS.size.height-44-50)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.backgroundColor = BackColor;
    _TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
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
    return 111;
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
    orderDetailsViewController *orderVC = [[orderDetailsViewController alloc]init];
    orderVC.stateStr = [_dataArr[indexPath.row] objectForKey:@"work_status_cn"];
    orderVC.workOrderID = [_dataArr[indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:orderVC animated:YES];
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
