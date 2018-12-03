//
//  MailHomeViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/16.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "MailHomeViewController.h"
#import "ShangpinfenleiViewController.h"
#import "GoodsDetailViewController.h"
#import "shangpinerjiViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "GouwucheViewController.h"
#import "HalfCircleActivityIndicatorView.h"
#import "NSTimer+Addition.h"
#import "SBCycleScrollView.h"
#import "WebViewController.h"
#import "TimeLabel.h"
#import "acivityViewController.h"
#import "MJRefresh.h"
#import "LoginViewController.h"
#import "weixiuViewController.h"
#import "activitydetailsViewController.h"
#import "PYSearch.h"
#import "searchreslutsViewController.h"
#import "youhuiquanxiangqingViewController.h"
#import "youhuiquanViewController.h"
#import "circledetailsViewController.h"
#import "JKBannarView.h"
#import "noticeViewController.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"


@interface MailHomeViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,SBCycleScrollViewDelegate,PYSearchViewControllerDelegate>
{
    UITableView *_TableView;
    NSMutableArray *HeaDataArr;
    NSMutableArray *areaArr;
    NSMutableArray *robArr;
    NSMutableArray *centerArr;
    
    UIImageView *NoUrlimageview;
    UIButton *Againbut;
    HalfCircleActivityIndicatorView *LoadingView;
    
    UIImageView *redcountimage;
    NSArray *_searcharr;
    
    JKBannarView *bannerView;
}
@property(nonatomic,strong)  SBCycleScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *allshopArr;
@end

@implementation MailHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self again];
    
    [self createdaohangolan];
    [self createnotice];
    [self CreateTableview];
    //[self LoadingView];
    //[LoadingView startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadtable) name:@"changetitle" object:nil];
    
//    [self.view addSubview:self.scrollView];
    
    
    // Do any additional setup after loading the view.
}
 -(void)reloadtable
{
    [_TableView.mj_header beginRefreshing];
    //[self get];
//    [self post1];
//    [self post];
//
//    [self postcenter];
//    [self postcount];
}
- (void)createnotice
{
    NoUrlimageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-50, 100, 100)];
    NoUrlimageview.image = [UIImage imageNamed:@"pinglunweikong"];
    [self.view addSubview:NoUrlimageview];
    Againbut = [UIButton buttonWithType:UIButtonTypeCustom];
    Againbut.frame = CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-20+110, 100, 40);
    [Againbut setTitle:@"暂无商品" forState:UIControlStateNormal];
    [Againbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Againbut.alpha = 0.5;
    //[Againbut addTarget:self action:@selector(again) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Againbut];
    
    NoUrlimageview.hidden = YES;
    Againbut.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启定时器 DDCycleScrollView自动滚动
    [[NSNotificationCenter  defaultCenter]  postNotificationName:SBCycleScrollViewOpenTimerNotiName object:nil userInfo:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    //关闭定时器  DDCycleScrollView停止自动滚动
    [[NSNotificationCenter  defaultCenter]  postNotificationName:SBCycleScrollViewCloseTimerNotiName object:nil userInfo:nil];
}
//#pragma ---- banna滚动图片------
//-(SBCycleScrollView *)scrollView
//{
//    if (!_scrollView) {
//
//
//        //_scrollView.backgroundColor=[UIColor cyanColor];
//    }
//    return _scrollView;
//}


#pragma mark - LoadingView
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    [self.view addSubview:LoadingView];
}

