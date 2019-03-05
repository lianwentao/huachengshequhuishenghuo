//
//  LoginViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/21.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "LoginViewController.h"
#import <AFNetworking.h>
#import "RigistViewController.h"
#import "GSKeyChainDataManager.h"
#import "MainViewController.h"
#import "yonghuxieyiwebViewController.h"
#import "HalfCircleActivityIndicatorView.h"
#import "MBProgressHUD+TVAssistant.h"
#import "yanzhengmalogViewController.h"
#import <EAccountSDK/EAccountSDK.h>
#import "MD5.h"
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
#import "WXApi.h"
#import "WXApiManager.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#import "PrefixHeader.pch"

@interface LoginViewController ()<UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIButton *surcebut1;
    UIButton *surcebut2;
    UITextField *mimatext;
    UITextField *phonbe;
    UITextField *yanzhengmatextfield;
    UITextField *yaoqingmatextfield;
    
    UIButton *yanzhengmabut;
    UIButton *logbut1;
    UIButton *logbut;
    int timeDown; //60秒后重新获取验证码
    NSTimer *timer;
    
    NSDictionary *_dict;//请求参数
    NSString *_strurl; //请求地址
    
    NSDictionary *_dict2;//请求参数
    NSString *_strurl2; //请求地址
    
    HalfCircleActivityIndicatorView *LoadingView;
    
    NSString *openid;
    NSString *username;
    NSString *timeStamp;
    NSString *clientIp;
    
    MBProgressHUD *_HUD;
    
    NSDictionary *wxuserinfodic;
    NSString *WXcode;
}

@end

@implementation LoginViewController

 - (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    [self createdaohangolan];
    [self CreateLog];
    [self LoadingView];
    LoadingView.hidden = YES;
    
    [self getDeviceIPIpAddresses];
    [self downshoushi];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxlogstasus:) name:@"wxlogstatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxlogstasus1) name:@"wxlogstatus1" object:nil];
    // Do any additional setup after loading the view.
}
- (void)wxlogstasus1
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)wxlogstasus:(NSNotification *)info
{
    //对话框显示时需要执行的操作
    NSString *status = [info.userInfo objectForKey:@"status"];
    wxuserinfodic = [info.userInfo objectForKey:@"wx_userinfo"];
    WXcode = [info.userInfo objectForKey:@"wxcode"];
    NSLog(@"%@",[info.userInfo objectForKey:@"status"]);
    if ([status isEqualToString:@"100"]) {
        RigistViewController *rigist = [[RigistViewController alloc] init];
        rigist.wxinfo = [info.userInfo objectForKey:@"wx_userinfo"];
        [self presentViewController:rigist animated:YES completion:nil];
    }else if ([status isEqualToString:@"1"]){
        
    }else{
        NSLog(@"登录失败");
    }
}

//获取ip地址
- (NSString *)getDeviceIPIpAddresses

