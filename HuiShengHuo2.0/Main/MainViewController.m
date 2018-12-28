//
//  MainViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/16.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "MainViewController.h"
#import "ChangeinfomationViewController.h"
#import "SettingViewController.h"
#import <AFNetworking.h>
#import "ChangeinfomationViewController.h"
#import "GouwucheViewController.h"
#import "XiaofeijiluViewController.h"
#import "AdressViewController.h"
#import "ASBirthSelectSheet.h"
#import "UIImageView+WebCache.h"
#import "fuwudingdanViewController.h"
#import "mycircleViewController.h"
#import "dingdanViewController.h"
#import "youhuiquanViewController.h"
#import "wuyeyanzhengViewController.h"
#import "CustomActivity.h"
#import "LoginViewController.h"
#import "wuyejiaofeiViewController.h"
#import "HalfCircleActivityIndicatorView.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
#import "MD5.h"
#import "jiaofeiViewController.h"
#import "AppKeFuLib.h"
#import "MJRefresh.h"
#import "myserviceViewController.h"
#import "bangdingqianViewController.h"
#import "MyhomeViewController.h"
#import "selectHomeViewController.h"
#import "FacePayViewController.h"
#import "openDoorViewController.h"

#import "fangkeyaqingViewController.h"
#import "xinfangshouceViewController.h"
#import "MyzhuangxiuViewController.h"
#import "MBProgressHUD+TVAssistant.h"

#import "rentalhouseViewController.h"
#import "afteryanzhengViewController.h"
#import "myhouseViewController.h"
#import "mywuyegongdanViewController.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>{
    UITableView *_Hometableview;
    NSMutableDictionary *_Datadic;
    
    UIImageView *redcountimage;
    NSDictionary *_dict;
    HalfCircleActivityIndicatorView *LoadingView;
}

