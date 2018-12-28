//
//  newhomeViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/6/2.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newhomeViewController.h"
#import "xianshiqianggouViewController.h"
#import "WRNavigationBar.h"
#import "WRImageHelper.h"
#import "MJRefresh.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "HWPopTool.h"
#import "JKBannarView.h"
#import "PYSearch.h"
#import "searchreslutsViewController.h"
#import "GouwucheViewController.h"
#import "XiaoquViewController.h"
#import "MenuScrollView.h"
#import "CustomerScrollViewModel.h"
#import "GSKeyChainDataManager.h"
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
#import "shangpinliebiaoViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import "yuefunextViewController.h"
#import "LoginViewController.h"
#import "selectxiaoquViewController.h"
#import "afteryanzhengViewController.h"
#import "huodongwebviewViewController.h"
#import "serviceDetailViewController.h"
#import <UIKit/UIKit.h>
#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 0
#define SCROLL_DOWN_LIMIT 70
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#import "XLsn0wTextCarousel.h"
#import "DataSourceModel.h"

#import "afteryanzhengViewController.h"//物业缴费
#import "ziyongliebiaoViewController.h"//家用报修
#import "gonggongbaoxiuViewController.h"//公共报修
#import "zuFangViewController.h"//租房
#import "shouFangViewController.h"//售房
#import "zushouweituoViewController.h"//发布租售
#import "zuFangDetailViewController.h"
#import "shouFangDetailViewController.h"
@interface newhomeViewController ()<UITableViewDelegate,UITableViewDataSource,MenuScrollViewDeleagte,TextInfoViewDelegate>
{
    NSArray *topArr;
    NSDictionary *dataDic;
    NSDictionary *tieziDic;
    NSArray *centerguanggaoarr;
    NSArray *chanpinarr;
    NSArray *muluarr;
    NSArray *xieyiarr;
    NSArray *gongGaoArr;
    NSArray *housesList;
    JKBannarView *bannerView;
    
    UILabel *titlelabel;
    
    NSInteger _row;
    NSInteger _col;
    
    NSDictionary *_dict;
    CGFloat height;
    
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) MenuScrollView * menuScrollView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;


@end

@implementation newhomeViewController
   
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self checkv];
    [self setupNavItems];
//    [self getData];
    [self createui];
    
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; //清除角标//以上方法在任何地方均可调用，根据自己的需要设定即可。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changetitle" object:nil];
    // Do any additional setup after loading the view.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < IMAGE_HEIGHT) {
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
        //[self.searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
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
- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
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
        //        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Cookie"]];
        //        NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        //        for (NSHTTPCookie * cookie in cookies){
        //            [cookieStorage setCookie: cookie];
        //        }
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
        
        if ([status isEqualToString:@"1"]) {
            
            NSString *compel = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"compel"]];
            NSString *path = [[responseObject objectForKey:@"data"] objectForKey:@"path"];
            if ([compel isEqualToString:@"0"]) {
                [self creategengxinview:@"0" : [[responseObject objectForKey:@"data"] objectForKey:@"mgs"]:[[responseObject objectForKey:@"data"] objectForKey:@"version"]:path];
            }else {
                [self creategengxinview:@"1" : [[responseObject objectForKey:@"data"] objectForKey:@"mgs"]:[[responseObject objectForKey:@"data"] objectForKey:@"version"]:path];
            }
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)creategengxinview :(NSString *)compels :(NSString *)msage :(NSString *)ver :(NSString *)path
{
    NSLog(@"%@%@%@",compels,msage,ver);
    
    UIView *shandowview = [[UIView alloc] initWithFrame:self.view.frame];
    [[HWPopTool sharedInstance] showWithPresentView:shandowview animated:YES];
    
    UIView *alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width-100, Main_Height-250)];
    alertview.center = self.view.center;
    alertview.layer.cornerRadius = 5;
    alertview.backgroundColor = [UIColor clearColor];
    [shandowview addSubview:alertview];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertview.frame.size.width, alertview.frame.size.width/1.7)];
    imageview1.image = [UIImage imageNamed:@"icon_update_top"];
    [alertview addSubview:imageview1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageview1.frame.size.height/2, imageview1.frame.size.width, 20)];
    label1.text = @"发现新版本";
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:17];
    [imageview1 addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageview1.frame.size.height/2+20+10, imageview1.frame.size.width, 20)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.font = nomalfont;
    label2.text = [NSString stringWithFormat:@"版本号:%@",ver];
    [imageview1 addSubview:label2];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, alertview.frame.size.height-alertview.frame.size.width/4.4, alertview.frame.size.width, alertview.frame.size.width/4.4)];
    imageview2.image = [UIImage imageNamed:@"icon_update_bottom"];
    imageview2.userInteractionEnabled = YES;
    [alertview addSubview:imageview2];
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, imageview1.frame.size.height, alertview.frame.size.width, alertview.frame.size.height-alertview.frame.size.width/4.4-alertview.frame.size.width/1.7)];
    scrollview.backgroundColor = [UIColor whiteColor];
    [alertview addSubview:scrollview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, alertview.frame.size.width-30, 0)];
    
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:8];
    
    NSString  *testString = msage;
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    // 设置Label要显示的text
    [label  setAttributedText:setString];
    label.alpha = 0.7;
    label.numberOfLines = 0;
    label.font = font15;
    CGSize size = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width,  size.height);
    [scrollview addSubview:label];
    
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width, label.frame.size.height+40);
    
    
    if ([compels isEqualToString:@"0"]) {
        NSArray *arr = @[@"残忍拒绝",@"立即更新"];
        for (int i=0; i<2; i++) {
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(i*imageview2.frame.size.width/2, imageview2.frame.size.height-60, imageview2.frame.size.width/2, 60);
            [imageview2 addSubview:but];
            but.titleLabel.font = font15;
            [but setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
            [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            but.tag = i;
            [but addTarget:self action:@selector(butclick:)forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, imageview2.frame.size.height-60, imageview2.frame.size.width, 60);
        [imageview2 addSubview:but];
        [but setTitle:@"立即更新" forState:UIControlStateNormal];
        but.tag = 1;
        but.titleLabel.font = font15;
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(butclick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)butclick:(UIButton *)sender
{
    if (sender.tag==0) {
        NSLog(@"0000000");
        [[HWPopTool sharedInstance] closeWithBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        NSLog(@"11111111");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1205914187?mt=8"]];
    }
}
- (void)createui
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height-49-LCL_HomeIndicator_Height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.backgroundColor = BackColor;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    //_TabelView.enablePlaceHolderView = YES;
   
    self.tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - [self navBarBottom], 0, 0, 0);
    [self.view addSubview:_tableView];
    
    WS(ws);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.tableView.mj_footer endRefreshing];
        [ws getData];
        
    }];
     _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    [self.tableView.mj_header beginRefreshing];
}
- (void)xiala
{
    [self getData];
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
     */
    NSLog(@"dict = %@",dict);
    NSString *strurl = [API stringByAppendingString:@"index/index"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
         [_tableView.mj_header endRefreshing];
//        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            dataDic = [[NSDictionary alloc] init];
            dataDic = [responseObject objectForKey:@"data"];
            xieyiarr = [NSArray array];
            xieyiarr = [dataDic objectForKey:@"article_list"];
            tieziDic = [NSDictionary dictionary];
            tieziDic = dataDic[@"social_list"];
            chanpinarr = [NSArray array];
            chanpinarr = [dataDic objectForKey:@"pro_list"];
            gongGaoArr = [NSArray array];
            gongGaoArr = [dataDic objectForKey:@"p_social_list"];
            topArr = [NSArray array];
            topArr = [dataDic objectForKey:@"ad_top_list"];
            centerguanggaoarr = [NSArray array];
            centerguanggaoarr = [dataDic objectForKey:@"ad_center_list"];
            bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 0, Main_width, Main_width/2.5) viewSize:CGSizeMake(Main_width,Main_width/2.5)];
            NSMutableArray *imagearr = [NSMutableArray arrayWithCapacity:0];
            if ([topArr isKindOfClass:[NSArray class]]) {
                for (int i=0; i<topArr.count; i++) {
                    NSString *url = [API_img stringByAppendingString:[[topArr objectAtIndex:i]objectForKey:@"img"]];
                    NSLog(@"%@",url);
                    [imagearr addObject:url];
                    bannerView.items = imagearr;
                }
            }
            WBLog(@"2222222");
            housesList = [NSArray array];
            housesList = [dataDic objectForKey:@"houses_list"];
            muluarr = [NSArray array];
            muluarr = [dataDic objectForKey:@"menu_list"];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
