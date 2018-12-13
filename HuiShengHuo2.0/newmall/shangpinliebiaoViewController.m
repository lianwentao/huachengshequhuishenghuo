//
//  shangpinliebiaoViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/29.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "shangpinliebiaoViewController.h"
#import "PYSearch.h"
#import "searchreslutsViewController.h"
#import "shangpinliebiaochildViewController.h"
@interface shangpinliebiaoViewController ()<UITableViewDelegate,UITableViewDataSource,FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
{
    NSMutableArray *biaoqianarr;
    NSArray *idarr;
    UIButton *_tmpBtn;
    NSString *liebiaoid;
    
    NSMutableArray *liebiaoArr;
    NSMutableArray *modelArr;
    
    UITableView *_TabelView;
    NSArray *_searcharr;
    
    int _pagenum;
    
    
}
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@end

@implementation shangpinliebiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self post];
    [self createdaohangolan];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bupeisong) name:@"bupeisong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kucunbuzu) name:@"kucunbuzu" object:nil];//liebiaojiarugouwuche
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gouwuche:) name:@"liebiaojiarugouwuche" object:nil];
    // Do any additional setup after loading the view.
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
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
#pragma mark --
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
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
        
        idarr = [NSArray array];
        idarr = [responseObject objectForKey:@"data"];
        
        biaoqianarr = [[NSMutableArray alloc] init];
        NSArray *arr = [responseObject objectForKey:@"data"];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        for (int i=0; i<arr.count; i++) {
            [biaoqianarr addObject:[[arr objectAtIndex:i] objectForKey:@"cate_name"]];
        }
        
        self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, CGRectGetWidth(self.view.bounds), 50) titles:biaoqianarr delegate:self indicatorType:FSIndicatorTypeEqualTitle];
        [self setui];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)setui
{
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];//类型 qb->全部  dfw->待服务 dpj->待评价 wc->完成
    for (int i=0; i<idarr.count; i++) {
        shangpinliebiaochildViewController *vc = [[shangpinliebiaochildViewController alloc]init];
        vc.id = [[idarr objectAtIndex:i] objectForKey:@"id"];
        [childVCs addObject:vc];
    }
    
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:17];
    self.titleView.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(247)/255.0 blue:(248)/255.0 alpha:0.54];
    self.titleView.titleNormalColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.54];
    self.titleView.selectIndex = 0;
    [self.view addSubview:_titleView];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    //self.pageContentView.contentViewCanScroll = YES;//设置滑动属性
    [self.view addSubview:_pageContentView];
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