@property (nonatomic, strong) NSString      *onlineStatus;
@property (nonatomic, strong) NSString      *onlineStatus2;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self loggggg];
    [self post];
    
    [self LoadingView];
    [LoadingView startAnimating];
    self.navigationController.delegate = self;
    //修改信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changeinfomation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changeinfomationfullname" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changeinfomationnickname" object:nil];
    //头像
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changeinfomationtouxiang" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushjiaofei:) name:@"pushjiaofei2" object:nil];
    
    //更新登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"logsusess" object:nil];
    
    //更新count（数字）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"gengxinmain" object:nil];
    
    //修改系统导航栏下一个界面的返回按钮title
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    // Do any additional setup after loading the view.
}
- (void)pushjiaofei:(NSNotification *)user
{
    NSString *jiaofeiid = [user.userInfo objectForKey:@"jiaofeiid"];
    if ([jiaofeiid isEqualToString:@"9999999"]) {
        wuyejiaofeiViewController *jiaofei = [[wuyejiaofeiViewController alloc] init];
        jiaofei.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jiaofei animated:YES];
        
    }if ([jiaofeiid isEqualToString:@"5030"]){
        
    }if ([jiaofeiid isEqualToString:@"5031"]){
        
    }
}
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    [self.view addSubview:LoadingView];
}
- (void)change:(NSNotification *)info
{
    [self post];
}
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
    
}
//#pragma mark - 隐藏导航栏
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//
//
//    //监听登录状态
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(isConnected:) name:APPKEFU_LOGIN_SUCCEED_NOTIFICATION object:nil];
//
//    //监听在线状态
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(notifyOnlineStatus:) name:APPKEFU_WORKGROUP_ONLINESTATUS object:nil];
//
//    //监听接收到的消息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyMessage:) name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
//
//    //监听连接服务器报错
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyXmppStreamDisconnectWithError:) name:APPKEFU_NOTIFICATION_DISCONNECT_WITH_ERROR object:nil];
//}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_LOGIN_SUCCEED_NOTIFICATION object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_WORKGROUP_ONLINESTATUS object:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:APPKEFU_NOTIFICATION_DISCONNECT_WITH_ERROR object:nil];
//}
#pragma mark ------联网请求---
-(void)post
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"tokenSecret"] == nil) {
        
    }else{
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        
        
        NSLog(@"token--%@--%@",[defaults objectForKey:@"token"],[defaults objectForKey:@"tokenSecret"]);
        NSDictionary *dict = @{@"c_id":[defaults objectForKey:@"community_id"],@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
        NSString *strurl = [API stringByAppendingString:@"userCenter/index_40"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            _Datadic = [[NSMutableDictionary alloc] init];
            
            NSLog(@"%@###%@",[responseObject objectForKey:@"msg"],responseObject);
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                _Datadic = [responseObject objectForKey:@"data"];
                
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
                [self logout];
            }else{
                
            }
            [LoadingView stopAnimating];
            LoadingView.hidden = YES;
            [self CreateTableView];
            [_Hometableview reloadData];
            [_Hometableview.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }
}
- (void)logout
{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    NSString *url = [API stringByAppendingString:@"site/logout"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSLog(@"token--%@",[user objectForKey:@"token"]);
    //    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    //    NSDictionary *dict = @{@"apk_token":uid_username,@"c_id":[user objectForKey:@"community_id"],@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    //POST必须上传的字段
    [mgr POST:url parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"logout---%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        
        if ([status isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeselecetindex" object:nil userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            NSLog(@"logout11--%@",responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)post1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"c_id":[defaults objectForKey:@"community_id"],@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"userCenter/index_40"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _Datadic = [[NSMutableDictionary alloc] init];
        
        NSLog(@"%@###%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _Datadic = [responseObject objectForKey:@"data"];
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
            [self logout];
        }else{
            
        }
        [_Hometableview reloadData];
        [_Hometableview.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - 创建TableView
- (void)CreateTableView
{
    _Hometableview = [[UITableView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height, self.view.frame.size.width, kScreen_Height-RECTSTATUS.size.height-49-LCL_HomeIndicator_Height) style:UITableViewStylePlain];
    _Hometableview.backgroundColor = BackColor;
    _Hometableview.estimatedRowHeight = 0;
    _Hometableview.estimatedSectionFooterHeight = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _Hometableview.tableHeaderView = view;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _Hometableview.tableFooterView = view1;
    //_Hometableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.01f)];
    /** 去除tableview 右侧滚动条 */
    _Hometableview.showsVerticalScrollIndicator = YES;
    _Hometableview.bounces = YES;
    /** 去掉分割线 */
    _Hometableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _Hometableview.delegate = self;
    _Hometableview.dataSource = self;
    
    
    [self.view addSubview:_Hometableview];
    
    _Hometableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post1)];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }if (section==1){
        return 1;
    }else{
        return 7;
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return (Main_width-45)/2/1.65+20;
    }else if (indexPath.section==1){
        return 85;
    }else{
        if (indexPath.row==2) {
            return 60;
        }else{
            return 60;
        }
    }
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
    return @"   ";
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
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
        if (indexPath.section!=0) {
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        }
    if (indexPath.section==1) {
        cell.backgroundColor = BackColor;
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 85)];
        backview.layer.cornerRadius = 5;
        backview.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:backview];
        
        float with = (Main_width-30-60-30)/3;
        NSArray *imgarr = @[@"ic_shenghuozhangdang",@"ic_baoxiudingdan",@"ic_fuwudingdan",@"ic_shangchengdingdan"];
        NSArray *labelarr = @[@"生活账单",@"物业工单",@"服务订单",@"商城订单"];
        for (int i=0; i<4; i++) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(30+i*with, 10, 30, 30)];
            imageview.image = [UIImage imageNamed:[imgarr objectAtIndex:i]];
            [backview addSubview:imageview];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((Main_width-30)/4*i, 50, (Main_width-30)/4, 20)];
            label.text = [labelarr objectAtIndex:i];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            [backview addSubview:label];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake((Main_width-30)/4*i, 0, (Main_width-30)/4, 85);
            but.tag = i;
            [but addTarget:self action:@selector(selectsection1:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:but];
        }
        }if (indexPath.section==2) {
            cell.backgroundColor = BackColor;

            if (indexPath.row==0) {
                UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 60)];
                backview.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:backview];
               
                
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"         访客邀请"];
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"fangke"];
                attch.bounds = CGRectMake(15, -5, 25, 25);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:string atIndex:0];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width/2, 59)];
                label.attributedText = attri;
                [backview addSubview:label];
                
                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 59, Main_width-30-20, 1)];
                lineview.backgroundColor = BackColor;
                [backview addSubview:lineview];
                
                NSString *stringnum;
                NSString *str_num = [NSString stringWithFormat:@"%@",[_Datadic objectForKey:@"guest_num"]];
                if ([str_num isEqualToString:@"0"]) {
                    stringnum = @" ";
                }else{
                    stringnum = str_num;
                }
                UILabel *labelnum = [[UILabel alloc] initWithFrame:CGRectMake((Main_width-30)/3*2, 15, (Main_width-30)/3-40, 30)];
                labelnum.text = stringnum;
                labelnum.font = font15;
                labelnum.textColor = QIColor;
                labelnum.textAlignment = NSTextAlignmentRight;
                [backview addSubview:labelnum];
                
                UIImageView *youjiantou = [[UIImageView alloc] initWithFrame:CGRectMake(labelnum.frame.size.width+labelnum.frame.origin.x+15, 22.5, 9, 15)];
                youjiantou.image = [UIImage imageNamed:@"jiantou_you"];
                [backview addSubview:youjiantou];
            }if(indexPath.row==1){
                UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 60)];
                backview.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:backview];
                
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"         优惠券"];
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"youhuiquan"];
                attch.bounds = CGRectMake(15, -5, 25, 25);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:string atIndex:0];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width/2, 59)];
                label.attributedText = attri;
                [backview addSubview:label];
                
                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 59, Main_width-30-20, 1)];
                lineview.backgroundColor = BackColor;
                [backview addSubview:lineview];
                
                UIImageView *youjiantou = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width-30)/3-40+(Main_width-30)/3*2+15, 22.5, 9, 15)];
                youjiantou.image = [UIImage imageNamed:@"jiantou_you"];
                [backview addSubview:youjiantou];
            }if(indexPath.row==2){
                UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 60)];
                backview.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:backview];

                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"         我的房产"];
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"wodefangchan"];
                attch.bounds = CGRectMake(15, -5, 25, 25);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:string atIndex:0];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width/2, 59)];
                label.attributedText = attri;
                [backview addSubview:label];

                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 59, Main_width-30-20, 1)];
                lineview.backgroundColor = BackColor;
                [backview addSubview:lineview];

                UIImageView *youjiantou = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width-30)/3-40+(Main_width-30)/3*2+15, 22.5, 9, 15)];
                youjiantou.image = [UIImage imageNamed:@"jiantou_you"];
                [backview addSubview:youjiantou];
            }if(indexPath.row==3){
                UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 60)];
                backview.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:backview];
                
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"         我的邻里"];
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"lingli"];
                attch.bounds = CGRectMake(15, -5, 25, 25);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:string atIndex:0];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width/2, 59)];
                label.attributedText = attri;
                [backview addSubview:label];
                
                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 59, Main_width-30-20, 1)];
                lineview.backgroundColor = BackColor;
                [backview addSubview:lineview];
                
                NSString *stringnum;
                NSString *str_num = [NSString stringWithFormat:@"%@",[_Datadic objectForKey:@"social_num"]];
                if ([str_num isEqualToString:@"0"]) {
                    stringnum = @" ";
                }else{
                    stringnum = str_num;
                }
                UILabel *labelnum = [[UILabel alloc] initWithFrame:CGRectMake((Main_width-30)/3*2, 15, (Main_width-30)/3-40, 30)];
                labelnum.text = stringnum;
                labelnum.font = font15;
                labelnum.textColor = QIColor;
                labelnum.textAlignment = NSTextAlignmentRight;
                [backview addSubview:labelnum];
                
                UIImageView *youjiantou = [[UIImageView alloc] initWithFrame:CGRectMake(labelnum.frame.size.width+labelnum.frame.origin.x+15, 22.5, 9, 15)];
                youjiantou.image = [UIImage imageNamed:@"jiantou_you"];
                [backview addSubview:youjiantou];
            }if(indexPath.row==4){
                
                UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 60)];
                backview.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:backview];
                
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"         购物车"];
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"shop"];
                attch.bounds = CGRectMake(15, -5, 25, 25);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:string atIndex:0];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width/2, 59)];
                label.attributedText = attri;
                [backview addSubview:label];
                
                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 59, Main_width-30-20, 1)];
                lineview.backgroundColor = BackColor;
                [backview addSubview:lineview];
                
                NSString *stringnum;
                NSString *str_num = [NSString stringWithFormat:@"%@",[_Datadic objectForKey:@"cart_num"]];
                if ([str_num isEqualToString:@"0"]) {
                    stringnum = @" ";
                }else{
                    stringnum = str_num;
                }
                UILabel *labelnum = [[UILabel alloc] initWithFrame:CGRectMake((Main_width-30)/3*2, 15, (Main_width-30)/3-40, 30)];
                labelnum.text = stringnum;
                labelnum.font = font15;
                labelnum.textColor = QIColor;
                labelnum.textAlignment = NSTextAlignmentRight;
                [backview addSubview:labelnum];
                
                UIImageView *youjiantou = [[UIImageView alloc] initWithFrame:CGRectMake(labelnum.frame.size.width+labelnum.frame.origin.x+15, 22.5, 9, 15)];
                youjiantou.image = [UIImage imageNamed:@"jiantou_you"];
                [backview addSubview:youjiantou];
            }if (indexPath.row==5) {
                UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 60)];
                backview.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:backview];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"         消费记录"];
                
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"xiaofeijilu"];
                attch.bounds = CGRectMake(15, -5, 25, 25);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:string atIndex:0];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width/2, 59)];
                label.attributedText = attri;
                [backview addSubview:label];
                
                UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 59, Main_width-30-20, 1)];
                lineview.backgroundColor = BackColor;
                [backview addSubview:lineview];
                
                UIImageView *youjiantou = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width-30)/3-40+(Main_width-30)/3*2+15, 22.5, 9, 15)];
                youjiantou.image = [UIImage imageNamed:@"jiantou_you"];
                [backview addSubview:youjiantou];
            }if (indexPath.row==6) {
                UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(15, 0, Main_width-30, 60)];
                backview.backgroundColor = [UIColor whiteColor];
                [cell.contentView addSubview:backview];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"         设置"];
                
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.image = [UIImage imageNamed:@"set"];
                attch.bounds = CGRectMake(15, -5, 25, 25);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [attri insertAttributedString:string atIndex:0];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width/2, 60)];
                label.attributedText = attri;
                [backview addSubview:label];
                
                UIImageView *youjiantou = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width-30)/3-40+(Main_width-30)/3*2+15, 22.5, 9, 15)];
                youjiantou.image = [UIImage imageNamed:@"jiantou_you"];
                [backview addSubview:youjiantou];
            }
        }
        if (_Datadic!=nil) {
            if (indexPath.section==0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
                view1.backgroundColor = [UIColor clearColor];
                [cell addSubview:view1];
                
                
                UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 70)];
                view3.backgroundColor = [UIColor whiteColor];
                [view1 addSubview:view3];
                
                UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(30, 0, Main_width-60, 120)];
                view4.backgroundColor = [UIColor whiteColor];
                view4.layer.cornerRadius = 10;
                [view1 addSubview:view4];
                
                UIImageView *touxiangimage = [[UIImageView alloc] initWithFrame:CGRectMake(24, 25, 80, 80)];
                touxiangimage.layer.masksToBounds = YES;
                touxiangimage.layer.cornerRadius = 40;
                if ([[_Datadic objectForKey:@"avatars"] isEqualToString:@""]) {
                    touxiangimage.image = [UIImage imageNamed:@"facehead1"];
                }else{
                    NSString *imgstring = [_Datadic objectForKey:@"avatars"];
                    if ([imgstring rangeOfString:@"http://"].location == NSNotFound) {
                        NSString *strurl = [API_img stringByAppendingString:imgstring];
                        [touxiangimage sd_setImageWithURL:[NSURL URLWithString: strurl] placeholderImage:[UIImage imageNamed:@"展位图正"]];
                    } else {
                        NSString *imgstring = [_Datadic objectForKey:@"avatars"];
                        [touxiangimage sd_setImageWithURL:[NSURL URLWithString:imgstring] placeholderImage:[UIImage imageNamed:@"展位图正"]];
                    }
                }
                [view4 addSubview:touxiangimage];
                
                UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(124, 20, kScreen_Width-124-20, 30)];
                namelabel.text = [_Datadic objectForKey:@"nickname"];
                [namelabel setFont:nomalfont];
                [view4 addSubview:namelabel];
                UILabel *addresslabel = [[UILabel alloc] initWithFrame:CGRectMake(124, 50, kScreen_Width-144, 30)];
                addresslabel.text = [_Datadic objectForKey:@"username"];
                [addresslabel setFont:font15];
                addresslabel.alpha = 0.5;
                [view4 addSubview:addresslabel];
                
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                NSString *is_bind_property = [userdefaults objectForKey:@"is_bind_property"];
                if ([is_bind_property isEqualToString:@"2"]) {
                    UILabel *renzhenglabel = [[UILabel alloc] initWithFrame:CGRectMake(124, 80, Main_width-144, 30)];
                    renzhenglabel.text = @"已认证业主";
                    renzhenglabel.alpha = 0.5;
                    [renzhenglabel setFont:font15];
                    [view4 addSubview:renzhenglabel];
                }else{
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(124, 80, Main_width-144, 30);
                    //[but setTitle:@"" forState:UIControlStateNormal];
                    NSMutableAttributedString *attri =     [[NSMutableAttributedString alloc] initWithString:@"请绑定房屋"];
                    
                    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                    attch.image = [UIImage imageNamed:@"youjiantou2x_03"];
                    attch.bounds = CGRectMake(0, -3, 15, 15);
                    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                    [attri insertAttributedString:string atIndex:5];
                    [but setAttributedTitle:attri forState:UIControlStateNormal];
                    [but.titleLabel setFont:font15];
                    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    but.alpha = 0.5;
                    but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    //but.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                    [but addTarget:self action:@selector(bangding) forControlEvents:UIControlEventTouchUpInside];
                    [view4 addSubview:but];
                }
                UIButton *changebut = [[UIButton alloc] initWithFrame:CGRectMake(24, 25, 80, 80)];
                changebut.backgroundColor = [UIColor clearColor];
                [changebut addTarget:self action:@selector(changeinfo) forControlEvents:UIControlEventTouchUpInside];
                [view4 addSubview:changebut];
                view1.frame = CGRectMake(0, 0, Main_width, (Main_width-45)/2/1.65+20);