//        [self createui];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
        NSLog(@"failure--%@",error);
    }];
}
//-(MenuScrollView *)menuScrollView{
//    if (!_menuScrollView) {
//        _menuScrollView = [[MenuScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 225)];
//        _menuScrollView.maxCol  =  4;
//        _menuScrollView.maxRow = 2;
//        _menuScrollView.delegate = self;
//    }
//    return _menuScrollView;
//}
- (void)change: (NSNotification *)notification
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    titlelabel.text = [defaults objectForKey:@"community_name"];
    [_tableView.mj_header beginRefreshing];
}
- (void)selectxiaoqu
{
    //    XiaoquViewController *xiaoqu = [[XiaoquViewController alloc] init];
    //    xiaoqu.biaojistr = @"0";
    //    xiaoqu.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:xiaoqu animated:YES];
    selectxiaoquViewController *xiaoqu = [[selectxiaoquViewController alloc] init];
    xiaoqu.biaoshi = @"0";//0为非第一次进入选择小区页面
    xiaoqu.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:xiaoqu animated:YES];
}

#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if(section==1){
        return 1;
    }else if(section==2){
        return 1;
    }else if(section==3){
        if ([xieyiarr isKindOfClass:[NSArray class]]) {
            return xieyiarr.count;
        }else{
            return 0;
        }
    }else if(section==4){
        return 1;
    }else if(section==5){
        return 1;
    }else if(section==6){
        return 2;
    }else{
        if ([chanpinarr isKindOfClass:[NSArray class]]) {
            return 1+chanpinarr.count;
        }else{
            return 0;
        }
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
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
    NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
//    cell.contentView.backgroundColor = BackColor;
    if (indexPath.section==0) {
        
        if ([topArr isKindOfClass:[NSArray class]]) {
            [cell.contentView addSubview:bannerView];
            [bannerView imageViewClick:^(JKBannarView * _Nonnull barnerview, NSInteger index){
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
                    circle.id = url_id;
                    circle.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:circle animated:YES];
                }if ([url_type isEqualToString:@"14"]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_id]];
                }if ([url_type isEqualToString:@"15"]){
                    youxianjiaofeiViewController *youxian = [[youxianjiaofeiViewController alloc] init];
                    youxian.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:youxian animated:YES];
                }if ([url_type isEqualToString:@"16"]){
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
                }if ([url_type isEqualToString:@"22"]){
                    
                }if ([url_type isEqualToString:@"23"]){
                    NSString *type_name = [[topArr objectAtIndex:index] objectForKey:@"type_name"];
                    NSRange range = [type_name rangeOfString:@"id/"]; //现获取要截取的字符串位置
                    NSString * result = [urltypename substringFromIndex:range.location+3]; //截取字符串
                    serviceDetailViewController *vc = [[serviceDetailViewController alloc] init];
                    vc.serviceID = result;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }if ([url_type isEqualToString:@"24"]){
                    
                }if ([url_type isEqualToString:@"25"]){
                    
                }
            }];
            tableView.rowHeight = Main_width/2.5;
        }else{
            tableView.rowHeight = RECTSTATUS.size.height+44;
        }
    }else if(indexPath.section==2){
       
            if ([gongGaoArr isKindOfClass:[NSArray class]] && gongGaoArr.count != 0) {
                NSMutableArray *titleArray = [NSMutableArray array];
                for (int m = 0; m < gongGaoArr.count; m++) {
                    NSDictionary *dic = gongGaoArr[m];
                    NSString *title = [dic objectForKey:@"title"];
                    [titleArray addObject:title];
                }
                NSLog(@"titleArray = %@",titleArray);
                NSMutableArray *timeArray = [NSMutableArray array];

                for (int m = 0; m < gongGaoArr.count; m++) {
                    NSDictionary *dic = gongGaoArr[m];
                    NSString *time = [dic objectForKey:@"addtime"];
                    [timeArray addObject:time];
                }
                self.dataSourceArray = [NSMutableArray array];
                for (int i = 0; i < titleArray.count; i++) {
                    NSString *title = [titleArray objectAtIndex:i];
                    NSString *time = [timeArray objectAtIndex:i];
                    DataSourceModel *model = [DataSourceModel dataSourceModelWithType:nil title:title time:time URLString:nil];
                    [self.dataSourceArray addObject:model];
                }
                XLsn0wTextCarousel *view = [[XLsn0wTextCarousel alloc] initWithFrame:CGRectMake(0 , 0, Main_width, 70)];
                UILabel *topLabel = [[UILabel alloc]init];
                [topLabel setFrame:(CGRectMake(70, 16, 30, 15))];
                topLabel.text = @"提示";
                topLabel.backgroundColor = [UIColor whiteColor];
                topLabel.textColor = [UIColor colorWithHexString:@"#FF5722"];
                topLabel.layer.cornerRadius = 2;
                topLabel.layer.masksToBounds = YES;
                topLabel.textAlignment = NSTextAlignmentCenter;
                topLabel.font = [UIFont systemFontOfSize:10];
                [view addSubview:topLabel];

                UILabel *bottomLabel = [[UILabel alloc]init];
                [bottomLabel setFrame:(CGRectMake(70, 44, 30, 15))];
                bottomLabel.text = @"提示";
                bottomLabel.backgroundColor = [UIColor whiteColor];
                bottomLabel.textColor = [UIColor colorWithHexString:@"#FF5722"];
                bottomLabel.layer.cornerRadius = 2;
                bottomLabel.layer.masksToBounds = YES;
                bottomLabel.textAlignment = NSTextAlignmentCenter;
                bottomLabel.font = [UIFont systemFontOfSize:10];
                [view addSubview:bottomLabel];

                view.dataSourceArray = self.dataSourceArray;
                view.currentTextInfoView.xlsn0wDelegate = self;
                view.hiddenTextInfoView.xlsn0wDelegate = self;

                UILabel *ggLab1 = [[UILabel alloc]init];
                ggLab1.frame = CGRectMake(10, 16, 60, 22);
                ggLab1.numberOfLines = 2;
                ggLab1.text = @"物业";
                ggLab1.textColor = [UIColor whiteColor];
                [ggLab1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
                [view addSubview:ggLab1];

                UILabel *ggLab2 = [[UILabel alloc]init];
                ggLab2.frame = CGRectMake(10, 38, 60, 22);
                ggLab2.numberOfLines = 2;
                ggLab2.text = @"公告";
                ggLab2.textColor = [UIColor whiteColor];
                [ggLab2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
                [view addSubview:ggLab2];

                //            view.backgroundColor =[UIColor orangeColor];
                [cell.contentView addSubview:view];

                tableView.rowHeight = 70;

            }else{

                tableView.rowHeight = 0;
            }
        
    }else if (indexPath.section==3){
        
        if (indexPath.row==0) {
            
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.frame = CGRectMake(10,17, 75, 19);
            titleLab.text = @"物业手册";
            titleLab.textColor = [UIColor colorWithHexString:@"#555555FF"];
            titleLab.font = [UIFont systemFontOfSize:18];
            [cell.contentView addSubview:titleLab];
            
            UILabel *fuLab = [[UILabel alloc]init];
            fuLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame)+10, 22, 113, 14);
            fuLab.text = @"品质服务 美好生活";
            fuLab.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
            fuLab.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:fuLab];
            
            tableView.rowHeight = 53;
            
        }else if(indexPath.row==1){
            
            for (int i=0; i<2; i++) {
                UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15+i*((Main_width-30)/2), 0, (Main_width-30)/2, 150)];
                backview.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:backview];
                
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
                NSString *urlstr = [API_img stringByAppendingString:[[xieyiarr objectAtIndex:i] objectForKey:@"article_image"]];
                [imageview sd_setImageWithURL:[NSURL URLWithString:urlstr]];
                [backview addSubview:imageview];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, imageview.frame.origin.y+imageview.frame.size.height+10, (Main_width-60)/2, 25)];
                NSString *article1 = [[xieyiarr objectAtIndex:i] objectForKey:@"title"];
                label.text = article1;
                [label setFont:nomalfont];
                [backview addSubview:label];
                
                UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, label.frame.origin.y+label.frame.size.height+12.5, (Main_width-60)/2, 50)];
                NSString *article = [[xieyiarr objectAtIndex:i] objectForKey:@"content"];
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[article dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                label1.attributedText = attributedString;
                label1.numberOfLines = 2;
                [label1 setFont:font15];
                label1.alpha = 0.5;
                [backview addSubview:label1];
                UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backview.frame)-1, (Main_width-30)/2, 1)];
                line1.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
                [backview addSubview:line1];
                UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (Main_width-30)/2, 1)];
                line2.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
                [backview addSubview:line2];
                UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 150)];
                line3.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
                [backview addSubview:line3];
                UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake((Main_width-30)/2, 0, 1, 150)];
                line4.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
                [backview addSubview:line4];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(15+i*(Main_width/2-35/2)+5*i, 0, Main_width/2-35/2, 150);
                but.tag=  i;
                [but addTarget:self action:@selector(guiyuexieyi:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:but];
            }
            tableView.rowHeight = 150;
        }else{
            tableView.rowHeight = 55;
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 54)];
            view.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:view];
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(view.frame), Main_width-30, 1)];
            line1.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
            [cell.contentView addSubview:line1];
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(Main_width-30, 0, 1, 54)];
            line2.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
            [view addSubview:line2];
            UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 54)];
            line3.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
            [view addSubview:line3];
            NSString *urlstr = [API_img stringByAppendingString:[[xieyiarr objectAtIndex:indexPath.row] objectForKey:@"article_image"]];
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 25, 25)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:urlstr]];
            [view addSubview:imageview];
            
            NSString *article = [[xieyiarr objectAtIndex:indexPath.row] objectForKey:@"title"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15+25+10, 0, Main_width-30, 55)];
            label.text = [NSString stringWithFormat:@"%@",article];
            [label setFont:nomalfont];
            [view addSubview:label];
        }
    }else if(indexPath.section==4){
        
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(10, 17, 75, 19);
        titleLab.text = @"物业服务";
        titleLab.textColor = [UIColor colorWithHexString:@"#555555FF"];
        titleLab.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:titleLab];
        
        UILabel *fuLab = [[UILabel alloc]init];
        fuLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame)+10, 22, 113, 14);
        fuLab.text = @"缴费报修 省心省力";
        fuLab.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
        fuLab.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:fuLab];
        NSArray *textArr1 = @[@"生活缴费",@"家用报修",@"公共报修"];
        NSArray *textArr2 = @[@"便捷缴费",@"一键报修",@"一键报修"];
        NSArray *imgArr = @[@"物业缴费",@"家用维修",@"报事处理"];
        for (int i = 0; i < 3; i++) {
            
            UIView *bgView = [[UIView alloc]init];
            bgView.frame = CGRectMake(10+(i*((Main_width-40)/3+10)), CGRectGetMaxY(titleLab.frame)+19, (Main_width-40)/3, 66);
            UILabel *textLab1 = [[UILabel alloc]init];
            textLab1.frame = CGRectMake(5, 17, 55, 13);
            textLab1.text = textArr1[i];
            textLab1.textColor = [UIColor colorWithHexString:@"#555555"];
            textLab1.font = [UIFont systemFontOfSize:13];
            [bgView addSubview:textLab1];
            
            UILabel *textLab2 = [[UILabel alloc]init];
            textLab2.frame = CGRectMake(5, 39, 45, 12);
            textLab2.text = textArr2[i];
            textLab2.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
            textLab2.font = [UIFont systemFontOfSize:11];
            [bgView addSubview:textLab2];
            
            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.frame = CGRectMake(62, 13, 43, 40);
            imgView.image = [UIImage imageNamed:imgArr[i]];
            [bgView addSubview:imgView];
            
            UIButton *wuYeJiaoFei = [UIButton buttonWithType:UIButtonTypeCustom];
            wuYeJiaoFei.frame = CGRectMake(0,0, (Main_width-40)/3, 66);
            wuYeJiaoFei.tag = i+100;
            [wuYeJiaoFei addTarget:self action:@selector(wuYeJiaoFei:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:wuYeJiaoFei];
            
            //                bgView.backgroundColor = [UIColor yellowColor];
            bgView.layer.cornerRadius = 5;
            bgView.layer.masksToBounds = YES;
            bgView.layer.borderWidth = 1;
            bgView.layer.borderColor = [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] CGColor];
            [cell.contentView addSubview:bgView];
        }
        
        tableView.rowHeight = 53+68;
        
    }else if(indexPath.section==5){
        
        if ([tieziDic isKindOfClass:[NSDictionary class]]) {
            
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.frame = CGRectMake(10,17, 75, 19);
            titleLab.text = @"邻里交流";
            titleLab.textColor = [UIColor colorWithHexString:@"#555555FF"];
            titleLab.font = [UIFont systemFontOfSize:18];
            [cell.contentView addSubview:titleLab];
            
            UILabel *fuLab = [[UILabel alloc]init];
            fuLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame)+10, 22, 226, 14);
            fuLab.text = @"社区资讯 随时了解";
            fuLab.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
            fuLab.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:fuLab];
            
            UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            moreBtn.frame = CGRectMake(Main_width-10-50, 17, 50, 19);
            [moreBtn setTitle:@"更多 >" forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor colorWithHexString:@"#9C9C9C"] forState:UIControlStateNormal];
            moreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:moreBtn];
            
            UIView *backview = [[UIView alloc] init];
            backview.frame = CGRectMake(12, CGRectGetMaxY(titleLab.frame)+19, Main_width-24, 145);
            backview.backgroundColor = [UIColor whiteColor];
            
            backview.layer.cornerRadius = 5;
            backview.layer.masksToBounds = YES;
            backview.layer.borderWidth = 1;
            backview.layer.borderColor = [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] CGColor];
            
            UIImageView *_imageview = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width-24-80-10, 15, 80, 80)];
            [backview addSubview:_imageview];
            _imageview.userInteractionEnabled = YES;
            _imageview.clipsToBounds = YES;
            _imageview.contentMode = UIViewContentModeScaleAspectFill;
            NSArray *imglistarr = [[NSArray alloc] init];
            imglistarr = [tieziDic objectForKey:@"img_list"];
            
            NSString *imagestring = [[[tieziDic objectForKey:@"img_list"] objectAtIndex:0] objectForKey:@"img"];
            [_imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:imagestring]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
            
            UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, Main_width-24-20-80-10, 40)];
            NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[tieziDic objectForKey:@"title"] options:0];
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
            NSData *data2 = [[NSData alloc] initWithBase64EncodedString:[tieziDic objectForKey:@"content"] options:0];
            NSString *labeltext2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
            contentlabel.text = labeltext2;
            [backview addSubview:contentlabel];
            
            UIImageView *touxiang = [[UIImageView alloc] initWithFrame:CGRectMake(10, contentlabel.frame.size.height+contentlabel.frame.origin.y+10, 20, 20)];
            NSString *imagestring1 = [tieziDic objectForKey:@"avatars"];
            [touxiang sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:imagestring1]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
            touxiang.layer.cornerRadius = 10;
            touxiang.clipsToBounds = YES;
            [backview addSubview:touxiang];
            
            UILabel *zuozhe = [[UILabel alloc] initWithFrame:CGRectMake(10+20+5, contentlabel.frame.size.height+contentlabel.frame.origin.y+10, Main_width-24-20-80-10-40, 20)];
            zuozhe.font = [UIFont systemFontOfSize:13];
            zuozhe.alpha = 0.54;
            zuozhe.text = [NSString stringWithFormat:@"%@  发布于  %@  %@",[tieziDic objectForKey:@"nickname"],[tieziDic objectForKey:@"c_name"],[tieziDic objectForKey:@"addtime"]];
            [backview addSubview:zuozhe];
            
            UILabel *scanlabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-24-100-10, contentlabel.frame.size.height+contentlabel.frame.origin.y+10, 60, 20)];
            
            NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",[tieziDic objectForKey:@"click"]]];
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
            NSMutableAttributedString *attri1 =     [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",[tieziDic objectForKey:@"reply_num"]]];
            NSTextAttachment *attch1 = [[NSTextAttachment alloc] init];
            attch1.image = [UIImage imageNamed:@"pinglun"];
            attch1.bounds = CGRectMake(0, -3, 15, 15);
            NSAttributedString *string1 = [NSAttributedString attributedStringWithAttachment:attch1];
            [attri1 insertAttributedString:string1 atIndex:0];
            pinglunlabel.attributedText = attri1;
            pinglunlabel.alpha = 0.54;
            pinglunlabel.font = [UIFont systemFontOfSize:13];
            [backview addSubview:pinglunlabel];
            
            UIButton *tiezxiangqingbut = [UIButton buttonWithType:UIButtonTypeCustom];
            tiezxiangqingbut.frame = CGRectMake(0, 0, Main_width-24, 140);
            [backview addSubview:tiezxiangqingbut];
            //                tiezxiangqingbut.tag = i;
            [tiezxiangqingbut addTarget:self action:@selector(tiezixiangqing:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:backview];
            
            tableView.rowHeight = 39+10+145+16;
        }else{
            tableView.rowHeight = 0;
        }
        
    }else if(indexPath.section==6){
        
        if (indexPath.row==0) {
            
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.frame = CGRectMake(10, 17, 75, 19);
            titleLab.text = @"租售服务";
            titleLab.textColor = [UIColor colorWithHexString:@"#555555FF"];
            titleLab.font = [UIFont systemFontOfSize:18];
            [cell.contentView addSubview:titleLab];
            
            UILabel *fuLab = [[UILabel alloc]init];
            fuLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame)+10, 22, 113, 14);
            fuLab.text = @"租赁买卖 安心放心";
            fuLab.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
            fuLab.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:fuLab];
            
            NSArray *textArr1 = @[@"找物业租房",@"找物业买房",@"发布租售"];
            NSArray *textArr2 = @[@"安全便捷放心舒心",@"物业认证省心称心",@"自主发布无需中介"];
            NSArray *imgArr = @[@"zufang",@"shoufang",@"fabu"];
            for (int i = 0; i < 3; i++) {
                
                UIView *bgView = [[UIView alloc]init];
                bgView.frame = CGRectMake(10+(i*((Main_width-40)/3+10)), CGRectGetMaxY(titleLab.frame)+19, (Main_width-40)/3, 65);
                CAGradientLayer *layer = [CAGradientLayer layer];
                layer.frame = CGRectMake(0, 0, Main_width, 70);
                layer.startPoint = CGPointMake(0,0);
                layer.endPoint = CGPointMake(1, 0);
                if (i == 0) {
                    layer.colors = @[(id)[UIColor colorWithHexString:@"#ff7124"].CGColor,(id)[UIColor colorWithHexString:@"#ff4049"].CGColor];
                    [bgView.layer addSublayer:layer];
                }else if (i == 1){
                    layer.colors = @[(id)[UIColor colorWithHexString:@"#77beff"].CGColor,(id)[UIColor colorWithHexString:@"#0084ff"].CGColor];
                    [bgView.layer addSublayer:layer];
                }else{
                    layer.colors = @[(id)[UIColor colorWithHexString:@"#fd3aff"].CGColor,(id)[UIColor colorWithHexString:@"#a628ff"].CGColor];
                    [bgView.layer addSublayer:layer];
                }
                
                UIImageView *imgView = [[UIImageView alloc]init];
                imgView.frame = CGRectMake(10, 13, 18, 18);
                imgView.image = [UIImage imageNamed:imgArr[i]];
                [bgView addSubview:imgView];
                
                UILabel *textLab1 = [[UILabel alloc]init];
                textLab1.frame = CGRectMake(34, 16, 67, 13);
                textLab1.text = textArr1[i];
                textLab1.textColor = [UIColor whiteColor];
                textLab1.font = [UIFont systemFontOfSize:13];
                [bgView addSubview:textLab1];
                
                UILabel *textLab2 = [[UILabel alloc]init];
                textLab2.frame = CGRectMake(8, 38, 90, 11);
                textLab2.text = textArr2[i];
                textLab2.textColor = [UIColor whiteColor];
                textLab2.font = [UIFont systemFontOfSize:11];
                [bgView addSubview:textLab2];
                
                UIButton *zuShouFang = [UIButton buttonWithType:UIButtonTypeCustom];
                zuShouFang.frame = CGRectMake(0,0, (Main_width-40)/3, 66);
                zuShouFang.tag = i+100;
                [zuShouFang addTarget:self action:@selector(zuShouFang:) forControlEvents:UIControlEventTouchUpInside];
                [bgView addSubview:zuShouFang];
                
                
                bgView.layer.cornerRadius = 5;
                bgView.layer.masksToBounds = YES;
                bgView.layer.borderWidth = 1;
                bgView.layer.borderColor = [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] CGColor];
                [cell.contentView addSubview:bgView];
            }
            
            tableView.rowHeight = 120;
            
        }else{

            //新加租售房列表
            if ([housesList isKindOfClass:[NSArray class]] && housesList.count != 0) {
             
                long number;
                if (housesList.count%2==0) {
                    tableView.rowHeight = ((Main_width-24-7)/2+112.5+5)*housesList.count/2+5;
                    number = housesList.count;
                }else{
                    tableView.rowHeight = ((Main_width-24-7)/2+112.5+5)*(housesList.count+1)/2+5;
                    number = housesList.count;
                }
                for (int i=0; i<number; i++) {
                    if (i%2 == 0) {
                        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 10+((Main_width-24-7)/2+32.5+5)*(i/2), (Main_width-24-7)/2, 200)];
                        view.backgroundColor = [UIColor whiteColor];
                        view.layer.cornerRadius = 3;
                        [cell.contentView addSubview:view];

                        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 110)];
                        NSURL *url = [NSURL URLWithString:[API_img stringByAppendingString:[[housesList objectAtIndex:i] objectForKey:@"head_img"]]];
                        imageview.userInteractionEnabled = YES;
                        imageview.clipsToBounds = YES;
                        imageview.contentMode = UIViewContentModeScaleAspectFill;
                        [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"背景图1.5"]];
                        
                        UIButton *dianjibut = [UIButton buttonWithType:UIButtonTypeCustom];
                        dianjibut.frame = view.frame;
                        dianjibut.tag = [[[housesList objectAtIndex:i] objectForKey:@"id"] longValue];
                        [dianjibut setTitle:[[housesList objectAtIndex:i] objectForKey:@"house_type"]  forState:UIControlStateNormal];
                        [dianjibut setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//                        [dianjibut setTitleColor:[UIColor clearColor]];
                        [dianjibut addTarget:self action:@selector(fangWuDetail:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:dianjibut];

                        NSInteger houseType = [[[housesList objectAtIndex:i] objectForKey:@"house_type"] integerValue];
                        if (houseType == 1) {
                            UIImageView *smallImg = [[UIImageView alloc]init];
                            smallImg.frame = CGRectMake(10, 10, 30, 30);
                            smallImg.image = [UIImage imageNamed:@"zu"];
                            [imageview addSubview:smallImg];
                            [view addSubview:imageview];
                            
                           
                        }else{
                            UIImageView *smallImg = [[UIImageView alloc]init];
                            smallImg.frame = CGRectMake(10, 10, 30, 30);
                            smallImg.image = [UIImage imageNamed:@"shou"];
                            [imageview addSubview:smallImg];
                            [view addSubview:imageview];
                        }
                        
                        
                        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 5+imageview.frame.size.height, view.frame.size.width-25, 40)];
                        NSString *str = [NSString stringWithFormat:@"-%@室",[[housesList objectAtIndex:i] objectForKey:@"room"]];
                        NSString *str1 = [NSString stringWithFormat:@"%@厅",[[housesList objectAtIndex:i] objectForKey:@"office"]];
                        NSString *str2 = [NSString stringWithFormat:@"%@厨",[[housesList objectAtIndex:i] objectForKey:@"kitchen"]];
                        NSString *str3 = [NSString stringWithFormat:@"%@卫",[[housesList objectAtIndex:i] objectForKey:@"guard"]];
                        NSString *str4 = [str stringByAppendingString:str1];
                        NSString *str5 = [str4 stringByAppendingString:str2];
                        NSString *str6 = [str5 stringByAppendingString:str3];
                        NSString *str7 = [[[housesList objectAtIndex:i] objectForKey:@"community_name"] stringByAppendingString:str6];
                        NSString *str8 = [NSString stringWithFormat:@"-面积%@平米",[[housesList objectAtIndex:i] objectForKey:@"area"]];
                        NSString *floor = [[housesList objectAtIndex:i] objectForKey:@"house_floor"];
                        NSString *houseFloor = [[housesList objectAtIndex:i] objectForKey:@"floor"];
                        NSString *str9 = [NSString stringWithFormat:@"|%@/%@层",floor,houseFloor];
                        NSString *str10 = [str7 stringByAppendingString:str8];
                        NSString *titleStr = [str10 stringByAppendingString:str9];
                        
                        name.text = titleStr;
                        name.font = [UIFont systemFontOfSize:13];
                        name.textColor = [UIColor colorWithHexString:@"#555555"];
                        name.numberOfLines = 2;
                        [view addSubview:name];
                        
                    
                        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(12.5, CGRectGetMaxY(name.frame)+10, view.frame.size.width-25, 17)];
                        if (houseType == 1) {
                            price.text = [NSString stringWithFormat:@"%@元/月",[[housesList objectAtIndex:i] objectForKey:@"unit_price"]];
                        }else{
                            price.text = [NSString stringWithFormat:@"%@",[[housesList objectAtIndex:i] objectForKey:@"total_price"]];
                        }
                        
                        price.textColor = QIColor;
                        price.font = [UIFont systemFontOfSize:18];
                        
                        view.layer.cornerRadius = 0;
                        view.layer.masksToBounds = YES;
                        view.layer.borderWidth = 1;
                        view.layer.borderColor = [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] CGColor];
                        [view addSubview:price];
                        
