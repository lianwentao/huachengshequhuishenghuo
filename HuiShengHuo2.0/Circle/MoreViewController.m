//
//  MoreViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/28.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "MoreViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "SaveViewController.h"
#import "MJRefresh.h"
#import "circledetailsViewController.h"
#import "UITableView+PlaceHolderView.h"
#import <YYLabel.h>
#import "PrefixHeader.pch"
#import "circleCell.h"
#import "NoiconCell.h"
#import "pengyouquanmodel.h"
#import "fabutieziViewController.h"
#import "LSPPageView.h"
#import "YBPopupMenu.h"
#import "mycircleViewController.h"
#import "DefaultView.h"
#import "LoginViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import "newgonggaoTableViewCell.h"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *Arr;
    int _pagenum;
    int _pagenum1;
    int _pagenum2;
    int _pagenum3;
    int _pagenum4;
    int _pagenum5;
    int _pagenum6;
    int _pagenum7;
    int _pagenum8;
    int _pagenum9;
    int _pagenum10;
    NSMutableArray *ImageArr;
    NSMutableArray *ImageArr1;
    NSMutableArray *ImageArr2;
    NSMutableArray *ImageArr3;
    NSMutableArray *ImageArr4;
    NSMutableArray *ImageArr5;
    NSMutableArray *ImageArr6;
    NSMutableArray *ImageArr7;
    NSMutableArray *ImageArr8;
    NSMutableArray *ImageArr9;
    NSMutableArray *ImageArr10;
    
    UIScrollView *BIG_scrollview;
    NSMutableArray *quanzizhongleiArr;
    
    UIViewController *vc;
    
    UIButton *savebutton;
    
    UIImageView *nodataimageview;
    UILabel *nodatalabel;
}

@property(nonatomic ,strong)UITableView *TableView0;
@property(nonatomic ,strong)UITableView *TableView1;
@property(nonatomic ,strong)UITableView *TableView2;
@property(nonatomic ,strong)UITableView *TableView3;
@property(nonatomic ,strong)UITableView *TableView4;
@property(nonatomic ,strong)UITableView *TableView5;
@property(nonatomic ,strong)UITableView *TableView6;
@property(nonatomic ,strong)UITableView *TableView7;
@property(nonatomic ,strong)UITableView *TableView8;
@property(nonatomic ,strong)UITableView *TableView9;
@property(nonatomic ,strong)UITableView *TableView10;

@property(nonatomic ,strong)NSMutableArray *DataArr;
@property(nonatomic ,strong)NSMutableArray *DataArr1;
@property(nonatomic ,strong)NSMutableArray *DataArr2;
@property(nonatomic ,strong)NSMutableArray *DataArr3;
@property(nonatomic ,strong)NSMutableArray *DataArr4;
@property(nonatomic ,strong)NSMutableArray *DataArr5;
@property(nonatomic ,strong)NSMutableArray *DataArr6;
@property(nonatomic ,strong)NSMutableArray *DataArr7;
@property(nonatomic ,strong)NSMutableArray *DataArr8;
@property(nonatomic ,strong)NSMutableArray *DataArr9;
@property(nonatomic ,strong)NSMutableArray *DataArr10;
@end

@implementation MoreViewController


//#pragma mark - 隐藏导航栏
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//}