#pragma mark ------联网请求---
-(void)post
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
    NSString *strurl = [API stringByAppendingString:@"shop/shop_index"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _allshopArr = [[NSMutableArray alloc] init];
        robArr = [[NSMutableArray alloc] init];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _allshopArr = [[responseObject objectForKey:@"data"] objectForKey:@"all"];
            robArr = [[responseObject objectForKey:@"data"] objectForKey:@"rob"];
            
//            [LoadingView stopAnimating];
//            LoadingView.hidden = YES;
        }
        [_TableView reloadData];
        [_TableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
-(void)get
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"]};
    //3.发送GET请求
    /*
     */
    NSString *strurl = [API stringByAppendingString:@"shop/shop_index_area"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //[_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"get---success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        areaArr = [[NSMutableArray alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            areaArr = [[responseObject objectForKey:@"data"] objectForKey:@"area_list"];
            [self post1];
            [self post];
            [self postcenter];
            [self postcount];
            
            _TableView.hidden = NO;
            NoUrlimageview.hidden = YES;
            Againbut.hidden = YES;
            
            
        }else{
            areaArr = nil;
            _TableView.hidden = YES;
            //        [LoadingView stopAnimating];
            //        LoadingView.hidden = YES;
            NoUrlimageview.hidden = NO;
            Againbut.hidden = NO;
        }
        //[_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)again
{
    NoUrlimageview.hidden = YES;
    Againbut.hidden = YES;
//    [LoadingView startAnimating];
//    [self post];
//    [self post1];
    [self get];
    //[self postcount];
//    [self postcenter];
}
-(void)post1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"community_id":[user objectForKey:@"community_id"]};
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
    NSString *strurl = [API stringByAppendingString:@"site/get_Advertising/c_name/hc_shopindex"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        HeaDataArr = [[NSMutableArray alloc] init];
        HeaDataArr = [responseObject objectForKey:@"data"];
        NSLog(@"headarr==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        //NSLog(@"success--%@--%@",[responseObject class],responseObject);
        
        NSMutableArray *imagearr = [NSMutableArray array];
        bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width/(2.5)) viewSize:CGSizeMake(kScreen_Width,kScreen_Width/(2.5))];
        
        if ([HeaDataArr isKindOfClass:[NSArray class]]) {
            for (int i=0; i<HeaDataArr.count; i++) {
                NSString *strurl = [API_img stringByAppendingString:[[HeaDataArr objectAtIndex:i]objectForKey:@"img"]];
                NSLog(@"%@",strurl);
                [imagearr addObject:strurl];
                bannerView.items = imagearr;
            }
//            _scrollView=[[SBCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width,kScreen_Width/(2.5)) Duration:3 pageControlHeight:20];
//            _scrollView.delegate=self;
            //self.scrollView.imageArray=imagearr;
        }else{
            imagearr  =  nil;
            //self.scrollView.imageArray=nil;
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
-(void)postcenter
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"community_id":[user objectForKey:@"community_id"]};
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
    NSString *strurl = [API stringByAppendingString:@"apk/site/get_Advertising/c_name/hc_shop_center"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        centerArr = [[NSMutableArray alloc] init];
        centerArr = [responseObject objectForKey:@"data"];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        
        centerArr = [responseObject objectForKey:@"data"];
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
-(void)postcount
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"]};
    NSString *strurl = [API stringByAppendingString:@"shop/cart_num"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"gouwuche--%@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSString *cart_num = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"cart_num"]];
            if ([cart_num isEqualToString:@"0"]) {
                redcountimage.hidden = YES;
            }else{
                redcountimage.hidden = NO;
            }
        }
        [_TableView reloadData];
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.navigationItem setTitleView:view];
    
    NSArray *Imagearr = @[@"shop_icon_fenlei",@"icon_center_gouwu-1"];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 5, 30, 30)];
    [but setImage:[UIImage imageNamed:[Imagearr objectAtIndex:1]] forState:UIControlStateNormal];
    but.backgroundColor = [UIColor redColor];
    [but addTarget:self action:@selector(rightbut:) forControlEvents:UIControlEventTouchUpInside];
    but.backgroundColor = [UIColor clearColor];
    [view addSubview:but];
    redcountimage = [[UIImageView alloc] initWithFrame:CGRectMake(27, 2, 6, 6)];
    redcountimage.layer.masksToBounds = YES;
    redcountimage.layer.cornerRadius = 3;
    redcountimage.backgroundColor = [UIColor redColor];
    redcountimage.hidden = YES;
    [but addSubview:redcountimage];
    
    UISearchBar *customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(15,5, (self.view.frame.size.width-70), 34)];
    customSearchBar.delegate = self;
    customSearchBar.showsCancelButton = NO;
    customSearchBar.placeholder = @"搜一搜";
    customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [view addSubview:customSearchBar];
    
    UIButton *searchbut = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbut.frame = CGRectMake(0, 0, kScreen_Width-70, 34);
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
    NSDictionary *dict = @{@"id":[user objectForKey:@"community_id"]};
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
#pragma mark - 右上角按钮的点击事件
- (void)rightbut:(UIButton *)sender
{
    //NSLog(@"购物车");
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *str = [userinfo objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        GouwucheViewController *gouwuche = [[GouwucheViewController alloc] init];
        gouwuche.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gouwuche animated:YES];
    }
    
}
#pragma mark - 创建tableview
- (void)CreateTableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, self.view.frame.size.width, kScreen_Height-49-RECTSTATUS.size.height-44) ];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(again)];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
     [_TableView.mj_header beginRefreshing];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3) {
        return 2;
    }if (section==1){
        if ([robArr isKindOfClass:[NSArray class]]) {
            return robArr.count+1;
        }else{
            return 0;
        }
    }if (section==2) {
        if ([centerArr isKindOfClass:[NSArray class]]) {
            return centerArr.count+1;
        }else{
            return 0;
        }
    } else{
        return 1;
    }
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 10;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.section==0) {
        
        UIScrollView *scrollview = [[UIScrollView alloc] init];
        if ([HeaDataArr isKindOfClass:[NSArray class]]) {
            [cell.contentView addSubview:bannerView];
            
            [bannerView imageViewClick:^(JKBannarView * _Nonnull barnerview, NSInteger index) {
                NSLog(@"点击图片%ld",index);
                NSString *url_type = [[HeaDataArr objectAtIndex:index] objectForKey:@"url_type"];
                NSString *url_id = [[HeaDataArr objectAtIndex:index] objectForKey:@"id"];
                NSString *urltypename = [[HeaDataArr objectAtIndex:index] objectForKey:@"type_name"];
                if ([url_type isEqualToString:@"5"]) {
                    weixiuViewController *weixiu = [[weixiuViewController alloc] init];
                    weixiu.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:weixiu animated:YES];
                }if ([url_type isEqualToString:@"3"]) {
                    acivityViewController *aciti = [[acivityViewController alloc] init];
                    aciti.hidesBottomBarWhenPushed = YES;
                    aciti.url = url_id;
                    [self.navigationController pushViewController:aciti animated:YES];
                }if ([url_type isEqualToString:@"4"]) {
                    activitydetailsViewController *acti = [[activitydetailsViewController alloc] init];
                    acti.url = url_id;
                    acti.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:acti animated:YES];
                }if ([url_type isEqualToString:@"7"]) {
                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",url_id];
                    UIWebView *callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebview];
                }if ([url_type isEqualToString:@"1"]) {
                    shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
                    NSString *type_name = [[HeaDataArr objectAtIndex:index] objectForKey:@"type_name"];
                    NSRange range = [type_name rangeOfString:@"id/"]; //现获取要截取的字符串位置
                    NSString * result = [type_name substringFromIndex:range.location+3]; //截取字符串
                    erji.id = result;
                    erji.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:erji animated:YES];
                }if ([url_type isEqualToString:@"6"]) {
                    //优惠券
                    NSString *type_name = [[HeaDataArr objectAtIndex:index] objectForKey:@"type_name"];
                    
                    WebViewController *web = [[WebViewController alloc] init];
                    web.url_type = @"2";
                    web.title = @"优惠券";
                    web.url = type_name;
                    web.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:web animated:YES];
                }if ([url_type isEqualToString:@"8"]) {
                    youhuiquanViewController *youhuiquan = [[youhuiquanViewController alloc] init];
                    [self.navigationController presentViewController:youhuiquan animated:YES completion:nil];
                }if ([url_type isEqualToString:@"9"]) {
                    youhuiquanxiangqingViewController *youhuiquan = [[youhuiquanxiangqingViewController alloc] init];
                    [self.navigationController presentViewController:youhuiquan animated:YES completion:nil];
                }if ([url_type isEqualToString:@"2"]) {
                    GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
                    NSRange range = [urltypename rangeOfString:@"id/"]; //现获取要截取的字符串位置
                    NSString * result = [urltypename substringFromIndex:range.location+3]; //截取字符串
                    goods.IDstring = result;
                    goods.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:goods animated:YES];
                }if ([url_type isEqualToString:@"10"]) {
                    WebViewController *web = [[WebViewController alloc] init];
                    web.url = url_id;
                    web.url_type = @"1";
                    //web.jpushstring = @"jpush";
                    web.title = @"小慧推荐";
                    web.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:web animated:YES];
                }if ([url_type isEqualToString:@"11"]) {
                    noticeViewController *notice = [[noticeViewController alloc] init];
                    notice.hidesBottomBarWhenPushed = YES;
                    NSRange range = [url_id rangeOfString:@"id/"]; //现获取要截取的字符串位置
                    NSString * result = [url_id substringFromIndex:range.location+3]; //截取字符串
                    notice.id = result;
                    //notice.jpushstring = @"jpush";
                    [self.navigationController pushViewController:notice animated:YES];
                }
            }];
            tableView.rowHeight = kScreen_Width/(2.5)+60+20+15+10;
             scrollview.frame =  CGRectMake(0,kScreen_Width/(2.5)+10,kScreen_Width,95);
        }else{
            //[cell.contentView addSubview:_scrollView];
            tableView.rowHeight = 60+20+15;
            scrollview.frame =  CGRectMake(0,10,kScreen_Width,95);
        }
       
        [scrollview setContentSize:CGSizeMake(80*
                                              (areaArr.count+1)+40, scrollview.bounds.size.height)];
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.pagingEnabled = NO;
        [cell.contentView addSubview:scrollview];
        for (int i=0; i<areaArr.count+1; i++) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(40+i*80,5,40,40)];
            [scrollview addSubview:imageview];
            if (i==0) {
                imageview.image = [UIImage imageNamed:@"quanbu"];
            }else{
                NSString *strurl = [API_img stringByAppendingString:[[areaArr objectAtIndex:i-1] objectForKey:@"icon"]];
                [imageview sd_setImageWithURL:[NSURL URLWithString: strurl] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                
            }
            
            UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(i*80+20,60,80,20)];
            namelabel.textAlignment = NSTextAlignmentCenter;
            namelabel.font = [UIFont systemFontOfSize:12];
            [scrollview addSubview:namelabel];
            if (i==0) {
                namelabel.text = @"全部";
            }else{
                namelabel.text = [[areaArr objectAtIndex:i-1] objectForKey:@"cate_name"];
            }
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(40+i*80,5,40,80);
            but.backgroundColor = [UIColor clearColor];
            
            [but addTarget:self action:@selector(moregoods:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:but];
            if (i==0) {
                but.tag = 10000;
            }else{
                but.tag = [[[areaArr objectAtIndex:i-1] objectForKey:@"id"] integerValue];
            }
            
            
        }
    }if (indexPath.section==2) {
        if (indexPath.row==0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width-80)/2, 10, 80, 20)];
            label.text = @"小慧推荐";
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            tableView.rowHeight = 40;
        }else{
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, kScreen_Width-30, (kScreen_Width-30)/(2.5))];
            NSString *strurl = [API_img stringByAppendingString:[[centerArr objectAtIndex:indexPath.row-1] objectForKey:@"img"]];
            [imageview sd_setImageWithURL:[NSURL URLWithString: strurl] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
            [cell.contentView addSubview:imageview];
            UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:imageview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = imageview.bounds;
            maskLayer.path = bezierPath.CGPath;
            imageview.layer.mask = maskLayer;
            
            tableView.rowHeight = (kScreen_Width-30)/(2.5)+10;
        }
    }if (indexPath.section==1) {
        if (indexPath.row==0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width-80)/2, 10, 80, 20)];
            label.text = @"限时抢购";
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            tableView.rowHeight = 40;
        }if (indexPath.row>0) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, kScreen_Width-30, (kScreen_Width-30)/(2.5))];
            NSString *strurl = [API_img stringByAppendingString:[[robArr objectAtIndex:indexPath.row-1] objectForKey:@"index_img"]];
            [imageview sd_setImageWithURL:[NSURL URLWithString: strurl] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
            [cell.contentView addSubview:imageview];
            UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:imageview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = imageview.bounds;
            maskLayer.path = bezierPath.CGPath;
            imageview.layer.mask = maskLayer;
            
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, (kScreen_Width-30)/(2.5)+5, kScreen_Width-30, 55)];
            backview.backgroundColor = HColor(244, 247, 248);
            [cell.contentView addSubview:backview];
            UIBezierPath * bezierPath1 = [UIBezierPath bezierPathWithRoundedRect:backview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
            maskLayer1.frame = backview.bounds;
            maskLayer1.path = bezierPath1.CGPath;
            backview.layer.mask = maskLayer1;
            
            TimeLabel *timeLabel = [[TimeLabel alloc]  initWityFrame:CGRectMake(kScreen_Width/4, 17.5, kScreen_Width/8*5, 20) type:TIME_HOUR_MINUTE_SECOND timeChange:^(NSInteger time) {
                //NSLog(@"%ld",(long)time);
            } timeEnd:^{
                NSLog(@"倒计时结束");
            }];
            [backview addSubview:timeLabel];
            
            long MMDDSSbefor = [[[robArr objectAtIndex:indexPath.row-1] objectForKey:@"shop_cate_stime"] integerValue];
            long MMDDSSafter = [[[robArr objectAtIndex:indexPath.row-1] objectForKey:@"shop_cate_etime"] integerValue];
            long miaobefor = (MMDDSSbefor-time(NULL))%(60*60*24);
            long miaoafter = (MMDDSSafter - time(NULL))%(60*60*24);
            
            long daybefor = (MMDDSSbefor-time(NULL))/(60*60*24);
            long dayafter = (MMDDSSafter - time(NULL))/(60*60*24);
            
            NSLog(@"date1时间戳 = %ld==%ld",miaobefor,miaoafter);
            
            UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 100, 25)];
            timelabel.font = [UIFont systemFontOfSize:15];
            timelabel.textAlignment = NSTextAlignmentCenter;
            [backview addSubview:timelabel];
            
            if (miaobefor>0) {
                [timeLabel setcurentTime:miaobefor];
                timelabel.text = [NSString stringWithFormat:@"距开始%ld天",daybefor];
            }if (miaobefor<0&&miaoafter>0) {
                [timeLabel setcurentTime:miaoafter];
                timelabel.text = [NSString stringWithFormat:@"距结束%ld天",dayafter];
            }if (miaoafter<0) {
                [timeLabel setcurentTime:miaoafter];
                timelabel.text = @"已结束";
            }
            //0, 10, kScreen_Width-30, 20
            
            tableView.rowHeight = (kScreen_Width-30)/(2.5)+65;
        }
    }if (indexPath.section==3) {
        if (indexPath.row==0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 20)];
            NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:@"精选商品"];
            
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"icon_shop_right"];
            attch.bounds = CGRectMake(0, -5, 20, 20);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:4];
            label.attributedText = attri;
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            tableView.rowHeight = 40;
        }if (indexPath.row==1) {
            for (int i=0; i<_allshopArr.count; i++) {
                if (i%3==0) {
                    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 5+(kScreen_Width-30-14)/3*(i/3)*2, (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3)];
                    backview.backgroundColor = HColor(244, 247, 248);
                    [cell.contentView addSubview:backview];
                    
                    UIView *backview1 = [[UIView alloc] initWithFrame:CGRectMake(15, 5+(kScreen_Width-30-14)/3*(i/3)*2+(kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3)];
                    backview1.backgroundColor = [UIColor whiteColor];
                    [cell.contentView addSubview:backview1];
                    
                    
                    
                    UILabel *labelname = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (kScreen_Width-30-14)/3-20, 0)];
                    labelname.text = [[_allshopArr objectAtIndex:i] objectForKey:@"title"];
                    labelname.font = [UIFont systemFontOfSize:15];
                    labelname.numberOfLines = 2;
                    CGSize size = [labelname sizeThatFits:CGSizeMake(labelname.frame.size.width, MAXFLOAT)];
                    labelname.frame = CGRectMake(labelname.frame.origin.x, labelname.frame.origin.y, labelname.frame.size.width,            size.height);
                    [backview1 addSubview:labelname];
                    
                    UILabel *labelpreice = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+5+size.height, (kScreen_Width-30-14)/3-20, 20)];
                    labelpreice.text = [NSString stringWithFormat:@"¥%@",[[_allshopArr objectAtIndex:i] objectForKey:@"min_price"]];
                    labelpreice.textColor = [UIColor redColor];
                    labelpreice.font = [UIFont systemFontOfSize:18];
                    [backview1 addSubview:labelpreice];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, (kScreen_Width-30-14)/3-20, (kScreen_Width-30-14)/3-20)];
                    
                    NSString *strurl = [API_img stringByAppendingString:[[_allshopArr objectAtIndex:i] objectForKey:@"title_img"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [backview addSubview:imageview];
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(15, 5+(kScreen_Width-30-14)/3*(i/3)*2, (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3*2);
                    but.tag = [[[_allshopArr objectAtIndex:i] objectForKey:@"id"] integerValue];
                    but.backgroundColor = [UIColor clearColor];
                    [but setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    [but addTarget:self action:@selector(GoodsDetail:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:but];
                }else if (i%3==1){
                    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15+(kScreen_Width-30-14)/3+7, 5+(kScreen_Width-30-14)/3*2*(i/3), (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3)];
                    backview.backgroundColor = HColor(244, 247, 248);
                    [cell.contentView addSubview:backview];
                    
                    UIView *backview1 = [[UIView alloc] initWithFrame:CGRectMake(15+(kScreen_Width-30-14)/3+7, 5+(kScreen_Width-30-14)/3*2*(i/3)+(kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3)];
                    backview1.backgroundColor = [UIColor whiteColor];
                    [cell.contentView addSubview:backview1];
                    
                    UILabel *labelname = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (kScreen_Width-30-14)/3-20, 0)];
                    labelname.text = [[_allshopArr objectAtIndex:i] objectForKey:@"title"];
                    labelname.font = [UIFont systemFontOfSize:15];
                    labelname.numberOfLines = 2;
                    CGSize size = [labelname sizeThatFits:CGSizeMake(labelname.frame.size.width, MAXFLOAT)];
                    labelname.frame = CGRectMake(labelname.frame.origin.x, labelname.frame.origin.y, labelname.frame.size.width,            size.height);
                    [backview1 addSubview:labelname];
                    
                    UILabel *labelpreice = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+5+size.height, (kScreen_Width-30-14)/3-20, 20)];
                    labelpreice.text = [NSString stringWithFormat:@"¥%@",[[_allshopArr objectAtIndex:i] objectForKey:@"min_price"]];
                    labelpreice.textColor = [UIColor redColor];
                    labelpreice.font = [UIFont systemFontOfSize:18];
                    [backview1 addSubview:labelpreice];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, (kScreen_Width-30-14)/3-20, (kScreen_Width-30-14)/3-20)];
                    
                    NSString *strurl = [API_img stringByAppendingString:[[_allshopArr objectAtIndex:i] objectForKey:@"title_img"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [backview addSubview:imageview];
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(15+(kScreen_Width-30-14)/3+7, 5+(kScreen_Width-30-14)/3*2*(i/3), (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3*2);
                    but.tag = [[[_allshopArr objectAtIndex:i] objectForKey:@"id"] integerValue];
                    but.backgroundColor = [UIColor clearColor];
                    [but addTarget:self action:@selector(GoodsDetail:) forControlEvents:UIControlEventTouchUpInside];
                     [but setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    [cell.contentView addSubview:but];
                }else{
                    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15+(kScreen_Width-30-14)/3*2+14, 5+(kScreen_Width-30-14)/3*2*(i/3), (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3)];
                    backview.backgroundColor = HColor(244, 247, 248);
                    [cell.contentView addSubview:backview];
                    
                    UIView *backview1 = [[UIView alloc] initWithFrame:CGRectMake(15+(kScreen_Width-30-14)/3*2+14, 5+(kScreen_Width-30-14)/3*2*(i/3)+(kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3)];
                    backview1.backgroundColor = [UIColor whiteColor];
                    [cell.contentView addSubview:backview1];
                    
                    
                    UILabel *labelname = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (kScreen_Width-30-14)/3-20, 0)];
                    labelname.text = [[_allshopArr objectAtIndex:i] objectForKey:@"title"];
                    labelname.font = [UIFont systemFontOfSize:15];
                    labelname.numberOfLines = 2;
                    CGSize size = [labelname sizeThatFits:CGSizeMake(labelname.frame.size.width, MAXFLOAT)];
                    labelname.frame = CGRectMake(labelname.frame.origin.x, labelname.frame.origin.y, labelname.frame.size.width,            size.height);
                    [backview1 addSubview:labelname];
                    
                    UILabel *labelpreice = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+5+size.height, (kScreen_Width-30-14)/3-20, 20)];
                    labelpreice.text = [NSString stringWithFormat:@"¥%@",[[_allshopArr objectAtIndex:i] objectForKey:@"min_price"]];
                    labelpreice.textColor = [UIColor redColor];
                    labelpreice.font = [UIFont systemFontOfSize:18];
                    [backview1 addSubview:labelpreice];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, (kScreen_Width-30-14)/3-20, (kScreen_Width-30-14)/3-20)];
                    
                    NSString *strurl = [API_img stringByAppendingString:[[_allshopArr objectAtIndex:i] objectForKey:@"title_img"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [backview addSubview:imageview];
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(15+(kScreen_Width-30-14)/3*2+14, 5+(kScreen_Width-30-14)/3*2*(i/3), (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3*2);
                    but.tag = [[[_allshopArr objectAtIndex:i] objectForKey:@"id"] integerValue];
                    [but addTarget:self action:@selector(GoodsDetail:) forControlEvents:UIControlEventTouchUpInside];
                    but.backgroundColor = [UIColor clearColor];
                    [but setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    [cell.contentView addSubview:but];
                }
            }
            tableView.rowHeight = 10+(kScreen_Width-30-14)/3*((_allshopArr.count+2)/3)*2;
        }
    }
    return  cell;
}