//                        tableView.rowHeight = ((Main_width-24-7)/2+32.5+5)*4/2+5;
                        
                    }else{
                        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12+((Main_width-24-7)/2+7), 10+((Main_width-24-7)/2+32.5+5)*(i/2), (Main_width-24-7)/2, 200)];
                        view.backgroundColor = [UIColor whiteColor];
                        view.layer.cornerRadius = 3;
                        [cell.contentView addSubview:view];
                        
                        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 110)];
                        NSURL *url = [NSURL URLWithString:[API_img stringByAppendingString:[[housesList objectAtIndex:i] objectForKey:@"head_img"]]];
                        imageview.userInteractionEnabled = YES;
                        imageview.clipsToBounds = YES;
                        imageview.contentMode = UIViewContentModeScaleAspectFill;
                        [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"背景图1.5"]];
                        [view addSubview:imageview];
                        
                        UIButton *dianjibut = [UIButton buttonWithType:UIButtonTypeCustom];
                        dianjibut.frame = view.frame;
                        dianjibut.tag = [[[housesList objectAtIndex:i] objectForKey:@"id"] longValue];
                        [dianjibut setTitle:[[housesList objectAtIndex:i] objectForKey:@"house_type"]  forState:UIControlStateNormal];
                        [dianjibut setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                        [dianjibut addTarget:self action:@selector(fangWuDetail:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:dianjibut];
                        
                        NSInteger houseType = [[[housesList objectAtIndex:i] objectForKey:@"house_type"] integerValue];
                        if (houseType == 1) {
                            
                            UIImageView *smallImg = [[UIImageView alloc]init];
                            smallImg.frame = CGRectMake(10, 10, 30, 30);
                            smallImg.image = [UIImage imageNamed:@"zu"];
                            [imageview addSubview:smallImg];
                            [view addSubview:imageview];
                            
                        }else{
                            UIImageView *smallImg = [[UIImageView alloc]init];
                            smallImg.frame = CGRectMake(10, 10, 30, 30);
                            smallImg.image = [UIImage imageNamed:@"shou"];
                            [imageview addSubview:smallImg];
                            [view addSubview:imageview];
    
                        }
                        
                        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 5+imageview.frame.size.height, view.frame.size.width-25, 40)];
                        NSString *str = [NSString stringWithFormat:@"-%@室",[[housesList objectAtIndex:i] objectForKey:@"room"]];
                        NSString *str1 = [NSString stringWithFormat:@"%@厅",[[housesList objectAtIndex:i] objectForKey:@"office"]];
                        NSString *str2 = [NSString stringWithFormat:@"%@厨",[[housesList objectAtIndex:i] objectForKey:@"kitchen"]];
                        NSString *str3 = [NSString stringWithFormat:@"%@卫",[[housesList objectAtIndex:i] objectForKey:@"guard"]];
                        NSString *str4 = [str stringByAppendingString:str1];
                        NSString *str5 = [str4 stringByAppendingString:str2];
                        NSString *str6 = [str5 stringByAppendingString:str3];
                        NSString *str7 = [[[housesList objectAtIndex:i] objectForKey:@"community_name"] stringByAppendingString:str6];
                        NSString *str8 = [NSString stringWithFormat:@"-面积%@平米",[[housesList objectAtIndex:i] objectForKey:@"area"]];
                        NSString *floor = [[housesList objectAtIndex:i] objectForKey:@"floor"];
                        NSString *houseFloor = [[housesList objectAtIndex:i] objectForKey:@"house_floor"];
                        NSString *str9 = [NSString stringWithFormat:@"|%@/%@层",floor,houseFloor];
                        NSString *str10 = [str7 stringByAppendingString:str8];
                        NSString *titleStr = [str10 stringByAppendingString:str9];
                        name.text = titleStr;
                        name.font = [UIFont systemFontOfSize:13];
                        name.textColor = [UIColor colorWithHexString:@"#555555"];
                        name.numberOfLines = 2;
                        [view addSubview:name];
                        
                        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(12.5, CGRectGetMaxY(name.frame)+10, view.frame.size.width-25, 17)];
                        if (houseType == 1) {
                            price.text = [NSString stringWithFormat:@"%@元/月",[[housesList objectAtIndex:i] objectForKey:@"unit_price"]];
                        }else{
                            price.text = [NSString stringWithFormat:@"%@",[[housesList objectAtIndex:i] objectForKey:@"total_price"]];
                        }
                        price.textColor = QIColor;
                        price.font = [UIFont systemFontOfSize:18];
                        view.layer.cornerRadius = 0;
                        view.layer.masksToBounds = YES;
                        view.layer.borderWidth = 1;
                        view.layer.borderColor = [[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] CGColor];
                        [view addSubview:price];
                        
