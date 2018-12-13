//
//  AppDelegate.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/16.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "GSKeyChainDataManager.h"
#import "XiaoquViewController.h"
#import "yindaoyeViewController.h"
#import "LoginViewController.h"
#import "guanyuwomenViewController.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import <AFNetworking.h>
#import <AlipaySDK/AlipaySDK.h>
#import "UrlDefine.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "youhuiquanViewController.h"
#import "weixiuViewController.h"
#import "activitydetailsViewController.h"
#import "acivityViewController.h"
#import "youhuiquanxiangqingViewController.h"
#import "GoodsDetailViewController.h"
#import "shangpinerjiViewController.h"
#import "WebViewController.h"
#import "noticeViewController.h"
#import "BestpaySDK.h"
#import <EAccountSDK/EAccountSDK.h>
#import "WRNavigationBar.h"
#import "MBProgressHUD+TVAssistant.h"
#import "circledetailsViewController.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import <Bugly/Bugly.h>
#import "AppKeFuLib.h"
#import "HXPhotoTools.h"
#import "openDoorViewController.h"
#import "XYLaunchVC.h"
#import "XYIntroductionPage.h"
#import "jujiayanglaoViewController.h"
#import <LinkedME_iOS/LinkedME.h>
// 微信开放平台申请得到的 appid, 需要同时添加在 URL schema
NSString * const WXAppId = @"wx8765e31488491eb2";
NSString *const WXAppSecret = @"d84daba151d38166a67e0c218d8224bf";
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define kAppKey                  @"8015489963"
#define kAppSecret               @"tW0N2VEpc7BrAUaF2Y9XoWiY2bzjXtZM"
#define kAppName                 @"社区慧生活"
#define APPID             @"165999044c"           //bugly
#define KEFUAPPKEY             @"18c33e519eca38296f42f4c1611264b3"           //微客服

