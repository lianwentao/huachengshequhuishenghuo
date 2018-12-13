//
//  myservicechildViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "myservicechildViewController.h"
#import "newfuwudingdancellTableViewCell.h"
#import "newfuwudingdandetailsViewController.h"
#import "newfuwudingdanmodel.h"

@interface myservicechildViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_TableView;
    NSMutableArray *modelArr;
    NSMutableArray *_dataArr;
    int _pnum;
}

@end

@implementation myservicechildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    modelArr = [NSMutableArray arrayWithCapacity:0];
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shauxin) name:@"newpingjiadingdan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shauxin) name:@"newquxiaodingdan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shauxin) name:@"newquxiaodingdan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shauxin) name:@"newtousudingdan" object:nil];
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)shauxin
{
    [_TableView.mj_header beginRefreshing];
}
- (void)getdata
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"type":_type,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/Service/order/myorder"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSArray *arr = [[NSArray alloc] init];
            [modelArr removeAllObjects];
            [_dataArr removeAllObjects];
            arr = [responseObject objectForKey:@"data"];
            for (int i=0; i<arr.count; i++) {
                newfuwudingdanmodel *model = [[newfuwudingdanmodel alloc] init];
                model.fuwuname = [[arr objectAtIndex:i] objectForKey:@"s_name"];
                model.address = [[arr objectAtIndex:i] objectForKey:@"address"];
                model.beizhu = [[arr objectAtIndex:i] objectForKey:@"description"];
                model.imgstring = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                model.status = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"status"]];
                model.dingdanid = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"id"]];
                [modelArr addObject:model];
            }
            [_dataArr addObjectsFromArray:arr];
            
            
        }else{
            
            
        }
        [_TableView.mj_header endRefreshing];
        [_TableView reloadData];
        
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
    return 147;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"myhousecell";
    
    newfuwudingdancellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[newfuwudingdancellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
        cell.model = [modelArr objectAtIndex:indexPath.row];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    newfuwudingdandetailsViewController *details = [[newfuwudingdandetailsViewController alloc] init];
    details.dingdanid = [[_dataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:details animated:YES];
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