//                         tableView.rowHeight = (((Main_width-24-7)/2+32.5+5)*4/2+5)/2;
                    }
            
                }
                
                if (number == 2) {
                     tableView.rowHeight = (((Main_width-24-7)/2+32.5+5)*4/2+5)/2;
                }else{
                     tableView.rowHeight = ((Main_width-24-7)/2+32.5+5)*4/2+5;
                }
           
              
            }else{
                tableView.rowHeight = 0;
            }
        }
    }else if (indexPath.section==1){
        _menuScrollView = [[MenuScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
        _menuScrollView.maxCol  =  4;
        _menuScrollView.maxRow = 2;
        _menuScrollView.delegate = self;
        [cell.contentView addSubview:_menuScrollView];
        
        NSMutableArray *mulu = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<muluarr.count; i++) {
            CustomerScrollViewModel * model = [[CustomerScrollViewModel alloc ] init];
            model.name = [[muluarr objectAtIndex:i] objectForKey:@"menu_name"];
            model.icon = [[muluarr objectAtIndex:i] objectForKey:@"menu_logo"];
            [mulu addObject:model];
        }
        self.menuScrollView.dataArr = mulu;
        
        if (muluarr.count <= 8) {
            tableView.rowHeight = 180;
        }else{
            tableView.rowHeight = 200;
        }
        
        
    }else{
        //cell.contentView.backgroundColor = BackColor;
        if (indexPath.row==0) {
           
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.frame = CGRectMake(10, 17, 75, 19);
            titleLab.text = @"精选商品";
            titleLab.textColor = [UIColor colorWithHexString:@"#555555FF"];
            titleLab.font = [UIFont systemFontOfSize:18];
            [cell.contentView addSubview:titleLab];
            
            UILabel *fuLab = [[UILabel alloc]init];
            fuLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame)+10, 22, 113, 14);
            fuLab.text = @"热卖精选 品质保证";
            fuLab.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
            fuLab.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:fuLab];
            
            long m;
            if (centerguanggaoarr.count%2==0) {
                tableView.rowHeight = ((Main_width-24-7)/2+112.5+5)*centerguanggaoarr.count/2+5;
                m = centerguanggaoarr.count;
            }else{
                tableView.rowHeight = ((Main_width-24-7)/2+112.5+5)*(centerguanggaoarr.count+1)/2+5;
                m = centerguanggaoarr.count;
            }
            for (int i=0; i<m; i++) {
                if (i%2 == 0) {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12+(Main_width-24+2)*i/2, CGRectGetMaxY(titleLab.frame)+18, Main_width/2-24/2, (Main_width-24)/2/1.5)];
                    view.backgroundColor = [UIColor whiteColor];
                    view.layer.cornerRadius = 3;
                    [cell.contentView addSubview:view];

                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, (Main_width-24)/2/1.5)];
                    NSURL *url = [NSURL URLWithString:[API_img stringByAppendingString:[[centerguanggaoarr objectAtIndex:i] objectForKey:@"img"]]];
                    [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"展位图长1.5"]];
                    imageview.backgroundColor = [UIColor yellowColor];
                    [view addSubview:imageview];
                    
                    UIButton *dianjibut = [UIButton buttonWithType:UIButtonTypeCustom];
                    dianjibut.frame = imageview.frame;
                    dianjibut.tag = i+indexPath.row;
