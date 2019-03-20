//
//  newserviceViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newserviceViewController.h"
#import "WRNavigationBar.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "JKBannarView.h"
#import "MenuScrollView.h"
#import "CustomerScrollViewModel.h"
#import "ScanViewController.h"//扫描二维码界面
#import <AVFoundation/AVFoundation.h>
#import "newshangjiaViewController.h"
#import "fuwusearchViewController.h"
#import "fengLeiDetailViewController.h"
#import "serviceDetailViewController.h"
#import "fwflViewController.h"
#import "weixiuViewController.h"
#import "activitydetailsViewController.h"
#import "acivityViewController.h"
#import "shangpinerjiViewController.h"
#import "WebViewController.h"
#import "youhuiquanViewController.h"
#import "youhuiquanxiangqingViewController.h"
#import "noticeViewController.h"
#import "MoreViewController.h"
#import "circledetailsViewController.h"
#import "youxianjiaofeiViewController.h"
#import "openDoorViewController.h"
#import "FacePayViewController.h"
#import "jujiayanglaoViewController.h"
#import "selectHomeViewController.h"
#import "blueyaViewController.h"
#import "bangdingqianViewController.h"
#import "shangpinliebiaoViewController.h"
#import "MyhomeViewController.h"
#import "xinfangshouceViewController.h"
#import "xianshiqianggouerjiViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import "LoginViewController.h"
#import "huodongwebviewViewController.h"
#import "GoodsDetailViewController.h"
#import "GSKeyChainDataManager.h"
#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 0
#define SCROLL_DOWN_LIMIT 70
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)


@interface newserviceViewController ()<UITableViewDelegate,UITableViewDataSource,MenuScrollViewDeleagte,AVCaptureMetadataOutputObjectsDelegate>{
    NSArray *category;
    NSArray *category_service;
    NSArray *info;
    NSArray *item;
    
    NSArray *topArr;
    JKBannarView *bannerView;
    NSString *titleStr;
    CGFloat height;
    AppDelegate *myDelegate;
}

@property (nonatomic,strong) MenuScrollView * menuScrollView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation newserviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    category = [[NSArray alloc] init];
    category_service = [[NSArray alloc] init];
    info = [[NSArray alloc] init];
    item = [[NSArray alloc] init];
    topArr = [[NSArray alloc] init];
    
    [self topData];
    [self getdata];
    
    [self setupNavItems];
    [self createui];
    
    
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"changetitle" object:nil];
    // Do any additional setup after loading the view.
}
- (void)change
{
    [_tableView.mj_header beginRefreshing];
}
- (void)setupNavItems
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.navigationItem setTitleView:view];

    UIButton *butleft = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [butleft setImage:[UIImage imageNamed:@"扫描"] forState:UIControlStateNormal];
    butleft.backgroundColor = [UIColor redColor];
    [butleft addTarget:self action:@selector(onClickLeft) forControlEvents:UIControlEventTouchUpInside];
    butleft.backgroundColor = [UIColor clearColor];
    [view addSubview:butleft];

    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 5, 30, 30)];
    [but setImage:[UIImage imageNamed:@"订单"] forState:UIControlStateNormal];
    but.backgroundColor = [UIColor redColor];
    [but addTarget:self action:@selector(onClickRight) forControlEvents:UIControlEventTouchUpInside];
    but.backgroundColor = [UIColor clearColor];
    [view addSubview:but];

    UIButton *butthree = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50-40, 5, 30, 30)];
    [butthree setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    butthree.backgroundColor = [UIColor redColor];
    [butthree addTarget:self action:@selector(butthree) forControlEvents:UIControlEventTouchUpInside];
    butthree.backgroundColor = [UIColor clearColor];
    [view addSubview:butthree];

}
- (void)onClickLeft
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (granted) {
                    //配置扫描view
                    ScanViewController *scan = [[ScanViewController alloc] init];
                    scan.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:scan animated:YES];
                } else {
                    NSString *title = @"请在iPhone的”设置-隐私-相机“选项中，允许App访问你的相机";
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                }
                
            });
        }];
    }
}
- (void)onClickRight
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        myserviceViewController *myservice = [[myserviceViewController alloc] init];
        myservice.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myservice animated:YES];
    }
}
- (void)butthree
{
    fuwusearchViewController *vc = [[fuwusearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < -IMAGE_HEIGHT) {
        [self updateNavBarButtonItemsAlphaAnimated:.0f];
    } else {
        [self updateNavBarButtonItemsAlphaAnimated:1.0f];
    }
    
    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self wr_setNavBarBackgroundAlpha:alpha];
    }
    else
    {
        [self wr_setNavBarBackgroundAlpha:0];
    }
    
    //    //限制下拉的距离
    //    if(offsetY < LIMIT_OFFSET_Y) {
    //        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    //    }
}
- (void)updateNavBarButtonItemsAlphaAnimated:(CGFloat)alpha
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.navigationController.navigationBar wr_setBarButtonItemsAlpha:alpha hasSystemBackIndicator:NO];
    }];
}
- (void)createui
{
    
    CGRect frame = CGRectMake(0, 0, Main_width, Main_Height-49-LCL_HomeIndicator_Height);

    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BackColor;
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - [self navBarBottom], 0, 0, 0);
    [self.view addSubview:self.tableView];
}
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tableView.mj_header endRefreshing];
        [self getdata];
        [self topData];
    });
}