void uncaughtExceptionHandler(NSException *exception) {
    NSSLog(@"CRASH: %@", exception);
    NSSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

@interface AppDelegate ()<UINavigationControllerDelegate,UITabBarControllerDelegate,WXApiDelegate,JPUSHRegisterDelegate>
{
    TabBarViewController *tabBarController;
    
    NSString *WXCODE;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    tabBarController = [[TabBarViewController alloc]init];
    tabBarController.delegate = self;
    
    UIFont *font = [UIFont systemFontOfSize:20.f];
    
    NSDictionary *textAttributes = @{
                                     
                                     NSFontAttributeName : font,
                                     
                                     NSForegroundColorAttributeName : [UIColor blackColor]
                                     
                                     };
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    
    
    
    //[[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [WRNavigationBar wr_setDefaultNavBarTitleColor:[UIColor blackColor]];
    [WRNavigationBar wr_setDefaultNavBarTintColor:[UIColor blackColor]];
    
    [WRNavigationBar wr_setDefaultNavBarShadowImageHidden:YES];
    if ([GSKeyChainDataManager.readUUID isEqualToString:@""]) {
        [self getUUID];
    }
    [self Firstrun];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"change" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeselecetindex:) name:@"changeselecetindex" object:nil];
    
    [WXApi registerApp:WXAppId];
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categorieshttps://developer.apple.com/
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    //NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"b4fee000a6ee3079afc88ea2"
                          channel:@"AppStore"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    NSNotificationCenter*defaultCenter =[NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
     
                     selector:@selector(networkDidLogin:)
     
                         name:kJPFNetworkDidLoginNotification
     
                       object:nil];
    
    [EAccount initWithSelfKey:kAppKey appSecret:kAppSecret appName:kAppName];
    
    [Bugly startWithAppId:APPID];
    
    //步骤一：初始化操作
    [[AppKeFuLib sharedInstance] loginWithAppkey:KEFUAPPKEY];
    //步骤二：注册离线消息推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    
    
    

    return YES;
}
-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)networkDidLogin:(NSNotification*)notification {
    NSString *registrationIDStr = [JPUSHService registrationID];
    NSLog(@"registrationIDStr----%@",registrationIDStr);
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:registrationIDStr forKey:@"registrationID"];
    [userdefaults synchronize];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    //步骤三：同步deviceToken便于离线消息推送, 同时必须在管理后台上传 .pem文件才能生效
    [[AppKeFuLib sharedInstance] uploadDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    NSLog(@"注册推送失败，原因：%@",error);
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    NSLog(@"user------%@",userInfo);
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"user--%@",userInfo);
        NSString *url_type = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"url_type"]];
        NSString *url_id = [userInfo objectForKey:@"url_link"];
        //NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        if ([url_type isEqualToString:@"8"]) {
            NSLog(@"%@",url_type);
            youhuiquanViewController *youhuiquan = [[youhuiquanViewController alloc] init];
            youhuiquan.jpushstring = @"jpush";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:youhuiquan];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if ([url_type isEqualToString:@"9"]) {
            NSLog(@"%@",url_type);
            youhuiquanxiangqingViewController *youhuiquan = [[youhuiquanxiangqingViewController alloc] init];
            youhuiquan.jpushstring = @"jpush";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:youhuiquan];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if ([url_type isEqualToString:@"5"]) {
            weixiuViewController *weixiu = [[weixiuViewController alloc] init];
            weixiu.hidesBottomBarWhenPushed = YES;
            weixiu.jpushstring = @"jpush";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:weixiu];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if ([url_type isEqualToString:@"3"]) {
            acivityViewController *aciti = [[acivityViewController alloc] init];
            aciti.hidesBottomBarWhenPushed = YES;
            aciti.url = url_id;
            aciti.jpushstring = @"jpush";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:aciti];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if ([url_type isEqualToString:@"4"]) {
            activitydetailsViewController *acti = [[activitydetailsViewController alloc] init];
            acti.url = url_id;
            acti.hidesBottomBarWhenPushed = YES;
            acti.jpushstring = @"jpush";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:acti];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if ([url_type isEqualToString:@"7"]) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",url_id];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.window.rootViewController.view addSubview:callWebview];
        }else if ([url_type isEqualToString:@"2"]) {
            GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
            NSRange range = [url_id rangeOfString:@"id/"]; //现获取要截取的字符串位置
            NSString * result = [url_id substringFromIndex:range.location+3]; //截取字符串
            goods.IDstring = result;
            goods.hidesBottomBarWhenPushed = YES;
            goods.jpushstring = @"jpush";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:goods];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if ([url_type isEqualToString:@"1"]) {
            
            shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
            NSRange range = [url_id rangeOfString:@"id/"]; //现获取要截取的字符串位置
            NSLog(@"%@",NSStringFromRange(range));
            if (range.length==3) {
                NSString * result = [url_id substringFromIndex:range.location+3]; //截取字符串
                erji.id = result;
            }else{
                erji.rokou = @"2";
            }
            erji.jpushstring = @"jpush";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:erji];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if ([url_type isEqualToString:@"6"]) {
            WebViewController *web = [[WebViewController alloc] init];
            web.hidesBottomBarWhenPushed = YES;
            web.title = @"优惠券";
            NSString *url = url_id;
            web.url = url;
            web.jpushstring = @"jpush";
            web.url_type = @"2";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if ([url_type isEqualToString:@"10"]) {
            WebViewController *web = [[WebViewController alloc] init];
            web.url = url_id;
            web.url_type = @"1";
            web.jpushstring = @"jpush";
            web.title = @"小慧推荐";
            web.hidesBottomBarWhenPushed = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if ([url_type isEqualToString:@"11"]) {
            noticeViewController *notice = [[noticeViewController alloc] init];
            notice.hidesBottomBarWhenPushed = YES;
            NSRange range = [url_id rangeOfString:@"id/"]; //现获取要截取的字符串位置
            NSString * result = [url_id substringFromIndex:range.location+3]; //截取字符串
            notice.id = result;
            notice.jpushstring = @"jpush";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:notice];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if ([url_type isEqualToString:@"index"]){
            
        }else if ([url_type isEqualToString:@"12"]){
            
        }else if ([url_type isEqualToString:@"13"]){
            circledetailsViewController *circledetails = [[circledetailsViewController alloc] init];
            NSRange range = [url_id rangeOfString:@"id/"]; //现获取要截取的字符串位置
            NSString * result = [url_id substringFromIndex:range.location+3]; //截取字符串
            circledetails.id = result;
            circledetails.jpushstring = @"jpush";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:circledetails];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else {
            openDoorViewController *opendoor = [[openDoorViewController alloc] init];
            opendoor.dict = userInfo;
            opendoor.jpushstring = @"jpush";
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:opendoor];
            [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }
    }
    
    completionHandler(UNNotificationPresentationOptionAlert);  // 系统要求执行这个方法
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
//    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
//        
//        NSLog(@"acitve or background");
//        UIAlertController*alert = [UIAlertController
//                                   alertControllerWithTitle: nil
//                                   message:userInfo[@"aps"][@"alert"]
//                                   preferredStyle:UIAlertControllerStyleAlert];
//              
//        [alert addAction:[UIAlertAction
//                          actionWithTitle:@"取消"
//                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//                          {
//                              
//                          }]];
//        [alert addAction:[UIAlertAction
//                          actionWithTitle:@"确定"
//                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//                          {
//                              [self tiaozhuanyemian];
//                          }]];
//        //弹出提示框
//        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
//    }
//    else//杀死状态下，直接跳转到跳转页面。
//    {
//        [self tiaozhuanyemian];
//    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"user--%@",userInfo);
    [self tiaozhuanyemian];
    
    NSLog(@"收到推送消息。这里主要起到通知的作用，用户进入应用后，服务器会再次推送即时通讯消息");
}
- (void)tiaozhuanyemian
{
    youhuiquanViewController *youhuiquan = [[youhuiquanViewController alloc] init];
    youhuiquan.jpushstring = @"jpush";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:youhuiquan];
    nav.title = @"我的优惠券";
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}
- (void)change: (NSNotification *)notification
{
    [self settabbar];
}