//                    [[[centerguanggaoarr objectAtIndex:i] objectForKey:@"id"] longValue];
                    [dianjibut addTarget:self action:@selector(centerguanggao:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:dianjibut];
                    
                }else{
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12+(Main_width-24+2)*i/2, CGRectGetMaxY(titleLab.frame)+18, Main_width/2-24/2, (Main_width-24)/2/1.5)];
                    view.backgroundColor = [UIColor whiteColor];
                    view.layer.cornerRadius = 3;
                    [cell.contentView addSubview:view];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, (Main_width-24)/2/1.5)];
                    NSURL *url = [NSURL URLWithString:[API_img stringByAppendingString:[[centerguanggaoarr objectAtIndex:i] objectForKey:@"img"]]];
                    [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"展位图长1.5"]];
                    [view addSubview:imageview];
                    
                    UIButton *dianjibut = [UIButton buttonWithType:UIButtonTypeCustom];
                    dianjibut.frame = imageview.frame;
                    dianjibut.tag = i+indexPath.row;
//                    [[[centerguanggaoarr objectAtIndex:i] objectForKey:@"id"] longValue];
                    [dianjibut addTarget:self action:@selector(centerguanggao:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:dianjibut];

                }
                
            }
            
            tableView.rowHeight = 54+(Main_width-24)/2/1.5;
            
        }else{
            
            tableView.rowHeight = 110+22.5;
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(12, 10, Main_width-24, 110)];
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
            
            UILabel *_pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(119, _tagview.frame.size.height+_tagview.frame.origin.y+12.5, 65, 20)];
            _pricelabel.font = [UIFont systemFontOfSize:14];
            [backview addSubview:_pricelabel];
            
            UILabel *_yuanpricelabel = [[UILabel alloc] initWithFrame:CGRectMake(119+70, _tagview.frame.size.height+_tagview.frame.origin.y+12.5, 60, 20)];
            _yuanpricelabel.font = [UIFont systemFontOfSize:13];
            [backview addSubview:_yuanpricelabel];
            
            UILabel *_yishoulabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-24-12.5-100, _tagview.frame.size.height+_tagview.frame.origin.y+12.5, 100, 20)];
            _yishoulabel.font = [UIFont systemFontOfSize:12];
            _yishoulabel.textAlignment = NSTextAlignmentRight;
            [backview addSubview:_yishoulabel];
            
            NSString *imagestring = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"title_img"];
            NSString *is_hot = [NSString stringWithFormat:@"%@",[[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"is_hot"]];
            NSString *is_new = [NSString stringWithFormat:@"%@",[[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"is_new"]];
            NSString *is_time = [NSString stringWithFormat:@"%@",[[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"discount"]];
            NSString *kucun = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"inventory"];
            NSString *title = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"title"];
            NSString *nowprice = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"price"];
            NSString *yuanprice = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"original"];
            [_imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:imagestring]] placeholderImage:[UIImage imageNamed:@"展位图长1.5"]];
            
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
                _maiwanlemelabel.hidden = NO;
            }else{
                _maiwanlemelabel.hidden = YES;
            }
            
            _titlelabel.text = title;
            
            NSArray *tagarr = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"goods_tag"];
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
                        [_tagview addSubview:taglabel];
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
- (void)centerguanggao:(UIButton *)sender
{
    NSLog(@"sender.tag------%ld",sender.tag);
    NSString *url_type = [[centerguanggaoarr objectAtIndex:sender.tag] objectForKey:@"url_type"];
    NSString *url_id = [[centerguanggaoarr objectAtIndex:sender.tag] objectForKey:@"id"];
    NSString *urltypename = [[centerguanggaoarr objectAtIndex:sender.tag] objectForKey:@"type_name"];
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
        NSString *type_name = [[centerguanggaoarr objectAtIndex:sender.tag] objectForKey:@"type_name"];
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
            NSLog(@"精选专栏-------------%@",responseObject);
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
        NSString *type_name = [[centerguanggaoarr objectAtIndex:sender.tag] objectForKey:@"type_name"];
        
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
        circle.id = url_id;
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
}
- (void)joingouwuche:(UIButton *)sender
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
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
}
-(void)postjiarugouwuche:(NSInteger)num{
    NSString *tagid = [[chanpinarr objectAtIndex:num] objectForKey:@"tagid"];
    NSString *p_id = [[chanpinarr objectAtIndex:num] objectForKey:@"id"];
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user1 = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict1 = @{@"c_id":[user1 objectForKey:@"community_id"],@"p_id":p_id,@"tagid":tagid,@"num":@"1",@"token":[user1 objectForKey:@"token"],@"tokenSecret":[user1 objectForKey:@"tokenSecret"]};
    //3.发送GET请求
    NSString *strurl1 = [API stringByAppendingString:@"shop/check_shop_limit"];
    [manager1 GET:strurl1 parameters:dict1 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            //1.创建会话管理者
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            //2.封装参数
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];//,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]
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
            NSString *strurl = [API stringByAppendingString:@"shop/add_shopping_cart"];
            [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                    [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                    NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
                }
                else if ([[responseObject objectForKey:@"status"] integerValue]==2){
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
                    //            [self logout];
                }else{
                    
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failure--%@",error);
            }];

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
            //            [self logout];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
        NSLog(@"failure--%@",error);
    }];
    
}
- (void)guiyuexieyi: (UIButton *)sender
{
    yuefunextViewController *yuefunext = [[yuefunextViewController alloc] init];
    yuefunext.hidesBottomBarWhenPushed = YES;
    yuefunext.title = [[xieyiarr objectAtIndex:sender.tag] objectForKey:@"title"];
    yuefunext.content = [[xieyiarr objectAtIndex:sender.tag] objectForKey:@"content"];
    [self.navigationController pushViewController:yuefunext animated:YES];
}
- (void)tiezixiangqing:(UIButton *)sender
{
    circledetailsViewController *circle = [[circledetailsViewController alloc] init];
    circle.id = [tieziDic objectForKey:@"id"];    
//    circle.is_pro = [tieziDic objectForKey:@"is_pro"];
     circle.is_pro = @"0";
    circle.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:circle animated:YES];
}

