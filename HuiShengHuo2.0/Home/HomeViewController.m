//
//  HomeViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/16.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//
#pragma mark - ===首页===
#import "HomeViewController.h"
#import "ChangeinfomationViewController.h"
#import "QuickLookViewController.h"         //读取docx文件
#import "XiaoquViewController.h"
#import "GoodsDetailViewController.h"
#import "HalfCircleActivityIndicatorView.h"
#import <AFNetworking.h>
#import "SBCycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "acivityViewController.h"
#import "activitydetailsViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import "homedetailsViewController.h"
#import "MoreViewController.h"
#import "wuyeyanzhengViewController.h"
#import "HWPopTool.h"
#import "WebViewController.h"
#import "PrefixHeader.pch"
#import "shangpinerjiViewController.h"
#import "JKBannarView.h"
#import "weixiuViewController.h"
#import "wuyejiaofeiViewController.h"
#import "noticeViewController.h"
#import "MJRefresh.h"
#import "LoginViewController.h"
#import "youhuiquanxiangqingViewController.h"
#import "youhuiquanViewController.h"
#import "MenuButton.h"
#import "jiaofeiViewController.h"
#import "shuidianfeiViewController.h"
#import "WebViewJavascriptBridge.h"
#import "NewPagedFlowView.h"

#import "yuefunextViewController.h"
#import "xinfangshouceViewController.h"
#import "FacePayViewController.h"
#import "fangkeyaqingViewController.h"
#import "blueyaViewController.h"
#import "selectHomeViewController.h"
#import "bangdingqianViewController.h"
#import "MyhomeViewController.h"
#import "circledetailsViewController.h"
#import "jiatingzhangdanViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "jujiayanglaoViewController.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)

@interface HomeViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate,WKUIDelegate,WKNavigationDelegate,NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>
{
    UITableView *_Hometableview;
    UILabel *label3;
    UILabel *titlelabel;
    NSMutableDictionary *_Datadic;
    
    UIImageView *NoUrlimageview;
    UIButton *Againbut;
    HalfCircleActivityIndicatorView *LoadingView;
    
    UIImageView *_pop_upimageview;
    
    NSArray *_DataArrtop;
    
    NSMutableArray *_SCrollviewarr;
    
    JKBannarView *bannerView;
    
    NSDictionary *_dict;
    
    NSString *popstr;
    
    WKWebView *wkwebview;
    
    NSArray *article_listArr;
    NSArray *ad_listArr;
    BOOL YueFu;
}
/**
 *  图片数组
 */
@property (nonatomic, strong) NSArray *newpageimageArray;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *popBtn;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self checkv];
    [self loggggg];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"community_id---%@",[defaults objectForKey:@"is_new"]);
    if ([[defaults objectForKey:@"is_new"] isEqualToString:@"1"]) {
        YueFu = YES;
        [self createyuefu];
        NSLog(@"yuefu");
    }else{
        YueFu = NO;
        [self qitaxiaoqu];
        NSLog(@"qita");
    }
    [self createdaohangolan];
    [self again];
    [self CreateTableView];
    
    // Do any additional setup after loading the view.
}
- (void)selectxiaoqu
{
    XiaoquViewController *xiaoqu = [[XiaoquViewController alloc] init];
    xiaoqu.biaojistr = @"0";
    xiaoqu.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xiaoqu animated:YES];
}
- (void)createyuefu
{
    
}
- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"community_id":[user objectForKey:@"community_id"],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"site/index_40"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        ad_listArr = [NSArray array];
        article_listArr = [NSArray array];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            ad_listArr = [[responseObject objectForKey:@"data"] objectForKey:@"ad_list"];
            article_listArr = [[responseObject objectForKey:@"data"] objectForKey:@"article_list"];
        }
        [_Hometableview.mj_header endRefreshing];
        [_Hometableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)qitaxiaoqu
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushjiaofei:) name:@"pushjiaofei1" object:nil];
    //修改系统导航栏下一个界面的返回按钮title
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    self.navigationController.delegate = self;
    
    [self createnotice];
    //[self LoadingView];
