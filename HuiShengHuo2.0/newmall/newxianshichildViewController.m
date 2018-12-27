//
//  newxianshichildViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/20.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newxianshichildViewController.h"
#import "UIImageView+WebCache.h"
//#import <AFNetworking.h>
#import "liebiaoTableViewCell.h"
#import "liebiaomodel.h"
#import "GoodsDetailViewController.h"
#import "MJRefresh.h"
#import "PYSearch.h"
#import "searchreslutsViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import "newxianshichildViewController.h"
@interface newxianshichildViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITableView *_TableView;
    
    NSString *isstar;
    UIButton *_tmpBtn;
    UIButton *_tmpBtn1;
    
    NSMutableArray *liebiaoArr;
    NSMutableArray *modelArr;
    NSArray *biaoqianarr;
    
    NSString *liebiaoid;
    
    NSArray *_searcharr;
    NSArray *class_namearr;
    int _pagenum;
}

@end

@implementation newxianshichildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getclass];
    class_namearr = [NSArray array];
    isstar = @"0";
    // Do any additional setup after loading the view.
}
- (void)selectbut: (UIButton *)sender
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
    isstar = [NSString stringWithFormat:@"%ld",sender.tag];
    [_TableView.mj_header beginRefreshing];
    WBLog(@"#######%@",isstar);
}
- (void)getclass
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"is_star":_start};
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
    NSLog(@"---%@",dict);
    NSString *strurl = [API stringByAppendingString:@"shop/pro_discount_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        liebiaoArr = [[NSMutableArray alloc] init];
        modelArr = [NSMutableArray arrayWithCapacity:0];
        
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"getclass---success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            arr = [[responseObject objectForKey:@"data"] objectForKey:@"class_name"];
            
            UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 50)];
            //   _scrollView.delegate = self;//设置代理
            [_scrollView setContentSize:CGSizeMake(Main_width, 50)];
            _scrollView.backgroundColor = [UIColor whiteColor];
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.bounces = NO;
            _scrollView.pagingEnabled = NO;
            [self.view addSubview:_scrollView];
            for (int i=0; i<arr.count; i++) {
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(i*Main_width/4, 0, Main_width/4, 50);
                //but.backgroundColor = [arrrrrrrr objectAtIndex:i];
                [but setTitle:[[arr objectAtIndex:i] objectForKey:@"cate_name"] forState:UIControlStateNormal];
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
            
            class_namearr = [[responseObject objectForKey:@"data"] objectForKey:@"class_name"];
            [self createUI];
        }else{
            [self createUI1];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)getdata
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"is_star":_start,@"class_id":[[class_namearr objectAtIndex:_tmpBtn.tag] objectForKey:@"id"]};
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
    NSLog(@"---%@",dict);
    NSString *strurl = [API stringByAppendingString:@"shop/pro_discount_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        liebiaoArr = [[NSMutableArray alloc] init];
        modelArr = [NSMutableArray arrayWithCapacity:0];
        
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                arr = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
        
        
        
        
        
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
                        model.is_time = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"discount"]];
                        model.is_new = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_new"]];
                        model.is_hot = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_hot"]];
                        model.kucun = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"inventory"]];
                        model.is_start = isstar;
        
                        model.exihours = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"exist_hours"]];
                        model.id = [[arr objectAtIndex:i] objectForKey:@"id"];
                        model.tagname = [[arr objectAtIndex:i] objectForKey:@"tagname"];
                        model.tagid = [[arr objectAtIndex:i] objectForKey:@"tagid"];
                        model.title_img = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                        [modelArr addObject:model];
                    }
                    [liebiaoArr addObjectsFromArray:arr];
                }
        [_TableView.mj_header endRefreshing];
                [_TableView reloadData];
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
    NSString *p = [NSString stringWithFormat:@"%d",_pagenum];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"p":p,@"is_star":isstar,@"class_id":[[class_namearr objectAtIndex:[isstar integerValue]] objectForKey:@"id"]};
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
    NSString *strurl = [API stringByAppendingString:@"shop/pro_discount_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            arr = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum>i) {
                _TableView.mj_footer.state = MJRefreshStateNoMoreData;
                [_TableView.mj_footer resetNoMoreData];
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
                    model.is_new = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_new"]];
                    model.is_hot = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_hot"]];
                    model.kucun = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"inventory"]];
                    model.id = [[arr objectAtIndex:i] objectForKey:@"id"];
                    model.is_start = isstar;
                    model.is_time = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"discount"]];
                    model.exihours = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"exist_hours"]];
                    model.tagname = [[arr objectAtIndex:i] objectForKey:@"tagname"];
                    model.tagid = [[arr objectAtIndex:i] objectForKey:@"tagid"];
                    model.title_img = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                    [modelArr addObject:model];
                }
                [liebiaoArr addObjectsFromArray:arr];
            }
            
        }
        [_TableView.mj_footer endRefreshing];
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)createUI
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, Main_width, Main_Height-(RECTSTATUS.size.height+44+50+50))];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.backgroundColor = BackColor;
    _TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getdata)];
    _TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
    [_TableView.mj_header beginRefreshing];
    [self.view addSubview:_TableView];
}
- (void)createUI1
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height-(RECTSTATUS.size.height+44+50))];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.backgroundColor = BackColor;
    [self.view addSubview:_TableView];
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
