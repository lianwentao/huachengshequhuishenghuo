//
//  newMallViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newMallViewController.h"
#import "xianshiqianggouViewController.h"
#import "WRNavigationBar.h"
#import "WRImageHelper.h"
#import "MJRefresh.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "GSKeyChainDataManager.h"
#import "JKBannarView.h"
#import "PYSearch.h"
#import "searchreslutsViewController.h"
#import "shangpinliebiaoViewController.h"
#import "ShangpinfenleiViewController.h"
#import "GouwucheViewController.h"
#import "NewPagedFlowView.h"

#import "GoodsDetailViewController.h"
#import "circledetailsViewController.h"
#import "acivityViewController.h"
#import "activitydetailsViewController.h"
#import "weixiuViewController.h"
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

#import "newxianshiqianggouViewController.h"
#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 0
#define SCROLL_DOWN_LIMIT 70
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)

@interface newMallViewController ()<UITableViewDelegate, UITableViewDataSource,NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,UISearchBarDelegate>
{
    NSArray *HeaDataArr;
    NSArray *centerArr;
    NSArray *guanggaoArr;
    NSMutableArray *shangpinArr;
    NSArray *fenleiArr;
    NSArray *pro_discount_listArr;
    NSString *cate_img;
    
    JKBannarView *bannerView;
    
    NSArray *_searcharr;
    
    int _pagenum;
    
    UIButton *_tmpBtn;
    
    NSString *moregoodsid;
    
    UIImageView *redcountimage;
    
    NSInteger secondsCountDown;//倒计时总时长
    NSTimer *countDownTimer;
    UILabel *daylabel;
    UILabel *hourslabel;
    UILabel *mlabel;
    UILabel *slabel;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *searchButton;
@end

@implementation newMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //_tmpBtn.tag=0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self postcenter];
    [self postshopindex];
    [self postguanggao];
    [self postcount];
    
    [self setupNavItems];
    