//    [self post];
//    [self post1];
    
    
    [LoadingView startAnimating];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width*3/4, kScreen_Width*3/4)];
    
    _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _popBtn.frame = CGRectMake(0, 0, kScreen_Width*3/4, kScreen_Width*3/4);
    _popBtn.backgroundColor = [UIColor clearColor];
    [_popBtn addTarget:self action:@selector(closeAndBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *butpop = [[UIButton alloc] initWithFrame:CGRectMake(-100, -50, 25, 25)];
    [butpop addTarget:self action:@selector(popViewShow) forControlEvents:UIControlEventTouchUpInside];
    [butpop setImage:[UIImage imageNamed:@"iv_address"] forState:UIControlStateNormal];
    popstr = [_Datadic objectForKey:@"pop_up"];
    if (![[_Datadic objectForKey:@"pop_up"] isKindOfClass:[NSDictionary class]]) {
        NSLog(@"pop为空");
    }else{
        NSLog(@"pop不为空");
        NSUserDefaults *myUD=[NSUserDefaults standardUserDefaults];
        if(![myUD boolForKey:@"firstStart"])
        {
            [myUD setBool:YES forKey:@"firstStart"];
            [myUD synchronize];//同步community_id
            NSLog(@"首页_____第一次启动");
            [butpop sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
        }
    }
    [self.view addSubview:butpop];
}
- (void)loggggg
{
    //用户信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@==%@--%@",[defaults objectForKey:@"username"],[defaults objectForKey:@"pwd"],[defaults objectForKey:@"uid"]);
    NSString *password = [defaults objectForKey:@"pwd"];
    _dict = [[NSMutableDictionary alloc] init];
    
    if ([defaults objectForKey:@"username"]!=nil) {
        NSString *user_cookie = [defaults objectForKey:@"Cookie"];
        if (user_cookie.length==0) {
            NSLog(@"cookies为0");
            
        }
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Cookie"]];
        NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie * cookie in cookies){
            [cookieStorage setCookie: cookie];
        }
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        if (password.length>25) {
            if ([userdefaults objectForKey:@"registrationID"]==nil) {
                _dict = @{@"uid":[defaults objectForKey:@"uid"],@"phone_type":[defaults objectForKey:@"phone_type"]};
                NSLog(@"1111111---no");
            }else{
                _dict = @{@"uid":[defaults objectForKey:@"uid"],@"phone_type":[defaults objectForKey:@"phone_type"],@"phone_name":[userdefaults objectForKey:@"registrationID"]};
                NSLog(@"1111111---yes");
            }
            [self CreatePost1];
        }else{
            if ([userdefaults objectForKey:@"registrationID"]==nil) {
//                _dict = @{@"uid":[defaults objectForKey:@"uid"],@"phone_type":[defaults objectForKey:@"phone_type"]};
                _dict = @{@"username":[defaults objectForKey:@"username"],@"password":[defaults objectForKey:@"pwd"],@"phone_type":[defaults objectForKey:@"phone_type"]};
                NSLog(@"2222---no");
            }else{
                _dict = @{@"username":[defaults objectForKey:@"username"],@"password":[defaults objectForKey:@"pwd"],@"phone_name":[userdefaults objectForKey:@"registrationID"],@"phone_type":[defaults objectForKey:@"phone_type"]};
                NSLog(@"22222---yes");
            }
            [self CreatePost];
        }
    }
}
#pragma mark - 联网请求
- (void)CreatePost
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数.0
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
    //
    NSString *url=[API stringByAppendingString:@"site/login"];
    [manager POST:url parameters:_dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"登录成功");
            NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
            [userdf setObject:[[responseObject objectForKey:@"data"] objectForKey:@"is_bind_property"] forKey:@"is_bind_property"];
            [userdf synchronize];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"logsusess" object:nil userInfo:nil];
        }else{
            NSLog(@"登录失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)CreatePost1
{
    //1.创建会话管理者
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
    //
    NSString *url=[API stringByAppendingString:@"site/login_verify"];
    [manager POST:url parameters:_dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"登录成功");
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"logsusess" object:nil userInfo:nil];
        }else{
            NSLog(@"登录失败");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)checkv
{
    //获取手机程序的版本号
    NSString *ver = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"-------%@",ver);
    //获取网络该应用的版本号
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    NSString *url = [API stringByAppendingString:@"site/version_update"];
    NSDictionary *dict = @{@"type":@"2",@"version":ver};
    //POST必须上传的字段
    [mgr POST:url parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"ver---%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([status isEqualToString:@"1"]) {
            
            NSString *compel = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"compel"]];
            NSString *path = [[responseObject objectForKey:@"data"] objectForKey:@"path"];
            if ([compel isEqualToString:@"0"]) {
                UIAlertController*alert = [UIAlertController
                                           alertControllerWithTitle:@"发现新版本"
                                           message: msg
                                           preferredStyle:UIAlertControllerStyleAlert];
                UIView *subView1 = alert.view.subviews[0];
                UIView *subView2 = subView1.subviews[0];
                UIView *subView3 = subView2.subviews[0];
                UIView *subView4 = subView3.subviews[0];
                UIView *subView5 = subView4.subviews[0];
                UILabel *message = subView5.subviews[1];
                message.textAlignment = NSTextAlignmentLeft;
                [alert addAction:[UIAlertAction
                                  actionWithTitle:@"取消"
                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                  }]];
                [alert addAction:[UIAlertAction
                                  actionWithTitle:@"前往下载"
                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
                                  }]];
                //弹出提示框
                [self presentViewController:alert
                                   animated:YES completion:nil];
            }else {
                UIAlertController*alert = [UIAlertController
                                           alertControllerWithTitle:@"发现新版本"
                                           message: msg
                                           preferredStyle:UIAlertControllerStyleAlert];
                UIView *subView1 = alert.view.subviews[0];
                UIView *subView2 = subView1.subviews[0];
                UIView *subView3 = subView2.subviews[0];
                UIView *subView4 = subView3.subviews[0];
                UIView *subView5 = subView4.subviews[0];
                UILabel *message = subView5.subviews[1];
                message.textAlignment = NSTextAlignmentLeft;
                [alert addAction:[UIAlertAction
                                  actionWithTitle:@"前往下载"
                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
                                  }]];
                //弹出提示框
                [self presentViewController:alert
                                   animated:YES completion:nil];
            }
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)createdaohangolan
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    [self.navigationItem setTitleView:view];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (YueFu==YES) {
        titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, Main_width-120-35, 40)];
        titlelabel.text = [defaults objectForKey:@"community_name"];
        titlelabel.font = [UIFont systemFontOfSize:20];
        [view addSubview:titlelabel];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
        imageview.image = [UIImage imageNamed:@"yuefu_13"];
        [view addSubview:imageview];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 5, Main_width/2, 40);
        but.backgroundColor = [UIColor clearColor];
        [view addSubview:but];
        [but addTarget:self action:@selector(selectxiaoqu) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *imgarr = @[@"ic_order5",@"fangkeyaoqing",@"ic_home_bluetooth"];
        for (int i=0; i<3; i++) {
            UIButton *butthree = [[UIButton alloc] initWithFrame:CGRectMake(Main_width-(i+1)*45, 12.5, 25, 25)];
            [butthree addTarget:self action:@selector(shouyedaohanglanbut:) forControlEvents:UIControlEventTouchUpInside];
            butthree.tag = i;
            [butthree setImage:[UIImage imageNamed:[imgarr objectAtIndex:i]] forState:UIControlStateNormal];
            //[butthree sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
            [view addSubview:butthree];
        }
    }else{
        
        titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, Main_width-55-35, 40)];
        titlelabel.text = [defaults objectForKey:@"community_name"];
        titlelabel.font = [UIFont systemFontOfSize:20];
        [view addSubview:titlelabel];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
        imageview.image = [UIImage imageNamed:@"yuefu_13"];
        [view addSubview:imageview];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 5, Main_width/2, 40);
        but.backgroundColor = [UIColor clearColor];
        [view addSubview:but];
        [but addTarget:self action:@selector(selectxiaoqu) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *butthree = [[UIButton alloc] initWithFrame:CGRectMake(Main_width-25-15-5, 12.5, 25, 25)];
        [butthree addTarget:self action:@selector(shouyedaohanglanbut:) forControlEvents:UIControlEventTouchUpInside];
        butthree.tag = 0;
        [butthree setImage:[UIImage imageNamed:@"ic_order5"] forState:UIControlStateNormal];
        //[butthree sendActionsForControlEvents:UIControlEventTouchUpInside];//代码点击
        [view addSubview:butthree];
    }
}
- (void)popViewShow {
    
    
    //    看看pop效果把下面这一句加上
    [_contentView addSubview:_popBtn];
    
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];
    
    
}