//                UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
//                NSArray *buttonarr = @[@"icon_my_fw_home",@"youhuiquanxin"];
//                for (int i = 0 ;i < 2 ;i ++) {
//
////                    UIImageView *imageviews = [[UIImageView alloc] initWithFrame:CGRectMake(20+i*20+i*(Main_width/2-30), view4.frame.size.height+view4.frame.origin.y+15, Main_width/2-30, (Main_width/2-30)/2)];
////
////                    imageviews.image = [UIImage imageNamed:[buttonarr objectAtIndex:i]];
////                    imageviews.layer.cornerRadius = 8;
////                    [view1 addSubview:imageviews];
//
//                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                    button.frame = CGRectMake(15+i*15+i*(Main_width-45)/2, view4.frame.size.height+view4.frame.origin.y+15, (Main_width-45)/2, (Main_width-45)/2/1.65);
//                    button.tag = i;
//                    [button setImage:[UIImage imageNamed:[buttonarr objectAtIndex:i]] forState:UIControlStateNormal];
//                    button.layer.masksToBounds = YES;
//                    button.layer.cornerRadius = 8;
//                    [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
//                    [view1 addSubview:button];
//                }
//                view1.frame = CGRectMake(0, 0, Main_width, view4.frame.size.height+view4.frame.origin.y+15+(Main_width-45)/2/1.65+5);
            }
        }
    return cell;
}
- (void)bangding
{
//    NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
//    bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
//    bangding.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:bangding animated:YES];
//    [userdf setObject:@"1" forKey:@"is_bind_property"];
//    [userdf synchronize];
    
    
    afteryanzhengViewController *afteryanzheng = [[afteryanzhengViewController alloc] init];
    afteryanzheng.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:afteryanzheng animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==2){
        if (indexPath.row==0) {
            NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
            
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
                                //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
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
                    [self logout];
                }else{
//                    bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
//                    bangding.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:bangding animated:YES];
//                    [defaults setObject:@"1" forKey:@"is_bind_property"];
//                    [userdf synchronize];
//                    [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                    
                    afteryanzhengViewController *afteryanzheng = [[afteryanzhengViewController alloc] init];
                    afteryanzheng.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:afteryanzheng animated:YES];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failure--%@",error);
            }];
            
            
        }else if (indexPath.row==1) {
            
            youhuiquanViewController *youhuiquan = [[youhuiquanViewController alloc] init];
            youhuiquan.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:youhuiquan animated:YES];
            
        }else if (indexPath.row==2) {
            myhouseViewController *myhouse = [[myhouseViewController alloc] init];
            myhouse.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myhouse animated:YES];
        }else if (indexPath.row==3) {
            mycircleViewController *mycircle = [[mycircleViewController alloc] init];
            mycircle.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mycircle animated:YES];
        }else if (indexPath.row==4){
            GouwucheViewController *gouwuche = [[GouwucheViewController alloc] init];
            gouwuche.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gouwuche animated:YES];
        }else if (indexPath.row==5){
            XiaofeijiluViewController *xiaofei = [[XiaofeijiluViewController alloc] init];
            xiaofei.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:xiaofei animated:YES];
        }else{
            SettingViewController *setting = [[SettingViewController alloc] init];
            setting.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setting animated:YES];
        }
    }
}
//接收是否登录成功通知
- (void)isConnected:(NSNotification*)notification
{
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
        //登录成功
        //self.title = @"微客服4(登录成功)";
        
        //
        //查询工作组在线状态，需要将wgdemo替换为开发者自己的 “工作组名称”，请在官方管理后台申请，地址：http://appkefu.com/AppKeFu/admin
        [[AppKeFuLib sharedInstance] queryWorkgroupOnlineStatus:@"hckf001"];
    }
    else
    {
        //登录失败
        //self.title = @"微客服4(登录失败)";
        
    }
}