- (void)menuScrollViewDeleagte:(id)menuScrollViewDeleagte index:(NSInteger)index{
    NSLog(@"点击的是 第%ld个",index);
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    
    NSString *url_type = [[muluarr objectAtIndex:index] objectForKey:@"url_type"];
    NSString *url_id = [[muluarr objectAtIndex:index] objectForKey:@"url_id"];
    NSString *urltypename = [[muluarr objectAtIndex:index] objectForKey:@"type_name"];
    if ([url_type isEqualToString:@"5"]) {
        
        if (str==nil) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }else{
            gonggongbaoxiuViewController *weixiu = [[gonggongbaoxiuViewController alloc] init];
            weixiu.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:weixiu animated:YES];
        }
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
        NSString *type_name = [[muluarr objectAtIndex:index] objectForKey:@"type_name"];
        NSRange range = [type_name rangeOfString:@"id/"]; //现获取要截取的字符串位置
        NSString * result = [type_name substringFromIndex:range.location+3]; //截取字符串
        erji.id = result;
        erji.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:erji animated:YES];
    }if ([url_type isEqualToString:@"6"]) {
        //优惠券
        NSString *type_name = [[muluarr objectAtIndex:index] objectForKey:@"type_name"];
        
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
        circle.id = url_id;
        circle.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:circle animated:YES];
    }if ([url_type isEqualToString:@"14"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_id]];
    }if ([url_type isEqualToString:@"15"]){
        if (str==nil) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }else{
            youxianjiaofeiViewController *youxian = [[youxianjiaofeiViewController alloc] init];
            youxian.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:youxian animated:YES];
        }
    }if ([url_type isEqualToString:@"16"]){
        if (str==nil) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }else{
            afteryanzhengViewController *afteryanzheng = [[afteryanzhengViewController alloc] init];
            afteryanzheng.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:afteryanzheng animated:YES];
            
            
            //            NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
            //            NSString *is_bind_property = [userdf objectForKey:@"is_bind_property"];
            //
            //            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //            NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
            //            NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
            //            NSString *strurl = [API stringByAppendingString:@"apk/property/binding_community"];
            //            [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //                NSLog(@"%@-000000-%@",[responseObject objectForKey:@"msg"],responseObject);
            //                NSArray *arrrrr = [[NSArray alloc] init];
            //                if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            //                    arrrrr = [responseObject objectForKey:@"data"];
            //                    if (arrrrr.count>1) {
            //                        selectHomeViewController *selecthome = [[selectHomeViewController alloc] init];
            //                        selecthome.homeArr = arrrrr;
            //                        selecthome.hidesBottomBarWhenPushed = YES;
            //                        [self.navigationController pushViewController:selecthome animated:YES];
            //                    }else{
            //                        MyhomeViewController *myhome = [[MyhomeViewController alloc] init];
            //                        myhome.room_id = [[arrrrr objectAtIndex:0] objectForKey:@"room_id"];
            //                        myhome.hidesBottomBarWhenPushed = YES;
            //                        [self.navigationController pushViewController:myhome animated:YES];
            //                    }
            //                    [defaults setObject:@"2" forKey:@"is_bind_property"];
            //                    [userdf synchronize];
            //                }else{
            //                    bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
            //                    bangding.hidesBottomBarWhenPushed = YES;
            //                    [self.navigationController pushViewController:bangding animated:YES];
            //
            //                    [defaults setObject:@"1" forKey:@"is_bind_property"];
            //                    [userdf synchronize];
            //                }
            //            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //                NSLog(@"failure--%@",error);
            //            }];
        }
        
    }if ([url_type isEqualToString:@"17"]){
        if (str==nil) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }else{
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
                    //                bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
                    //                bangding.hidesBottomBarWhenPushed = YES;
                    //                [self.navigationController pushViewController:bangding animated:YES];
                    //                [defaults setObject:@"1" forKey:@"is_bind_property"];
                    //                [userdf synchronize];
                    
                    afteryanzhengViewController *afteryanzheng = [[afteryanzhengViewController alloc] init];
                    afteryanzheng.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:afteryanzheng animated:YES];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failure--%@",error);
            }];
        }
    }if ([url_type isEqualToString:@"18"]){
        if (str==nil) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }else{
            FacePayViewController *face = [[FacePayViewController alloc] init];
            face.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:face animated:YES];
        }
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
    }if ([url_type isEqualToString:@"22"]){
        
    }if ([url_type isEqualToString:@"23"]){
        
    }if ([url_type isEqualToString:@"24"]){
        
    }if ([url_type isEqualToString:@"25"]){
        
    }if ([url_type isEqualToString:@"26"]){
        huodongwebviewViewController *web = [[huodongwebviewViewController alloc] init];
        web.url = url_id;
        web.title = [[muluarr objectAtIndex:index] objectForKey:@"menu_name"];
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section==3){
        if (indexPath.row>1) {
            yuefunextViewController *yuefunext = [[yuefunextViewController alloc] init];
            yuefunext.hidesBottomBarWhenPushed = YES;
            yuefunext.title = [[xieyiarr objectAtIndex:indexPath.row] objectForKey:@"title"];
            yuefunext.content = [[xieyiarr objectAtIndex:indexPath.row] objectForKey:@"content"];
            [self.navigationController pushViewController:yuefunext animated:YES];
        }
    }else if(indexPath.section==7){
        if (indexPath.row>0) {
            GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
            goods.IDstring = [[chanpinarr objectAtIndex:indexPath.row-1] objectForKey:@"id"];
            goods.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goods animated:YES];
        }
    }else{
        
    }
}
- (void)setupNavItems
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 44)];

    [self.navigationItem setTitleView:view];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, Main_width-55-35, 40)];
    titlelabel.text = [defaults objectForKey:@"community_name"];
    titlelabel.font = [UIFont systemFontOfSize:20];
    [view addSubview:titlelabel];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
    imageview.image = [UIImage imageNamed:@"iv_address"];
    [view addSubview:imageview];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 5, Main_width/2, 40);
    but.backgroundColor = [UIColor clearColor];
    [view addSubview:but];
    [but addTarget:self action:@selector(selectxiaoqu) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 邻里交流更多按钮
-(void)moreAction{
   self.tabBarController.selectedIndex = 3;
}
#pragma mark - 物业公告文字滚动
- (void)handleTopEventWithURLString:(NSString *)URLString {
    self.tabBarController.selectedIndex = 3;
}

- (void)getTopDataSourceModel:(DataSourceModel *)topDataSourceModel {
    //    XLsn0wLog(@"第一个 %@ %@ %@", topDataSourceModel.type, topDataSourceModel.title, topDataSourceModel.URLString);
}

- (void)getBottomDataSourceModel:(DataSourceModel *)bottomDataSourceModel {
    //    XLsn0wLog(@"第二个 %@ %@ %@", bottomDataSourceModel.type, bottomDataSourceModel.title, bottomDataSourceModel.URLString);
}

//- (void)handleBottomEventWithURLString:(NSString *)URLString {
//    XLsn0wLog(@"URLString===%@", URLString);
//}
#pragma mark - 物业缴费
-(void)wuYeJiaoFei:(UIButton *)sender{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    NSString *is_bind_property = [userdefaults objectForKey:@"is_bind_property"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        if (sender.tag == 100) {
            afteryanzhengViewController *afterVC = [[afteryanzhengViewController alloc]init];
            afterVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:afterVC animated:YES];
        }else if (sender.tag == 101){
            
            if ([is_bind_property isEqualToString:@"2"]) {
                ziyongliebiaoViewController *ziyongliebiaoVC = [[ziyongliebiaoViewController alloc]init];
                ziyongliebiaoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:ziyongliebiaoVC animated:YES];
            }else{
                afteryanzhengViewController *afterVC = [[afteryanzhengViewController alloc]init];
                afterVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:afterVC animated:YES];
            }
        }else{
            if ([is_bind_property isEqualToString:@"2"]) {
                gonggongbaoxiuViewController *gonggongbaoxiuVC = [[gonggongbaoxiuViewController alloc]init];
                gonggongbaoxiuVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:gonggongbaoxiuVC animated:YES];
            }else{
                
                afteryanzhengViewController *afterVC = [[afteryanzhengViewController alloc]init];
                afterVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:afterVC animated:YES];
            }
        }
    }
}
#pragma mark - 租房，售房，发布
-(void)zuShouFang:(UIButton *)sender{
    
    if (sender.tag == 100) {
        zuFangViewController *zuFangVC = [[zuFangViewController alloc]init];
        zuFangVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:zuFangVC animated:YES];
    }else if (sender.tag == 101){
        shouFangViewController *shouFangVC = [[shouFangViewController alloc]init];
         shouFangVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shouFangVC animated:YES];
    }else{
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        NSString *str = [userdefaults objectForKey:@"token"];
        if (str==nil) {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }else{
            zushouweituoViewController *zushouweituoVC = [[zushouweituoViewController alloc]init];
            zushouweituoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:zushouweituoVC animated:YES];
        }
    }
}
-(void)fangWuDetail:(UIButton *)sender{
    
    NSInteger houseType = [sender.titleLabel.text integerValue];
    if (houseType == 1) {
        zuFangDetailViewController *zuVC = [[zuFangDetailViewController alloc]init];
        zuVC.zfID = [NSString stringWithFormat:@"%ld",sender.tag];
        zuVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:zuVC animated:YES];
    }else{
        shouFangDetailViewController *shouVC = [[shouFangDetailViewController alloc]init];
        shouVC.sfID = [NSString stringWithFormat:@"%ld",sender.tag];
        shouVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shouVC animated:YES];
    }
}
@end
