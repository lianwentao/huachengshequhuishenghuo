
//
//  dingdanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/6.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "dingdanViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+TVAssistant.h"
#import "gouwudingdanTableViewCell.h"
#import "dingdandetailsViewController.h"
#import "UITableView+PlaceHolderView.h"
#import "UIViewController+BackButtonHandler.h"
#import "HalfCircleActivityIndicatorView.h"
#import "MJRefresh.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
@interface dingdanViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_DataArr;
    UIButton *_tmpBtn;
    UITableView *_TableView;
    
    NSString *_status;
    int _pnum;
    
    HalfCircleActivityIndicatorView *LoadingView;
}

@end

@implementation dingdanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商城订单";
    _pnum = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    if (_but_tag.length==0) {
        _status = @"0";
    }else{
        _status = _but_tag;
    }
    [self post];
    [self createui];
    [self LoadingView];
    [LoadingView startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"deleteshopid" object:nil];
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.frame = CGRectMake(0, 0, 60, 40);
//    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = item;
    // Do any additional setup after loading the view.
}
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    [self.view addSubview:LoadingView];
}
- (void)change
{
    [self post];
}
-(BOOL)navigationShouldPopOnBackButton {
    [self backBtnClicked];
    
    return YES;
}
- (BOOL)backBtnClicked{
    
    if (_but_tag.length==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    return YES;
}
- (void)createui
{
    NSArray *arrbut = @[@"全部",@"待付款",@"待收货",@"评价/售后"];
    int j;
    if ([_but_tag isEqualToString:@"2"]) {
        j=2;
    }else{
        j=0;
    }
    for (int i=0; i<4; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(i*kScreen_Width/4, RECTSTATUS.size.height+44, kScreen_Width/4, 40);
        [but setTitle:[arrbut objectAtIndex:i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        but.tag = i;
        [but addTarget:self action:@selector(selectbuttag:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
        
        if (i==j) {
            but.selected = YES;
            _tmpBtn = but;
        }
    }
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+40, kScreen_Width, 3)];
    lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:lineview];
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+43, kScreen_Width, kScreen_Height-(RECTSTATUS.size.height+44+43))];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.enablePlaceHolderView = YES;
    _TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
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
- (void)selectbuttag: (UIButton *)sender
{
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    [LoadingView startAnimating];
    LoadingView.hidden = NO;
    _status = [NSString stringWithFormat:@"%ld",sender.tag];
    [self post];
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"status":_status,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
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
        }else{
            _DataArr = nil;
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [LoadingView stopAnimating];
        LoadingView.hidden = YES;
        [self createtableview];
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
    NSDictionary *dict = @{@"status":_status,@"p":[NSString stringWithFormat:@"%d",_pnum],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
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