#pragma mark OnlineStatus

//监听工作组在线状态
-(void)notifyOnlineStatus:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    
    //客服工作组名称
    NSString *workgroupName = [dict objectForKey:@"hckf001"];
    
    //客服工作组在线状态
    NSString *status   = [dict objectForKey:@"status"];
    
    NSLog(@"%s workgroupName:%@, status:%@", __PRETTY_FUNCTION__, workgroupName, status);
    
    //
    if ([workgroupName isEqualToString:@"hckf001"]) {
        
        //客服工作组在线
        if ([status isEqualToString:@"online"])
        {
            self.onlineStatus = NSLocalizedString(@"1.在线咨询演示1(在线)", nil);
        }
        //客服工作组离线
        else
        {
            self.onlineStatus = NSLocalizedString(@"1.在线咨询演示2(离线)", nil);
        }
        
    }
    //
    else if ([workgroupName isEqualToString:@"hckf001"]) {
        
        //客服工作组在线
        if ([status isEqualToString:@"online"])
        {
            self.onlineStatus2 = NSLocalizedString(@"2.在线咨询演示2(在线)", nil);
        }
        //客服工作组离线
        else
        {
            self.onlineStatus2 = NSLocalizedString(@"2.在线咨询演示2(离线)", nil);
        }
    }
    
    
    //[self.tableView reloadData];
}