#pragma mark - tableview delegate / dataSource

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return category_service.count+1;
    }else if (section==3) {
        return 2;
    }else if (section==4){
        if ([item isKindOfClass:[NSArray class]]) {
            return item.count+1;
        }else{
            return 1;
        }
    } else{
        return 1;
    }
}


//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==3){
        return @"";
    }else{
        return @"";
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
        
    }
    if (indexPath.section==0) {
        if ([topArr isKindOfClass:[NSArray class]]) {
            tableView.rowHeight = Main_width/(1.87);
            [cell.contentView addSubview:bannerView];
            [bannerView imageViewClick:^(JKBannarView * _Nonnull barnerview, NSInteger index) {
                NSLog(@"点击图片%ld",index);
                NSString *url_type = [[topArr objectAtIndex:index] objectForKey:@"url_type"];
                NSString *url_id = [[topArr objectAtIndex:index] objectForKey:@"url_id"];
                NSString *urltypename = [[topArr objectAtIndex:index] objectForKey:@"type_name"];
                if ([url_type isEqualToString:@"5"]) {
                    weixiuViewController *weixiu = [[weixiuViewController alloc] init];
                    weixiu.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:weixiu animated:YES];
                }if ([url_type isEqualToString:@"3"]) {
                    acivityViewController *aciti = [[acivityViewController alloc] init];
                    aciti.hidesBottomBarWhenPushed = YES;
                    aciti.url = urltypename;
                    [self.navigationController pushViewController:aciti animated:YES];
                }if ([url_type isEqualToString:@"4"]) {
                    activitydetailsViewController *acti = [[activitydetailsViewController alloc] init];
                    acti.url = urltypename;
                    acti.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:acti animated:YES];
                }if ([url_type isEqualToString:@"7"]) {
                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",url_id];
                    UIWebView *callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebview];
                }if ([url_type isEqualToString:@"1"]) {
                    shangpinliebiaoViewController *liebiao = [[shangpinliebiaoViewController alloc] init];
                    shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
                    NSString *type_name = [[topArr objectAtIndex:index] objectForKey:@"type_name"];
                    NSRange range = [type_name rangeOfString:@"id/"]; //现获取要截取的字符串位置
                    NSString * result = [type_name substringFromIndex:range.location+3]; //截取字符串
                    liebiao.id = result;
                    erji.id = result;
                    erji.hidesBottomBarWhenPushed = YES;
                    liebiao.hidesBottomBarWhenPushed = YES;
                    
                    
                    //1.创建会话管理者
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                    //2.封装参数
                    
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"cate_id":result,@"hui_community_id":[user objectForKey:@"community_id"]};
                    NSString *strurl = [API stringByAppendingString:@"shop/pro_list_cate"];
                    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        NSArray *arr = [responseObject objectForKey:@"data"];
                        if (![arr isKindOfClass:[NSArray class]]) {
                            [self.navigationController pushViewController:erji animated:YES];
                        }else{
                            [self.navigationController pushViewController:liebiao animated:YES];
                        }
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        NSLog(@"failure--%@",error);
                    }];
                    
                    
                }if ([url_type isEqualToString:@"6"]) {
                    //优惠券
                    NSString *type_name = [[topArr objectAtIndex:index] objectForKey:@"type_name"];
                    
                    WebViewController *web = [[WebViewController alloc] init];
                    web.url_type = @"2";
                    web.title = @"优惠券";
                    web.url = type_name;
                    web.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:web animated:YES];
                }if ([url_type isEqualToString:@"8"]) {
                    youhuiquanViewController *youhuiquan = [[youhuiquanViewController alloc] init];
                    youhuiquan.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:youhuiquan animated:YES];
                }if ([url_type isEqualToString:@"9"]) {
                    youhuiquanxiangqingViewController *youhuiquan = [[youhuiquanxiangqingViewController alloc] init];
                    youhuiquan.hidesBottomBarWhenPushed = YES;
                    NSRange range = [urltypename rangeOfString:@"id/"]; //现获取要截取的字符串位置
                    NSString * result = [urltypename substringFromIndex:range.location+3]; //截取字符串
                    youhuiquan.id = result;
                    [self.navigationController pushViewController:youhuiquan animated:YES];
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
                }if ([url_type isEqualToString:@"12"]){
                    
                }if ([url_type isEqualToString:@"13"]){
                    circledetailsViewController *circle = [[circledetailsViewController alloc] init];
                    NSRange range = [urltypename rangeOfString:@"id/"]; //现获取要截取的字符串位置
                    NSString * result = [urltypename substringFromIndex:range.location+3]; //截取字符串
                    circle.id = result;
                    circle.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:circle animated:YES];
                }if ([url_type isEqualToString:@"14"]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_id]];
                }if ([url_type isEqualToString:@"15"]){
                    youxianjiaofeiViewController *youxian = [[youxianjiaofeiViewController alloc] init];
                    youxian.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:youxian animated:YES];
                }if ([url_type isEqualToString:@"16"]){
                    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
                    NSString *is_bind_property = [userdf objectForKey:@"is_bind_property"];
                    
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
                    NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
                    NSString *strurl = [API stringByAppendingString:@"property/binding_community"];
                    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog(@"%@-000000-%@",[responseObject objectForKey:@"msg"],responseObject);
                        NSArray *arrrrr = [[NSArray alloc] init];
                        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                            arrrrr = [responseObject objectForKey:@"data"];
                            if (arrrrr.count>1) {
                                selectHomeViewController *selecthome = [[selectHomeViewController alloc] init];
                                selecthome.homeArr = arrrrr;
                                selecthome.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:selecthome animated:YES];
                            }else{
                                MyhomeViewController *myhome = [[MyhomeViewController alloc] init];
                                myhome.room_id = [[arrrrr objectAtIndex:0] objectForKey:@"room_id"];
                                myhome.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:myhome animated:YES];
                            }
                            [defaults setObject:@"2" forKey:@"is_bind_property"];
                            [userdf synchronize];
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
//                            [self logout];
                        }else{
                            bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
                            bangding.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:bangding animated:YES];
                            
                            [defaults setObject:@"1" forKey:@"is_bind_property"];
                            [userdf synchronize];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"failure--%@",error);
                    }];
                }if ([url_type isEqualToString:@"17"]){
                    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
                    NSString *is_bind_property = [userdf objectForKey:@"is_bind_property"];
                    
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
                    NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
                    NSString *strurl = [API stringByAppendingString:@"property/binding_community"];
                    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog(@"%@-000000-%@",[responseObject objectForKey:@"msg"],responseObject);
                        NSArray *arrrrr = [[NSArray alloc] init];
                        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                            arrrrr = [responseObject objectForKey:@"data"];
                            if (arrrrr.count>1) {
                                selectHomeViewController *selecthome = [[selectHomeViewController alloc] init];
                                selecthome.homeArr = arrrrr;
                                selecthome.rukoubiaoshi = @"layakaimen";
                                selecthome.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:selecthome animated:YES];
                            }else{
                                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                                NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
                                NSDictionary *dict = @{@"apk_token":uid_username,@"room_id":[[arrrrr objectAtIndex:0] objectForKey:@"room_id"],@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
                                NSString *strurl = [API stringByAppendingString:@"property/checkIsAjb"];
                                [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    NSLog(@"%@-11111-%@",[responseObject objectForKey:@"msg"],responseObject);
                                    NSDictionary *dicccc = [[NSDictionary alloc] init];
                                    if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                                        dicccc = [responseObject objectForKey:@"data"];
                                        if ([dicccc isKindOfClass:[NSDictionary class]]) {
                                            blueyaViewController *blueya = [[blueyaViewController alloc] init];
                                            blueya.Dic = dicccc;
                                            blueya.hidesBottomBarWhenPushed = YES;
                                            [self.navigationController pushViewController:blueya animated:YES];
                                        }else{
                                            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
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
//                                        [self logout];
                                    }else{
                                        [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                                    }
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    NSLog(@"failure--%@",error);
                                }];
                            }
                            [defaults setObject:@"2" forKey:@"is_bind_property"];
                            [userdf synchronize];
                        }else{
                            bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
                            bangding.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:bangding animated:YES];
                            [defaults setObject:@"1" forKey:@"is_bind_property"];
                            [userdf synchronize];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"failure--%@",error);
                    }];
                }if ([url_type isEqualToString:@"18"]){
                    FacePayViewController *face = [[FacePayViewController alloc] init];
                    face.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:face animated:YES];
                }if ([url_type isEqualToString:@"19"]){
                    jujiayanglaoViewController *hujia = [[jujiayanglaoViewController alloc] init];
                    hujia.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:hujia animated:YES];
                }if ([url_type isEqualToString:@"20"]){
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    
                    if ([user objectForKey:@"username"]==nil) {
                        LoginViewController *log = [[LoginViewController alloc] init];
                        [self presentViewController:log animated:YES completion:nil];
                    }else{
                        huodongwebviewViewController *web = [[huodongwebviewViewController alloc] init];
                        web.url = urltypename;
                        
                        
                        //         http://www.dsyg42.com/ec/app_index?username=18503408643&sign=hshObj&atitude=112.727884&longitude=37.690397&uuid=990009261666328
                        
                        web.url = [NSString stringWithFormat:@"%@?username=%@&sign=hshObj&atitude=%@&longitude=%@&uuid=%@",urltypename,[user objectForKey:@"username"],[user objectForKey:@"latitude"],[user objectForKey:@"longitude"],GSKeyChainDataManager.readUUID];
                        web.title = @"东森易购";
                        NSLog(@"weburl---%@---%@",web.url,GSKeyChainDataManager.readUUID);
                        web.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:web animated:YES];
                    }
                }if ([url_type isEqualToString:@"21"]){
                    xinfangshouceViewController *xinfang = [[xinfangshouceViewController alloc] init];
                    xinfang.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:xinfang animated:YES];
                }
            }];
        }else{
            tableView.rowHeight = RECTSTATUS.size.height+44;
        }
    }else if (indexPath.section==1){
        if ([category isKindOfClass:[NSArray class]]) {
            _menuScrollView = [[MenuScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
            _menuScrollView.maxCol  =  5;
            _menuScrollView.maxRow = 2;
            _menuScrollView.delegate = self;
            [cell.contentView addSubview:_menuScrollView];
            
            NSMutableArray *mulu = [NSMutableArray arrayWithCapacity:0];
            CustomerScrollViewModel * model = [[CustomerScrollViewModel alloc ] init];
            model.name = @"全部";
            model.icon = @"ic_servicex_cate";
            [mulu addObject:model];
            for (int i=0; i<category.count; i++) {
                CustomerScrollViewModel * model1 = [[CustomerScrollViewModel alloc ] init];
                model1.name = [[category objectAtIndex:i] objectForKey:@"name"];
                model1.icon = [[category objectAtIndex:i] objectForKey:@"img"];
                [mulu addObject:model1];
            }

            self.menuScrollView.dataArr = mulu;
            tableView.rowHeight = 200;
        }else{
            tableView.rowHeight = 0;
        }
    }else if (indexPath.section==2){
        if (indexPath.row==0) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 105, 45)];
            imageview.image = [UIImage imageNamed:@"最受欢迎"];
            [cell.contentView addSubview:imageview];
            
            tableView.rowHeight = 65;
        }else{
            
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            titleBtn.frame = CGRectMake(15, 20, Main_width-30, 15);
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            NSString *titleStr = [NSString stringWithFormat:@"%@>",[[category_service objectAtIndex:indexPath.row-1] objectForKey:@"name"]];
            titleBtn.tag = [[NSString stringWithFormat:@"%@",[[category_service objectAtIndex:indexPath.row-1] objectForKey:@"id"]] integerValue]+100;
            [titleBtn setTitle: titleStr forState:UIControlStateNormal];
             titleBtn.alpha = 0.54;
            [titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:titleBtn];
            
//            UILabel *label = [[UILabel alloc] init];
//            label.frame = CGRectMake(15, 20, Main_width-30, 15);
//            label.font = [UIFont systemFontOfSize:14];
//            label.alpha = 0.54;
//            label.text = [NSString stringWithFormat:@"%@>",[[category_service objectAtIndex:indexPath.row-1] objectForKey:@"name"]];
//            [cell.contentView addSubview:label];
            
            UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35+18, Main_width, 114+10+15)];
            scrollview.showsHorizontalScrollIndicator = NO;
            scrollview.showsVerticalScrollIndicator = NO;
            [cell.contentView addSubview:scrollview];
            
            NSArray *imgarr = [[NSArray alloc] init];
            imgarr = [[category_service objectAtIndex:indexPath.row-1] objectForKey:@"service"];
            scrollview.contentSize = CGSizeMake(30+252*imgarr.count-10, 114+10+15);
            for (int i=0; i<imgarr.count; i++) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15+242*i+10*i, 0, 242, 97)];
                view.backgroundColor = [UIColor whiteColor];
                view.layer.cornerRadius = 3;
                [scrollview addSubview:view];
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 242, 97)];
                [img sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[imgarr objectAtIndex:i] objectForKey:@"title_img"]]] placeholderImage:[UIImage imageNamed:@"展位图长1.5"]];
                img.clipsToBounds = YES;
                img.layer.cornerRadius = 7;
                [view addSubview:img];
                
                UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                imgBtn.frame = CGRectMake(0, 0, 242, 97);
                imgBtn.tag = [[[imgarr objectAtIndex:i] objectForKey:@"id"] integerValue]+100;
                imgBtn.titleLabel.text = [[imgarr objectAtIndex:i] objectForKey:@"title"];
                [imgBtn addTarget:self action:@selector(imgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [view addSubview:imgBtn];
               
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15+242*i+10*i, 107, 242, 15)];
                label1.text = [[imgarr objectAtIndex:i] objectForKey:@"title"];
                label1.font = [UIFont systemFontOfSize:14];
                label1.textAlignment = NSTextAlignmentCenter;
                [scrollview addSubview:label1];
                
            }
            
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, scrollview.frame.size.height+scrollview.frame.origin.y+10, Main_width-30, 0.5)];
            lineview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05];
            [cell.contentView addSubview:lineview];
            
            tableView.rowHeight = lineview.frame.size.height+lineview.frame.origin.y;
        }
    }else if (indexPath.section==3){
        if (indexPath.row==0) {
            if ([info isKindOfClass:[NSArray class]]) {
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 105, 45)];
                imageview.image = [UIImage imageNamed:@"优质商家"];
                [cell.contentView addSubview:imageview];
                
                UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                titleBtn.frame = CGRectMake(Main_width-60, 20, 50, 30);
                titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                NSString *titleStr = @"更多>";
                [titleBtn setTitle: titleStr forState:UIControlStateNormal];
                titleBtn.alpha = 0.54;
                [titleBtn addTarget:self action:@selector(gengDuoAction1:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:titleBtn];
                
                tableView.rowHeight = 65;
            }else{
                tableView.rowHeight = 0;
            }
            
        }else{
            if ([info isKindOfClass:[NSArray class]]) {
                UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 20, Main_width-30, 227)];
                scrollview.showsHorizontalScrollIndicator = NO;
                scrollview.showsVerticalScrollIndicator = NO;
                scrollview.contentSize = CGSizeMake(168*info.count, 227);
                [cell.contentView addSubview:scrollview];
                
                for (int i = 0; i<info.count; i++) {
                    
                    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(168*i, 0, 158, 227)];
                    backview.clipsToBounds = YES;
                    backview.layer.cornerRadius = 10;
                    backview.layer.borderColor = BackColor.CGColor;//颜色
                    backview.layer.borderWidth = 1.0f;//设置边框粗细
                    [scrollview addSubview:backview];
                    
                    UIImageView *imgview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 158, 80)];
                    [imgview1 sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[info objectAtIndex:i] objectForKey:@"index_img"]]] placeholderImage:[UIImage imageNamed:@"展位图长1.5"]];
                    imgview1.contentMode = UIViewContentModeScaleAspectFill;
                    [backview addSubview:imgview1];
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(55, 50, 48, 48)];
                    view.backgroundColor = [UIColor whiteColor];
                    view.clipsToBounds = YES;
                    view.layer.cornerRadius = 24;
                    [backview addSubview:view];
                    
                    UIImageView *imgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
                    [imgview2 sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[info objectAtIndex:i] objectForKey:@"logo"]]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
                    imgview2.clipsToBounds = YES;
                    imgview2.layer.cornerRadius = 20;
                    [view addSubview:imgview2];
                    
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height+view.frame.origin.y+10, 158, 15)];
                    label1.text = [[info objectAtIndex:i] objectForKey:@"name"];
                    label1.font = [UIFont systemFontOfSize:14];
                    label1.textAlignment = NSTextAlignmentCenter;
                    [backview addSubview:label1];
                    
                    NSArray *tarr = [NSArray array];
                    tarr = [[info objectAtIndex:i] objectForKey:@"category"];
                    WBLog(@"%@",tarr);
                    float butX = 10;
                    float butY = CGRectGetMaxY(label1.frame)+10;
                    long arrcount;
                    if (tarr.count>4) {
                        arrcount = 4;
                    }else{
                        arrcount = tarr.count;
                    }
                    for(int i = 0; i < arrcount; i++){
                        
                        //宽度自适应
                        NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
                        CGRect frame_W = [[tarr[i] objectForKey:@"category_cn"] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
                        
                        if (butX+frame_W.size.width+20>158) {
                            
                            butX = 10;
                            
                            butY += 30;
                        }
                        
                        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, frame_W.size.width+20, 15)];
                        [but setTitle:[tarr[i] objectForKey:@"category_cn"] forState:UIControlStateNormal];
                        [but setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
                        but.titleLabel.font = [UIFont systemFontOfSize:10];
                        but.alpha = 0.54;
                        but.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
                        [backview addSubview:but];
                        
                        butX = CGRectGetMaxX(but.frame)+10;
                    }
                    
                    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(45, label1.frame.size.height+label1.frame.origin.y+64, 68, 27)];
                    label2.layer.borderColor = [UIColor blackColor].CGColor;//颜色
                    label2.layer.borderWidth = 1.0f;//设置边框粗细
                    label2.layer.masksToBounds = YES;
                    label2.layer.cornerRadius = 10;
                    label2.font = [UIFont systemFontOfSize:11];
                    label2.text = @"进店逛逛";
                    label2.textAlignment = NSTextAlignmentCenter;
                    [backview addSubview:label2];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(0, 0, 158, 227);
                    but.tag = i;
                    [but addTarget:self action:@selector(pushshangjia:) forControlEvents:UIControlEventTouchUpInside];
                    [backview addSubview:but];
                }
                
                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, scrollview.frame.size.height+scrollview.frame.origin.y+19.5, Main_width-30, 0.5)];
                lineview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05];
                [cell.contentView addSubview:lineview];
                
                tableView.rowHeight = 227+40;
            }else{
                tableView.rowHeight = 0;
            }
            
        }
    }else if (indexPath.section==4){
        if (indexPath.row==0) {
            if ([item isKindOfClass:[NSArray class]]) {
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 105, 45)];
                imageview.image = [UIImage imageNamed:@"精选服务"];
                [cell.contentView addSubview:imageview];
                
                UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                titleBtn.frame = CGRectMake(Main_width-60, 20, 50, 30);
                titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                NSString *titleStr = @"更多>";
                [titleBtn setTitle: titleStr forState:UIControlStateNormal];
                titleBtn.alpha = 0.54;
                [titleBtn addTarget:self action:@selector(gengDuoAction2:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:titleBtn];
                
                tableView.rowHeight = 65;
            }else{
                tableView.rowHeight = 0;
            }
            
        }else{
            
            
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, Main_width-30, (Main_width-30)/[[[item objectAtIndex:indexPath.row-1] objectForKey:@"title_img_size"] floatValue])];
            [imgview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[item objectAtIndex:indexPath.row-1] objectForKey:@"title_img"]]] placeholderImage:[UIImage imageNamed:@"展位图长1.5"]];
            imgview.clipsToBounds = YES;
            imgview.layer.cornerRadius = 10;
            [cell.contentView addSubview:imgview];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15+imgview.frame.size.height+imgview.frame.origin.y, Main_width*3/4, 15)];
            label1.text = [[item objectAtIndex:indexPath.row-1] objectForKey:@"title"];
            label1.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:label1];
            
            UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(Main_width*3/4-15, 15+imgview.frame.size.height+imgview.frame.origin.y, Main_width/4, 15)];
            price.text = [NSString stringWithFormat:@"¥%@",[[item objectAtIndex:indexPath.row-1] objectForKey:@"price"]];
            price.font = [UIFont systemFontOfSize:14];
            price.textAlignment = NSTextAlignmentRight;
            price.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1.0];
            [cell.contentView addSubview:price];
            
            UIImageView *touxiang = [[UIImageView alloc] initWithFrame:CGRectMake(15, label1.frame.size.height+label1.frame.origin.y+15, 20, 20)];
            touxiang.clipsToBounds = YES;
            touxiang.layer.cornerRadius = 10;
            [touxiang sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[item objectAtIndex:indexPath.row-1] objectForKey:@"logo"]]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
            [cell.contentView addSubview:touxiang];
            
            UILabel *label2 = [[UILabel alloc] init];
            label2.text = [[item objectAtIndex:indexPath.row-1] objectForKey:@"i_name"];
            label2.font = [UIFont systemFontOfSize:11];
            label2.alpha = 0.54;
            CGSize size = [label2 sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
            label2.frame = CGRectMake(15+20+7, label1.frame.size.height+label1.frame.origin.y+15, size.width, 20);
            [cell.contentView addSubview:label2];
            
            
            NSArray *arr = [NSArray array];
            arr = [[item objectAtIndex:indexPath.row-1] objectForKey:@"category"];
            float butX = 15+20+7+25+size.width;
            float butY = label1.frame.size.height+label1.frame.origin.y+15;
            long arrcount;
            if (arr.count>2) {
                arrcount = 2;
            }else{
                arrcount = arr.count;
            }
            for(int i = 0; i < arrcount; i++){
                
                //宽度自适应
                NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:10]};
                CGRect frame_W = [[arr[i] objectForKey:@"category_cn"] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
                
                if (butX+frame_W.size.width>Main_width-15-20-7-25-size.width) {
                    
                    //butX += 10;
                    
                    //butY += 20;
                }
                
                UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, frame_W.size.width+20, 20)];
                [but setTitle:[arr[i] objectForKey:@"category_cn"] forState:UIControlStateNormal];
                [but setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
                but.titleLabel.font = [UIFont systemFontOfSize:10];
                but.alpha = 0.54;
                but.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
                [cell.contentView addSubview:but];
                butX = CGRectGetMaxX(but.frame)+10;
            }
            
            UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, label2.frame.size.height+label2.frame.origin.y+10, Main_width-30, 0.5)];
            lineview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05];
            [cell.contentView addSubview:lineview];
            
            tableView.rowHeight = lineview.frame.size.height+lineview.frame.origin.y;
        }
    }else {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_width/1.76)];
        img.image = [UIImage imageNamed:@"底部"];
        [cell.contentView addSubview:img];
        tableView.rowHeight = Main_width/1.76;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==4){
        if (indexPath.row == 0) {
        }else{
            NSString *idStr =  [[item objectAtIndex:indexPath.row-1] objectForKey:@"id"];
            NSString *titleStr =  [[item objectAtIndex:indexPath.row-1] objectForKey:@"title"];
//            NSLog(@"idStr = %@",idStr);
//            NSLog(@"titleStr = %@",titleStr);
            serviceDetailViewController *sdVC = [[serviceDetailViewController alloc]init];
            sdVC.hidesBottomBarWhenPushed = YES;
            sdVC.serviceID = idStr;
            sdVC.serviceTitle = titleStr;
            [self.navigationController pushViewController:sdVC animated:YES];
        }
    }
}
- (void)pushshangjia:(UIButton *)sender
{
    newshangjiaViewController *shangjia = [[newshangjiaViewController alloc] init];
    shangjia.shangjiaid = [[info objectAtIndex:sender.tag] objectForKey:@"id"];
    shangjia.titleStr = [[info objectAtIndex:sender.tag] objectForKey:@"name"];
    shangjia.img = [[info objectAtIndex:sender.tag] objectForKey:@"logo"];
    shangjia.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shangjia animated:YES];
}

- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}
//下拉刷新
- (void)xiala
{
    
}
-(void)getdata
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"hui_community_id":[user objectForKey:@"community_id"]};
   
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/service/index/serviceindex"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WBLog(@"fuwujiekou--%@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            category = [[responseObject objectForKey:@"data"] objectForKey:@"category"];
            category_service = [[responseObject objectForKey:@"data"] objectForKey:@"category_service"];
            info = [[responseObject objectForKey:@"data"] objectForKey:@"info"];
            item = [[responseObject objectForKey:@"data"] objectForKey:@"item"];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WBLog(@"failure--%@",error);
    }];
}
-(void)topData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"community_id":[user objectForKey:@"community_id"],@"hui_community_id":[user objectForKey:@"community_id"]};  
    NSString *strurl = [API stringByAppendingString:@"site/get_Advertising/c_name/service_indextop"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WBLog(@"fuwujiekoutop--%@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            topArr = [responseObject objectForKey:@"data"];
            
            NSMutableArray *imagearr = [NSMutableArray array];
            bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 0, Main_width, Main_width/(1.87)) viewSize:CGSizeMake(Main_width,Main_width/(1.87))];
            
            if ([topArr isKindOfClass:[NSArray class]]) {
                for (int i=0; i<topArr.count; i++) {
                    NSString *strurl = [API_img stringByAppendingString:[[topArr objectAtIndex:i]objectForKey:@"img"]];
                    WBLog(@"%@",strurl);
                    [imagearr addObject:strurl];
                    bannerView.items = imagearr;
                }
            }else{
                imagearr  =  nil;
                
            }
        }
        
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - item 点击跳转
- (void)menuScrollViewDeleagte:(id)menuScrollViewDeleagte index:(NSInteger)index{
    NSLog(@"点击的是 第%ld个",index);
    if ([category isKindOfClass:[NSArray class]]) {
        if (index==0) {
            fwflViewController *fenlei = [[fwflViewController alloc] init];
            fenlei.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fenlei animated:YES];
        }else{
            NSMutableArray *IDArr = [NSMutableArray array];
            for (int i = 0; i < category.count; i++) {
                NSDictionary *dic = category[i];
                NSString *idStr = [dic objectForKey:@"id"];
                [IDArr addObject:idStr];
            }
            NSMutableArray *titleArr = [NSMutableArray array];
            for (int i = 0; i < category.count; i++) {
                NSDictionary *dic = category[i];
                NSString *titleStr = [dic objectForKey:@"name"];
                [titleArr addObject:titleStr];
            }
            fengLeiDetailViewController *fldVC = [[fengLeiDetailViewController alloc]init];
            fldVC.hidesBottomBarWhenPushed = YES;
            fldVC.fuwuid = IDArr[index-1];
            fldVC.name = titleArr[index-1];
            [self.navigationController pushViewController:fldVC animated:YES];
        }
    }
}
#pragma mark - 最受欢迎 titleBtn 点击跳转
-(void)titleBtnAction:(UIButton *)sender{
    
    fengLeiDetailViewController *fldVC = [[fengLeiDetailViewController alloc]init];
    fldVC.hidesBottomBarWhenPushed = YES;
    fldVC.fuwuid =[NSString stringWithFormat:@"%ld",sender.tag-100];
    NSString *uuu = sender.titleLabel.text;
    NSString *cccc = [uuu substringToIndex:[uuu length] - 1];
    fldVC.name = cccc;
    [self.navigationController pushViewController:fldVC animated:YES];
}
#pragma mark - 最受欢迎 imgActionBtn 点击跳转
-(void)imgBtnAction:(UIButton *)sender{
   
    serviceDetailViewController *sdVC = [[serviceDetailViewController alloc]init];
    sdVC.hidesBottomBarWhenPushed = YES;
    sdVC.serviceID =[NSString stringWithFormat:@"%ld",sender.tag-100];
    sdVC.serviceTitle = sender.titleLabel.text;
    NSLog(@"sender.titleLabel.text = %@",titleStr);
    [self.navigationController pushViewController:sdVC animated:YES];
}
#pragma mark - 更多
-(void)gengDuoAction1:(UIButton *)sender{
    fengLeiDetailViewController *fldVC = [[fengLeiDetailViewController alloc]init];
    fldVC.hidesBottomBarWhenPushed = YES;
    fldVC.fuwuid = @"";
    fldVC.name = @"全部";
    fldVC.tagStr = @"1";
    [self.navigationController pushViewController:fldVC animated:YES];
}
-(void)gengDuoAction2:(UIButton *)sender{
    fengLeiDetailViewController *fldVC = [[fengLeiDetailViewController alloc]init];
    fldVC.hidesBottomBarWhenPushed = YES;
    fldVC.fuwuid = @"";
    fldVC.name = @"全部";
    fldVC.tagStr = @"0";
    [self.navigationController pushViewController:fldVC animated:YES];
}

@end