- (void)closeAndBack {
    
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
            
            WebViewController *web = [[WebViewController alloc] init];
            web.hidesBottomBarWhenPushed = YES;
            web.title = @"优惠券";
            NSString *url = [[_Datadic objectForKey:@"pop_up"] objectForKey:@"link"];
            web.url = url;
            web.url_type = @"2";
            [self.navigationController pushViewController:web animated:YES];
        }];
}
- (void)createnotice
{
    NoUrlimageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-50, 100, 100)];
    NoUrlimageview.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:NoUrlimageview];
    Againbut = [UIButton buttonWithType:UIButtonTypeCustom];
    Againbut.frame = CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-20+110, 100, 40);
    [Againbut setTitle:@"重新加载" forState:UIControlStateNormal];
    [Againbut setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [Againbut addTarget:self action:@selector(again) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Againbut];
    
    NoUrlimageview.hidden = YES;
    Againbut.hidden = YES;
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
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    
    NSString *strurl = [API stringByAppendingString:@"site/index"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _Datadic = nil;
        _Datadic = [responseObject objectForKey:@"data"];
        
        _newpageimageArray = [NSArray array];
        _newpageimageArray = [_Datadic objectForKey:@"activity"];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _Hometableview.hidden = NO;
            NoUrlimageview.hidden = YES;
            Againbut.hidden = YES;
            [LoadingView stopAnimating];
            LoadingView.hidden = YES;
            
            if (![[_Datadic objectForKey:@"pop_up"] isKindOfClass:[NSDictionary class]]) {
                NSLog(@"pop为空");
            }else{
                NSLog(@"pop不为空");
                NSString *strurl = [API_img stringByAppendingString:[[_Datadic objectForKey:@"pop_up"] objectForKey:@"img"]];
                
                _pop_upimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width*3/4, kScreen_Width*3/4)];
                [_pop_upimageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                
                [_contentView addSubview:_pop_upimageview];
            }
            //_pop_upimageview.image = [UIImage imageNamed:@"alipayIcon"];
        }
        
        [self post1];
        [_Hometableview reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _Hometableview.hidden = YES;
        [LoadingView stopAnimating];
        LoadingView.hidden = YES;
        NoUrlimageview.hidden = NO;
        Againbut.hidden = NO;
        NSLog(@"failure--%@",error);
    }];
}
-(void)post1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
     NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userd objectForKey:@"uid"],[userd objectForKey:@"username"]]];
    NSString *cid = [userd objectForKey:@"community_id"];
    dict = @{@"community_id":cid,@"apk_token":uid_username,@"token":[userd objectForKey:@"token"],@"tokenSecret":[userd objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"site/get_Advertising/c_name/hc_index_top"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success11--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        NSMutableArray *imagearr = [NSMutableArray array];
        NSMutableArray *arr = [responseObject objectForKey:@"data"];
        _DataArrtop = arr;
        if ([arr isKindOfClass:[NSArray class]]) {
            for (int i=0; i<arr.count; i++) {
                NSString *strurl = [API_img stringByAppendingString:[[arr objectAtIndex:i]objectForKey:@"img"]];
                [imagearr addObject:strurl];
            }
            _SCrollviewarr=imagearr;
        }else{
            imagearr = nil;
            _SCrollviewarr = imagearr;
        }
        bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width/(1.8)) viewSize:CGSizeMake(kScreen_Width,kScreen_Width/(1.8))];
        bannerView.items = _SCrollviewarr;
        
        
        [_Hometableview.mj_header endRefreshing];
        [_Hometableview reloadData];
        
        //[_Hometableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}

- (void)again
{
    //[_Hometableview.mj_header beginRefreshing];
    //NoUrlimageview.hidden = YES;
    Againbut.hidden = YES;
    //[LoadingView startAnimating];
    
    if (YueFu==YES) {
        [self getData];//悦府首页
        
    }else{
        [self post];
        
    }
}

#pragma mark - LoadingView
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    [self.view addSubview:LoadingView];
}
//#pragma mark - 隐藏导航栏
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//
//    [super viewWillAppear:YES];
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//    [super viewWillDisappear:YES];
//
//
//}
- (void)change: (NSNotification *)notification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    titlelabel.text = [defaults objectForKey:@"community_name"];
    [_Hometableview.mj_header beginRefreshing];
    if ([[defaults objectForKey:@"is_new"] isEqualToString:@"1"]) {
        YueFu = YES;
    }else{
        YueFu = NO;
        [self post];
        
    }
    [self createdaohangolan];
    //[self CreateTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 创建TableView
- (void)CreateTableView
{
    _Hometableview = [[UITableView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, kScreen_Width, kScreen_Height-49-RECTSTATUS.size.height-44)];
    _Hometableview.delegate = self;
    _Hometableview.dataSource = self;
    _Hometableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _Hometableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(again)];
    if (YueFu == YES) {
        _Hometableview.backgroundColor = BackColor;
    }else{
        
    }
    [self.view addSubview:_Hometableview];
    [_Hometableview.mj_header beginRefreshing];
}
#pragma mark - TableView的代理方法

