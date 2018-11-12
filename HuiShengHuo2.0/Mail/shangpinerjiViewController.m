//
//  shangpinerjiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/15.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "shangpinerjiViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "GoodsDetailViewController.h"
#import "MJRefresh.h"
#import "UITableView+PlaceHolderView.h"
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#import "PrefixHeader.pch"
#import "liebiaomodel.h"
#import "liebiaoTableViewCell.h"
#import "PYSearch.h"
#import "searchreslutsViewController.h"
#import "MBProgressHUD+TVAssistant.h"
@interface shangpinerjiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_DataArr;
    int _pagenum;
    NSArray *_searcharr;
    NSMutableArray *modelArr;
}

@end

@implementation shangpinerjiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pagenum = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    _DataArr = [[NSMutableArray alloc] init];
    [self post];
    [self createtableview];
    [self createdaohangolan];
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bupeisong) name:@"bupeisong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kucunbuzu) name:@"kucunbuzu" object:nil];//liebiaojiarugouwuche
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gouwuche:) name:@"liebiaojiarugouwuche" object:nil];
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
    // Do any additional setup after loading the view.
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *mid = [user objectForKey:@"community_id"];
    if ([_rokou isEqualToString:@"2"]) {
        dict = @{@"c_id":mid};
    }else{
        dict = @{@"id":_id,@"c_id":mid};
    }
    NSString *strurl = [API stringByAppendingString:@"shop/pro_list"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@--%@",[responseObject objectForKey:@"msg"],responseObject,dict);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        modelArr = [NSMutableArray arrayWithCapacity:0];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            arr = [responseObject objectForKey:@"data"];
            if ([_rokou isEqualToString:@"2"]) {
                //self.title = @"精选商品";
                self.title = [[arr objectAtIndex:0] objectForKey:@"category_title"];
            }else{
                //self.title = [[arr objectAtIndex:0] objectForKey:@"category_title"];
            }
            for (int i=0; i<arr.count; i++) {
                liebiaomodel *model = [[liebiaomodel alloc] init];
                model.imagestring = [[arr objectAtIndex:i] objectForKey:@"title_thumb_img"];
                model.title = [[arr objectAtIndex:i] objectForKey:@"title"];
                model.tagArr = [[arr objectAtIndex:i] objectForKey:@"goods_tag"];
                model.nowprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"price"]];
                model.yuanprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"original"]];
                model.unit = [[arr objectAtIndex:i] objectForKey:@"unit"];
                model.yishou = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"order_num"]];
                model.biaoshi = @"0";//1代表限时抢购，0代表其他商品
                model.is_new = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_new"]];
                model.is_hot = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_hot"]];
                model.is_time = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"discount"]];
                model.kucun = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"inventory"]];
                model.exihours = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"exist_hours"]];
                model.id = [[arr objectAtIndex:i] objectForKey:@"id"];
                model.tagname = [[arr objectAtIndex:i] objectForKey:@"tagname"];
                model.tagid = [[arr objectAtIndex:i] objectForKey:@"tagid"];
                model.title_img = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                [modelArr addObject:model];
            }
        }else{
            arr = nil;
        }
        [_DataArr addObjectsFromArray:arr];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)post1
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum = _pagenum + 1;
    NSLog(@"%@",[NSString stringWithFormat:@"%d",_pagenum]);
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *mid = [user objectForKey:@"community_id"];
    if ([_rokou isEqualToString:@"2"]) {
        dict = @{@"c_id":mid,@"p":[NSString stringWithFormat:@"%d",_pagenum]};
    }else{
        dict = @{@"id":_id,@"c_id":mid,@"p":[NSString stringWithFormat:@"%d",_pagenum]};
    }
    NSLog(@"%@",dict);
    NSString *strurl = [API stringByAppendingString:@"shop/pro_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum>i) {
                _tableView.mj_footer.state = MJRefreshStateNoMoreData;
                [_tableView.mj_footer resetNoMoreData];
            }else{
                for (int i=0; i<arr.count; i++) {
                    liebiaomodel *model = [[liebiaomodel alloc] init];
                    model.imagestring = [[arr objectAtIndex:i] objectForKey:@"title_thumb_img"];
                    model.title = [[arr objectAtIndex:i] objectForKey:@"title"];
                    model.tagArr = [[arr objectAtIndex:i] objectForKey:@"goods_tag"];
                    model.nowprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"price"]];
                    model.yuanprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"original"]];
                    model.unit = [[arr objectAtIndex:i] objectForKey:@"unit"];
                    model.yishou = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"order_num"]];
                    model.biaoshi = @"0";//1代表限时抢购，0代表其他商品
                    model.is_new = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_new"]];
                    model.is_hot = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_hot"]];
                    model.is_time = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"discount"]];
                    model.kucun = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"inventory"]];
                    model.id = [[arr objectAtIndex:i] objectForKey:@"id"];
                    model.exihours = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"exist_hours"]];
                    model.tagname = [[arr objectAtIndex:i] objectForKey:@"tagname"];
                    model.tagid = [[arr objectAtIndex:i] objectForKey:@"tagid"];
                    model.title_img = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                    [modelArr addObject:model];
                }
                [_DataArr addObjectsFromArray:arr];
                [_tableView.mj_footer endRefreshing];
            }
            [_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)createtableview
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
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
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
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
    gooddetail.IDstring = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
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