{
    
    int sockfd =socket(AF_INET,SOCK_DGRAM, 0);
    
    //    if (sockfd <</span> 0) return nil;
    
    NSMutableArray *ips = [NSMutableArray array];
    
    
    
    int BUFFERSIZE =4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd,SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len =sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                
                len = ifr->ifr_addr.sa_len;
                
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family !=AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr =0;
            
            if (strncmp(lastname, ifr->ifr_name,IFNAMSIZ) == 0)continue;
            
            memcpy(lastname, ifr->ifr_name,IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd,SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags &IFF_UP) == 0)continue;
            
            
            
            NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
            
        }
        
    }
    
    close(sockfd);
    
    
    
    
    
    NSString *deviceIP =@"";
    
    for (int i=0; i < ips.count; i++)
        
    {
        
        if (ips.count >0)
            
        {
            
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
            
            
            
        }
        
    }
    clientIp = deviceIP;
    NSLog(@"deviceIP========%@",deviceIP);
    return deviceIP;
}
#pragma mark - LoadingView
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    [self.view addSubview:LoadingView];
}
#pragma mark - 自定义导航栏
- (void)createdaohangolan
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    but.frame = CGRectMake(30, 23+rectStatus.size.height, 35, 35);
    [but setImage:[UIImage imageNamed:@"closed"] forState:UIControlStateNormal];
    
    [self.view addSubview:but];
    [but addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
}
- (void)cancle
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)mianmilog
{
    
    NSLog(@"******log******");
    NSString *thirdLoginStr = @"";
    
    
    
    ThirdLoginType thirdLoginType = ThirdLoginDefaultLogin;
    if ([thirdLoginStr containsString:@"qq"]) {
        thirdLoginType = thirdLoginType | ThirdLoginQQLogin;
    }
    if ([thirdLoginStr containsString:@"weixin"]) {
        thirdLoginType = thirdLoginType | ThirdLoginWeiXinLogin;
    }
    if ([thirdLoginStr containsString:@"weibo"]) {
        thirdLoginType = thirdLoginType | ThirdLoginWeiboLogin;
    }
    NSArray *arr = [[NSArray alloc] init];
    [EAccount login:thirdLoginType
           loginWay:@"dm|zm"
        accountType:@"mobile"   //accountTypeStr
          loginList:arr
              hasat:NO
            hideTop:NO
            baseApp:NO
      basicLoginTxt:@""
         controller:self
            success:^(NSDictionary *resultDic) {
                [self GeneralButtonAction];
                timeStamp = [resultDic objectForKey:@"timeStamp"];
                NSLog(@"********resultDic:%@",resultDic);//保存在本地
                //1.创建会话管理者
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                NSDictionary *dict = @{@"accessToken":[resultDic objectForKey:@"accessToken"],@"openId":[resultDic objectForKey:@"openId"],@"clientIp":clientIp,@"clientId":@"8015489963"};
                NSString *mianmiurl = [API stringByAppendingString:@"site/get_userInfo"];
                [manager POST:mianmiurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
                    NSLog(@"success--%@--%@--%@",[responseObject class],responseObject,[responseObject objectForKey:@"msg"]);
                    if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                        
                        username = [[responseObject objectForKey:@"data"] objectForKey:@"mobileName"];
                        openid = [[responseObject objectForKey:@"data"] objectForKey:@"openId"];
                        
                        [self dianxinmianmilog];
                    }else{
                        [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"failure--%@",error);
                }];
                //[EAccount closeLoginView];
            }failure:^(NSError *error) {
                NSLog(@"❎❎❎❎❎❎❎");
                /*
                 "{\"result\":7003,\"msg\":\"用户选择用微博登录\"}";
                 "{\"result\":7002,\"msg\":\"用户选择用QQ登录\"}";
                 "{\"result\":7001,\"msg\":\"用户选择用微信登录\"}";
                 */
                if (error.code == 7002) {
                    
                    //    vc.account = self.eAccount;
                    
                    
                }else if (error.code == 7003) {
                    
                    //    vc.account = self.eAccount;
                    
                    
                }else if (error.code == 7001) {
                    
                    //    vc.account = self.eAccount;
                }else {
                    //[EAccountDemoUtil showResultDic:error.userInfo viewController:self];
                }
            }];
}
- (void)GeneralButtonAction{
    //初始化进度框，置于当前的View当中
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"登录中,请稍后...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    //细节文字
    //_HUD.detailsLabelText = @"请耐心等待";
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(3);
        
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
- (void)dianxinmianmilog
{
    AFHTTPSessionManager *managerlog = [AFHTTPSessionManager manager];
    managerlog.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [[MD5 MD5:[NSString stringWithFormat:@"%@%@",openid,timeStamp]] lowercaseString];
    NSDictionary *dictlog = [[NSDictionary alloc] init];
    
    NSString *gudingzifuchuan = @"hui-shenghuo.api_sms";
    NSString *gudingjiami = [MD5 MD5:gudingzifuchuan];
    //NSString *TEACHERLower      = [TEACHER lowercaseString];
    NSString *str2 = [[gudingjiami lowercaseString] substringWithRange:NSMakeRange(8,16)];
    NSString *timestring = [NSString stringWithFormat:@"%ld",time(NULL)];
    NSString *str3 = [NSString stringWithFormat:@"%@%@%@",timestring,str2,timestring];
    NSString *str4 = [MD5 MD5:[str3 lowercaseString]];
    NSString *str5 = [[str4 lowercaseString] substringWithRange:NSMakeRange(0,16)];
    NSString *ApiSmstoken = str5;//,@"ApiSmstoken":ApiSmstoken,@"ApiSmstokentime":timestring
    
    
    if ([userdefaults objectForKey:@"registrationID"]==nil){
        dictlog = @{@"username":username,@"openId":openid,@"token":token,@"timeStamp":timeStamp,@"phone_type":@"2",@"ApiSmstoken":ApiSmstoken,@"ApiSmstokentime":timestring};
    }else{
        dictlog = @{@"username":username,@"openId":openid,@"token":token,@"timeStamp":timeStamp,@"phone_name":[userdefaults objectForKey:@"registrationID"],@"phone_type":@"2",@"ApiSmstoken":ApiSmstoken,@"ApiSmstokentime":timestring};
    }
    
    NSLog(@"---%@",dictlog);
    NSString *mianmiurllog = [API stringByAppendingString:@"site/free_login"];
    [managerlog POST:mianmiurllog parameters:dictlog progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@--%@",[responseObject class],responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
            
            //存储用户信息
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:phonbe.text forKey:@"username"];
            [defaults setObject:[[responseObject objectForKey:@"data"] objectForKey:@"uid"] forKey:@"uid"];
            [defaults setObject:@"2" forKey:@"phone_type"];
            [defaults setObject:[[responseObject objectForKey:@"data"] objectForKey:@"community_id"] forKey:@"community_id"];
            [defaults setObject:[[responseObject objectForKey:@"data"] objectForKey:@"pwd"] forKey:@"pwd"];
            NSString *is_bind_property = [[responseObject objectForKey:@"data"] objectForKey:@"is_bind_property"];
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
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logsusess" object:nil userInfo:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
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
#pragma mark - 创建登录
- (void)CreateLog
{
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 23+RECTSTATUS.size.height+25+35, 200, 26)];
    titlelabel.text = @"登录";
    titlelabel.font = [UIFont systemFontOfSize:27];
    [self.view addSubview:titlelabel];
    
    UILabel *miaosulabel = [[UILabel alloc] initWithFrame:CGRectMake(30, titlelabel.frame.size.height+titlelabel.frame.origin.y+14, Main_width-60, 13)];
    miaosulabel.text = @"未注册手机验证后自动登录";
    miaosulabel.alpha = 0.45;
    miaosulabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:miaosulabel];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, miaosulabel.frame.size.height+miaosulabel.frame.origin.y+44, 24, 24)];
    imageview1.image = [UIImage imageNamed:@"shoujihao"];
    [self.view addSubview:imageview1];
    
    phonbe = [[UITextField alloc] initWithFrame:CGRectMake(imageview1.frame.origin.x+imageview1.frame.size.width+20, imageview1.frame.origin.y, Main_width-150, 24)];
    phonbe.placeholder = @"请输入手机号码";
    phonbe.tag = 1001;
    phonbe.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phonbe];
    
    UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(30, imageview1.frame.size.height+imageview1.frame.origin.y+13, Main_width-60, 1)];
    lineview1.backgroundColor = [UIColor blackColor];
    lineview1.alpha = 0.2;
    [self.view addSubview:lineview1];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(30, lineview1.frame.size.height+lineview1.frame.origin.y+20, 24, 24)];
    imageview2.image = [UIImage imageNamed:@"yanzhengma"];
    [self.view addSubview:imageview2];
    
    yanzhengmatextfield = [[UITextField alloc] initWithFrame:CGRectMake(imageview2.frame.size.width+imageview2.frame.origin.x+20, imageview2.frame.origin.y, Main_width-150, 24)];
    yanzhengmatextfield.placeholder = @"请输入短信验证码";
    yanzhengmatextfield.tag = 1002;
    yanzhengmatextfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:yanzhengmatextfield];
    
    //发送验证码按钮
    yanzhengmabut = [UIButton buttonWithType:UIButtonTypeCustom];
    yanzhengmabut.clipsToBounds=YES;
    //yanzhengmabut.layer.cornerRadius=30;//圆角
    yanzhengmabut.frame = CGRectMake(Main_width-115, imageview2.frame.origin.y, 85, 24);
    yanzhengmabut.layer.cornerRadius = 10;
    [yanzhengmabut.layer setBorderWidth:1];
    [yanzhengmabut.titleLabel setFont:font15];
    [yanzhengmabut.layer setBorderColor:QIColor.CGColor];
    [yanzhengmabut setTitle:@"获取验证" forState:UIControlStateNormal];
    [yanzhengmabut setTitleColor:QIColor forState:UIControlStateNormal];
    yanzhengmabut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [yanzhengmabut addTarget:self action:@selector(daojishi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yanzhengmabut];
    
    UIView *lineview2 = [[UIView alloc] initWithFrame:CGRectMake(30, imageview2.frame.size.height+imageview2.frame.origin.y+13, Main_width-60, 1)];
    lineview2.backgroundColor = [UIColor blackColor];
    lineview2.alpha = 0.2;
    [self.view addSubview:lineview2];
    
    UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(30, lineview2.frame.size.height+lineview2.frame.origin.y+20, 24, 24)];
    imageview3.image = [UIImage imageNamed:@"yaoqingma"];
    [self.view addSubview:imageview3];
    
    yaoqingmatextfield = [[UITextField alloc] initWithFrame:CGRectMake(imageview3.frame.size.width+imageview3.frame.origin.x+20, imageview3.frame.origin.y, Main_width-150, 24)];
    yaoqingmatextfield.placeholder = @"请输入邀请码（选填）";
    yaoqingmatextfield.tag = 1003;
    [self.view addSubview:yaoqingmatextfield];
    
    UIView *lineview3 = [[UIView alloc] initWithFrame:CGRectMake(30, imageview3.frame.size.height+imageview3.frame.origin.y+13, Main_width-60, 1)];
    lineview3.backgroundColor = [UIColor blackColor];
    lineview3.alpha = 0.2;
    [self.view addSubview:lineview3];
    
    logbut = [UIButton buttonWithType:UIButtonTypeCustom];
    logbut.clipsToBounds=YES;
    logbut.layer.cornerRadius=10;//圆角
    logbut.frame = CGRectMake(30, lineview3.frame.size.height+lineview3.frame.origin.y+30, Main_width-60, 40);
    [logbut setTitle:@"登录/注册" forState:UIControlStateNormal];
    [logbut.titleLabel setFont:font18];
    logbut.backgroundColor = QIColor;
    [logbut addTarget:self action:@selector(Log) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logbut];
    
    UILabel *xieyilabel = [[UILabel alloc] initWithFrame:CGRectMake(30, logbut.frame.size.height+logbut.frame.origin.y+15, Main_width-60, 13)];
    xieyilabel.textAlignment = NSTextAlignmentCenter;
    [xieyilabel setFont:[UIFont systemFontOfSize:13]];
    //xieyilabel.text = @"登录即表示您已同意《社区慧生活用户注册协议》";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"登录即表示您已同意《社区慧生活用户注册协议》"];
    [attrStr setAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:QIColor}
                     range:NSMakeRange(9, 13)];
    xieyilabel.attributedText = attrStr;
    //xieyilabel.textColor = [UIColor blackColor];
    xieyilabel.alpha = 0.54;
    [self.view addSubview:xieyilabel];
    
    UIButton *xieyibut = [UIButton buttonWithType:UIButtonTypeCustom];
    xieyibut.frame = CGRectMake(Main_width/2, logbut.frame.size.height+logbut.frame.origin.y+15, Main_width-60, 20);
    [xieyibut addTarget:self action:@selector(openxieyi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieyibut];
    
    UIButton *wexin = [UIButton buttonWithType:UIButtonTypeCustom];
    wexin.frame = CGRectMake(80, Main_Height-58-48, 48, 48);
    [wexin setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
    [wexin addTarget:self action:@selector(weixinlog) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wexin];
    
    UILabel *wexinlabel = [[UILabel alloc] initWithFrame:CGRectMake(65, Main_Height-30-13, 48+30, 13)];
    wexinlabel.text = @"微信登录";
    wexinlabel.textAlignment = NSTextAlignmentCenter;
    wexinlabel.font = [UIFont systemFontOfSize:13];
    wexinlabel.textColor = [UIColor colorWithRed:117.002/255.0 green:199.002/255.0 blue:113.003/255.0 alpha:1];
    [self.view addSubview:wexinlabel];
    
    UIButton *mianmi = [UIButton buttonWithType:UIButtonTypeCustom];
    mianmi.frame = CGRectMake(Main_width-80-48, Main_Height-58-48, 48, 48);
    [mianmi setImage:[UIImage imageNamed:@"mianmi"] forState:UIControlStateNormal];
    [self.view addSubview:mianmi];
    
    UILabel *mianmilabel = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-80-15-48, Main_Height-30-13, 48+30, 13)];
    mianmilabel.text = @"免密登录";
    mianmilabel.font = [UIFont systemFontOfSize:13];
    mianmilabel.textAlignment = NSTextAlignmentCenter;
    mianmilabel.textColor = [UIColor colorWithRed:103.999/255.0 green:203/255.0 blue:247.995/255.0 alpha:1];
    [mianmi addTarget:self action:@selector(mianmilog) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mianmilabel];
}
- (void)weixinlog
{
    if ([WXApi isWXAppInstalled]) {
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"shequhuishenghuoapp";
        //第三方向微信终端发送一个SendAuthReq消息结构
        [WXApi sendReq:req];
    }
    else {
        [self setupAlertController];
    }
}
#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 发送验证码
- (void)daojishi
{
//    NSString *phoneNumber =phonbe.text;
//    
//    if(![self isValidateMobile:phoneNumber])
//    {
//        [MBProgressHUD showToastToView:self.view withText:@"手机号格式错误"];
//    }else
//    {
//        NSString *gudingzifuchuan = @"hui-shenghuo.api_sms";
//        NSString *gudingjiami = [MD5 MD5:gudingzifuchuan];
//        //NSString *TEACHERLower      = [TEACHER lowercaseString];
//        NSString *str2 = [[gudingjiami lowercaseString] substringWithRange:NSMakeRange(8,16)];
//        NSString *timestring = [NSString stringWithFormat:@"%ld",time(NULL)];
//        NSString *str3 = [NSString stringWithFormat:@"%@%@%@",timestring,str2,timestring];
//        NSString *str4 = [MD5 MD5:[str3 lowercaseString]];
//        NSString *str5 = [[str4 lowercaseString] substringWithRange:NSMakeRange(0,16)];
//        
//        NSString *ApiSmstoken = str5;//,@"ApiSmstoken":ApiSmstoken,@"ApiSmstokentime":timestring
//        _dict2 = [[NSDictionary alloc] init];
//        _strurl2 = [API stringByAppendingString:@"site/reg_send_sms"];
//        _dict2 = @{@"username":phonbe.text,@"sms_type":@"login",@"phone_type":@"2",@"ApiSmstoken":ApiSmstoken,@"ApiSmstokentime":timestring};
//        [self CreatePost2];
//        timeDown = 59;
//        [self handleTimer];
//        timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
//        NSLog(@"%@---%@---%@---%@---%@---%@",gudingzifuchuan,gudingjiami,str2,str3,str4,str5);
//    }
    NSString *gudingzifuchuan = @"hui-shenghuo.api_sms";
    NSString *gudingjiami = [MD5 MD5:gudingzifuchuan];
    //NSString *TEACHERLower      = [TEACHER lowercaseString];
    NSString *str2 = [[gudingjiami lowercaseString] substringWithRange:NSMakeRange(8,16)];
    NSString *timestring = [NSString stringWithFormat:@"%ld",time(NULL)];
    NSString *str3 = [NSString stringWithFormat:@"%@%@%@",timestring,str2,timestring];
    NSString *str4 = [MD5 MD5:[str3 lowercaseString]];
    NSString *str5 = [[str4 lowercaseString] substringWithRange:NSMakeRange(0,16)];
    
    NSString *ApiSmstoken = str5;//,@"ApiSmstoken":ApiSmstoken,@"ApiSmstokentime":timestring
    _dict2 = [[NSDictionary alloc] init];
    _strurl2 = [API stringByAppendingString:@"site/reg_send_sms"];
    _dict2 = @{@"username":phonbe.text,@"sms_type":@"login",@"phone_type":@"2",@"ApiSmstoken":ApiSmstoken,@"ApiSmstokentime":timestring};
    [self CreatePost2];
    
    NSLog(@"%@---%@---%@---%@---%@---%@",gudingzifuchuan,gudingjiami,str2,str3,str4,str5);
}
-(void)handleTimer
{
    if(timeDown>=0)
    {
        [yanzhengmabut setUserInteractionEnabled:NO];
        int sec = ((timeDown%(24*3600))%3600)%60;
        [yanzhengmabut setTitle:[NSString stringWithFormat:@"(%d)后重发",sec] forState:UIControlStateNormal];
        
    }
    else
    {
        [yanzhengmabut setUserInteractionEnabled:YES];
        [yanzhengmabut setTitle:@"重新发送" forState:UIControlStateNormal];
        [timer invalidate];
        
    }
    timeDown = timeDown - 1;
}
- (void)CreatePost2
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    //NSDictionary *dict = @{@"sms_type":@"login",@"username":phonbe.text};
    
    [manager POST:_strurl2 parameters:_dict2 progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"发送验证码成功");
            timeDown = 59;
            [self handleTimer];
            timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
            [MBProgressHUD showToastToView:self.view withText:@"验证码发送成功"];
            //            [LoadingView stopAnimating];
            //            LoadingView.hidden = YES;
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
/*手机号码验证 MODIFIED BY LYH*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex =@"^1[3,8]\\d{9}|14[5,7,9]\\d{8}|15[^4]\\d{8}|17[^2,4,9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
- (void)openxieyi
{
    yonghuxieyiwebViewController *xieyi = [yonghuxieyiwebViewController new];
    [self presentViewController:xieyi animated:YES completion:nil];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == mimatext) {
        NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
            unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
            // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57 && character < 65) return NO; //
            if (character > 90 && character < 97) return NO;
            if (character > 122) return NO;
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 16) {
            return NO;//限制长度
        }
        return YES;
    }
    return YES;
}
#pragma mark - 登录
- (void)Log
{
    if (phonbe.text.length==0) {
        [MBProgressHUD showToastToView:self.view withText:@"手机号不能为空"];
    }else if (yanzhengmatextfield.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"验证码不能为空"];
    }else if (phonbe.text.length==0&&yanzhengmatextfield.text.length==0) {
        [MBProgressHUD showToastToView:self.view withText:@"手机号不能为空"];
    }else{
        //[LoadingView startAnimating];
        _dict = [[NSDictionary alloc] init];
        _strurl = [API stringByAppendingString:@"site/login_verify"];
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        if ([userdefaults objectForKey:@"registrationID"]==nil){
            _dict = @{@"username":phonbe.text,@"mobile_vcode":yanzhengmatextfield.text,@"phone_type":@"2"};
        }else{
            _dict = @{@"username":phonbe.text,@"mobile_vcode":yanzhengmatextfield.text,@"phone_name":[userdefaults objectForKey:@"registrationID"],@"phone_type":@"2"};
        }
        
        
        [self GeneralButtonAction1];
    }
}
- (void)GeneralButtonAction1{
    //初始化进度框，置于当前的View当中
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"登录中,请稍后...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    //细节文字
    //_HUD.detailsLabelText = @"请耐心等待";
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        //sleep(3);
        [self CreatePost];
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
#pragma  mark - textField delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击空白");
    [yanzhengmatextfield resignFirstResponder];
    [phonbe resignFirstResponder];
    [yaoqingmatextfield resignFirstResponder];
}
- (void)downshoushi{
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    
    UITextField * field3=(UITextField *)[self.view viewWithTag:1001];
    UITextField * field4=(UITextField *)[self.view viewWithTag:1002];
    UITextField * field5=(UITextField *)[self.view viewWithTag:1003];
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        
        
        NSLog(@"swipe down");
        
        [field5 resignFirstResponder];
        [field4 resignFirstResponder];
        [field3 resignFirstResponder];
    }
}
#pragma mark - 验证码登录
- (void)yanzhengmalog
{
    yanzhengmalogViewController *yanzhengmalog = [[yanzhengmalogViewController alloc] init];
    [self presentViewController:yanzhengmalog animated:YES completion:nil];
    
    
}
#pragma mark - 去注册
- (void)rigClick
{
    RigistViewController *rig = [[RigistViewController alloc] init];
    rig.hidesBottomBarWhenPushed = YES;
    [self presentViewController:rig animated:YES completion:nil];
}
#pragma mark - 联网请求
- (void)CreatePost
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:_strurl parameters:_dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"登录成功");
            
            [MBProgressHUD showToastToView:self.view withText:@"登录成功"];
//            [LoadingView stopAnimating];
//            LoadingView.hidden = YES;
            //存储用户信息
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:phonbe.text forKey:@"username"];
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
            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSString *community = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"community_id"]];
            if ([community isEqualToString:@"0"]||[community isEqualToString:@""]) {
                [self gengxinxiaoquid];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logsusess" object:nil userInfo:nil];
        }else{
            [LoadingView stopAnimating];
            LoadingView.hidden = YES;
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LoadingView stopAnimating];
        LoadingView.hidden = YES;
        NSLog(@"failure--%@",error);
    }];
}

#pragma mark - 显示密码与否
- (void)surcebutclick:(UIButton *)button
{
    if (button.tag==1) {
        surcebut2.hidden = NO;
        surcebut1.hidden = YES;
        mimatext.secureTextEntry = YES;
    }else{
        surcebut1.hidden = NO;
        surcebut2.hidden = YES;
        mimatext.secureTextEntry = NO;
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