- (void)moregoods:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    if (sender.tag==10000) {
        ShangpinfenleiViewController *shangpinfenlei = [[ShangpinfenleiViewController alloc] init];
        shangpinfenlei.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shangpinfenlei animated:YES];
    }else{
        shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
        erji.id = [NSString stringWithFormat:@"%ld",sender.tag];
        erji.rokou = @"1";
        erji.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:erji animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1&&indexPath.row>0) {
        GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
        goods.IDstring = [[robArr objectAtIndex:indexPath.row-1] objectForKey:@"id"];
//        long MMDDSSbefor = [[[robArr objectAtIndex:indexPath.row-1] objectForKey:@"shop_cate_stime"] integerValue];
//        long MMDDSSafter = [[[robArr objectAtIndex:indexPath.row-1] objectForKey:@"shop_cate_etime"] integerValue];
//        long miaobefor = (MMDDSSbefor-time(NULL))%(60*60*24);
//        long miaoafter = (MMDDSSafter - time(NULL))%(60*60*24);
//
//        NSLog(@"date1时间戳 = %ld==%ld",miaobefor,miaoafter);
//
//        if (miaobefor>0) {
//            goods.timeout = @"0";
//        }if (miaobefor<0&&miaoafter>0) {
//            goods.timeout = @"1";
//        }if (miaoafter<0) {
//            goods.timeout = @"2";
//        }
        goods.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goods animated:YES];
        
    }if (indexPath.section==2&&indexPath.row>0) {
        NSString *url_id = [[centerArr objectAtIndex:indexPath.row-1] objectForKey:@"id"];
        NSString *url_type = [[centerArr objectAtIndex:indexPath.row-1] objectForKey:@"url_type"];
        NSString *url = [[centerArr objectAtIndex:indexPath.row-1] objectForKey:@"adv_url"];
        NSString *goodsid = [[centerArr objectAtIndex:indexPath.row-1] objectForKey:@"adv_inside_url"];
        if ([url_type isEqualToString:@"5"]) {
            weixiuViewController *weixiu = [[weixiuViewController alloc] init];
            weixiu.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:weixiu animated:YES];
        }if ([url_type isEqualToString:@"3"]) {
            acivityViewController *aciti = [[acivityViewController alloc] init];
            aciti.hidesBottomBarWhenPushed = YES;
            aciti.url = [[centerArr objectAtIndex:indexPath.row-1] objectForKey:@"type_name"];
            
            [self.navigationController pushViewController:aciti animated:YES];
        }if ([url_type isEqualToString:@"4"]) {
            activitydetailsViewController *acti = [[activitydetailsViewController alloc] init];
            acti.url = [[centerArr objectAtIndex:indexPath.row-1] objectForKey:@"type_name"];
            acti.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:acti animated:YES];
        }if ([url_type isEqualToString:@"7"]) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",url_id];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }if ([url_type isEqualToString:@"2"]) {
            GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
            NSRange range = [url_id rangeOfString:@"id/"]; //现获取要截取的字符串位置
            NSString * result = [url_id substringFromIndex:range.location+3]; //截取字符串
            goods.IDstring = result;
            goods.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goods animated:YES];
        }if ([url_type isEqualToString:@"10"]||[url_type isEqualToString:@"0"]){
            WebViewController *web = [[WebViewController alloc] init];
            web.url = url;
            web.url_type = @"1";
            web.title = @"小慧推荐";
            NSRange range = [goodsid rangeOfString:@"id/"]; //现获取要截取的字符串位置
            NSString * result = [goodsid substringFromIndex:range.location+3]; //截取字符串
            web.id = result;
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }if ([url_type isEqualToString:@"12"]) {
            self.tabBarController.selectedIndex = 4;
        }if ([url_type isEqualToString:@"13"]) {
            circledetailsViewController *notice = [[circledetailsViewController alloc] init];
            notice.hidesBottomBarWhenPushed = YES;
            notice.id = url_id;
            [self.navigationController pushViewController:notice animated:YES];
        }if ([url_type isEqualToString:@"14"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_id]];
        }
    }if (indexPath.section==3) {
        if (indexPath.row==0) {
            shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
            erji.hidesBottomBarWhenPushed = YES;
            erji.rokou = @"2";
            [self.navigationController pushViewController:erji animated:YES];
        }
    }
}

- (void)GoodsDetail:(UIButton *)sender
{
        GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
        goods.IDstring = [NSString stringWithFormat:@"%lu",sender.tag];
        goods.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goods animated:YES];
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