    //[self.tableView addSubview:self.advView];
    
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(Main_width - 60, ((Main_width - 60)/(2.5)) );
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    NSString *url_type = [[guanggaoArr objectAtIndex:subIndex] objectForKey:@"url_type"];
    NSString *url_id = [[guanggaoArr objectAtIndex:subIndex] objectForKey:@"url_id"];
    NSString *urltypename = [[guanggaoArr objectAtIndex:subIndex] objectForKey:@"type_name"];
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
        NSString *type_name = [[guanggaoArr objectAtIndex:subIndex] objectForKey:@"type_name"];
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
        NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"cate_id":result};
        
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
        NSString *type_name = [[guanggaoArr objectAtIndex:subIndex] objectForKey:@"type_name"];
        
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
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
        NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
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
//                [self logout];
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
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
        NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
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
                    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
                    NSDictionary *dict = @{@"apk_token":uid_username,@"room_id":[[arrrrr objectAtIndex:0] objectForKey:@"room_id"],@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
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
                        }else{
                            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"failure--%@",error);
                    }];
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
//                [self logout];
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
        
    }if ([url_type isEqualToString:@"21"]){
        xinfangshouceViewController *xinfang = [[xinfangshouceViewController alloc] init];
        xinfang.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:xinfang animated:YES];
    }
    
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}
#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return guanggaoArr.count;
    
}
- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    //在这里下载网络图片
    NSString *urlstr = [API stringByAppendingString:[[guanggaoArr objectAtIndex:index] objectForKey:@"img"]];
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:urlstr]];
    //bannerView.mainImageView.image = self.newpageimageArray[index];
    NSLog(@"/在这里下载网络图片---%@----%@",urlstr,centerArr);
    return bannerView;
}
- (void)setupNavItems
{
//    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenlei"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickLeft)];
//    self.navigationItem.leftBarButtonItem = leftButtonItem;
//
//    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gouwuche"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickRight)];
//    self.navigationItem.rightBarButtonItem = rightButtonItem;
//
//    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 5, 30, 30)];
//    [but setImage:[UIImage imageNamed:[Imagearr objectAtIndex:1]] forState:UIControlStateNormal];
//    but.backgroundColor = [UIColor redColor];
//    self.navigationItem.titleView addSubview:<#(nonnull UIView *)#>
//    redcountimage = [[UIImageView alloc] initWithFrame:CGRectMake(27, 2, 6, 6)];
//    redcountimage.layer.masksToBounds = YES;
//    redcountimage.layer.cornerRadius = 3;
//    redcountimage.backgroundColor = [UIColor redColor];
//    redcountimage.hidden = NO;
//    [self.navigationItem.titleView addSubview:redcountimage];
//    // 这里暂时没适配
//    self.searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 230, 30)];
//    [self.searchButton setTitle:@"搜索您想要的商品" forState:UIControlStateNormal];
//    self.searchButton.titleLabel.font = [UIFont systemFontOfSize:13];
//    [self.searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self.searchButton setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [self.searchButton addTarget:self action:@selector(onClickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.titleView = self.searchButton;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.navigationItem setTitleView:view];
    
    UIButton *butleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    [butleft setImage:[UIImage imageNamed:@"fenlei"] forState:UIControlStateNormal];
    butleft.backgroundColor = [UIColor redColor];
    [butleft addTarget:self action:@selector(onClickLeft) forControlEvents:UIControlEventTouchUpInside];
    butleft.backgroundColor = [UIColor clearColor];
    [view addSubview:butleft];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 5, 30, 30)];
    [but setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
    but.backgroundColor = [UIColor redColor];
    [but addTarget:self action:@selector(onClickRight) forControlEvents:UIControlEventTouchUpInside];
    but.backgroundColor = [UIColor clearColor];
    [view addSubview:but];
    redcountimage = [[UIImageView alloc] initWithFrame:CGRectMake(27, 2, 6, 6)];
    redcountimage.layer.masksToBounds = YES;
    redcountimage.layer.cornerRadius = 3;
    redcountimage.backgroundColor = [UIColor redColor];
    redcountimage.hidden = NO;
    [but addSubview:redcountimage];
    
    UISearchBar *customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50,5, (self.view.frame.size.width-120), 34)];
    customSearchBar.delegate = self;
    customSearchBar.showsCancelButton = NO;
    customSearchBar.placeholder = @"搜一搜";
    customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [view addSubview:customSearchBar];
    
    UIButton *searchbut = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbut.frame = CGRectMake(0, 0, Main_width-70, 34);
    [customSearchBar addSubview:searchbut];
    [searchbut addTarget:self action:@selector(getsearchs) forControlEvents:UIControlEventTouchUpInside];
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
        [self updateSearchBarColor:alpha];
    }
    else
    {
        [self wr_setNavBarBackgroundAlpha:0];
        [self.searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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

- (void)updateSearchBarColor:(CGFloat)alpha
{
    UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    UIImage *image = [UIImage imageNamed:@"search"];
    image = [image wr_updateImageWithTintColor:color alpha:alpha];
    [self.searchButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.searchButton setTitleColor:CIrclecolor forState:UIControlStateNormal];
}

-(void)postshopindex
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
        
        HeaDataArr = [[NSArray alloc] init];
        HeaDataArr = [responseObject objectForKey:@"data"];
        NSLog(@"headarr==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        //NSLog(@"success--%@--%@",[responseObject class],responseObject);
        
        NSMutableArray *imagearr = [NSMutableArray array];
        bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 0, Main_width, Main_width/(1.87)) viewSize:CGSizeMake(Main_width,Main_width/(1.87))];
        
        if ([HeaDataArr isKindOfClass:[NSArray class]]) {
            for (int i=0; i<HeaDataArr.count; i++) {
                NSString *strurl = [API_img stringByAppendingString:[[HeaDataArr objectAtIndex:i]objectForKey:@"img"]];
                NSLog(@"%@",strurl);
                [imagearr addObject:strurl];
                bannerView.items = imagearr;
            }
        }else{
            imagearr  =  nil;
            
        }
        
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
-(void)postcenter
{
    _pagenum = 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"]};
    //3.发送GET请求
    /*
     */
    NSString *strurl = [API stringByAppendingString:@"shop/shop_index_new"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //[_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"get---success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        centerArr = [[NSArray alloc] init];
        shangpinArr = [[NSMutableArray alloc] init];
        fenleiArr = [[NSArray alloc] init];
        pro_discount_listArr = [[NSArray alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            centerArr = [[responseObject objectForKey:@"data"] objectForKey:@"cate_list"];
            fenleiArr = [[responseObject objectForKey:@"data"] objectForKey:@"pro_list"];
            if ([fenleiArr isKindOfClass:[NSArray class]]) {
                [shangpinArr addObjectsFromArray:[[fenleiArr objectAtIndex:0] objectForKey:@"list"]];
            }
            pro_discount_listArr = [[[responseObject objectForKey:@"data"] objectForKey:@"pro_discount_list"] objectForKey:@"list"];
            cate_img = [[[responseObject objectForKey:@"data"] objectForKey:@"pro_discount_list"] objectForKey:@"cate_img"];
            if ([fenleiArr isKindOfClass:[NSArray class]]) {
                moregoodsid = [[fenleiArr objectAtIndex:0] objectForKey:@"id"];
            }
        }
        [_tableView.mj_header endRefreshing];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)postguanggao
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
    NSString *strurl = [API stringByAppendingString:@"site/get_Advertising/c_name/hc_shop_center"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        guanggaoArr = [[NSArray alloc] init];
        guanggaoArr = [responseObject objectForKey:@"data"];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        
        guanggaoArr = [responseObject objectForKey:@"data"];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - tableview delegate / dataSource

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([fenleiArr isKindOfClass:[NSArray class]]) {
        return 4+fenleiArr.count;
    }else{
        return 4;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section>3) {
        return 2;
    }else if (section==3){
        return 3;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    cell.userInteractionEnabled = YES;
    cell.backgroundColor = BackColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    if (indexPath.section==0) {
        if ([HeaDataArr isKindOfClass:[NSArray class]]) {
            [cell.contentView addSubview:bannerView];
            
            [bannerView imageViewClick:^(JKBannarView * _Nonnull barnerview, NSInteger index) {
                NSLog(@"点击图片%ld",index);
                NSString *url_type = [[HeaDataArr objectAtIndex:index] objectForKey:@"url_type"];
                NSString *url_id = [[HeaDataArr objectAtIndex:index] objectForKey:@"url_id"];
                NSString *urltypename = [[HeaDataArr objectAtIndex:index] objectForKey:@"type_name"];
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
                    NSString *type_name = [[HeaDataArr objectAtIndex:index] objectForKey:@"type_name"];
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
                    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"cate_id":result};
                    
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
                    NSString *type_name = [[HeaDataArr objectAtIndex:index] objectForKey:@"type_name"];
                    
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
                    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
                    NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
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
                    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
                    NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
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
                                NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
                                NSDictionary *dict = @{@"apk_token":uid_username,@"room_id":[[arrrrr objectAtIndex:0] objectForKey:@"room_id"],@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
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
            tableView.rowHeight = Main_width/(1.87);
        }else{
            tableView.rowHeight = RECTSTATUS.size.height+44;
        }
    }else if (indexPath.section==1){
        
        CGFloat width = (Main_width-24-30*5)/5;
        
        UIView *view = [[UIView alloc] init];
        if (centerArr.count<6) {
            view.frame = CGRectMake(12, 10, Main_width-24, width+30+20+15);
            tableView.rowHeight =width+30+20+15+10+10;
        }else{
            view.frame = CGRectMake(12, 10, Main_width-24, 15+width+15+20+10+15+width+20+15);
            tableView.rowHeight =15+width+15+20+10+15+width+20+15+10;
        }
        view.layer.cornerRadius = 5;
        view.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:view];
        
        CGFloat labelwidth = (Main_width-24)/5;
        if (centerArr.count<6){
            for (int i=0; i<centerArr.count; i++) {
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*30+i*width, 15, width, width)];
                [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                [view addSubview:imageview];

                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*labelwidth, 15+width+15, labelwidth, 20)];
                label.text = [[centerArr objectAtIndex:i] objectForKey:@"cate_name"];
                label.font = [UIFont systemFontOfSize:13];
                label.textAlignment = NSTextAlignmentCenter;
                [view addSubview:label];

                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(labelwidth*i, 15, labelwidth, labelwidth);
                but.tag = i;
                [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:but];
            }
        }else if (centerArr.count>=10) {
            for (int i=0; i<9; i++) {
                if (i<5) {
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*30+i*width, 15, width, width)];
                    [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                    [view addSubview:imageview];

                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*labelwidth, 15+width+15, labelwidth, 20)];
                    label.text = [[centerArr objectAtIndex:i] objectForKey:@"cate_name"];
                    label.font = [UIFont systemFontOfSize:13];
                    label.textAlignment = NSTextAlignmentCenter;
                    [view addSubview:label];

                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(labelwidth*i, 15, labelwidth, labelwidth);
                    but.tag = i;
                    [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:but];
                }else{

                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+(i-5)*30+(i-5)*width, 15+width+15+20+10, width, width)];

                    [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                    [view addSubview:imageview];

                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i-5)*labelwidth, 15+width+15+20+10+15+width, labelwidth, 20)];

                    label.font = [UIFont systemFontOfSize:13];
                    label.textAlignment = NSTextAlignmentCenter;
                    [view addSubview:label];

                    
                    [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                    label.text = [[centerArr objectAtIndex:i] objectForKey:@"cate_name"];
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(labelwidth*(i-5), 15+width+15+20+10, labelwidth, labelwidth);
                    but.tag = i;
                    [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:but];
                }
            }

            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+(9-5)*30+(9-5)*width, 15+width+15+20+10, width, width)];
            imageview.image = [UIImage imageNamed:@"iv_icon_all"];
            
            [view addSubview:imageview];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((9-5)*labelwidth, 15+width+15+20+10+15+width, labelwidth, 20)];
            
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"全部";
            [view addSubview:label];
            
            
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(labelwidth*(9-5), 15+width+15+20+10, labelwidth, labelwidth);
            but.tag = 9;
            [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:but];
        }else{
            for (int i=0; i<centerArr.count; i++) {
                if (i<5) {
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*30+i*width, 15, width, width)];
                    [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                    [view addSubview:imageview];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*labelwidth, 15+width+15, labelwidth, 20)];
                    label.text = [[centerArr objectAtIndex:i] objectForKey:@"cate_name"];
                    label.font = [UIFont systemFontOfSize:13];
                    label.textAlignment = NSTextAlignmentCenter;
                    [view addSubview:label];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(labelwidth*i, 15, labelwidth, labelwidth);
                    but.tag = i;
                    [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:but];
                }else{
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+(i-5)*30+(i-5)*width, 15+width+15+20+10, width, width)];
                    [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                    [view addSubview:imageview];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i-5)*labelwidth, 15+width+15+20+10+15+width, labelwidth, 20)];
                    label.text = [[centerArr objectAtIndex:i] objectForKey:@"cate_name"];
                    label.font = [UIFont systemFontOfSize:13];
                    label.textAlignment = NSTextAlignmentCenter;
                    [view addSubview:label];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(labelwidth*(i-5), 15+width+15+20+10, labelwidth, labelwidth);
                    but.tag = i;
                    [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:but];
                }
            }
        }
        
    
    }else if (indexPath.section==2){
        
        
        
        
//        //初始化pageControl
//        //                    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 32, Main_width, 8)];
//        //                    pageFlowView.pageControl = pageControl;
//        //                    [pageFlowView addSubview:pageControl];
//
//
//
//        if ([guanggaoArr isKindOfClass:[NSArray class]]) {
//
//            self.automaticallyAdjustsScrollViewInsets = NO;
//
//            NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 5, Main_width, (Main_width)/(2.5))];
//            pageFlowView.delegate = self;
//            pageFlowView.dataSource = self;
//            pageFlowView.minimumPageAlpha = 0.1;
//            pageFlowView.isCarousel = NO;
//            pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
//            pageFlowView.isOpenAutoScroll = YES;
//            [cell.contentView addSubview:pageFlowView];
//            tableView.rowHeight = Main_width/2.5;
//
//            [pageFlowView reloadData];
//        }else{
//            tableView.rowHeight = 0;
//        }
        tableView.rowHeight = 0;
        
    }else if (indexPath.section==3){
        if (indexPath.row==0) {
            if ([pro_discount_listArr isKindOfClass:[NSArray class]]&&pro_discount_listArr.count>0) {
                tableView.rowHeight = 75+26;
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, Main_width-24, 75+13)];
                
                NSString *imgstr = [NSString stringWithFormat:@"%@%@",API_img,cate_img];
                NSLog(@"pro_discount_listDicimage---%@--%@",pro_discount_listArr,cate_img);
                [imageview sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                [cell.contentView addSubview:imageview];
                
                UIButton *xianshi = [UIButton buttonWithType:UIButtonTypeCustom];
                xianshi.frame = CGRectMake(0, 0, Main_width, 75+26);
                [xianshi addTarget:self action:@selector(newxianshi) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:xianshi];
            }else{
                tableView.rowHeight = 0;
            }
            
        }else if (indexPath.row==1){
            if ([pro_discount_listArr isKindOfClass:[NSArray class]]&&pro_discount_listArr.count>0) {
                tableView.rowHeight = 212+25+8+8;
                UIButton *morebut = [UIButton buttonWithType:UIButtonTypeCustom];
                morebut.frame = CGRectMake(Main_width-50, 10, 40, 15);
                morebut.backgroundColor = QIColor;
                //[cell.contentView addSubview:morebut];
                
                UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(18, 25+8, Main_width-18*2, 212)];
                
                backscrollview.contentSize = CGSizeMake(125*pro_discount_listArr.count+16*(pro_discount_listArr.count-1), 212);
                backscrollview.showsVerticalScrollIndicator = NO;
                backscrollview.showsHorizontalScrollIndicator = NO;
                [cell.contentView addSubview:backscrollview];
                
                for (int i=0; i<pro_discount_listArr.count; i++) {
                    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake((125+16)*i, 0, 125, 212)];
                    backview.backgroundColor = [UIColor whiteColor];
                    backview.layer.cornerRadius = 5;
                    [backscrollview addSubview:backview];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 16, 117, 100)];
                    NSString *imgstr = [NSString stringWithFormat:@"%@%@",API_img,[[pro_discount_listArr objectAtIndex:i] objectForKey:@"title_thumb_img"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                    [backview addSubview:imageview];
                    
                    NSString *is_hot = [NSString stringWithFormat:@"%@",[[pro_discount_listArr objectAtIndex:i] objectForKey:@"is_hot"]];
                    NSString *is_new = [NSString stringWithFormat:@"%@",[[pro_discount_listArr objectAtIndex:i] objectForKey:@"is_new"]];
                    NSString *is_time = [NSString stringWithFormat:@"%@",[[pro_discount_listArr objectAtIndex:i] objectForKey:@"discount"]];
                    
                    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(3, -4, 31, 31)];
                    [backview addSubview:imageview1];
                    if ([is_time isEqualToString:@"1"]) {
                        imageview1.image = [UIImage imageNamed:@"秒杀"];
                    }else if ([is_hot isEqualToString:@"1"]) {
                        imageview1.image = [UIImage imageNamed:@"热卖"];
                    }else if([is_new isEqualToString:@"1"]){
                        imageview1.image = [UIImage imageNamed:@"上新"];
                    }else{
                        imageview1.alpha = 0;
                    }
                    
                    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(5, imageview.frame.size.height+imageview1.frame.origin.y+15, 115, 23)];
                    view1.backgroundColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
                    view1.layer.cornerRadius = 12;
                    [backview addSubview:view1];
                    
                    UILabel *julabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 35, 15)];
                    
                    julabel.textColor = [UIColor whiteColor];
                    julabel.font = [UIFont systemFontOfSize:10];
                    [view1 addSubview:julabel];
                    if ([[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_stime"] integerValue]-time(NULL)>0) {
                        secondsCountDown = [[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_stime"] integerValue]-time(NULL);//倒计时秒数
                        julabel.text = @"距开始";
                        
                    }else if ([[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue]-time(NULL)<0){
                        secondsCountDown = time(NULL)-[[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue];//已结束
                    }else{
                        secondsCountDown = [[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue]-time(NULL);
                        julabel.text = @"距结束";
                    }
                   
//                    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//                    attch.image = [UIImage imageNamed:@"shijian"];
//                    attch.bounds = CGRectMake(0, -3, 15, 15);
//                    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
//                    [attri insertAttributedString:string atIndex:0];
//                    label3.attributedText = attri;
//                    label3.textColor = [UIColor whiteColor];
//                    label3.textAlignment = NSTextAlignmentRight;
//                    label3.font = [UIFont systemFontOfSize:14];
                    NSDictionary *dicttime = @{@"tag":[NSString stringWithFormat:@"%d",i]};
                    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:dicttime repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
                    //设置倒计时显示的时间
                    NSString *str_day = [NSString stringWithFormat:@"%ld",secondsCountDown/3600/24];
                    NSString *str_hour = [NSString stringWithFormat:@"%ld",secondsCountDown/3600%24];//时
                    NSString *str_minute = [NSString stringWithFormat:@"%ld",(secondsCountDown%3600)/60];//分
                    NSString *str_second = [NSString stringWithFormat:@"%ld",secondsCountDown%60];//秒
                    
                    daylabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 15, 15)];
                    daylabel.backgroundColor = [UIColor whiteColor];
                    daylabel.layer.masksToBounds = YES;
                    daylabel.layer.cornerRadius = 3;
                    daylabel.textColor = QIColor;
                    daylabel.textAlignment = NSTextAlignmentCenter;
                    daylabel.text = str_day;
                    daylabel.font = [UIFont systemFontOfSize:10];
                    
                    UILabel *labelmaohao = [[UILabel alloc] initWithFrame:CGRectMake(55, 4, 15, 15)];
                    labelmaohao.text = @"天";
                    labelmaohao.textColor = [UIColor whiteColor];
                    labelmaohao.textAlignment = NSTextAlignmentCenter;
                    labelmaohao.font = [UIFont systemFontOfSize:10];
                    
                    hourslabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 4, 15, 15)];
                    hourslabel.backgroundColor = [UIColor whiteColor];
                    hourslabel.layer.masksToBounds = YES;
                    hourslabel.layer.cornerRadius = 3;
                    hourslabel.textColor = QIColor;
                    hourslabel.textAlignment = NSTextAlignmentCenter;
                    hourslabel.text = str_hour;
                    hourslabel.font = [UIFont systemFontOfSize:10];
                    
                    UILabel *labelmaohao1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 4, 10, 15)];
                    labelmaohao1.text = @":";
                    labelmaohao1.textColor = [UIColor whiteColor];
                    labelmaohao1.textAlignment = NSTextAlignmentCenter;
                    labelmaohao1.font = [UIFont systemFontOfSize:10];
                    
                    mlabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 4, 15, 15)];
                    mlabel.backgroundColor = [UIColor whiteColor];
                    mlabel.text = str_minute;
                    mlabel.layer.masksToBounds = YES;
                    mlabel.layer.cornerRadius = 3;
                    mlabel.font = [UIFont systemFontOfSize:10];
                    mlabel.textColor = QIColor;
                    mlabel.textAlignment = NSTextAlignmentCenter;
                    
                    UILabel *labelmaohao2 = [[UILabel alloc] initWithFrame:CGRectMake(105, 4, 10, 15)];
                    labelmaohao2.text = @":";
                    labelmaohao2.textColor = [UIColor whiteColor];
                    labelmaohao2.textAlignment = NSTextAlignmentCenter;
                    labelmaohao2.font = [UIFont systemFontOfSize:10];
                    
                    slabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 4, 15, 15)];
                    slabel.backgroundColor = [UIColor whiteColor];
                    slabel.font = [UIFont systemFontOfSize:10];
                    slabel.text = str_second;
                    slabel.textAlignment = NSTextAlignmentCenter;
                    slabel.layer.cornerRadius = 3;
                    slabel.layer.masksToBounds = YES;
                    slabel.textColor = QIColor;
                    
                    
                    
                    [view1 addSubview:daylabel];
                    [view1 addSubview:hourslabel];
                    [view1 addSubview:mlabel];
                    [view1 addSubview:labelmaohao];
                    [view1 addSubview:labelmaohao1];
                    
                    
                    
                    UILabel *labeltitle = [[UILabel alloc] initWithFrame:CGRectMake(6, view1.frame.size.height+view1.frame.origin.y+6, 108, 26)];
                    labeltitle.font = [UIFont systemFontOfSize:12];
                    labeltitle.numberOfLines = 2;
                    labeltitle.text = [[pro_discount_listArr objectAtIndex:i] objectForKey:@"title"];
                    [backview addSubview:labeltitle];
                    
                    UILabel *labelprice1 = [[UILabel alloc] initWithFrame:CGRectMake(6, labeltitle.frame.size.height+labeltitle.frame.origin.y+9, 125-28-6, 12)];
                    labelprice1.font = [UIFont systemFontOfSize:13];
                    labelprice1.textColor = QIColor;
                    labelprice1.text = [NSString stringWithFormat:@"¥%@/%@",[[pro_discount_listArr objectAtIndex:i] objectForKey:@"price"],[[pro_discount_listArr objectAtIndex:i] objectForKey:@"unit"]];
                    [backview addSubview:labelprice1];
                    
                    UILabel *labelprice2 = [[UILabel alloc] initWithFrame:CGRectMake(6, labelprice1.frame.size.height+labelprice1.frame.origin.y+6, 125-28-6, 9)];
                    labelprice2.font = [UIFont systemFontOfSize:12];
                    labelprice2.text = [NSString stringWithFormat:@"¥%@",[[pro_discount_listArr objectAtIndex:i] objectForKey:@"original"]];
                    labelprice2.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
                    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:labelprice2.text attributes:attribtDic];
                    labelprice2.attributedText = attribtStr;
                    [backview addSubview:labelprice2];
                    
                    UIImageView *lijigoumaiimg = [[UIImageView alloc] initWithFrame:CGRectMake(125-28-6, labelprice1.frame.origin.y, 28, 25)];
                    lijigoumaiimg.image = [UIImage imageNamed:@"ic_buynow"];
                    [backview addSubview:lijigoumaiimg];
                    
                    UIButton *goodsbut = [UIButton buttonWithType:UIButtonTypeCustom];
                    goodsbut.frame = CGRectMake(0, 0, 125, 212);
                    goodsbut.tag = [[[pro_discount_listArr objectAtIndex:i] objectForKey:@"id"] integerValue];
                    [goodsbut addTarget:self action:@selector(pushgoods:) forControlEvents:UIControlEventTouchUpInside];
                    [backview addSubview:goodsbut];
                }
            }else{
                tableView.rowHeight = 0;
            }
            
        }else{
            if (![guanggaoArr isKindOfClass:[NSArray class]]) {
                tableView.rowHeight = 0;
            }else{
                tableView.rowHeight =Main_width/3+10;
                UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, Main_width/2)];
                _scrollView.delegate = self;//设置代理
                
                _scrollView.showsHorizontalScrollIndicator = NO;
                [cell.contentView addSubview:_scrollView];
                
                [_scrollView setContentSize:CGSizeMake(Main_width*2/3*guanggaoArr.count+15+15+10+20,Main_width/3)];
                for (int i=0; i<guanggaoArr.count; i++) {
                    UIImageView *imaeee = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*(Main_width*2/3)+10*i, 0, Main_width*2/3, Main_width/3)];
                    NSString *url = [API_img stringByAppendingString:[[guanggaoArr objectAtIndex:i] objectForKey:@"img"]];
                    [imaeee sd_setImageWithURL:[NSURL URLWithString:url]];
                    [_scrollView addSubview:imaeee];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(15+i*(Main_width*2/3)+10*i, 0, Main_width*2/3, Main_width/3);
                    but.tag = i;
                    NSString *url_type = [[guanggaoArr objectAtIndex:i] objectForKey:@"url_type"];
                    [but setTitle:url_type forState:UIControlStateNormal];
                    [but.titleLabel setFont:[UIFont systemFontOfSize:1]];
                    [but addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                    [_scrollView addSubview:but];
                }
            }
        }
    } else{
        if (indexPath.row==0) {
            if ([fenleiArr isKindOfClass:[NSArray class]]) {
                tableView.rowHeight = (Main_width-24)/2.5+8;
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, Main_width-24, (Main_width-24)/2.5)];
                NSString *imgstr = [[fenleiArr objectAtIndex:indexPath.section-4] objectForKey:@"cate_img"];
                imageview.userInteractionEnabled = YES;
                imageview.clipsToBounds = YES;
                imageview.layer.cornerRadius = 5;
                [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:imgstr]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                [cell.contentView addSubview:imageview];
            }else{
                tableView.rowHeight = 0;
            }
        }else{
            if ([fenleiArr isKindOfClass:[NSArray class]]) {
                NSArray *arr = [NSArray array];
                long number;
                arr = [[fenleiArr objectAtIndex:indexPath.section-4] objectForKey:@"list"];
                if (arr.count%2==0) {
                    tableView.rowHeight = ((Main_width-24-7)/2+112.5+5)*arr.count/2+5;
                    number = arr.count;
                }else{
                    tableView.rowHeight = ((Main_width-24-7)/2+112.5+5)*(arr.count+1)/2+5;
                    number = arr.count;
                }
                
                
                for (int i=0; i<number; i++) {
                    if (i%2 == 0) {
                        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 10+((Main_width-24-7)/2+112.5+5)*(i/2), (Main_width-24-7)/2, (Main_width-24-7)/2+112.5)];
                        view.backgroundColor = [UIColor whiteColor];
                        view.layer.cornerRadius = 3;
                        [cell.contentView addSubview:view];
                        
                        UIButton *dianjibut = [UIButton buttonWithType:UIButtonTypeCustom];
                        dianjibut.frame = view.frame;
                        dianjibut.tag = [[[arr objectAtIndex:i] objectForKey:@"id"] longValue];
                        [dianjibut addTarget:self action:@selector(pushgoods:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:dianjibut];
                        
                        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.width)];
                        NSURL *url = [NSURL URLWithString:[API_img stringByAppendingString:[[arr objectAtIndex:i] objectForKey:@"title_thumb_img"]]];
                        [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                        [view addSubview:imageview];
                        
                        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 5+imageview.frame.size.height, view.frame.size.width-25, 40)];
                        name.text = [[arr objectAtIndex:i] objectForKey:@"title"];
                        name.font = font15;
                        name.numberOfLines = 2;
                        [view addSubview:name];
                        
                        UIView *tagview = [[UIView alloc] initWithFrame:CGRectMake(12.5, name.frame.size.height+name.frame.origin.y+7, 50, 16)];
                        [view addSubview:tagview];
                        NSArray *tagarr = [[arr objectAtIndex:i] objectForKey:@"goods_tag"];
                        if ([tagarr isKindOfClass:[NSArray class]]) {
                            if (tagarr.count>2) {
                                for (int j=0; j<2; j++) {
                                    UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 18)];
                                    taglabel.text = [[tagarr objectAtIndex:j] objectForKey:@"c_name"];
                                    taglabel.font = [UIFont systemFontOfSize:10];
                                    taglabel.textColor = QIColor;
                                    taglabel.textAlignment = NSTextAlignmentCenter;
                                    taglabel.layer.cornerRadius = 2;
                                    [taglabel.layer setBorderWidth:0.5];
                                    [taglabel.layer setBorderColor:QIColor.CGColor];
                                    [tagview addSubview:taglabel];
                                }
                            }else{
                                for (int j=0; j<tagarr.count; j++) {
                                    UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 18)];
                                    taglabel.text = [[tagarr objectAtIndex:j] objectForKey:@"c_name"];
                                    taglabel.font = [UIFont systemFontOfSize:10];
                                    taglabel.textColor = QIColor;
                                    taglabel.textAlignment = NSTextAlignmentCenter;
                                    taglabel.layer.cornerRadius = 2;
                                    [taglabel.layer setBorderWidth:0.5];
                                    [taglabel.layer setBorderColor:QIColor.CGColor];
                                    [tagview addSubview:taglabel];
                                }
                            }
                        }
                        
                        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(12.5, tagview.frame.size.height+tagview.frame.origin.y+12.5, 60, 20)];
                        price.text = [NSString stringWithFormat:@"%@/%@",[[arr objectAtIndex:i] objectForKey:@"price"],[[arr objectAtIndex:i] objectForKey:@"unit"]];
                        price.textColor = QIColor;
                        price.font = [UIFont systemFontOfSize:13];
                        
                        [view addSubview:price];
                        
                        UILabel *originalprice = [[UILabel alloc] initWithFrame:CGRectMake(12.5+60+5, tagview.frame.size.height+tagview.frame.origin.y+12.5, 60, 20)];
                        originalprice.textColor = CIrclecolor;
                        originalprice.text = [NSString stringWithFormat:@"¥%@",[[arr objectAtIndex:i] objectForKey:@"original"]];
                        originalprice.font = [UIFont systemFontOfSize:12];
                        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:originalprice.text attributes:attribtDic];
                        originalprice.attributedText = attribtStr;
                        [view addSubview:originalprice];
                        
                        UIButton *gouwuchebut = [UIButton buttonWithType:UIButtonTypeCustom];
                        gouwuchebut.frame = CGRectMake((Main_width-24-7)/2-45, tagview.frame.size.height+tagview.frame.origin.y+5, 30, 30);
                        [gouwuchebut setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
                        gouwuchebut.tag = i;
                        gouwuchebut.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.section-4];
                        [gouwuchebut.titleLabel setFont:[UIFont systemFontOfSize:0.01]];
                        [gouwuchebut addTarget:self action:@selector(jiarugouwuche:) forControlEvents:UIControlEventTouchUpInside];
                        [dianjibut addSubview:gouwuchebut];
                    }else{
                        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12+((Main_width-24-7)/2+7), 10+((Main_width-24-7)/2+112.5+5)*(i/2), (Main_width-24-7)/2, (Main_width-24-7)/2+112.5)];
                        view.backgroundColor = [UIColor whiteColor];
                        view.layer.cornerRadius = 3;
                        [cell.contentView addSubview:view];
                        
                        UIButton *dianjibut = [UIButton buttonWithType:UIButtonTypeCustom];
                        dianjibut.frame = view.frame;
                        dianjibut.tag = [[[arr objectAtIndex:i] objectForKey:@"id"] longValue];
                        [dianjibut addTarget:self action:@selector(pushgoods:) forControlEvents:UIControlEventTouchUpInside];
                        [cell.contentView addSubview:dianjibut];
                        
                        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.width)];
                        NSURL *url = [NSURL URLWithString:[API_img stringByAppendingString:[[arr objectAtIndex:i] objectForKey:@"title_thumb_img"]]];
                        [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                        [view addSubview:imageview];
                        
                        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 5+imageview.frame.size.height, view.frame.size.width-25, 40)];
                        name.text = [[arr objectAtIndex:i] objectForKey:@"title"];
                        name.font = font15;
                        name.numberOfLines = 2;
                        [view addSubview:name];
                        
                        UIView *tagview = [[UIView alloc] initWithFrame:CGRectMake(12.5, name.frame.size.height+name.frame.origin.y+7, 60, 18)];
                        [view addSubview:tagview];
                        NSArray *tagarr = [[arr objectAtIndex:i] objectForKey:@"goods_tag"];
                        if ([tagarr isKindOfClass:[NSArray class]]) {
                            if (tagarr.count>2) {
                                for (int j=0; j<2; j++) {
                                    UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 18)];
                                    taglabel.text = [[tagarr objectAtIndex:j] objectForKey:@"c_name"];
                                    taglabel.font = [UIFont systemFontOfSize:10];
                                    taglabel.textColor = QIColor;
                                    taglabel.textAlignment = NSTextAlignmentCenter;
                                    taglabel.layer.cornerRadius = 2;
                                    [taglabel.layer setBorderWidth:0.5];
                                    [taglabel.layer setBorderColor:QIColor.CGColor];
                                    [tagview addSubview:taglabel];
                                }
                            }else{
                                for (int j=0; j<tagarr.count; j++) {
                                    UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 18)];
                                    taglabel.text = [[tagarr objectAtIndex:j] objectForKey:@"c_name"];
                                    taglabel.font = [UIFont systemFontOfSize:10];
                                    taglabel.textColor = QIColor;
                                    taglabel.textAlignment = NSTextAlignmentCenter;
                                    taglabel.layer.cornerRadius = 2;
                                    [taglabel.layer setBorderWidth:0.5];
                                    [taglabel.layer setBorderColor:QIColor.CGColor];
                                    [tagview addSubview:taglabel];
                                }
                            }
                        }
                        
                        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(12.5, tagview.frame.size.height+tagview.frame.origin.y+12.5, 60, 20)];
                        price.text = [NSString stringWithFormat:@"%@/%@",[[arr objectAtIndex:i] objectForKey:@"price"],[[arr objectAtIndex:i] objectForKey:@"unit"]];
                        price.textColor = QIColor;
                        price.font = [UIFont systemFontOfSize:13];
                        
                        [view addSubview:price];
                        
                        UILabel *originalprice = [[UILabel alloc] initWithFrame:CGRectMake(12.5+60+10, tagview.frame.size.height+tagview.frame.origin.y+12.5, 50, 20)];
                        originalprice.textColor = CIrclecolor;
                        originalprice.text = [NSString stringWithFormat:@"¥%@",[[arr objectAtIndex:i] objectForKey:@"original"]];
                        originalprice.font = [UIFont systemFontOfSize:12];
                        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
                        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:originalprice.text attributes:attribtDic];
                        originalprice.attributedText = attribtStr;
                        [view addSubview:originalprice];
                        
                        UIButton *gouwuchebut = [UIButton buttonWithType:UIButtonTypeCustom];
                        gouwuchebut.frame = CGRectMake((Main_width-24-7)/2-45, tagview.frame.size.height+tagview.frame.origin.y+5, 30, 30);
                        [gouwuchebut setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
                        gouwuchebut.tag = i;
                        gouwuchebut.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.section-4];
                        [gouwuchebut.titleLabel setFont:[UIFont systemFontOfSize:0.01]];
                        [gouwuchebut addTarget:self action:@selector(jiarugouwuche:) forControlEvents:UIControlEventTouchUpInside];
                        [dianjibut addSubview:gouwuchebut];
                    }
                }
            }else{
                tableView.rowHeight = 0;
            }
        }
    }
    return cell;
}