#pragma mark Message

//接收到新消息
- (void)notifyMessage:(NSNotification *)nofication
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    KFMessageItem *msgItem = [nofication object];
    
    //接收到来自客服的消息
    if (!msgItem.isSendFromMe) {
        //
        NSLog(@"消息时间:%@, 工作组名称:%@, 发送消息用户名:%@",
              msgItem.timestamp,
              msgItem.workgroupName,
              msgItem.username);
        
        //文本消息
        if (KFMessageTypeText == msgItem.messageType) {
            
            NSLog(@"文本消息内容：%@", msgItem.messageContent);
        }
        //图片消息
        else if (KFMessageTypeImageHTTPURL == msgItem.messageType)
        {
            NSLog(@"图片消息内容：%@", msgItem.messageContent);
        }
        //语音消息
        else if (KFMessageTypeSoundHTTPURL == msgItem.messageType)
        {
            NSLog(@"语音消息内容：%@", msgItem.messageContent);
        }
    }
    //[self.tableView reloadData];
}

-(void)notifyXmppStreamDisconnectWithError:(NSNotification *)notification
{
    //登录失败
    //self.title = @"微客服4(网络连接失败)";
}


#pragma mark UIAlerviewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%s, %ld", __PRETTY_FUNCTION__, (unsigned long)buttonIndex);
    if (buttonIndex == 1) {
        
        //清空与客服工作组 "wgdemo" 的所有聊天记录
        [[AppKeFuLib sharedInstance] deleteMessagesWith:@"hckf001"];
    }
}

