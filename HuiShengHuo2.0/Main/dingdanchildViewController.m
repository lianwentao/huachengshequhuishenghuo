//
//  dingdanchildViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/13.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "dingdanchildViewController.h"
#import "gouwudingdanTableViewCell.h"
#import "dingdandetailsViewController.h"
@interface dingdanchildViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_DataArr;
    UIButton *_tmpBtn;
    UITableView *_TableView;
    int _pnum;
}

@end

@implementation dingdanchildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pnum = 1;
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height-(RECTSTATUS.size.height+44+50))];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post)];
    _TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
    [_TableView.mj_header beginRefreshing];
    [self.view addSubview:_TableView];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    // 从重用队列里查找可重用的cell
    gouwudingdanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (cell==nil) {
        cell = [[gouwudingdanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.titlelabel.text = [NSString stringWithFormat:@"订单编号:%@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"order_number"]];
    cell.numlabel.text = [NSString stringWithFormat:@"共%@件",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"pro_num"]];
    cell.pricelabel.text = [NSString stringWithFormat:@"¥%@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"price_total"]];
    
    NSArray *arr = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"img"];
    NSString *strurl = [API_img stringByAppendingString:[[arr objectAtIndex:0] objectForKey:@"img"]];
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
    
    if (arr.count>1) {
        NSString *strurl1 = [API_img stringByAppendingString:[[arr objectAtIndex:1] objectForKey:@"img"]];
        [cell.imageview1 sd_setImageWithURL:[NSURL URLWithString: strurl1]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dingdandetailsViewController *dingdandetails = [[dingdandetailsViewController alloc] init];
    dingdandetails.id = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
    dingdandetails.title = @"订单详情";
    dingdandetails.ordernumber = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"order_number"];
    dingdandetails.totleprice = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"price_total"];
    [self.navigationController pushViewController:dingdandetails animated:YES];
}
#pragma mark ------联网请求---
-(void)post
{
    _pnum = 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"status":_status,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
    
    NSString *urlstr = [API stringByAppendingString:@"userCenter/shopping_order"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _DataArr = [[NSMutableArray alloc] init];
        
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                _DataArr = nil;
            }else{
                [_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
            }
        }else if ([[responseObject objectForKey:@"status"] integerValue]==2){
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            [userinfo removeObjectForKey:@"username"];
            [userinfo removeObjectForKey:@"phone_type"];
            [userinfo removeObjectForKey:@"uid"];
            [userinfo removeObjectForKey:@"pwd"];
            [userinfo removeObjectForKey:@"is_bind_property"];
            [userinfo removeObjectForKey:@"Cookie"];
            [userinfo removeObjectForKey:@"is_new"];
            [userinfo removeObjectForKey:@"token"];
            [userinfo removeObjectForKey:@"tokenSecret"];
            NSHTTPCookieStorage *manager = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (NSHTTPCookie *cookie in cookieStorage) {
                [manager deleteCookie:cookie];
            }
            //                [self logout];
        }else{
            _DataArr = nil;
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView.mj_header endRefreshing];
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post1
{
    _pnum = _pnum + 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"status":_status,@"p":[NSString stringWithFormat:@"%d",_pnum],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
   
    NSString *urlstr = [API stringByAppendingString:@"userCenter/shopping_order"];
    [manager GET:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSString *stringnumber = [[_DataArr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            
            if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                _DataArr = nil;
            }else{
                if (_pnum > i) {
                    _TableView.mj_footer.state = MJRefreshStateNoMoreData;
                    [_TableView.mj_footer resetNoMoreData];
                }else{
                    [_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
                    [_TableView.mj_footer endRefreshing];
                }
            }
        }else{
            _DataArr = nil;
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView.mj_footer endRefreshing];
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
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