-(void) countDownAction{
    int i = [[countDownTimer.userInfo objectForKey:@"tag"] intValue];
    if ([[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_stime"] integerValue]-time(NULL)>0) {
        secondsCountDown = [[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_stime"] integerValue]-time(NULL);//倒计时秒数
    }else if ([[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue]-time(NULL)<0){
        secondsCountDown = time(NULL)-[[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue];//已结束
    }else{
        secondsCountDown = [[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue]-time(NULL);
        
    }
    NSString *str_day = [NSString stringWithFormat:@"%ld",secondsCountDown/3600/24];
    NSString *str_hour = [NSString stringWithFormat:@"%ld",secondsCountDown/3600%24];//时
    NSString *str_minute = [NSString stringWithFormat:@"%ld",(secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%ld",secondsCountDown%60];//秒
    //修改倒计时标签现实内容
    daylabel.text = str_day;
    hourslabel.text = str_hour;
    mlabel.text = str_minute;
    slabel.text = str_second;
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [countDownTimer invalidate];
    }
}
- (void)jiarugouwuche:(UIButton *)sender
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
    long i = sender.tag;
    int j = [sender.titleLabel.text intValue];
    NSArray *arr = [NSArray array];
    arr = [[fenleiArr objectAtIndex:j] objectForKey:@"list"];
    
    NSString *kucun = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"inventory"]];
    NSString *exist_hours = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"exist_hours"]];
    NSString *tagname = [[arr objectAtIndex:i] objectForKey:@"inventory"];
    NSString *pid = [[arr objectAtIndex:i] objectForKey:@"id"];
    NSString *title = [[arr objectAtIndex:i] objectForKey:@"title"];
    NSString *title_img = [[arr objectAtIndex:i] objectForKey:@"title_img"];
    NSString *tagid = [[arr objectAtIndex:i] objectForKey:@"tagid"];
    NSString *price = [[arr objectAtIndex:i] objectForKey:@"price"];
    if ([exist_hours isEqualToString:@"2"]) {
        [MBProgressHUD showToastToView:self.view withText:@"当前时间不在配送时间范围内"];
    }else if ([kucun isEqualToString:@"0"]){
        [MBProgressHUD showToastToView:self.view withText:@"库存不足"];
    }else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数

        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
        NSDictionary *dict = [[NSDictionary alloc] init];


        dict = @{@"number":@"1",@"tagname":tagname,@"p_id":pid,@"p_title":title,@"p_title_img":title_img,@"tagid":tagid,@"price":price,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
        NSString *strurl = [API stringByAppendingString:@"shop/add_shopping_cart"];
        [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section>3&&indexPath.row==0){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        shangpinliebiaoViewController *liebiao = [[shangpinliebiaoViewController alloc] init];
        liebiao.id = [[fenleiArr objectAtIndex:indexPath.section-4] objectForKey:@"id"];
        liebiao.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:liebiao animated:YES];
    }else{
        
    }
}

- (void)pushgoods:(UIButton *)sender
{
    GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
    goods.IDstring = [NSString stringWithFormat:@"%lu",sender.tag];
    goods.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goods animated:YES];
}
- (void)pusherji:(UIButton *)sender
{
    NSString *islimtt = [NSString stringWithFormat:@"%@",[[centerArr objectAtIndex:sender.tag] objectForKey:@"is_limit"]];
    if (sender.tag==9) {
        ShangpinfenleiViewController *shangfenlei = [[ShangpinfenleiViewController alloc] init];
        shangfenlei.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shangfenlei animated:YES];
    }else{
        if ([islimtt isEqualToString:@"1"]) {
            xianshiqianggouerjiViewController *xianshi = [[xianshiqianggouerjiViewController alloc] init];
            xianshi.id = [[centerArr objectAtIndex:sender.tag] objectForKey:@"id"];
            xianshi.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:xianshi animated:YES];
        }else{
            shangpinliebiaoViewController *liebiao = [[shangpinliebiaoViewController alloc] init];
            //liebiao.title = [[centerArr objectAtIndex:sender.tag] objectForKey:@"cate_name"];
            liebiao.id = [[centerArr objectAtIndex:sender.tag] objectForKey:@"id"];
            liebiao.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:liebiao animated:YES];
        }
    }
}
- (void)createui
{
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BackColor;
    
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - [self navBarBottom], 0, 0, 0);
    [self.view addSubview:self.tableView];
    [_tableView.mj_header beginRefreshing];
}
//#pragma mark - getter / setter
//- (UITableView *)tableView
//{
//    if (_tableView == nil) {
//
//    }
//    return _tableView;
//}
- (void)xiala
{
    //[_tableView.mj_header beginRefreshing];
    [self postcenter];
    [self postguanggao];
    [self postshopindex];
    [self postcount];
}