#pragma mark BarButtonItem
-(void)leftBarButtonItemTouchUpInside:(UIButton *)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


-(void)rightBarButtonItemTouchUpInside:(UIButton *)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
}
-(void)changeinfo
{
    NSLog(@"修改个人信息");
    ChangeinfomationViewController *changeinfo = [[ChangeinfomationViewController alloc] init];
    changeinfo.hidesBottomBarWhenPushed = YES;
    
    if ([[_Datadic objectForKey:@"fullname"] isKindOfClass:[NSNull class]]||[_Datadic objectForKey:@"fullname"]==nil) {
        changeinfo.fullname = @"请填写姓名";
    }else{
        changeinfo.fullname = [_Datadic objectForKey:@"fullname"];
    }
    if ([[_Datadic objectForKey:@"sex"] isKindOfClass:[NSNull class]]||[_Datadic objectForKey:@"sex"]==nil) {
        changeinfo.sex = @"请选择性别";
    }else{
        changeinfo.sex = [_Datadic objectForKey:@"sex"];
    }
    if ([[_Datadic objectForKey:@"birthday"] isKindOfClass:[NSNull class]]||[_Datadic objectForKey:@"birthday"]==nil) {
        changeinfo.birthday = @"请选择出生日期";
    }else{
        changeinfo.birthday = [_Datadic objectForKey:@"birthday"];
    }
    if ([[_Datadic objectForKey:@"nickname"] isKindOfClass:[NSNull class]]||[_Datadic objectForKey:@"nickname"]==nil) {
        changeinfo.nickname = @"请填写昵称";
    }else{
        changeinfo.nickname = [_Datadic objectForKey:@"nickname"];
    }
    if ([[_Datadic objectForKey:@"avatars"] isKindOfClass:[NSNull class]]||[_Datadic objectForKey:@"avatars"]==nil) {
        changeinfo.imagestr = @"";
    }else{
        changeinfo.imagestr = [_Datadic objectForKey:@"avatars"];
    }
    NSLog(@"%@==%@==%@==%@==%@",changeinfo.fullname,changeinfo.birthday,changeinfo.sex,changeinfo.nickname,changeinfo.imagestr);
    [self.navigationController pushViewController:changeinfo animated:YES];
}
- (void)selectsection1:(UIButton *)sender
{
    if (sender.tag==0) {
        afteryanzhengViewController *jiaofei = [[afteryanzhengViewController alloc] init];
        jiaofei.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jiaofei animated:YES];
    }else if (sender.tag==2){
        myserviceViewController *myservice = [[myserviceViewController alloc] init];
        myservice.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myservice animated:YES];
    }else if (sender.tag==1){
        mywuyegongdanViewController *vc = [[mywuyegongdanViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        dingdanViewController *dingdan = [[dingdanViewController alloc] init];
        dingdan.hidesBottomBarWhenPushed = YES;
        dingdan.title = @"商城订单";
        [self.navigationController pushViewController:dingdan animated:YES];
    }
}
- (void)push:(UIButton *)sender
{
    if (sender.tag==0) {
        NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
        //NSString *is_bind_property = [userdf objectForKey:@"is_bind_property"];
        
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
                [self logout];
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
    } if (sender.tag==1){
        youhuiquanViewController *youhuiquan = [[youhuiquanViewController alloc] init];
        youhuiquan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:youhuiquan animated:YES];
    }
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