- (void)changeselecetindex: (NSNotification *)notification
{
    tabBarController.selectedIndex = 0;
}
#pragma mark - 获取UUID
- (void)getUUID
{
    //获取uuid
    NSString *deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [GSKeyChainDataManager saveUUID:deviceUUID];
}
- (void)Firstrun
{
    NSUserDefaults *myUD=[NSUserDefaults standardUserDefaults];
    if([myUD objectForKey:@"community_id"]==nil)
    {
//        [myUD setBool:YES forKey:@"firstStart"];![myUD boolForKey:@"firstStart"]
//        [myUD synchronize];//同步community_id
        NSLog(@"第一次启动");
        
        //创建并初始化UITabBarController
        yindaoyeViewController *yindao = [[yindaoyeViewController alloc] init];
        UINavigationController *navCtrlr = [[UINavigationController alloc]initWithRootViewController:yindao];
        [self.window setRootViewController:navCtrlr];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
    }
    else{
        [self settabbar];
    }
}
- (void)settabbar
{
    //self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //创建并初始化UITabBarController
    
    self.window.rootViewController = tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
        //如果用户ID存在的话，说明已登陆
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSString *token = [userinfo objectForKey:@"token"];
        if (token==nil) {
            //跳到登录页面 CCPLoginVC
            LoginViewController *login = [[LoginViewController alloc] init];
            //隐藏tabbar
            login.hidesBottomBarWhenPushed =YES;
            [((UINavigationController *)tabBarController.selectedViewController) presentViewController:login animated:YES completion:nil];
            return NO;
        }else{
            return YES;
        }
    }else {
        return YES;
    }

    return YES;
}