//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (YueFu == YES) {
        if (section==0) {
            return 4+article_listArr.count-2;
        }else{
            return 1+ad_listArr.count;
        }
    }else{
       return 8;
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (YueFu == YES) {
        return 2;
    }else{
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
    if (YueFu == YES) {
        static NSString *cellIndetifier = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
        }
        cell.contentView.backgroundColor = BackColor;
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                wkwebview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, Main_width,Main_Height*7/10)];
                wkwebview.UIDelegate = self;
                wkwebview.navigationDelegate = self;
                wkwebview.scrollView.scrollEnabled = NO;
                
                NSURL *url = [NSURL URLWithString:@"http://down.hui-shenghuo.cn/zhuanti/app/"];
                NSURLRequest *request =[NSURLRequest requestWithURL:url];
                [wkwebview loadRequest:request];
                [cell.contentView addSubview:wkwebview];
                tableView.rowHeight = wkwebview.frame.size.height;
            }else if (indexPath.row==1){
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, Main_width-30, (Main_width-30)/2)];
                imageview.layer.cornerRadius = 4;
                imageview.image = [UIImage imageNamed:@"yuefu01"];
                [cell.contentView addSubview:imageview];
                
                tableView.rowHeight = (Main_width-30)/2+20;
            }else if (indexPath.row==2){
                tableView.rowHeight = 65;
                UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width-40-70-12.5)/2, 12.5, 40, 40)];
                imageview1.image = [UIImage imageNamed:@"yuefu02"];
                [cell.contentView addSubview:imageview1];
                
                UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(imageview1.frame.origin.x+40+12.5, 22.5, 70, 25)];
                imageview2.image = [UIImage imageNamed:@"yuefu03"];
                [cell.contentView addSubview:imageview2];
            }else if (indexPath.row==3){
                for (int i=0; i<2; i++) {
                    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15+i*(Main_width/2-35/2)+5*i, 0, Main_width/2-35/2, 150)];
                    backview.backgroundColor = [UIColor whiteColor];
                    [cell.contentView addSubview:backview];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
                    NSString *urlstr = [API_img stringByAppendingString:[[article_listArr objectAtIndex:i] objectForKey:@"article_image"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString:urlstr]];
                    [backview addSubview:imageview];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, imageview.frame.origin.y+imageview.frame.size.height+10, (Main_width-60)/2, 25)];
                    NSString *article1 = [[article_listArr objectAtIndex:i] objectForKey:@"title"];
                    label.text = article1;
                    [label setFont:nomalfont];
                    [backview addSubview:label];
                    
                    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, label.frame.origin.y+label.frame.size.height+12.5, (Main_width-60)/2, 50)];
                    NSString *article = [[article_listArr objectAtIndex:i] objectForKey:@"content_"];
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[article dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                    label1.attributedText = attributedString;
                    label1.numberOfLines = 2;
                    [label1 setFont:font15];
                    label1.alpha = 0.5;
                    [backview addSubview:label1];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(15+i*(Main_width/2-35/2)+5*i, 0, Main_width/2-35/2, 150);
                    but.tag=  i;
                    [but addTarget:self action:@selector(guiyuexieyi:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:but];
                }
                tableView.rowHeight = 150;
            } else {
                tableView.rowHeight = 55+8;
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 8, Main_width-30, 55)];
                view.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:view];
                NSString *urlstr = [API_img stringByAppendingString:[[article_listArr objectAtIndex:indexPath.row-2] objectForKey:@"article_image"]];
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 25, 25)];
                [imageview sd_setImageWithURL:[NSURL URLWithString:urlstr]];
                [view addSubview:imageview];
                
                NSString *article = [[article_listArr objectAtIndex:indexPath.row-2] objectForKey:@"title"];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15+25+10, 0, Main_width-30, 55)];
                label.text = [NSString stringWithFormat:@"%@",article];
                [label setFont:nomalfont];
                [view addSubview:label];
            }
        }else {
            if (indexPath.row==0) {
                tableView.rowHeight = 65;
                UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width-40-70-12.5)/2, 12.5, 40, 40)];
                imageview1.image = [UIImage imageNamed:@"yuefu05"];
                [cell.contentView addSubview:imageview1];
                
                UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(imageview1.frame.origin.x+40+12.5, 22.5, 70, 25)];
                imageview2.image = [UIImage imageNamed:@"yuefu06"];
                [cell.contentView addSubview:imageview2];
            }else{
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, kScreen_Width-30, (kScreen_Width-30)/2.2)];
                NSString *strurl = [API_img stringByAppendingString:[[ad_listArr objectAtIndex:indexPath.row-1] objectForKey:@"img"]];
                [imageview sd_setImageWithURL:[NSURL URLWithString: strurl] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
                [cell.contentView addSubview:imageview];
                UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:imageview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.frame = imageview.bounds;
                maskLayer.path = bezierPath.CGPath;
                imageview.layer.mask = maskLayer;
                
                tableView.rowHeight = (kScreen_Width-30)/2.2+10;
            }
        }
        
        return cell;
    }else{
        UILabel *label1 = nil;
        UILabel *label2 = nil;
        static NSString *cellIndetifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
            label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 40)];
            label2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4+10, 10, self.view.frame.size.width/4*3-5, 40)];
            label3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, 40)];
            label3.tag = 100;
            [cell.contentView addSubview:label1];
            [cell.contentView addSubview:label2];
            [cell.contentView addSubview:label3];
            
            
        }
        
        if (indexPath.row%2==0) {
            tableView.rowHeight = 50;
        }if (indexPath.row==0) {
            
            tableView.rowHeight = 0;
        }if (indexPath.row==2) {
            //cell.backgroundColor = HColor(244, 247, 248);
            tableView.rowHeight = 0;
            
        }if (indexPath.row==4) {
            NSArray *activityarr = nil;
            activityarr = [_Datadic objectForKey:@"activity"];
            if (![activityarr isKindOfClass:[NSArray class]]) {
                tableView.rowHeight = 0;
            }else{
                label1.text = @"精选服务";
                label1.font = [UIFont systemFontOfSize:18];
                label1.textAlignment = NSTextAlignmentCenter;
                //cell.backgroundColor = HColor(244, 247, 248) ;
            }
        }if (indexPath.row==6) {
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"精选商品"];
            
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"icon_shop_right"];
            attch.bounds = CGRectMake(0, -2.5, 20, 20);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:4];
            label1.attributedText = attri;
            label1.textAlignment = NSTextAlignmentCenter;
            label1.font = [UIFont systemFontOfSize:18];
            tableView.rowHeight = 50;
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(0, 0, kScreen_Width, 50);
            [but addTarget:self action:@selector(pusherji) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
        }if (indexPath.row==1) {
            NSLog(@"---------------------------------%@",_SCrollviewarr);
            if ([_DataArrtop isKindOfClass:[NSArray class]]) {
                [cell.contentView addSubview:bannerView];
                
                [bannerView imageViewClick:^(JKBannarView * _Nonnull barnerview, NSInteger index) {
                    NSLog(@"点击图片%ld",index);
                    NSString *url_type = [[_DataArrtop objectAtIndex:index] objectForKey:@"url_type"];
                    NSString *url_id = [[_DataArrtop objectAtIndex:index] objectForKey:@"id"];
                    NSString *urltypename = [[_DataArrtop objectAtIndex:index] objectForKey:@"type_name"];
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
                        NSString *type_name = [[_DataArrtop objectAtIndex:index] objectForKey:@"type_name"];
                        NSRange range = [type_name rangeOfString:@"id/"]; //现获取要截取的字符串位置
                        NSString * result = [type_name substringFromIndex:range.location+3]; //截取字符串
                        erji.id = result;
                        erji.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:erji animated:YES];
                    }if ([url_type isEqualToString:@"6"]) {
                        //优惠券
                        NSString *type_name = [[_DataArrtop objectAtIndex:index] objectForKey:@"type_name"];
                        
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
                tableView.rowHeight = kScreen_Width/(1.8);
            }else{
                tableView.rowHeight = 0;
            }
        }if (indexPath.row==3) {
            
            NSDictionary *workDic = nil;
            workDic = [_Datadic objectForKey:@"work"];
            
            
            
            
            NSDictionary *noticedic = [workDic objectForKey:@"notice"];
            if ([noticedic isKindOfClass:[NSDictionary class]]) {
                
                UIView *twobutview = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width-20, 80)];
                [cell.contentView addSubview:twobutview];
                NSArray *imagearr = @[@"wuyejiaofei",@"servicep"];
                NSArray *arr1 = @[@" 物业缴费",@" 维修"];
                for (int i=0; i<2; i++) {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*(kScreen_Width/2-10),  0, (kScreen_Width/2-10), 80)];
                    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:[arr1 objectAtIndex:i          ]];
                    label.font = [UIFont systemFontOfSize:20];
                    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                    attch.image = [UIImage imageNamed:[imagearr objectAtIndex:i]];
                    attch.bounds = CGRectMake(0, -5, 30, 30);
                    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                    [attri insertAttributedString:string atIndex:0];
                    label.attributedText = attri;
                    label.textAlignment = NSTextAlignmentCenter;
                    [twobutview addSubview:label];
                    
                    
                    UIButton *clickbut = [UIButton buttonWithType:UIButtonTypeCustom];
                    clickbut.frame = CGRectMake(i*(kScreen_Width-20)/2, 0, (kScreen_Width-20)/2, 80);
                    clickbut.backgroundColor = [UIColor clearColor];
                    clickbut.tag = i;
                    [clickbut addTarget:self action:@selector(qujiaofei:) forControlEvents:UIControlEventTouchUpInside];
                    [twobutview addSubview:clickbut];
                }
                
                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreen_Width, 10)];
                lineview.backgroundColor = HColor(244, 247, 248);
                [cell.contentView addSubview:lineview];
                UIView *noticeview = [[UIView alloc] initWithFrame:CGRectMake(10, 90, kScreen_Width-20, 90)];
                [cell.contentView addSubview:noticeview];
                UILabel *titlelabe = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, kScreen_Width/2-20, 20)];
                titlelabe.text = [[workDic objectForKey:@"notice"] objectForKey:@"title"];
                titlelabe.font = [UIFont systemFontOfSize:20];
                [noticeview addSubview:titlelabe];
                UILabel *datalabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2-20, 5, kScreen_Width/2-20-5, 20)];
                datalabel.text = [[workDic objectForKey:@"notice"] objectForKey:@"addtime"];
                datalabel.textAlignment = NSTextAlignmentRight;
                datalabel.font = [UIFont systemFontOfSize:15];
                [noticeview addSubview:datalabel];
                UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kScreen_Width-20, 50)];
                contentlabel.numberOfLines = 2;
                contentlabel.text = [[workDic objectForKey:@"notice"] objectForKey:@"content"];
                contentlabel.font = [UIFont systemFontOfSize:15];
                contentlabel.alpha = 0.5;
                [noticeview addSubview:contentlabel];
                
                UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 180, kScreen_Width, 10)];
                lineview1.backgroundColor = HColor(244, 247, 248);
                [cell.contentView addSubview:lineview1];
                
                UIButton *noticebut = [UIButton buttonWithType:UIButtonTypeCustom];
                noticebut.frame = CGRectMake(0, 0, kScreen_Width-20, 90);
                [noticebut addTarget:self action:@selector(noticepush) forControlEvents:UIControlEventTouchUpInside];
                [noticeview addSubview:noticebut];
                tableView.rowHeight=180;
            }else{
                UIView *twobutview = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width-20, 80)];
                [cell.contentView addSubview:twobutview];
                NSArray *imagearr = @[@"wuyejiaofei",@"servicep"];
                NSArray *arr1 = @[@" 物业缴费",@" 维修"];
                for (int i=0; i<2; i++) {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*(kScreen_Width/2-10),  0, (kScreen_Width/2-10), 80)];
                    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:[arr1 objectAtIndex:i          ]];
                    label.font = [UIFont systemFontOfSize:20];
                    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                    attch.image = [UIImage imageNamed:[imagearr objectAtIndex:i]];
                    attch.bounds = CGRectMake(0, -5, 30, 30);
                    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                    [attri insertAttributedString:string atIndex:0];
                    label.attributedText = attri;
                    label.textAlignment = NSTextAlignmentCenter;
                    [twobutview addSubview:label];
                    
                    
                    UIButton *clickbut = [UIButton buttonWithType:UIButtonTypeCustom];
                    clickbut.frame = CGRectMake(i*(kScreen_Width-20)/2, 0, (kScreen_Width-20)/2, 80);
                    clickbut.backgroundColor = [UIColor clearColor];
                    clickbut.tag = i;
                    [clickbut addTarget:self action:@selector(qujiaofei:) forControlEvents:UIControlEventTouchUpInside];
                    [twobutview addSubview:clickbut];
                }
                
                tableView.rowHeight=80;
            }
            
            
        }if (indexPath.row==5) {
            NSArray *activityarr = nil;
            activityarr = [_Datadic objectForKey:@"activity"];
            if (![activityarr isKindOfClass:[NSArray class]]) {
                tableView.rowHeight = 0;
            }else{
                //cell.backgroundColor = HColor(244, 247, 248);
                tableView.rowHeight = (kScreen_Width-60)/(2.5)+5;
                
                
                self.automaticallyAdjustsScrollViewInsets = NO;
                
                NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0, Main_width, (Main_width)/(2.5))];
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
                
                
//                UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (kScreen_Width-20)/(2.5)+50)];
//                _scrollView.delegate = self;//设置代理
//                [_scrollView setContentSize:CGSizeMake((self.view.frame.size.width)*activityarr.count, _scrollView.bounds.size.height)];
//                _scrollView.showsHorizontalScrollIndicator = NO;
//                _scrollView.pagingEnabled = YES;
//                [cell.contentView addSubview:_scrollView];
//                for (int i=0; i<activityarr.count; i++) {
//                    UIView *acticityview = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width)*i+10, 0, self.view.frame.size.width-20, (kScreen_Width-20)/(2.5)+40)];
//                    // 设置圆角的大小
//                    acticityview.layer.cornerRadius = 5;
//                    [acticityview.layer setMasksToBounds:YES];
//                    [_scrollView addSubview:acticityview];
//                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, (kScreen_Width-20)/(2.5))];
//                    NSString *strurl = [API stringByAppendingString:[[activityarr objectAtIndex:i] objectForKey:@"picture"]];
//                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
//                    [acticityview addSubview:imageview];
//
//                    UILabel *labeltitle = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreen_Width-20)/(2.5), kScreen_Width-20, 40)];
//                    labeltitle.text = [[activityarr objectAtIndex:i] objectForKey:@"title"];
//                    labeltitle.textAlignment = NSTextAlignmentCenter;
//                    labeltitle.backgroundColor = [UIColor whiteColor];
//                    [acticityview addSubview:labeltitle];
//
//                    UIButton *canyubut = [UIButton buttonWithType:UIButtonTypeCustom];
//                    canyubut.frame = CGRectMake(0, 0, kScreen_Width, (kScreen_Width-20)/(2.5)+40);
//                    [canyubut addTarget:self action:@selector(activtydetails:) forControlEvents:UIControlEventTouchUpInside];
//                    canyubut.tag = [[[activityarr objectAtIndex:i] objectForKey:@"id"] integerValue];
//                    [acticityview addSubview:canyubut];
//                }
            }
        }if (indexPath.row==7) {
            NSArray *shoparr = [[NSArray alloc] init];
            shoparr = [_Datadic objectForKey:@"shop"];
            for (int i=0; i<shoparr.count; i++) {
                if (i%3==0) {
                    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 5+(kScreen_Width-30-14)/3*(i/3)*2, (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3)];
                    backview.backgroundColor = HColor(244, 247, 248);
                    [cell.contentView addSubview:backview];
                    
                    UIView *backview1 = [[UIView alloc] initWithFrame:CGRectMake(15, 5+(kScreen_Width-30-14)/3*(i/3)*2+(kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3)];
                    backview1.backgroundColor = [UIColor whiteColor];
                    [cell.contentView addSubview:backview1];
                    
                    
                    UILabel *labelname = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (kScreen_Width-30-14)/3-20, 0)];
                    labelname.text = [[shoparr objectAtIndex:i] objectForKey:@"title"];
                    labelname.font = [UIFont systemFontOfSize:15];
                    labelname.numberOfLines = 2;
                    CGSize size = [labelname sizeThatFits:CGSizeMake(labelname.frame.size.width, MAXFLOAT)];
                    labelname.frame = CGRectMake(labelname.frame.origin.x, labelname.frame.origin.y, labelname.frame.size.width,            size.height);
                    [backview1 addSubview:labelname];
                    
                    UILabel *labelpreice = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+5+size.height, (kScreen_Width-30-14)/3-20, 20)];
                    labelpreice.text = [NSString stringWithFormat:@"¥%@",[[shoparr objectAtIndex:i] objectForKey:@"min_price"]];
                    labelpreice.textColor = [UIColor redColor];
                    labelpreice.font = [UIFont systemFontOfSize:18];
                    [backview1 addSubview:labelpreice];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, (kScreen_Width-30-14)/3-20, (kScreen_Width-30-14)/3-20)];
                    
                    NSString *strurl = [API_img stringByAppendingString:[[shoparr objectAtIndex:i] objectForKey:@"title_img"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [backview addSubview:imageview];
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(15, 5+(kScreen_Width-30-14)/3*(i/3)*2, (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3*2);
                    but.tag = [[[shoparr objectAtIndex:i] objectForKey:@"id"] integerValue];
                    but.backgroundColor = [UIColor clearColor];
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
                    labelname.text = [[shoparr objectAtIndex:i] objectForKey:@"title"];
                    labelname.font = [UIFont systemFontOfSize:15];
                    labelname.numberOfLines = 2;
                    CGSize size = [labelname sizeThatFits:CGSizeMake(labelname.frame.size.width, MAXFLOAT)];
                    labelname.frame = CGRectMake(labelname.frame.origin.x, labelname.frame.origin.y, labelname.frame.size.width,            size.height);
                    [backview1 addSubview:labelname];
                    
                    UILabel *labelpreice = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+5+size.height, (kScreen_Width-30-14)/3-20, 20)];
                    labelpreice.text = [NSString stringWithFormat:@"¥%@",[[shoparr objectAtIndex:i] objectForKey:@"min_price"]];
                    labelpreice.textColor = [UIColor redColor];
                    labelpreice.font = [UIFont systemFontOfSize:18];
                    [backview1 addSubview:labelpreice];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, (kScreen_Width-30-14)/3-20, (kScreen_Width-30-14)/3-20)];
                    
                    NSString *strurl = [API_img stringByAppendingString:[[shoparr objectAtIndex:i] objectForKey:@"title_img"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [backview addSubview:imageview];
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(15+(kScreen_Width-30-14)/3+7, 5+(kScreen_Width-30-14)/3*2*(i/3), (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3*2);
                    but.tag = [[[shoparr objectAtIndex:i] objectForKey:@"id"] integerValue];
                    but.backgroundColor = [UIColor clearColor];
                    [but addTarget:self action:@selector(GoodsDetail:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:but];
                }else{
                    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15+(kScreen_Width-30-14)/3*2+14, 5+(kScreen_Width-30-14)/3*2*(i/3), (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3)];
                    backview.backgroundColor = HColor(244, 247, 248);
                    [cell.contentView addSubview:backview];
                    
                    UIView *backview1 = [[UIView alloc] initWithFrame:CGRectMake(15+(kScreen_Width-30-14)/3*2+14, 5+(kScreen_Width-30-14)/3*2*(i/3)+(kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3)];
                    backview1.backgroundColor = [UIColor whiteColor];
                    [cell.contentView addSubview:backview1];
                    
                    
                    UILabel *labelname = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (kScreen_Width-30-14)/3-20, 0)];
                    labelname.text = [[shoparr objectAtIndex:i] objectForKey:@"title"];
                    labelname.font = [UIFont systemFontOfSize:15];
                    labelname.numberOfLines = 2;
                    CGSize size = [labelname sizeThatFits:CGSizeMake(labelname.frame.size.width, MAXFLOAT)];
                    labelname.frame = CGRectMake(labelname.frame.origin.x, labelname.frame.origin.y, labelname.frame.size.width,            size.height);
                    [backview1 addSubview:labelname];
                    
                    UILabel *labelpreice = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+5+size.height, (kScreen_Width-30-14)/3-20, 20)];
                    labelpreice.text = [NSString stringWithFormat:@"¥%@",[[shoparr objectAtIndex:i] objectForKey:@"min_price"]];
                    labelpreice.textColor = [UIColor redColor];
                    labelpreice.font = [UIFont systemFontOfSize:18];
                    [backview1 addSubview:labelpreice];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, (kScreen_Width-30-14)/3-20, (kScreen_Width-30-14)/3-20)];
                    
                    NSString *strurl = [API_img stringByAppendingString:[[shoparr objectAtIndex:i] objectForKey:@"title_img"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [backview addSubview:imageview];
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(15+(kScreen_Width-30-14)/3*2+14, 5+(kScreen_Width-30-14)/3*2*(i/3), (kScreen_Width-30-14)/3, (kScreen_Width-30-14)/3*2);
                    but.tag = [[[shoparr objectAtIndex:i] objectForKey:@"id"] integerValue];
                    [but addTarget:self action:@selector(GoodsDetail:) forControlEvents:UIControlEventTouchUpInside];
                    but.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:but];
                }
            }
            tableView.rowHeight = 10+(kScreen_Width-30-14)/3*((shoparr.count+2)/3)*2;
        }
        return cell;
    }
}
- (void)guiyuexieyi: (UIButton *)sender
{
    yuefunextViewController *yuefunext = [[yuefunextViewController alloc] init];
    yuefunext.hidesBottomBarWhenPushed = YES;
    yuefunext.title = [[article_listArr objectAtIndex:sender.tag] objectForKey:@"title"];
    yuefunext.content = [[article_listArr objectAtIndex:sender.tag] objectForKey:@"content"];
    [self.navigationController pushViewController:yuefunext animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (YueFu == YES) {
        if (indexPath.section==0) {
            if (indexPath.row==1) {
                xinfangshouceViewController *xinfang = [[xinfangshouceViewController alloc] init];
                xinfang.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:xinfang animated:YES];
            }if (indexPath.row>3) {
                yuefunextViewController *yuefunext = [[yuefunextViewController alloc] init];
                yuefunext.hidesBottomBarWhenPushed = YES;
                yuefunext.title = [[article_listArr objectAtIndex:indexPath.row-2] objectForKey:@"title"];
                yuefunext.content = [[article_listArr objectAtIndex:indexPath.row-2] objectForKey:@"content"];
                [self.navigationController pushViewController:yuefunext animated:YES];
            }
        }else if (indexPath.section==1){
            if (indexPath.row>0) {
                NSString *url_type = [[ad_listArr objectAtIndex:indexPath.row-1] objectForKey:@"url_type"];
                NSString *url_id = [[ad_listArr objectAtIndex:indexPath.row-1] objectForKey:@"id"];
                NSString *urltypename = [[ad_listArr objectAtIndex:indexPath.row-1] objectForKey:@"type_name"];
                if ([url_type isEqualToString:@"5"]) {
                    weixiuViewController *weixiu = [[weixiuViewController alloc] init];
                    weixiu.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:weixiu animated:YES];
                }if ([url_type isEqualToString:@"3"]) {
                    acivityViewController *aciti = [[acivityViewController alloc] init];
                    aciti.hidesBottomBarWhenPushed = YES;
                    aciti.url = [[ad_listArr objectAtIndex:indexPath.row-1] objectForKey:@"type_name"];
                    [self.navigationController pushViewController:aciti animated:YES];
                }if ([url_type isEqualToString:@"4"]) {
                    activitydetailsViewController *acti = [[activitydetailsViewController alloc] init];
                    acti.url = [[ad_listArr objectAtIndex:indexPath.row-1] objectForKey:@"type_name"];
                    acti.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:acti animated:YES];
                }if ([url_type isEqualToString:@"7"]) {
                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",url_id];
                    UIWebView *callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebview];
                }if ([url_type isEqualToString:@"1"]) {
                    shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
                    NSString *type_name = [[ad_listArr objectAtIndex:indexPath.row-1] objectForKey:@"type_name"];
                    NSRange range = [type_name rangeOfString:@"id/"]; //现获取要截取的字符串位置
                    NSString * result = [type_name substringFromIndex:range.location+3]; //截取字符串
                    erji.id = result;
                    erji.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:erji animated:YES];
                }if ([url_type isEqualToString:@"6"]) {
                    //优惠券
                    NSString *type_name = [[ad_listArr objectAtIndex:indexPath.row-1] objectForKey:@"type_name"];
                    
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
            }
        }
    }else{
        
    }
}
- (void)pusherji
{
    shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
    erji.hidesBottomBarWhenPushed = YES;
    erji.rokou = @"2";
    [self.navigationController pushViewController:erji animated:YES];
}
- (void)noticepush
{
    circledetailsViewController *notice = [[circledetailsViewController alloc] init];
    notice.hidesBottomBarWhenPushed = YES;
    notice.id = [[[_Datadic objectForKey:@"work"] objectForKey:@"notice"] objectForKey:@"id"];
    [self.navigationController pushViewController:notice animated:YES];
}
- (void)chakanxingqing
{
    homedetailsViewController *homedetails = [[homedetailsViewController alloc] init];
    homedetails.hidesBottomBarWhenPushed = YES;
    homedetails.title = @"华晟物业";
    
    [self.navigationController pushViewController:homedetails animated:YES];
}
- (void)pushjiaofei:(NSNotification *)user
{
    NSString *jiaofeiid = [user.userInfo objectForKey:@"jiaofeiid"];
    if ([jiaofeiid isEqualToString:@"9999999"]) {
        wuyejiaofeiViewController *jiaofei = [[wuyejiaofeiViewController alloc] init];
        jiaofei.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jiaofei animated:YES];
    }if ([jiaofeiid isEqualToString:@"5030"]){
        shuidianfeiViewController *shudian = [[shuidianfeiViewController alloc] init];
        shudian.title = @"水费";
        shudian.biaoshi = @"shui";
        shudian.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shudian animated:YES];
    }if ([jiaofeiid isEqualToString:@"5031"]){
        shuidianfeiViewController *shudian = [[shuidianfeiViewController alloc] init];
        shudian.title = @"电费";
        shudian.biaoshi = @"dian";
        shudian.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shudian animated:YES];
    }
}
- (void)qujiaofei: (UIButton *)sender
{
    if (sender.tag==0) {
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSString *is_bind_property = [userdefaults objectForKey:@"is_bind_property"];
        NSString *str = [userdefaults objectForKey:@"token"];
        if (str==nil) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }else{
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
                        selecthome.rukoubiaoshi = @"jiatingzhangdan";
                        
                        selecthome.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:selecthome animated:YES];
                    }else{
                        jiatingzhangdanViewController *myhome = [[jiatingzhangdanViewController alloc] init];
                        myhome.room_id = [[arrrrr objectAtIndex:0] objectForKey:@"room_id"];
                        myhome.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:myhome animated:YES];
                    }
                    [defaults setObject:@"2" forKey:@"is_bind_property"];
                    [userdefaults synchronize];
                }else{
                    bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
                    bangding.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:bangding animated:YES];
                    [defaults setObject:@"1" forKey:@"is_bind_property"];
                    [userdefaults synchronize];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failure--%@",error);
            }];
        }
    }else if (sender.tag==1){
        jujiayanglaoViewController *jujia = [[jujiayanglaoViewController alloc] init];
        jujia.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jujia animated:YES];
    }
}
//- (void)activtydetails: (UIButton *)but
//{
//    activitydetailsViewController *acdetails = [[activitydetailsViewController alloc] init];
//    acdetails.hidesBottomBarWhenPushed = YES;
//    acdetails.url = [NSString stringWithFormat:@"activity/activity_details/id/%ld",but.tag];
//    [self.navigationController pushViewController:acdetails animated:YES];
//}

