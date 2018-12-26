//
//  jujiayanglaoViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/31.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "jujiayanglaoViewController.h"
#import "moreteziViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "JKBannarView.h"
#import "NewPagedFlowView.h"
#import "shangpinliebiaoViewController.h"
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
#import "MyhomeViewController.h"
#import "xinfangshouceViewController.h"
#import "MBProgressHUD+TVAssistant.h"

@interface jujiayanglaoViewController ()<UITableViewDelegate,UITableViewDataSource,NewPagedFlowViewDelegate,NewPagedFlowViewDataSource>
{
    UITableView *_tableview;
    
    NSArray *tieziarr;
    NSArray *chanpinarr;
    
    NSArray *guanggaoarr;
    NSArray *centeguanggaoarr;
    
    JKBannarView *bannerView;
    
    NSDictionary *p_url;//产品
    NSDictionary *s_url;//帖子
}

@end

@implementation jujiayanglaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"居家养老";
    
    [self createui];
    [self getData];
    [self getguanggao];
    [self getcenter];
    // Do any additional setup after loading the view.
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
-(void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"]};
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
    
    NSString *strurl = [API stringByAppendingString:@"shop/old_index_new"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        tieziarr = [NSArray array];
        chanpinarr = [NSArray array];
        
        chanpinarr = [[responseObject objectForKey:@"data"] objectForKey:@"p_list"];
        tieziarr = [[responseObject objectForKey:@"data"] objectForKey:@"s_list"];
        
        p_url = [[NSDictionary alloc] init];
        s_url = [[NSDictionary alloc] init];
        
        p_url = [[responseObject objectForKey:@"data"] objectForKey:@"p_url"];
        s_url = [[responseObject objectForKey:@"data"] objectForKey:@"s_url"];
        [_tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
-(void)getguanggao
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
    NSString *strurl = [API stringByAppendingString:@"site/get_Advertising/c_name/hc_old_top"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        guanggaoarr = [[NSArray alloc] init];
        guanggaoarr = [responseObject objectForKey:@"data"];
        NSLog(@"headarr==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        //NSLog(@"success--%@--%@",[responseObject class],responseObject);
        
        NSMutableArray *imagearr = [NSMutableArray array];
        bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 0, Main_width, Main_width/(2.5)) viewSize:CGSizeMake(Main_width,Main_width/(2.5))];
        
        if ([guanggaoarr isKindOfClass:[NSArray class]]) {
            for (int i=0; i<guanggaoarr.count; i++) {
                NSString *strurl = [API_img stringByAppendingString:[[guanggaoarr objectAtIndex:i]objectForKey:@"img"]];
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
        [_tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
-(void)getcenter
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
    NSString *strurl = [API stringByAppendingString:@"site/get_Advertising/c_name/hc_old_center"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        centeguanggaoarr = [[NSArray alloc] init];
        centeguanggaoarr = [responseObject objectForKey:@"data"];
        NSLog(@"headarr==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        //NSLog(@"success--%@--%@",[responseObject class],responseObject);
        
        [_tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)createui
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = BackColor;
    //_TabelView.enablePlaceHolderView = YES;
    //_tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
    [self.view addSubview:_tableview];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        if ([tieziarr isKindOfClass:[NSArray class]]) {
            return  tieziarr.count+1;
        }else{
            return 0;
        }
    }else if (section==3){
        if ([chanpinarr isKindOfClass:[NSArray class]]) {
            return chanpinarr.count+1;
        }else{
            return 0;
        }
    }else if (section==2){
        if ([centeguanggaoarr isKindOfClass:[NSArray class]]) {
            return 1;
        }else{
          return 0;
        }
    }else{
        if ([guanggaoarr isKindOfClass:[NSArray class]]) {
            return 1;
        }else{
            return 0;
        }
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
    return 0;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return Main_width/2.5;
    }else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            return 40;
        }else{
            return 147;
        }
    }else if (indexPath.section==2)
    {
        return Main_width/2.5;
    }else{
        if (indexPath.row==0) {
            return 40;
        }else{
            return 110+12.5;
        }
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
    cell.contentView.backgroundColor = BackColor;
    if (indexPath.section==0) {
        [cell.contentView addSubview:bannerView];
        
        [bannerView imageViewClick:^(JKBannarView * _Nonnull barnerview, NSInteger index) {
            NSLog(@"点击图片%ld",index);
            NSString *url_type = [[guanggaoarr objectAtIndex:index] objectForKey:@"url_type"];
            NSString *url_id = [[guanggaoarr objectAtIndex:index] objectForKey:@"url_id"];
            NSString *urltypename = [[guanggaoarr objectAtIndex:index] objectForKey:@"type_name"];
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
                NSString *type_name = [[guanggaoarr objectAtIndex:index] objectForKey:@"type_name"];
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
                NSString *type_name = [[guanggaoarr objectAtIndex:index] objectForKey:@"type_name"];
                
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
//                        [self logout];
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
//                                    [self logout];
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
//                        [self logout];
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
        }];
    }else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, Main_width/2, 40)];
            label.text = @"老年风采";
            label.font = font18;
            label.textColor = QIColor;
            [cell.contentView addSubview:label];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(Main_width-12-50, 0, 50, 40);
            [but setTitle:@"更多" forState:UIControlStateNormal];
            [but.titleLabel setFont:[UIFont systemFontOfSize:15]];
            but.tag = 1001;
            [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
        }else{
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(12, 0, Main_width-24, 145)];
            backview.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:backview];
            
            UIImageView *_imageview = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width-24-80-10, 15, 80, 80)];
            [backview addSubview:_imageview];
            NSArray *imgarr = [[tieziarr objectAtIndex:indexPath.row-1] objectForKey:@"img_list"];
            if ([imgarr isKindOfClass:[NSArray class]]) {
                NSString *imagestring = [[[[tieziarr objectAtIndex:indexPath.row-1] objectForKey:@"img_list"] objectAtIndex:0] objectForKey:@"img"];
                
                [_imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:imagestring]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
            }
            _imageview.userInteractionEnabled = YES;
            _imageview.clipsToBounds = YES;
            _imageview.contentMode = UIViewContentModeScaleAspectFill;
            
            UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, Main_width-24-20-80-10, 40)];
            NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[[tieziarr objectAtIndex:indexPath.row-1] objectForKey:@"title"] options:0];
            NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
            titlelabel.text = labeltext;
            titlelabel.numberOfLines = 2;
            titlelabel.alpha = 0.87;
            titlelabel.font = [UIFont boldSystemFontOfSize:16.5];
            [backview addSubview:titlelabel];
            
            
            
            UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titlelabel.frame.size.height+titlelabel.frame.origin.y+10, Main_width-24-20-80-10, 40)];
            contentlabel.numberOfLines = 2;
            contentlabel.font = font15;
            contentlabel.alpha = 0.54;
            NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[[tieziarr objectAtIndex:indexPath.row-1] objectForKey:@"content"] options:0];
            NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
            contentlabel.text = labeltext2;
            [backview addSubview:contentlabel];
            
            UIImageView *touxiang = [[UIImageView alloc] initWithFrame:CGRectMake(10, contentlabel.frame.size.height+contentlabel.frame.origin.y+10, 20, 20)];
            touxiang.layer.cornerRadius = 10;
            NSString *imagestring1 = [[tieziarr objectAtIndex:indexPath.row-1] objectForKey:@"avatars"];
            [touxiang sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:imagestring1]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
            [backview addSubview:touxiang];
            
            UILabel *zuozhe = [[UILabel alloc] initWithFrame:CGRectMake(10+20+5, contentlabel.frame.size.height+contentlabel.frame.origin.y+10, Main_width-24-20-80-10-40, 20)];
            zuozhe.font = [UIFont systemFontOfSize:13];
            zuozhe.alpha = 0.54;
            zuozhe.text = [NSString stringWithFormat:@"%@  发布于  %@  %@",[[tieziarr objectAtIndex:indexPath.row-1] objectForKey:@"nickname"],[[tieziarr objectAtIndex:indexPath.row-1] objectForKey:@"c_name"],[[tieziarr objectAtIndex:indexPath.row-1] objectForKey:@"addtime"]];
            [backview addSubview:zuozhe];
            
            UILabel *scanlabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-24-100-10, contentlabel.frame.size.height+contentlabel.frame.origin.y+10, 60, 20)];

            NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",[[tieziarr objectAtIndex:indexPath.row-1] objectForKey:@"click"]]];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"liulan"];
            attch.bounds = CGRectMake(0, -3, 15, 15);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:0];
            scanlabel.attributedText = attri;
            scanlabel.alpha = 0.54;
            scanlabel.font = [UIFont systemFontOfSize:13];
            [backview addSubview:scanlabel];

            UILabel *pinglunlabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-24-100-10+60, contentlabel.frame.size.height+contentlabel.frame.origin.y+10, 50, 20)];
            NSMutableAttributedString *attri1 =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",[[tieziarr objectAtIndex:indexPath.row-1] objectForKey:@"reply_num"]]];
            NSTextAttachment *attch1 = [[NSTextAttachment alloc] init];
            attch1.image = [UIImage imageNamed:@"pinglun"];
            attch1.bounds = CGRectMake(0, -3, 15, 15);
            NSAttributedString *string1 = [NSAttributedString attributedStringWithAttachment:attch1];
            [attri1 insertAttributedString:string1 atIndex:0];
            pinglunlabel.attributedText = attri1;
            pinglunlabel.alpha = 0.54;
            pinglunlabel.font = [UIFont systemFontOfSize:13];
            [backview addSubview:pinglunlabel];
        }
    }else if (indexPath.section==2)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 5, Main_width, (Main_width)/(2.5))];
        pageFlowView.delegate = self;
        pageFlowView.dataSource = self;
        pageFlowView.minimumPageAlpha = 0.1;
        pageFlowView.isCarousel = NO;
        pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        pageFlowView.isOpenAutoScroll = YES;
        
        //初始化pageControl
        //                    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 32, Main_width, 8)];
        //                    pageFlowView.pageControl = pageControl;
        //                    [pageFlowView addSubview:pageControl];
        
        
        [pageFlowView reloadData];
        
        [cell.contentView addSubview:pageFlowView];
    }else{
        if (indexPath.row==0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, Main_width/2, 40)];
            label.text = @"老年产品";
            label.font = font18;
            label.textColor = QIColor;
            [cell.contentView addSubview:label];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(Main_width-12-50, 0, 50, 40);
            [but setTitle:@"更多" forState:UIControlStateNormal];
            [but.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [but addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
            but.tag = 1002;
            [cell.contentView addSubview:but];
        }else{
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(12, 0, Main_width-24, 110)];
            backview.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:backview];
            
             UIImageView *_imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
            [backview addSubview:_imageview];
            
            UIImageView *_is_hotnewimage = [[UIImageView alloc] initWithFrame:CGRectMake(5, -2, 30, 30)];
            [backview addSubview:_is_hotnewimage];
            
            UILabel *_maiwanlemelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110-25, 110, 25)];
            _maiwanlemelabel.textColor = [UIColor whiteColor];
            _maiwanlemelabel.backgroundColor = [UIColor darkGrayColor];
            _maiwanlemelabel.text = @"已售罄";
            _maiwanlemelabel.alpha = 0.4;
            _maiwanlemelabel.font = font15;
            _maiwanlemelabel.textAlignment = NSTextAlignmentCenter;
            [backview addSubview:_maiwanlemelabel];
            
            UILabel *_titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(110+9, 8, backview.frame.size.width-110-18, 40)];
            _titlelabel.numberOfLines = 2;
            _titlelabel.font = font15;
            [backview addSubview:_titlelabel];
            
            UIView *_tagview = [[UIView alloc] initWithFrame:CGRectMake(119, _titlelabel.frame.size.height+_titlelabel.frame.origin.y+7, 50+45, 16)];
            [backview addSubview:_tagview];
            
            UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
            [backview addSubview:_button];
            
            UILabel *_pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(119, _tagview.frame.size.height+_tagview.frame.origin.y+12.5, 60, 20)];
            _pricelabel.font = [UIFont systemFontOfSize:13];
            [backview addSubview:_pricelabel];
            
            UILabel *_yuanpricelabel = [[UILabel alloc] initWithFrame:CGRectMake(119+70, _tagview.frame.size.height+_tagview.frame.origin.y+12.5, 60, 20)];
            _yuanpricelabel.font = [UIFont systemFontOfSize:12];
            [backview addSubview:_yuanpricelabel];
            
            UILabel *_yishoulabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-24-12.5-100, _tagview.frame.size.height+_tagview.frame.origin.y+12.5, 100, 20)];
            _yishoulabel.font = [UIFont systemFontOfSize:12];
            _yishoulabel.textAlignment = NSTextAlignmentRight;
            [backview addSubview:_yishoulabel];
            
            NSString *imagestring = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"title_img"];
            NSString *is_hot = [NSString stringWithFormat:@"%@",[[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"is_hot"]];
            NSString *is_new = [NSString stringWithFormat:@"%@",[[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"is_new"]];
            NSString *is_time = [NSString stringWithFormat:@"%@",[[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"discount"]];
            NSString *kucun = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"title_img"];
            NSString *title = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"title"];
            NSString *nowprice = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"price"];
            NSString *yuanprice = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"original"];
            [_imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:imagestring]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
            
            if ([is_time isEqualToString:@"1"]) {
                _is_hotnewimage.image = [UIImage imageNamed:@"秒杀"];
            }else if ([is_hot isEqualToString:@"1"]) {
                _is_hotnewimage.image = [UIImage imageNamed:@"热卖"];
            }else if([is_new isEqualToString:@"1"]){
                _is_hotnewimage.image = [UIImage imageNamed:@"上新"];
            }else{
                _is_hotnewimage.alpha = 0;
            }
            
            int kuncun = [kucun intValue];
            if (kuncun <= 0) {
                _maiwanlemelabel.hidden = YES;
            }else{
                _maiwanlemelabel.hidden = NO;
            }
            
            _titlelabel.text = title;
            
            NSArray *tagarr = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"goods_tag"];
            if ([tagarr isKindOfClass:[NSArray class]]) {
                if (tagarr.count>2) {
                    for (int j=0; j<2; j++) {
                        UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 16)];
                        taglabel.text = [[tagarr objectAtIndex:j] objectForKey:@"c_name"];
                        taglabel.font = [UIFont systemFontOfSize:10];
                        taglabel.textColor = QIColor;
                        taglabel.textAlignment = NSTextAlignmentCenter;
                        taglabel.layer.cornerRadius = 2;
                        [taglabel.layer setBorderWidth:0.5];
                        [taglabel.layer setBorderColor:QIColor.CGColor];
                        [_tagview addSubview:taglabel];
                    }
                }else{
                    for (int j=0; j<tagarr.count; j++) {
                        UILabel *taglabel = [[UILabel alloc] initWithFrame:CGRectMake(60*j, 0, 55, 16)];
                        taglabel.text = [[tagarr objectAtIndex:j] objectForKey:@"c_name"];
                        taglabel.font = [UIFont systemFontOfSize:10];
                        taglabel.textColor = QIColor;
                        taglabel.textAlignment = NSTextAlignmentCenter;
                        taglabel.layer.cornerRadius = 2;
                        [taglabel.layer setBorderWidth:0.5];
                        [taglabel.layer setBorderColor:QIColor.CGColor];
                        [_tagview addSubview:taglabel];
                    }
                }
            }
            
            _button.frame = CGRectMake(Main_width-24-12.5-30, _titlelabel.frame.size.height+_titlelabel.frame.origin.y, 30, 30);
            _button.tag = indexPath.row-1;
            [_button addTarget:self action:@selector(joingouwuche:) forControlEvents:UIControlEventTouchUpInside];
            [_button setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
            
            NSString *unit = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"unit"];
            _pricelabel.text = [NSString stringWithFormat:@"¥%@/%@",nowprice,unit];
            _pricelabel.textColor = QIColor;
            
            _yuanpricelabel.text = [NSString stringWithFormat:@"¥%@",yuanprice];
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:_yuanpricelabel.text attributes:attribtDic];
            _yuanpricelabel.attributedText = attribtStr;
            _yuanpricelabel.textColor = CIrclecolor;
            
            NSString *yishou = [NSString stringWithFormat:@"%@",[[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"order_num"]];
            _yishoulabel.text = [NSString stringWithFormat:@"已售%@%@",yishou,unit];
            _yishoulabel.textColor = CIrclecolor;
        }
    }
    return cell;
}
- (void)joingouwuche:(UIButton *)sender
{
    NSString *exist_hours = [NSString stringWithFormat:@"%@",[[chanpinarr objectAtIndex:sender.tag] objectForKey:@"exist_hours"]];
    NSString *inventory = [NSString stringWithFormat:@"%@",[[chanpinarr objectAtIndex:sender.tag] objectForKey:@"inventory"]];
    if ([exist_hours isEqualToString:@"2"]) {
        [MBProgressHUD showToastToView:self.view withText:@"当前时间不在配送时间范围内"];
    }else if ([inventory isEqualToString:@"0"]){
        [MBProgressHUD showToastToView:self.view withText:@"库存不足"];
    }else{
        [self postjiarugouwuche:sender.tag];
    }
}
-(void)postjiarugouwuche:(NSInteger)num{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:uid_username forKey:@"apk_token"];
    [dict setObject:[user objectForKey:@"token"] forKey:@"token"];
    [dict setObject:[user objectForKey:@"tokenSecret"] forKey:@"tokenSecret"];
    [dict setObject:[[chanpinarr objectAtIndex:num] objectForKey:@"tagname"] forKey:@"tagname"];
    [dict setObject:@"1" forKey:@"number"];
    [dict setObject:[[chanpinarr objectAtIndex:num] objectForKey:@"id"] forKey:@"p_id"];
    [dict setObject:[[chanpinarr objectAtIndex:num] objectForKey:@"title"] forKey:@"p_title"];
    [dict setObject:[[chanpinarr objectAtIndex:num] objectForKey:@"title_img"] forKey:@"p_title_img"];
    [dict setObject:[[chanpinarr objectAtIndex:num] objectForKey:@"tagid"] forKey:@"tagid"];
    [dict setObject:[[chanpinarr objectAtIndex:num] objectForKey:@"price"] forKey:@"price"];
    
    NSLog(@"加入购物车%@",dict);
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
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user1 = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict1 = @{@"c_id":[user1 objectForKey:@"community_id"],@"p_id":[[chanpinarr objectAtIndex:num] objectForKey:@"id"],@"tagid":[[chanpinarr objectAtIndex:num] objectForKey:@"tagid"],@"num":@"1",@"token":[user1 objectForKey:@"token"],@"tokenSecret":[user1 objectForKey:@"tokenSecret"]};
    //3.发送GET请求
    NSString *strurl1 = [API stringByAppendingString:@"shop/check_shop_limit"];
    [manager1 GET:strurl1 parameters:dict1 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSString *strurl = [API stringByAppendingString:@"shop/add_shopping_cart"];
            [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failure--%@",error);
            }];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
        NSLog(@"failure--%@",error);
    }];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
    }else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            
        }else{
            circledetailsViewController *details = [[circledetailsViewController alloc] init];
            details.id = [[tieziarr objectAtIndex:indexPath.row-1] objectForKey:@"id"];
            details.is_pro = @"0";
            [self.navigationController pushViewController:details animated:YES];
        }
    }else if (indexPath.section==2)
    {
        
    }else{
        if (indexPath.row==0) {
            
        }else{
            GoodsDetailViewController *gooddetail = [[GoodsDetailViewController alloc] init];
            gooddetail.IDstring = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"id"];
            [self.navigationController pushViewController:gooddetail animated:YES];
        }
    }
}
- (void)more:(UIButton *)sender
{
    if (sender.tag==1001) {
        moreteziViewController *more = [[moreteziViewController alloc] init];
        more.c_id = [[s_url objectForKey:@"param"] objectForKey:@"c_id"];
        more.community_id = [[s_url objectForKey:@"param"] objectForKey:@"community_id"];
        [self.navigationController pushViewController:more animated:YES];
    }else{
        shangpinliebiaoViewController *liebiao = [[shangpinliebiaoViewController alloc] init];
        liebiao.id = [[p_url objectForKey:@"param"] objectForKey:@"id"];
        [self.navigationController pushViewController:liebiao animated:YES];
    }
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(Main_width - 60, ((Main_width - 60)/(2.5)) );
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    NSString *url_type = [[centeguanggaoarr objectAtIndex:subIndex] objectForKey:@"url_type"];
    NSString *url_id = [[centeguanggaoarr objectAtIndex:subIndex] objectForKey:@"url_id"];
    NSString *urltypename = [[centeguanggaoarr objectAtIndex:subIndex] objectForKey:@"type_name"];
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
        NSString *type_name = [[centeguanggaoarr objectAtIndex:subIndex] objectForKey:@"type_name"];
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
        NSString *type_name = [[centeguanggaoarr objectAtIndex:subIndex] objectForKey:@"type_name"];
        
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
    
    return centeguanggaoarr.count;
    
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
    NSString *urlstr = [API_img stringByAppendingString:[[centeguanggaoarr objectAtIndex:index] objectForKey:@"img"]];
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:urlstr]];
    //bannerView.mainImageView.image = self.newpageimageArray[index];
    NSLog(@"/在这里下载网络图片---%@----%@",urlstr,centeguanggaoarr);
    return bannerView;
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
