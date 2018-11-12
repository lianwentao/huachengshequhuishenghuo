//
//  xianshiqianggouerjiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/6/10.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "xianshiqianggouerjiViewController.h"
#import "MJRefresh.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "liebiaomodel.h"
#import "liebiaoTableViewCell.h"
#import "GoodsDetailViewController.h"
#import "PYSearch.h"
#import "searchreslutsViewController.h"
#import "UITableView+PlaceHolderView.h"
#import "MBProgressHUD+TVAssistant.h"
@interface xianshiqianggouerjiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *biaoqianarr;
    UIButton *_tmpBtn;
    NSString *liebiaoid;
    
    NSString *isstar;
    UIButton *_tmpBtn1;
    
    NSMutableArray *liebiaoArr;
    NSMutableArray *modelArr;
    
    UITableView *_TabelView;
    NSArray *_searcharr;
    
    int _pagenum;
    
    
}

@end

@implementation xianshiqianggouerjiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pagenum = 1;
    
    [self post];
    [self createUI];
    [self createdaohangolan];
    
    
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+50, Main_width, 50)];
    //   _scrollView.delegate = self;//设置代理
    [_scrollView setContentSize:CGSizeMake(Main_width, 50)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = NO;
    [self.view addSubview:_scrollView];
    
    NSArray *arr = @[@"正在抢购",@"准备活动"];
    for (int i=0; i<2; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(i*Main_width/2, 0, Main_width/2, 50);
        //but.backgroundColor = [arrrrrrrr objectAtIndex:i];
        [but setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitleColor:QIColor forState:UIControlStateSelected];
        but.titleLabel.font = [UIFont systemFontOfSize:16];
        but.tag = i;
        [but addTarget:self action:@selector(selectbut1:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:but];
        
        if (i==0) {
            but.selected = YES;
            _tmpBtn1 = but;
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bupeisong) name:@"bupeisong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kucunbuzu) name:@"kucunbuzu" object:nil];//liebiaojiarugouwuche
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gouwuche:) name:@"liebiaojiarugouwuche" object:nil];
    // Do any additional setup after loading the view.
}
- (void)bupeisong
{
    [MBProgressHUD showToastToView:self.view withText:@"当前时间不在配送时间范围内"];
}
- (void)kucunbuzu
{
    [MBProgressHUD showToastToView:self.view withText:@"库存不足"];
}
- (void)gouwuche:(NSNotification *)user
{
    NSDictionary *dic = [[NSDictionary alloc] init];
    dic = user.userInfo;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    
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
    NSString *strurl = [API stringByAppendingString:@"shop/add_shopping_cart"];
    [manager POST:strurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - 自定义导航栏
- (void)createdaohangolan
{
    //修改系统导航栏下一个界面的返回按钮title
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-100, 44)];
    [self.navigationItem setTitleView:view];
    
    UISearchBar *customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,5, (self.view.frame.size.width-100), 34)];
    customSearchBar.showsCancelButton = NO;
    customSearchBar.placeholder = @"搜一搜";
    customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [view addSubview:customSearchBar];
    
    UIButton *searchbut = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbut.frame = CGRectMake(0, 0, Main_width-100, 34);
    [customSearchBar addSubview:searchbut];
    [searchbut addTarget:self action:@selector(getsearchs) forControlEvents:UIControlEventTouchUpInside];
}
- (void)getsearchs
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"id":[user objectForKey:@"community_id"],@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    //3.发送GET请求
    /*
     */
    NSString *strurl = [API stringByAppendingString:@"shop/goods_search_keys"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _searcharr = [[NSArray alloc] init];
            _searcharr = [responseObject objectForKey:@"data"];
            [self search];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)search
{//apk/shop/goods_search_keys
    NSArray *hotSeaches = _searcharr;
    NSLog(@"%@****%@",hotSeaches,_searcharr);
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索商品",@"") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        searchreslutsViewController *searchvc = [[searchreslutsViewController alloc] init];
        searchvc.searchs = searchViewController.searchBar.text;
        [searchViewController.navigationController pushViewController:searchvc animated:YES];
    }];
    searchViewController.hotSearchStyle = 0;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"cate_id":_id};
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
    NSString *strurl = [API stringByAppendingString:@"shop/pro_list_cate"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        biaoqianarr = [[NSArray alloc] init];
        biaoqianarr = [responseObject objectForKey:@"data"];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        
        biaoqianarr = [responseObject objectForKey:@"data"];
        
        UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, 50)];
        //   _scrollView.delegate = self;//设置代理
        [_scrollView setContentSize:CGSizeMake((Main_width/4)*biaoqianarr.count, 50)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = NO;
        [self.view addSubview:_scrollView];
        
        for (int i=0; i<biaoqianarr.count; i++) {
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(i*Main_width/4, 0, Main_width/4, 50);
            //but.backgroundColor = [arrrrrrrr objectAtIndex:i];
            [but setTitle:[[biaoqianarr objectAtIndex:i] objectForKey:@"cate_name"] forState:UIControlStateNormal];
            [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [but setTitleColor:QIColor forState:UIControlStateSelected];
            but.titleLabel.font = [UIFont systemFontOfSize:16];
            but.tag = i;
            [but addTarget:self action:@selector(selectbut:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:but];
            
            if (i==0) {
                but.selected = YES;
                _tmpBtn = but;
            }
        }
        liebiaoid = [[biaoqianarr objectAtIndex:0] objectForKey:@"id"];
        isstar = @"1";
        [self postliebiao];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)selectbut: (UIButton *)sender
{
    _pagenum = 1;
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
    liebiaoid = [[biaoqianarr objectAtIndex:sender.tag] objectForKey:@"id"];
    [self postliebiao];
}
- (void)selectbut1: (UIButton *)sender
{
    _pagenum = 1;
    if (_tmpBtn1 == nil){
        sender.selected = YES;
        _tmpBtn1 = sender;
    }
    else if (_tmpBtn1 !=nil && _tmpBtn1 == sender){
        sender.selected = YES;
    }
    else if (_tmpBtn1!= sender && _tmpBtn1!=nil){
        _tmpBtn1.selected = NO;
        sender.selected = YES;
        _tmpBtn1 = sender;
    }
    isstar = [NSString stringWithFormat:@"%ld",sender.tag+1];
    
    [self postliebiao];
}
-(void)postliebiao
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"id":liebiaoid,@"is_star":isstar};
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
    NSString *strurl = [API stringByAppendingString:@"shop/pro_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        liebiaoArr = [[NSMutableArray alloc] init];
        modelArr = [NSMutableArray arrayWithCapacity:0];
        
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        arr = [responseObject objectForKey:@"data"];
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            for (int i=0; i<arr.count; i++) {
                liebiaomodel *model = [[liebiaomodel alloc] init];
                model.imagestring = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                model.title = [[arr objectAtIndex:i] objectForKey:@"title"];
                model.tagArr = [[arr objectAtIndex:i] objectForKey:@"goods_tag"];
                model.nowprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"price"]];
                model.yuanprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"original"]];
                model.unit = [[arr objectAtIndex:i] objectForKey:@"unit"];
                model.yishou = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"order_num"]];
                model.biaoshi = @"1";//1代表限时抢购，0代表其他商品
                model.is_start = isstar;
                model.is_time = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"discount"]];
                model.id = [[arr objectAtIndex:i] objectForKey:@"id"];
                model.tagname = [[arr objectAtIndex:i] objectForKey:@"tagname"];
                model.tagid = [[arr objectAtIndex:i] objectForKey:@"tagid"];
                model.title_img = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                model.exihours = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"exist_hours"]];
                
                model.is_new = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_new"]];
                model.is_hot = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_hot"]];
                model.kucun = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"inventory"]];
                [modelArr addObject:model];
            }
            [liebiaoArr addObjectsFromArray:arr];
        }
        
        
        [_TabelView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
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
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"id":liebiaoid,@"p":[NSString stringWithFormat:@"%d",_pagenum],@"is_star":isstar};
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
    NSString *strurl = [API stringByAppendingString:@"shop/pro_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum>i) {
                _TabelView.mj_footer.state = MJRefreshStateNoMoreData;
                [_TabelView.mj_footer resetNoMoreData];
            }else{
                for (int i=0; i<arr.count; i++) {
                    liebiaomodel *model = [[liebiaomodel alloc] init];
                    model.imagestring = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                    model.title = [[arr objectAtIndex:i] objectForKey:@"title"];
                    model.tagArr = [[arr objectAtIndex:i] objectForKey:@"goods_tag"];
                    model.nowprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"price"]];
                    model.yuanprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"original"]];
                    model.unit = [[arr objectAtIndex:i] objectForKey:@"unit"];
                    model.yishou = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"order_num"]];
                    model.biaoshi = @"1";//1代表限时抢购，0代表其他商品
                    model.is_start = isstar;
                    model.exihours = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"exist_hours"]];
                    model.is_new = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_new"]];
                    model.is_hot = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_hot"]];
                    model.is_time = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"discount"]];
                    model.kucun = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"inventory"]];
                    model.id = [[arr objectAtIndex:i] objectForKey:@"id"];
                    model.tagname = [[arr objectAtIndex:i] objectForKey:@"tagname"];
                    model.tagid = [[arr objectAtIndex:i] objectForKey:@"tagid"];
                    model.title_img = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                    [modelArr addObject:model];
                }
                [liebiaoArr addObjectsFromArray:arr];
            }
            [_TabelView.mj_footer endRefreshing];
            [_TabelView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)createUI
{
    _TabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+50+50, Main_width, Main_Height-(RECTSTATUS.size.height+44+50+50))];
    _TabelView.delegate = self;
    _TabelView.dataSource = self;
    _TabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TabelView.backgroundColor = BackColor;
    //_TabelView.enablePlaceHolderView = YES;
    _TabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
    [self.view addSubview:_TabelView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110+12.5;
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"facepayjiluTableViewCell";
    NSLog(@"-----------111==%@",modelArr);
    liebiaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[liebiaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    cell.backgroundColor = BackColor;
    cell.model = [modelArr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailViewController *gooddetail = [[GoodsDetailViewController alloc] init];
    gooddetail.IDstring = [[liebiaoArr objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:gooddetail animated:YES];
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