- (void)GoodsDetail:(UIButton *)sender
{
    GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
    goods.IDstring = [NSString stringWithFormat:@"%ld",sender.tag];
    goods.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goods animated:YES];
}
//- (void)selectxiaoqu
//{
//    XiaoquViewController *xiaoqu = [[XiaoquViewController alloc] init];
//    xiaoqu.biaojistr = @"0";
//    xiaoqu.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:xiaoqu animated:YES];
//}
- (void)shouyedaohanglanbut:(UIButton *)sender
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *is_bind_property = [userdefaults objectForKey:@"is_bind_property"];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        if (sender.tag==0) {
            
            FacePayViewController *facepay = [[FacePayViewController alloc] init];
            facepay.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:facepay animated:YES];
        }if (sender.tag==1) {
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
                        selecthome.rukoubiaoshi = @"fangkeyaoqing";
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
                                    fangkeyaqingViewController *fangkeyaoqing = [[fangkeyaqingViewController alloc] init];
                                    fangkeyaoqing.hidesBottomBarWhenPushed = YES;
                                    fangkeyaoqing.Dic = dicccc;
                                    [self.navigationController pushViewController:fangkeyaoqing animated:YES];
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
                    [userdefaults synchronize];
                }else{
                    bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
                    bangding.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:bangding animated:YES];
                    [defaults setObject:@"1" forKey:@"is_bind_property"];
                    [userdefaults synchronize];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failure--%@",error);
            }];
        }if (sender.tag==2) {
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
        }
    }
}





#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(Main_width - 60, ((Main_width - 60)/(2.5)) );
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    
    NSString *id = [[_newpageimageArray objectAtIndex:subIndex] objectForKey:@"id"];
    activitydetailsViewController *acdetails = [[activitydetailsViewController alloc] init];
    acdetails.hidesBottomBarWhenPushed = YES;
    acdetails.url = [NSString stringWithFormat:@"activity/activity_details/id/%@",id];
    [self.navigationController pushViewController:acdetails animated:YES];
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.newpageimageArray.count;
    
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
    NSString *urlstr = [API_img stringByAppendingString:[[_newpageimageArray objectAtIndex:index] objectForKey:@"picture"]];
      [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:urlstr]];
    //bannerView.mainImageView.image = self.newpageimageArray[index];
    NSLog(@"/在这里下载网络图片---%@----%@",urlstr,_newpageimageArray);
    return bannerView;
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