-(void)postquanzicategroy{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSString *strurl = [API stringByAppendingString:@"social/getSocialCategory"];
    [manager GET:strurl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"list--success--%@--%@",[responseObject class],responseObject);
        quanzizhongleiArr = [[NSMutableArray alloc] init];
        quanzizhongleiArr = [responseObject objectForKey:@"data"];
        [self createTableView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}


- (void)createTableView
{
    NSMutableArray *testArray = [NSMutableArray array];
    NSMutableArray *childVcArray = [NSMutableArray array];
    for (int i = 0; i < quanzizhongleiArr.count; i++) {
        [testArray addObject:[[quanzizhongleiArr objectAtIndex:i] objectForKey:@"c_name"]];
    }
    //    NSArray *titles = @[@"BTC0",@"ETH",@"BNB",@"TRX",@"BTC",@"ETH",@"BNB",@"TRX"];
    for (int i = 0; i < quanzizhongleiArr.count; i++) {
        vc = [[UIViewController alloc] init];
        if (i==0) {
            _TableView0 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height) style:UITableViewStylePlain];
            
            _TableView0.estimatedRowHeight = 0;
            _TableView0.tag = 0;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView0.tableHeaderView = view;
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView0.tableFooterView = view1;
            _TableView0.delegate = self;
            _TableView0.dataSource = self;
            _TableView0.separatorStyle = UITableViewCellSeparatorStyleNone;
            [vc.view addSubview:_TableView0];
            
            _TableView0.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post0)];
            //_TableView.mj_header.las = YES;
            //上拉刷新
            _TableView0.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post00)];
            [_TableView0.mj_header beginRefreshing];
        }if (i==4) {
            _TableView4 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-49) style:UITableViewStylePlain];
            
            _TableView4.estimatedRowHeight = 0;
            _TableView4.tag = 4;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView4.tableHeaderView = view;
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView4.tableFooterView = view1;
            _TableView4.delegate = self;
            _TableView4.dataSource = self;
            _TableView4.separatorStyle = UITableViewCellSeparatorStyleNone;
            [vc.view addSubview:_TableView4];
            
            _TableView4.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post4)];
            //_TableView.mj_header.las = YES;
            //上拉刷新
            _TableView4.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post44)];
            [_TableView4.mj_header beginRefreshing];
        }if (i==3) {
            _TableView3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64-49) style:UITableViewStylePlain];
            
            _TableView3.estimatedRowHeight = 0;
            _TableView3.tag = 3;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView3.tableHeaderView = view;
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView3.tableFooterView = view1;
            _TableView3.delegate = self;
            _TableView3.dataSource = self;
            [vc.view addSubview:_TableView3];
            vc.view.tag = [[[quanzizhongleiArr objectAtIndex:i] objectForKey:@"id"] integerValue];
            _TableView3.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post3)];
            //_TableView.mj_header.las = YES;
            //上拉刷新
            _TableView3.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post33)];
            [_TableView3.mj_header beginRefreshing];
        }if (i==1) {
            _TableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64-49) style:UITableViewStylePlain];
            
            _TableView1.estimatedRowHeight = 0;
            _TableView1.tag = 1;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView1.tableHeaderView = view;
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView1.tableFooterView = view1;
            _TableView1.delegate = self;
            _TableView1.dataSource = self;
            _TableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
            [vc.view addSubview:_TableView1];
            _TableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post1)];
            //_TableView.mj_header.las = YES;
            //上拉刷新
            _TableView1.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post11)];
            [_TableView1.mj_header beginRefreshing];
            
            nodataimageview = [[UIImageView alloc] initWithFrame:CGRectMake(100, 150, 100, 100)];
            nodataimageview.image = [UIImage imageNamed:@"pinglunweikong"];
            nodataimageview.contentMode = UIViewContentModeScaleAspectFit;
            //[_TableView1 addSubview:nodataimageview];
            nodatalabel = [[UILabel alloc] initWithFrame:CGRectMake(nodataimageview.frame.size.height+nodataimageview.frame.origin.y+20, 0, 300, 40)];
            nodatalabel.textColor = [UIColor grayColor];
            nodatalabel.textAlignment = NSTextAlignmentCenter;
            nodatalabel.text = @"暂无数据^_^";
            [_TableView1 addSubview:nodatalabel];
        }if (i==2) {
            _TableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64-49) style:UITableViewStylePlain];
            
            _TableView2.estimatedRowHeight = 0;
            _TableView2.tag = 2;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView2.tableHeaderView = view;
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView2.tableFooterView = view1;
            _TableView2.delegate = self;
            _TableView2.dataSource = self;
            _TableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
            [vc.view addSubview:_TableView2];
            _TableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post2)];
            //_TableView.mj_header.las = YES;
            //上拉刷新
            _TableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post22)];
            [_TableView2.mj_header beginRefreshing];
        }
        if (i==5) {
            _TableView5 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64-49) style:UITableViewStylePlain];
            
            _TableView5.estimatedRowHeight = 0;
            _TableView5.tag = 5;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView5.tableHeaderView = view;
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView5.tableFooterView = view1;
            _TableView5.delegate = self;
            _TableView5.dataSource = self;
            _TableView5.separatorStyle = UITableViewCellSeparatorStyleNone;
            [vc.view addSubview:_TableView5];
            _TableView5.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post5)];
            //_TableView.mj_header.las = YES;
            //上拉刷新
            _TableView5.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post55)];
            [_TableView5.mj_header beginRefreshing];
        }if (i==6) {
            _TableView6 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64-49) style:UITableViewStylePlain];
            
            _TableView6.estimatedRowHeight = 0;
            _TableView6.tag = 6;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView6.tableHeaderView = view;
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView6.tableFooterView = view1;
            _TableView6.delegate = self;
            _TableView6.dataSource = self;
            _TableView6.separatorStyle = UITableViewCellSeparatorStyleNone;
            [vc.view addSubview:_TableView6];
            _TableView6.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post6)];
            //_TableView.mj_header.las = YES;
            //上拉刷新
            _TableView6.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post66)];
            [_TableView6.mj_header beginRefreshing];
        }if (i==7) {
            _TableView7 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64-49) style:UITableViewStylePlain];
            
            _TableView7.estimatedRowHeight = 0;
            _TableView7.tag = 7;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView7.tableHeaderView = view;
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView7.tableFooterView = view1;
            _TableView7.delegate = self;
            _TableView7.dataSource = self;
            _TableView7.separatorStyle = UITableViewCellSeparatorStyleNone;
            [vc.view addSubview:_TableView7];
            _TableView7.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post7)];
            //_TableView.mj_header.las = YES;
            //上拉刷新
            _TableView7.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post77)];
            [_TableView7.mj_header beginRefreshing];
        }if (i==8) {
            _TableView8 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64-49) style:UITableViewStylePlain];
            
            _TableView8.estimatedRowHeight = 0;
            _TableView8.tag = 8;
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView8.tableHeaderView = view;
            UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
            _TableView8.tableFooterView = view1;
            _TableView8.delegate = self;
            _TableView8.dataSource = self;
            _TableView8.separatorStyle = UITableViewCellSeparatorStyleNone;
            [vc.view addSubview:_TableView8];
            _TableView8.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post8)];
            //_TableView.mj_header.las = YES;
            //上拉刷新
            _TableView8.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post88)];
            [_TableView8.mj_header beginRefreshing];
        }
        [childVcArray addObject:vc];
        //[_TableView.mj_header beginRefreshing];
    }
    LSPPageView *pageView = [[LSPPageView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height, self.view.bounds.size.width, self.view.bounds.size.height-RECTSTATUS.size.height) titles:testArray.mutableCopy style:nil childVcs:childVcArray.mutableCopy parentVc:self];
    pageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pageView];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+43.5, Main_width, 0.5)];
    lineview.backgroundColor = [UIColor blackColor];
    lineview.alpha = 0.3;
    [self.view addSubview:lineview];
    
    savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame = CGRectMake(Main_width-40, RECTSTATUS.size.height+7, 30, 30);
    [savebutton setImage:[UIImage imageNamed:@"ic_edit"] forState:UIControlStateNormal];
    [savebutton addTarget:self action:@selector(saveCircle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:savebutton];
}
- (void)viewDidLoad {
    
    //self.title = @"圈子";
    
    _DataArr = [[NSMutableArray alloc] init];
    _DataArr1 = [[NSMutableArray alloc] init];
    _DataArr2 = [[NSMutableArray alloc] init];
    _DataArr3 = [[NSMutableArray alloc] init];
    _DataArr4 = [[NSMutableArray alloc] init];
    _DataArr5 = [[NSMutableArray alloc] init];
    _DataArr6 = [[NSMutableArray alloc] init];
    _DataArr7 = [[NSMutableArray alloc] init];
    _DataArr8 = [[NSMutableArray alloc] init];
    _DataArr9 = [[NSMutableArray alloc] init];
    _DataArr10 = [[NSMutableArray alloc] init];
    
    ImageArr = [[NSMutableArray alloc] init];
    ImageArr1 = [[NSMutableArray alloc] init];
    ImageArr2 = [[NSMutableArray alloc] init];
    ImageArr3 = [[NSMutableArray alloc] init];
    ImageArr4 = [[NSMutableArray alloc] init];
    ImageArr5 = [[NSMutableArray alloc] init];
    ImageArr6 = [[NSMutableArray alloc] init];
    ImageArr7 = [[NSMutableArray alloc] init];
    ImageArr8 = [[NSMutableArray alloc] init];
    ImageArr9 = [[NSMutableArray alloc] init];
    ImageArr10 = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
    self.navigationController.delegate = self;
    [self postquanzicategroy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"changequnzishouye" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"changetitle" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletetiezi:) name:@"shanchutiezi" object:nil];
    [self createRightbut];
    //[self nodataview];
    // Do any additional setup after loading the view.
}
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
    
}
- (void)deletetiezi:(NSNotification *)userinfo
{
    //初始化警告框
    UIAlertController*alert = [UIAlertController
                               alertControllerWithTitle:@"提示"
                               message: @"是否确认删除"
                               preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"取消"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                          NSLog(@"取消退出登录");
                      }]];
    [alert addAction:[UIAlertAction
                      actionWithTitle:@"确定"
                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                      {
                          NSString *socail_id = [userinfo.userInfo objectForKey:@"scoailid"];
                          //1.创建会话管理者
                          AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                          manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                          //2.封装参数
                          NSDictionary *dict = nil;
                          NSUserDefaults *userdefalts = [NSUserDefaults standardUserDefaults];
                          NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userdefalts objectForKey:@"uid"],[userdefalts objectForKey:@"username"]]];
                          //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
                          dict = @{@"social_id":socail_id,@"apk_token":uid_username,@"token":[userdefalts objectForKey:@"token"],@"tokenSecret":[userdefalts objectForKey:@"tokenSecret"]};
                          NSString *strurl = [API stringByAppendingString:@"social/SocialDel"];
                          [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSLog(@"%@--%@",responseObject,[responseObject class]);
                              if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                                  [self post0];
                                  [self post1];
                                  [self post2];
                                  [self post3];
                                  [self post4];
                                  [self post5];
                                  [self post6];[self post7];[self post8];
                              }else{
                                  
                              }
                              [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              NSLog(@"failure--%@",error);
                          }];
                      }]];
    //弹出提示框
    [self presentViewController:alert
                       animated:YES completion:nil];
}
- (void)change
{
    [_TableView0.mj_header beginRefreshing];
    [_TableView1.mj_header beginRefreshing];
    [_TableView2.mj_header beginRefreshing];
    [_TableView3.mj_header beginRefreshing];
    [_TableView4.mj_header beginRefreshing];
    [_TableView5.mj_header beginRefreshing];
    [_TableView6.mj_header beginRefreshing];
    [_TableView7.mj_header beginRefreshing];
    [_TableView8.mj_header beginRefreshing];
}
#pragma mark ------联网请求---
-(void)post0
{
    _pagenum =1;
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
     NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:0] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:0] objectForKey:@"is_pro"] integerValue]],@"apk_token":uid_username};
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"teizilist---%@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
            [_DataArr removeAllObjects];
            [ImageArr removeAllObjects];
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr addObjectsFromArray:imgarr];
            for (int i=0; i<ImageArr.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[ImageArr objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                
                NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                    model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                }else{
                    model.touxiangurl = avatarsstring;
                }
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[ImageArr objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[ImageArr objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[ImageArr objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[ImageArr objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[ImageArr objectAtIndex:i] objectForKey:@"community_name"];
                [_DataArr addObject:model];
            }
            nodataimageview.hidden = YES;
            nodatalabel.hidden = YES;
        }else{
            nodataimageview.hidden = NO;
            nodatalabel.hidden = NO;
        }
        [_TableView0 reloadData];
        
        [_TableView0.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post1
{
    _pagenum1 = 1;
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:1] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:1] objectForKey:@"is_pro"] integerValue]],@"apk_token":uid_username};
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"1111---%@",responseObject);
            [_DataArr1 removeAllObjects];
            [ImageArr1 removeAllObjects];
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr1 addObjectsFromArray:imgarr];
            for (int i=0; i<ImageArr1.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[ImageArr1 objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                    model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                }else{
                    model.touxiangurl = avatarsstring;
                }
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[ImageArr1 objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[ImageArr1 objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[ImageArr1 objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[ImageArr1 objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[ImageArr1 objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[ImageArr1 objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[ImageArr1 objectAtIndex:i] objectForKey:@"community_name"];
                [_DataArr1 addObject:model];
            }
//            nodataimageview.hidden = YES;
//            nodatalabel.hidden = YES;
        }else{
//            nodataimageview.hidden = NO;
//            nodatalabel.hidden = NO;
        }
        [_TableView1 reloadData];
        
        [_TableView1.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post2
{
    _pagenum2 = 1;
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:2] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:2] objectForKey:@"is_pro"] integerValue]],@"apk_token":uid_username};
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"2222---%@",responseObject);
            [_DataArr2 removeAllObjects];
            [ImageArr2 removeAllObjects];
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr2 addObjectsFromArray:imgarr];
            for (int i=0; i<ImageArr2.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[ImageArr2 objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                    model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                }else{
                    model.touxiangurl = avatarsstring;
                }
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[ImageArr2 objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[ImageArr2 objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[ImageArr2 objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[ImageArr2 objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[ImageArr2 objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[ImageArr2 objectAtIndex:i] objectForKey:@"community_name"];
                [_DataArr2 addObject:model];
            }
            
        }
        [_TableView2 reloadData];
        
        [_TableView2.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post3
{
    _pagenum3 = 1;
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:3] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:3] objectForKey:@"is_pro"] integerValue]],@"apk_token":uid_username};
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"---%@",responseObject);
            [_DataArr3 removeAllObjects];
            [ImageArr3 removeAllObjects];
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr3 addObjectsFromArray:imgarr];
            for (int i=0; i<ImageArr3.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[ImageArr3 objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                    model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                }else{
                    model.touxiangurl = avatarsstring;
                }
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[ImageArr3 objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[ImageArr3 objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[ImageArr3 objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[ImageArr3 objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[ImageArr3 objectAtIndex:i] objectForKey:@"community_name"];
                [_DataArr3 addObject:model];
            }
            
        }
        [_TableView3 reloadData];
        
        [_TableView3.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post4
{
    _pagenum4 = 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:4] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:4] objectForKey:@"is_pro"] integerValue]],@"apk_token":uid_username};
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"---%@",responseObject);
            [_DataArr4 removeAllObjects];
            [ImageArr4 removeAllObjects];
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr4 addObjectsFromArray:imgarr];
            for (int i=0; i<ImageArr4.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[ImageArr4 objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                    model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                }else{
                    model.touxiangurl = avatarsstring;
                }
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[ImageArr4 objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[ImageArr4 objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[ImageArr4 objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[ImageArr4 objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[ImageArr4 objectAtIndex:i] objectForKey:@"community_name"];
                [_DataArr4 addObject:model];
            }
            
        }
        [_TableView4 reloadData];
        
        [_TableView4.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post5
{
    _pagenum5 = 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:5] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:5] objectForKey:@"is_pro"] integerValue]],@"apk_token":uid_username};
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"---%@",responseObject);
            [_DataArr5 removeAllObjects];
            [ImageArr5 removeAllObjects];
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr5 addObjectsFromArray:imgarr];
            for (int i=0; i<ImageArr5.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[ImageArr5 objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                    model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                }else{
                    model.touxiangurl = avatarsstring;
                }
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[ImageArr5 objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[ImageArr5 objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[ImageArr5 objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[ImageArr5 objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[ImageArr5 objectAtIndex:i] objectForKey:@"community_name"];
                [_DataArr5 addObject:model];
            }
            
        }
        [_TableView5 reloadData];
        
        [_TableView5.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post6
{
    _pagenum6 = 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
   
        //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
        dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:6] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:6] objectForKey:@"is_pro"] integerValue]],@"apk_token":uid_username};
        NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                NSLog(@"---%@",responseObject);
                [_DataArr6 removeAllObjects];
                [ImageArr6 removeAllObjects];
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr6 addObjectsFromArray:imgarr];
                for (int i=0; i<ImageArr6.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[ImageArr6 objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                    if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                        model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                    }else{
                        model.touxiangurl = avatarsstring;
                    }
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.title = labeltext2;
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[ImageArr6 objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[ImageArr6 objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[ImageArr6 objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[ImageArr6 objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[ImageArr6 objectAtIndex:i] objectForKey:@"community_name"];
                    [_DataArr6 addObject:model];
                }
                
            }
            [_TableView6 reloadData];
            
            [_TableView6.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    
    
}
-(void)post7
{
    _pagenum7 = 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    
        //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
        dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:7] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:7] objectForKey:@"is_pro"] integerValue]],@"apk_token":uid_username};
        NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                NSLog(@"---%@",responseObject);
                [_DataArr7 removeAllObjects];
                [ImageArr7 removeAllObjects];
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr7 addObjectsFromArray:imgarr];
                for (int i=0; i<ImageArr7.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[ImageArr7 objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                    if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                        model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                    }else{
                        model.touxiangurl = avatarsstring;
                    }
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.title = labeltext2;
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[ImageArr7 objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[ImageArr7 objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[ImageArr7 objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[ImageArr7 objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[ImageArr7 objectAtIndex:i] objectForKey:@"community_name"];
                    [_DataArr7 addObject:model];
                }
                
            }
            [_TableView7 reloadData];
            
            [_TableView7.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    
    
}
-(void)post8
{
    _pagenum8 = 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    
        //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
        dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:8] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:8] objectForKey:@"is_pro"] integerValue]],@"apk_token":uid_username};
        NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                NSLog(@"---%@",responseObject);
                [_DataArr8 removeAllObjects];
                [ImageArr8 removeAllObjects];
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr8 addObjectsFromArray:imgarr];
                for (int i=0; i<ImageArr8.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[ImageArr8 objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                    if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                        model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                    }else{
                        model.touxiangurl = avatarsstring;
                    }
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.title = labeltext2;
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[ImageArr8 objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[ImageArr8 objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[ImageArr8 objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[ImageArr8 objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[ImageArr8 objectAtIndex:i] objectForKey:@"community_name"];
                    [_DataArr8 addObject:model];
                }
                
            }
            [_TableView8 reloadData];
            
            [_TableView8.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    
    
}
-(void)post9
{
    _pagenum9 = 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    int j = 9;
    if (quanzizhongleiArr.count>=j) {
        //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
        dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:9] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:9] objectForKey:@"is_pro"] integerValue]],@"apk_token":uid_username};
        NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                NSLog(@"---%@",responseObject);
                [_DataArr9 removeAllObjects];
                [ImageArr9 removeAllObjects];
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr9 addObjectsFromArray:imgarr];
                for (int i=0; i<ImageArr6.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[ImageArr9 objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                    if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                        model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                    }else{
                        model.touxiangurl = avatarsstring;
                    }
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.title = labeltext2;
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[ImageArr9 objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[ImageArr9 objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[ImageArr9 objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[ImageArr9 objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[ImageArr9 objectAtIndex:i] objectForKey:@"community_name"];
                    [_DataArr9 addObject:model];
                }
                
            }
            [_TableView9 reloadData];
            
            [_TableView9.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }
    
}
-(void)post10
{
    _pagenum10 = 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    int j = 10;
    if (quanzizhongleiArr.count>=j) {
        //NSString *c_id = [[quanzizhongleiArr objectAtIndex:[NSString stringWithFormat:@"%d",tag]] objectForKey:@"id"];
        dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"is_pro"] integerValue]],@"apk_token":uid_username};
        NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                NSLog(@"---%@",responseObject);
                [_DataArr10 removeAllObjects];
                [ImageArr10 removeAllObjects];
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr10 addObjectsFromArray:imgarr];
                for (int i=0; i<ImageArr10.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[ImageArr10 objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                    if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                        model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                    }else{
                        model.touxiangurl = avatarsstring;
                    }
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.title = labeltext2;
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[ImageArr10 objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[ImageArr10 objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[ImageArr10 objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[ImageArr10 objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[ImageArr10 objectAtIndex:i] objectForKey:@"community_name"];
                    [_DataArr10 addObject:model];
                }
            }
            [_TableView10 reloadData];
            
            [_TableView10.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }
    
}
-(void)post00
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum = _pagenum+1;
    NSLog(@"%d",_pagenum);
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:0] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:0] objectForKey:@"is_pro"] integerValue]],@"p":string,@"apk_token":uid_username};

    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        NSArray *arr = [[NSArray alloc] init];
        arr = [responseObject objectForKey:@"data"];
        NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
        NSInteger i = [stringnumber integerValue];
        if (_pagenum>i) {
            _TableView0.mj_footer.state = MJRefreshStateNoMoreData;
            [_TableView0.mj_footer resetNoMoreData];
        }else{
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr addObjectsFromArray:imgarr];
            for (int i=0; i<imgarr.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                    model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                }else{
                    model.touxiangurl = avatarsstring;
                }
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];

                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                [_DataArr addObject:model];
            }
            [_TableView0 reloadData];
            [_TableView0.mj_footer endRefreshing];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post11
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum1 = _pagenum1+1;
    NSLog(@"%d",_pagenum1);
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum1];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:1] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:1] objectForKey:@"is_pro"] integerValue]],@"p":string,@"apk_token":uid_username};
    
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        NSArray *arr = [[NSArray alloc] init];
        arr = [responseObject objectForKey:@"data"];
        NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
        NSInteger i = [stringnumber integerValue];
        if (_pagenum1>i) {
            _TableView1.mj_footer.state = MJRefreshStateNoMoreData;
            [_TableView1.mj_footer resetNoMoreData];
        }else{
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr1 addObjectsFromArray:imgarr];
            for (int i=0; i<imgarr.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                    model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                }else{
                    model.touxiangurl = avatarsstring;
                }
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                [_DataArr1 addObject:model];
            }
            [_TableView1 reloadData];
            [_TableView1.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post22
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum2 = _pagenum2+1;
    NSLog(@"%d",_pagenum2);
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum2];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:2] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:2] objectForKey:@"is_pro"] integerValue]],@"p":string,@"apk_token":uid_username};
    
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        NSArray *arr = [[NSArray alloc] init];
        arr = [responseObject objectForKey:@"data"];
        NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
        NSInteger i = [stringnumber integerValue];
        if (_pagenum2>i) {
            _TableView2.mj_footer.state = MJRefreshStateNoMoreData;
            [_TableView2.mj_footer resetNoMoreData];
        }else{
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr2 addObjectsFromArray:imgarr];
            for (int i=0; i<imgarr.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                    model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                }else{
                    model.touxiangurl = avatarsstring;
                }
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                [_DataArr2 addObject:model];
            }
            [_TableView2 reloadData];
            [_TableView2.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post33
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum3 = _pagenum3+1;
    NSLog(@"%d",_pagenum3);
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum3];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:3] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:3] objectForKey:@"is_pro"] integerValue]],@"p":string,@"apk_token":uid_username};
    
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        NSArray *arr = [[NSArray alloc] init];
        arr = [responseObject objectForKey:@"data"];
        NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
        NSInteger i = [stringnumber integerValue];
        if (_pagenum3>i) {
            _TableView3.mj_footer.state = MJRefreshStateNoMoreData;
            [_TableView3.mj_footer resetNoMoreData];
        }else{
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr3 addObjectsFromArray:imgarr];
            for (int i=0; i<imgarr.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                    model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                }else{
                    model.touxiangurl = avatarsstring;
                }
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                [_DataArr3 addObject:model];
            }
            [_TableView3 reloadData];
            [_TableView3.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post44
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum4 = _pagenum4+1;
    NSLog(@"%d",_pagenum4);
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum4];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:4] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:4] objectForKey:@"is_pro"] integerValue]],@"p":string,@"apk_token":uid_username};
    
    NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        NSArray *arr = [[NSArray alloc] init];
        arr = [responseObject objectForKey:@"data"];
        NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
        NSInteger i = [stringnumber integerValue];
        if (_pagenum4>i) {
            _TableView4.mj_footer.state = MJRefreshStateNoMoreData;
            [_TableView4.mj_footer resetNoMoreData];
        }else{
            NSMutableArray *imgarr = [[NSMutableArray alloc] init];
            imgarr = [responseObject objectForKey:@"data"];
            [ImageArr4 addObjectsFromArray:imgarr];
            for (int i=0; i<imgarr.count; i++) {
                pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                model.content = labeltext;
                NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                    model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                }else{
                    model.touxiangurl = avatarsstring;
                }
                model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                model.title = labeltext2;
                model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                [_DataArr4 addObject:model];
            }
            [_TableView4 reloadData];
            [_TableView4.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post55
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum5 = _pagenum5+1;
    NSLog(@"%d",_pagenum5);
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum5];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    int j = 5;
    if (quanzizhongleiArr.count>=j) {
        dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"is_pro"] integerValue]],@"p":string,@"apk_token":uid_username};
        
        NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
            NSArray *arr = [[NSArray alloc] init];
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum5>i) {
                _TableView5.mj_footer.state = MJRefreshStateNoMoreData;
                [_TableView5.mj_footer resetNoMoreData];
            }else{
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr5 addObjectsFromArray:imgarr];
                for (int i=0; i<imgarr.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                    if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                        model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                    }else{
                        model.touxiangurl = avatarsstring;
                    }
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.title = labeltext2;
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                    [_DataArr5 addObject:model];
                }
                [_TableView5 reloadData];
                [_TableView5.mj_footer endRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }
}
-(void)post66
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum6 = _pagenum6+1;
    NSLog(@"%d",_pagenum6);
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum6];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    int j = 6;
    if (quanzizhongleiArr.count>=j) {
        dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"is_pro"] integerValue]],@"p":string,@"apk_token":uid_username};
        
        NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
            NSArray *arr = [[NSArray alloc] init];
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum6>i) {
                _TableView6.mj_footer.state = MJRefreshStateNoMoreData;
                [_TableView6.mj_footer resetNoMoreData];
            }else{
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr6 addObjectsFromArray:imgarr];
                for (int i=0; i<imgarr.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                    if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                        model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                    }else{
                        model.touxiangurl = avatarsstring;
                    }
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.title = labeltext2;
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                    [_DataArr6 addObject:model];
                }
                [_TableView6 reloadData];
                [_TableView6.mj_footer endRefreshing];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }
}
-(void)post77
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum7 = _pagenum7+1;
    NSLog(@"%d",_pagenum7);
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum5];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    int j = 7;
    if (quanzizhongleiArr.count>=j) {
        dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"is_pro"] integerValue]],@"p":string,@"apk_token":uid_username};
        
        NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
            NSArray *arr = [[NSArray alloc] init];
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum7>i) {
                _TableView7.mj_footer.state = MJRefreshStateNoMoreData;
                [_TableView7.mj_footer resetNoMoreData];
            }else{
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr7 addObjectsFromArray:imgarr];
                for (int i=0; i<imgarr.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                    if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                        model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                    }else{
                        model.touxiangurl = avatarsstring;
                    }
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.title = labeltext2;
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                    [_DataArr7 addObject:model];
                }
                [_TableView7 reloadData];
                [_TableView7.mj_footer endRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }
}
-(void)post88
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum8 = _pagenum8+1;
    NSLog(@"%d",_pagenum8);
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum8];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    int j = 8;
    if (quanzizhongleiArr.count>=j) {
        dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"is_pro"] integerValue]],@"p":string,@"apk_token":uid_username};
        
        NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
            NSArray *arr = [[NSArray alloc] init];
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum8>i) {
                _TableView8.mj_footer.state = MJRefreshStateNoMoreData;
                [_TableView8.mj_footer resetNoMoreData];
            }else{
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr5 addObjectsFromArray:imgarr];
                for (int i=0; i<imgarr.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                    if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                        model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                    }else{
                        model.touxiangurl = avatarsstring;
                    }
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.title = labeltext2;
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                    [_DataArr8 addObject:model];
                }
                [_TableView8 reloadData];
                [_TableView8.mj_footer endRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }
}
-(void)post99
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum9 = _pagenum9+1;
    NSLog(@"%d",_pagenum9);
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum5];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    int j = 9;
    if (quanzizhongleiArr.count>=j) {
        dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"is_pro"] integerValue]],@"p":string,@"apk_token":uid_username};
        
        NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
            NSArray *arr = [[NSArray alloc] init];
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum9>i) {
                _TableView9.mj_footer.state = MJRefreshStateNoMoreData;
                [_TableView9.mj_footer resetNoMoreData];
            }else{
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr5 addObjectsFromArray:imgarr];
                for (int i=0; i<imgarr.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                    if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                        model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                    }else{
                        model.touxiangurl = avatarsstring;
                    }
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.title = labeltext2;
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                    [_DataArr9 addObject:model];
                }
                [_TableView9 reloadData];
                [_TableView9.mj_footer endRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }
}
-(void)post1010
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum10 = _pagenum10+1;
    NSLog(@"%d",_pagenum10);
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum5];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    int j = 10;
    if (quanzizhongleiArr.count>=j) {
        dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"c_id":[NSString stringWithFormat:@"%ld",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"id"] integerValue]],@"is_pro":[NSString stringWithFormat:@"%d",[[[quanzizhongleiArr objectAtIndex:j] objectForKey:@"is_pro"] integerValue]],@"p":string,@"apk_token":uid_username};
        
        NSString *strurl = [API stringByAppendingString:@"social/get_social_list"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
            NSArray *arr = [[NSArray alloc] init];
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum10>i) {
                _TableView10.mj_footer.state = MJRefreshStateNoMoreData;
                [_TableView10.mj_footer resetNoMoreData];
            }else{
                NSMutableArray *imgarr = [[NSMutableArray alloc] init];
                imgarr = [responseObject objectForKey:@"data"];
                [ImageArr10 addObjectsFromArray:imgarr];
                for (int i=0; i<imgarr.count; i++) {
                    pengyouquanmodel *model = [[pengyouquanmodel alloc] init];
                    model.name = [[imgarr objectAtIndex:i] objectForKey:@"nickname"];
                    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"content"] options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                    model.content = labeltext;
                    NSString *avatarsstring = [[imgarr objectAtIndex:i] objectForKey:@"avatars"];
                    if ([avatarsstring rangeOfString:@"http://"].location == NSNotFound) {
                        model.touxiangurl = [API_img stringByAppendingString:avatarsstring];
                    }else{
                        model.touxiangurl = avatarsstring;
                    }
                    
                    model.imageArr = [[imgarr objectAtIndex:i] objectForKey:@"img_list"];
                    NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[imgarr objectAtIndex:i] objectForKey:@"title"] options:0];
                    NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    model.title = labeltext2;
                    model.social_id = [[imgarr objectAtIndex:i] objectForKey:@"id"];
                    model.uid = [[imgarr objectAtIndex:i] objectForKey:@"uid"];
                    model.fabutime = [[imgarr objectAtIndex:i] objectForKey:@"addtime"];
                    model.scan = [[imgarr objectAtIndex:i] objectForKey:@"click"];
                    model.pinglun = [[imgarr objectAtIndex:i] objectForKey:@"reply_num"];
                    model.fenlei = [[imgarr objectAtIndex:i] objectForKey:@"c_name"];
                    model.guanfang = [[imgarr objectAtIndex:i] objectForKey:@"admin_id"];
                    model.community_name = [[imgarr objectAtIndex:i] objectForKey:@"community_name"];
                    [_DataArr10 addObject:model];
                }
                [_TableView10 reloadData];
                [_TableView10.mj_footer endRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }
}
- (void)createRightbut
{
    
}
-(void)changeButtonStatus{
    savebutton.enabled = YES;
}
- (void)saveCircle:(UIButton *)sender
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        savebutton.enabled = NO;
        [self performSelector:@selector(changeButtonStatus) withObject:nil afterDelay:1.0f];//防止用户重复点击
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        
        NSString *strurl = [API stringByAppendingString:@"social/social_num"];
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
        NSDictionary *dic = @{@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
        [manager GET:strurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                NSString *socialnum = [[responseObject objectForKey:@"data"] objectForKey:@"social_num"];
                if ([socialnum isEqualToString:@"0"]) {
                    [YBPopupMenu showRelyOnView:sender titles:@[@"我的邻里",@"发帖"] icons:nil menuWidth:120 delegate:self];
                }else{
                    NSString *string = [NSString stringWithFormat:@"我的邻里 %@",socialnum];
                    [YBPopupMenu showRelyOnView:sender titles:@[string,@"发帖"] icons:nil menuWidth:120 delegate:self];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }

}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    if (index==0) {
        
        mycircleViewController *mycircle = [[mycircleViewController alloc] init];
        mycircle.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mycircle animated:YES];
    }else{
        fabutieziViewController *fabu = [[fabutieziViewController alloc] init];
        fabu.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fabu animated:YES];
        NSLog(@"fabu帖子");
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==0) {
        return _DataArr.count;
    }else if(tableView.tag==1){
        return self.DataArr1.count;
    }else if(tableView.tag==2){
        return self.DataArr2.count;
    }else if(tableView.tag==3){
        return self.DataArr3.count;
    }else if(tableView.tag==4){
        return self.DataArr4.count;
    }else if(tableView.tag==5){
        return self.DataArr5.count;
    }else if(tableView.tag==6){
        return self.DataArr6.count;
    }else if(tableView.tag==7){
        return self.DataArr7.count;
    }else{
        return self.DataArr8.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==0) {
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        
        NSString *admin = [NSString stringWithFormat:@"%@",[[ImageArr objectAtIndex:0] objectForKey:@"admin_id"]];
        if ([admin isEqualToString:@"0"]) {
            if (arr.count>0) {
                NSString *cellIndetifier = @"oneiconcell0";
                NSLog(@"-----------111");
                circleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[circleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr objectAtIndex:indexPath.section];
                return cell;
            }else{
                NSLog(@"-----------222");
                NSString *cellIndetifier = @"noiconcell0";
                NoiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[NoiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr objectAtIndex:indexPath.section];
                return cell;
            }
            
        }else{
            NSString *cellIndetifier = @"oneiconcell0";
            NSLog(@"-----------333");
            newgonggaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[newgonggaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr objectAtIndex:indexPath.section];
            return cell;
        }
    }else if(tableView.tag==1){
        
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr1 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        
        NSString *admin = [NSString stringWithFormat:@"%@",[[ImageArr1 objectAtIndex:0] objectForKey:@"admin_id"]];
        if ([admin isEqualToString:@"0"]) {
            if (arr.count>0) {
                NSString *cellIndetifier = @"oneiconcell0";
                NSLog(@"-----------111");
                circleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[circleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr1 objectAtIndex:indexPath.section];
                return cell;
            }else{
                NSLog(@"-----------222");
                NSString *cellIndetifier = @"noiconcell0";
                NoiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[NoiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr1 objectAtIndex:indexPath.section];
                return cell;
            }
            
        }else{
            NSString *cellIndetifier = @"oneiconcell0";
            NSLog(@"-----------333");
            newgonggaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[newgonggaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr1 objectAtIndex:indexPath.section];
            return cell;
        }
    }else if(tableView.tag==2){
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr2 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        
        NSString *admin = [NSString stringWithFormat:@"%@",[[ImageArr2 objectAtIndex:0] objectForKey:@"admin_id"]];
        if ([admin isEqualToString:@"0"]) {
            if (arr.count>0) {
                NSString *cellIndetifier = @"oneiconcell0";
                NSLog(@"-----------111");
                circleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[circleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr2 objectAtIndex:indexPath.section];
                return cell;
            }else{
                NSLog(@"-----------222");
                NSString *cellIndetifier = @"noiconcell0";
                NoiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[NoiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr2 objectAtIndex:indexPath.section];
                return cell;
            }
            
        }else{
            NSString *cellIndetifier = @"oneiconcell0";
            NSLog(@"-----------333");
            newgonggaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[newgonggaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr2 objectAtIndex:indexPath.section];
            return cell;
        }
    }else if(tableView.tag==3){
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr3 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        
        NSString *admin = [NSString stringWithFormat:@"%@",[[ImageArr3 objectAtIndex:0] objectForKey:@"admin_id"]];
        if ([admin isEqualToString:@"0"]) {
            if (arr.count>0) {
                NSString *cellIndetifier = @"oneiconcell0";
                NSLog(@"-----------111");
                circleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[circleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr3 objectAtIndex:indexPath.section];
                return cell;
            }else{
                NSLog(@"-----------222");
                NSString *cellIndetifier = @"noiconcell0";
                NoiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[NoiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr3 objectAtIndex:indexPath.section];
                return cell;
            }
            
        }else{
            NSString *cellIndetifier = @"oneiconcell0";
            NSLog(@"-----------333");
            newgonggaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[newgonggaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr3 objectAtIndex:indexPath.section];
            return cell;
        }
    }else if(tableView.tag==4){
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr4 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        
        NSString *admin = [NSString stringWithFormat:@"%@",[[ImageArr4 objectAtIndex:0] objectForKey:@"admin_id"]];
        if ([admin isEqualToString:@"0"]) {
            if (arr.count>0) {
                NSString *cellIndetifier = @"oneiconcell0";
                NSLog(@"-----------111");
                circleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[circleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr4 objectAtIndex:indexPath.section];
                return cell;
            }else{
                NSLog(@"-----------222");
                NSString *cellIndetifier = @"noiconcell0";
                NoiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[NoiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr4 objectAtIndex:indexPath.section];
                return cell;
            }
            
        }else{
            NSString *cellIndetifier = @"oneiconcell0";
            NSLog(@"-----------333");
            newgonggaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[newgonggaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr4 objectAtIndex:indexPath.section];
            return cell;
        }
    }else if(tableView.tag==5){
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr5 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        
        NSString *admin = [NSString stringWithFormat:@"%@",[[ImageArr5 objectAtIndex:0] objectForKey:@"admin_id"]];
        if ([admin isEqualToString:@"0"]) {
            if (arr.count>0) {
                NSString *cellIndetifier = @"oneiconcell0";
                NSLog(@"-----------111");
                circleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[circleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr5 objectAtIndex:indexPath.section];
                return cell;
            }else{
                NSLog(@"-----------222");
                NSString *cellIndetifier = @"noiconcell0";
                NoiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[NoiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr5 objectAtIndex:indexPath.section];
                return cell;
            }
            
        }else{
            NSString *cellIndetifier = @"oneiconcell0";
            NSLog(@"-----------333");
            newgonggaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[newgonggaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr5 objectAtIndex:indexPath.section];
            return cell;
        }
    }else if(tableView.tag==6){
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr6 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
            
        NSString *admin = [NSString stringWithFormat:@"%@",[[ImageArr6 objectAtIndex:0] objectForKey:@"admin_id"]];
        if ([admin isEqualToString:@"0"]) {
            if (arr.count>0) {
                NSString *cellIndetifier = @"oneiconcell0";
                NSLog(@"-----------111");
                circleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[circleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr6 objectAtIndex:indexPath.section];
                return cell;
            }else{
                NSLog(@"-----------222");
                NSString *cellIndetifier = @"noiconcell0";
                NoiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[NoiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr6 objectAtIndex:indexPath.section];
                return cell;
            }
            
        }else{
            NSString *cellIndetifier = @"oneiconcell0";
            NSLog(@"-----------333");
            newgonggaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[newgonggaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr6 objectAtIndex:indexPath.section];
            return cell;
        }
    }else if(tableView.tag==7){
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr7 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        
        NSString *admin = [NSString stringWithFormat:@"%@",[[ImageArr7 objectAtIndex:0] objectForKey:@"admin_id"]];
        if ([admin isEqualToString:@"0"]) {
            if (arr.count>0) {
                NSString *cellIndetifier = @"oneiconcell0";
                NSLog(@"-----------111");
                circleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[circleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr7 objectAtIndex:indexPath.section];
                return cell;
            }else{
                NSLog(@"-----------222");
                NSString *cellIndetifier = @"noiconcell0";
                NoiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[NoiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr7 objectAtIndex:indexPath.section];
                return cell;
            }
            
        }else{
            NSString *cellIndetifier = @"oneiconcell0";
            NSLog(@"-----------333");
            newgonggaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[newgonggaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr7 objectAtIndex:indexPath.section];
            return cell;
        }
    }else {
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr8 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        
        NSString *admin = [NSString stringWithFormat:@"%@",[[ImageArr8 objectAtIndex:0] objectForKey:@"admin_id"]];
        if ([admin isEqualToString:@"0"]) {
            if (arr.count>0) {
                NSString *cellIndetifier = @"oneiconcell0";
                NSLog(@"-----------111");
                circleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[circleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr8 objectAtIndex:indexPath.section];
                return cell;
            }else{
                NSLog(@"-----------222");
                NSString *cellIndetifier = @"noiconcell0";
                NoiconCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
                if (cell == nil) {
                    cell = [[NoiconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    //cell.userInteractionEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
                }
                cell.model = [_DataArr8 objectAtIndex:indexPath.section];
                return cell;
            }
            
        }else{
            NSString *cellIndetifier = @"oneiconcell0";
            NSLog(@"-----------333");
            newgonggaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
            if (cell == nil) {
                cell = [[newgonggaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                
                //cell.userInteractionEnabled = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            }
            cell.model = [_DataArr8 objectAtIndex:indexPath.section];
            return cell;
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *imagearr = [[NSArray alloc] init];
//    imagearr = [[ImageArr objectAtIndex:indexPath.section] objectForKey:@"img_list"];
    if (tableView.tag==0) {
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        if ([[NSString stringWithFormat:@"%@",[[ImageArr objectAtIndex:indexPath.section] objectForKey:@"admin_id"]] isEqualToString:@"0"]) {
            if (arr.count>0) {
                return 75+(Main_width-36)/3+15+40+18+30+25;
            }else{
                return 75+40+18+30+25;
            }
            
        }else{
            return 147;
        }
    }else if (tableView.tag==1) {
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr1 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        if ([[NSString stringWithFormat:@"%@",[[ImageArr1 objectAtIndex:indexPath.section] objectForKey:@"admin_id"]] isEqualToString:@"0"]) {
            if (arr.count>0) {
                return 75+(Main_width-36)/3+15+40+18+30+25;
            }else{
                return 75+40+18+30+25;
            }
            
        }else{
            return 147;
        }
    }else if (tableView.tag==2) {
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr2 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        if ([[NSString stringWithFormat:@"%@",[[ImageArr2 objectAtIndex:indexPath.section] objectForKey:@"admin_id"]] isEqualToString:@"0"]) {
            if (arr.count>0) {
                return 75+(Main_width-36)/3+15+40+18+30+25;
            }else{
                return 75+40+18+30+25;
            }
            
        }else{
            return 147;
        }
    }else if (tableView.tag==3) {
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr3 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        if ([[NSString stringWithFormat:@"%@",[[ImageArr3 objectAtIndex:indexPath.section] objectForKey:@"admin_id"]] isEqualToString:@"0"]) {
            if (arr.count>0) {
                return 75+(Main_width-36)/3+15+40+18+30+25;
            }else{
                return 75+40+18+30+25;
            }
            
        }else{
            return 147;
        }
    }else if (tableView.tag==4){
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr4 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        if ([[NSString stringWithFormat:@"%@",[[ImageArr4 objectAtIndex:indexPath.section] objectForKey:@"admin_id"]] isEqualToString:@"0"]) {
            if (arr.count>0) {
                return 75+(Main_width-36)/3+15+40+18+30+25;
            }else{
                return 75+40+18+30+25;
            }
            
        }else{
            return 147;
        }
    }else if (tableView.tag==5){
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr5 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        if ([[NSString stringWithFormat:@"%@",[[ImageArr5 objectAtIndex:indexPath.section] objectForKey:@"admin_id"]] isEqualToString:@"0"]) {
            if (arr.count>0) {
                return 75+(Main_width-36)/3+15+40+18+30+25;
            }else{
                return 75+40+18+30+25;
            }
            
        }else{
            return 147;
        }
    }else if (tableView.tag==6){
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr6 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        if ([[NSString stringWithFormat:@"%@",[[ImageArr6 objectAtIndex:indexPath.section] objectForKey:@"admin_id"]] isEqualToString:@"0"]) {
            if (arr.count>0) {
                return 75+(Main_width-36)/3+15+40+18+30+25;
            }else{
                return 75+40+18+30+25;
            }
            
        }else{
            return 147;
        }
        
    }else if (tableView.tag==7){
        
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr7 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        if ([[NSString stringWithFormat:@"%@",[[ImageArr7 objectAtIndex:indexPath.section] objectForKey:@"admin_id"]] isEqualToString:@"0"]) {
            if (arr.count>0) {
                return 75+(Main_width-36)/3+15+40+18+30+25;
            }else{
                return 75+40+18+30+25;
            }
            
        }else{
            return 147;
        }
    }else {
        NSArray *arr = [[NSArray alloc] init];
        arr = [[ImageArr8 objectAtIndex:indexPath.section] objectForKey:@"img_list"];
        
        if ([[NSString stringWithFormat:@"%@",[[ImageArr8 objectAtIndex:indexPath.section] objectForKey:@"admin_id"]] isEqualToString:@"0"]) {
            if (arr.count>0) {
                return 75+(Main_width-36)/3+15+40+18+30+25;
            }else{
                return 75+40+18+30+25;
            }
            
        }else{
            return 147;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"---%zi",indexPath.section);
    circledetailsViewController *details = [[circledetailsViewController alloc] init];
    if (tableView.tag==0) {
        details.id = [[ImageArr objectAtIndex:indexPath.section] objectForKey:@"id"];
        details.is_pro = [[quanzizhongleiArr objectAtIndex:0] objectForKey:@"is_pro"];
    }else if (tableView.tag == 1){
        details.id = [[ImageArr1 objectAtIndex:indexPath.section] objectForKey:@"id"];
        details.is_pro = [[quanzizhongleiArr objectAtIndex:1] objectForKey:@"is_pro"];
    }else if (tableView.tag == 2){
        details.id = [[ImageArr2 objectAtIndex:indexPath.section] objectForKey:@"id"];
        details.is_pro = [[quanzizhongleiArr objectAtIndex:2] objectForKey:@"is_pro"];
    }else if (tableView.tag == 3){
        details.id = [[ImageArr3 objectAtIndex:indexPath.section] objectForKey:@"id"];
        details.is_pro = [[quanzizhongleiArr objectAtIndex:3] objectForKey:@"is_pro"];
    }else if (tableView.tag == 4){
        details.id = [[ImageArr4 objectAtIndex:indexPath.section] objectForKey:@"id"];
        details.is_pro = [[quanzizhongleiArr objectAtIndex:4] objectForKey:@"is_pro"];
    }else if (tableView.tag == 5){
        details.id = [[ImageArr5 objectAtIndex:indexPath.section] objectForKey:@"id"];
        details.is_pro = [[quanzizhongleiArr objectAtIndex:5] objectForKey:@"is_pro"];
    }else if (tableView.tag == 6){
        details.id = [[ImageArr6 objectAtIndex:indexPath.section] objectForKey:@"id"];
        details.is_pro = [[quanzizhongleiArr objectAtIndex:6] objectForKey:@"is_pro"];
    }else if (tableView.tag == 7){
        details.id = [[ImageArr7 objectAtIndex:indexPath.section] objectForKey:@"id"];
        details.is_pro = [[quanzizhongleiArr objectAtIndex:7] objectForKey:@"is_pro"];
    }else {
        details.id = [[ImageArr8 objectAtIndex:indexPath.section] objectForKey:@"id"];
        details.is_pro = [[quanzizhongleiArr objectAtIndex:8] objectForKey:@"is_pro"];
    }
    
    details.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:details animated:YES];
}
+ (NSString *)textFromBase64String:(NSString *)base64
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return text;
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