#pragma mark - 微信支付回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"----%@----52332",url);
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    
    //NSLog(@"WX---%@",[WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]]);
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    if ([url.host isEqualToString:@"pay"]){
//
//    }
    //判断是否是通过LinkedME的UrlScheme唤起App
//    if ([[url description] rangeOfString:@"click_id"].location != NSNotFound) {
//        return [[LinkedME getInstance] handleDeepLink:url];
//    }
    NSLog(@"----%@----",url);
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return YES;
    
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //判断是否是通过LinkedME的UrlScheme唤起App
//    if ([[url description] rangeOfString:@"click_id"].location != NSNotFound) {
//        return [[LinkedME getInstance] handleDeepLink:url];
//    }
    NSLog(@"host-%@",url.host);
    if([url.scheme isEqualToString:WXAppId]){
        if ([url.host isEqualToString:@"pay"]) {
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }else if ([url.host isEqualToString:@"oauth"]){
            NSString *string = [NSString stringWithFormat:@"%@",url];
            NSRange startRange = [string rangeOfString:@"code="];
            NSRange endRange = [string rangeOfString:@"&state"];
            NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);    NSString *result = [string substringWithRange:range];
            NSLog(@"%@",result);
            WXCODE = result;
            
            return [WXApi handleOpenURL:url delegate:self];
            
            
        } else{
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
    }else{
        if ([url.host isEqualToString:@"pay"]) {
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }else if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                    NSLog(@"11111---%@",[resultDic objectForKey:@"memo"]);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"alisendmsgsure" object:nil userInfo:nil];
                }else{
                    NSLog(@"22222---%@",[resultDic objectForKey:@"memo"]);
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"alisendmsgerror" object:nil userInfo:resultDic];
                }
            }];
        }else{
            [BestpaySDK processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"确保结果显示不会出错：%@",resultDic);
            }];
        }
    }
    return YES;
}
- (void)onResp:(BaseResp *)resp{
    NSLog(@"resp.errCode = %d",resp.errCode);
    NSLog(@"resp.errCode = %@",resp.errStr);
    NSLog(@"resp.errcode = %d",resp.type);
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //3.发送GET请求
    /*
     */
    [self huoquaccesstoken];
//    NSString *strurl = @"https://api.weixin.qq.com/sns/oauth2/access_token";
//    NSLog(@"strurl---%@",strurl);
//    NSDictionary *dict = @{@"appid":WXAppId,@"secret":WXAppSecret,@"code":WXCODE,@"grant_type":@"authorization_code"};
//    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //[_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
//        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
//        NSLog(@"wxlog---success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
//
//
//        [self wechatLoginByRequestForUserInfo];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"wxlog---lost--%@",error);
//    }];
}
- (void)wechatLoginByRequestForUserInfo {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strurl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",[defaults objectForKey:@"access_token"],[defaults objectForKey:@"openid"]];
    [manager GET:strurl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [self huoquaccesstoken];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)huoquaccesstoken
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSString *strurl = [NSString stringWithFormat:@"%@%@",API,@"site/wx_login"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = nil;
    if ([defaults objectForKey:@"registrationID"]==nil){
        dict = @{@"phone_type":@"2",@"code":WXCODE};
    }else{
        dict = @{@"phone_name":[defaults objectForKey:@"registrationID"],@"phone_type":@"2",@"code":WXCODE};
    }
    
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"1---%@",responseObject);
        NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
        if ([status isEqualToString:@"100"]) {
            
            NSDictionary *statusdcit = nil;
            statusdcit = @{@"status":status,@"wx_userinfo":[responseObject objectForKey:@"data"],@"wxcode":WXCODE};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wxlogstatus" object:nil userInfo:statusdcit];
        }else if ([status isEqualToString:@"1"]){
            NSLog(@"登录成功");
            NSLog(@"----%@",responseObject);
            
            //[MBProgressHUD showToastToView:self.view withText:@"登录成功"];
            //            [LoadingView stopAnimating];
            //            LoadingView.hidden = YES;   community_id
            //存储用户信息
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[[responseObject objectForKey:@"data"] objectForKey:@"username"] forKey:@"username"];
            [defaults setObject:[[responseObject objectForKey:@"data"] objectForKey:@"uid"] forKey:@"uid"];
            [defaults setObject:@"2" forKey:@"phone_type"];
            //[defaults setObject:mimatext.text forKey:@"pwd"];
            NSString *is_bind_property = [[responseObject objectForKey:@"data"] objectForKey:@"is_bind_property"];
            NSLog(@"----%@",is_bind_property);
            [defaults setObject:is_bind_property forKey:@"is_bind_property"];
            
            //            NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            //            [defaults setObject: cookiesData forKey:@"Cookie"];
            NSString *token = [[responseObject objectForKey:@"data"] objectForKey:@"token"];
            NSString *tokenSecret = [[responseObject objectForKey:@"data"] objectForKey:@"tokenSecret"];
            [defaults setObject:token forKey:@"token"];
            [defaults setObject:tokenSecret forKey:@"tokenSecret"];
            
            [defaults synchronize];
            
            
            NSString *community = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"community_id"]];
            if ([community isEqualToString:@"0"]||[community isEqualToString:@""]) {
                [self gengxinxiaoquid];
            }
            NSLog(@"token--%@-%@",[defaults objectForKey:@"token"],[defaults objectForKey:@"tokenSecret"]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wxlogstatus1" object:nil userInfo:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logsusess" object:nil userInfo:nil];
        }else{
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
//登录成功后，如果小区id为0需要走这个接口
- (void)gengxinxiaoquid
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSString *strurl = [NSString stringWithFormat:@"%@%@",API,@"site/select_community"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = nil;
    dict = @{@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"],@"community_id":[defaults objectForKey:@"community_id"]};
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"---%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

 
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //苹果官方规定除特定应用类型，如：音乐、VOIP类可以在后台运行，其他类型应用均不得在后台运行，所以在程序退到后台要执行logout登出，
    //离线消息通过服务器推送可接收到
    //在程序切换到前台时，执行重新登录，见applicationWillEnterForeground函数中
    //步骤四：
    [[AppKeFuLib sharedInstance] logout];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    //步骤五：切换到前台重新登录
    [[AppKeFuLib sharedInstance] loginWithAppkey:KEFUAPPKEY];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