- (UIImage *)imageWithImageSimple:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width*2, newSize.height*2));
    [image drawInRect:CGRectMake (0, 0, newSize.width*2, newSize.height*2)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//- (SDCycleScrollView *)advView
//{
//    if (_advView == nil) {
//        NSArray *localImages = @[@"lagou0", @"lagou1", @"lagou2", @"lagou3"];
//        _advView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -IMAGE_HEIGHT, kScreenWidth, IMAGE_HEIGHT) imageNamesGroup:localImages];
//        _advView.pageDotColor = [UIColor grayColor];
//        _advView.autoScrollTimeInterval = 2;
//        _advView.currentPageDotColor = [UIColor whiteColor];
//        _advView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//    }
//    return _advView;
//}

- (void)onClickLeft
{
    ShangpinfenleiViewController *shangfenlei = [[ShangpinfenleiViewController alloc] init];
    shangfenlei.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shangfenlei animated:YES];
}
- (void)onClickRight
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        GouwucheViewController *gouwuche = [[GouwucheViewController alloc] init];
        gouwuche.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gouwuche animated:YES];
    }
    
}
- (void)onClickSearchBtn
{
    [self getsearchs];
}
- (void)getsearchs
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"id":[user objectForKey:@"community_id"]};
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
- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}
-(void)next
{
    xianshiqianggouViewController *xianshiqianggou = [[xianshiqianggouViewController alloc] init];
    xianshiqianggou.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xianshiqianggou animated:YES];
}
- (void)newxianshi
{
    newxianshiqianggouViewController *newxianshi = [[newxianshiqianggouViewController alloc] init];
    newxianshi.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newxianshi animated:YES];
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
