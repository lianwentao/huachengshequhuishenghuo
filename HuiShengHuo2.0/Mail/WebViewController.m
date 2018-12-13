//
//  WebViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/3.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "WebViewController.h"
#import "CustomActivity.h"
#import "UIImageView+WebCache.h"
#import <AFNetworking.h>
#import "GoodsDetailViewController.h"
#import "WKWebViewJavascriptBridge.h"

#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"

@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>
{
    NSString *_title;
    NSString *_imgstr;
    NSString *_call_link;
    
    WKWebView *wkwebview;
}
@property WKWebViewJavascriptBridge* bridge;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self post];
    wkwebview = [[WKWebView alloc] init];
    wkwebview.frame = self.view.frame;
    wkwebview.UIDelegate = self;
    wkwebview.navigationDelegate = self;
    [self.view addSubview:wkwebview];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.hui-shenghuo.cn/apk/%@",_url]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [wkwebview loadRequest:request];
    
    
    [self createrightbutton];
    
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    
    UIButton *buy = [UIButton buttonWithType:UIButtonTypeCustom];
    buy.frame = CGRectMake(kScreen_Width-90, kScreen_Height-110, 100, 100);
    [buy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buy setImage:[UIImage imageNamed:@"buy"] forState:UIControlStateNormal];
    [buy addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    if ([self.title isEqualToString:@"小慧推荐"]) {
        [wkwebview addSubview:buy];
    }
    
    // Do any additional setup after loading the view.
}
- (void)buy
{
    GoodsDetailViewController *goodsdetail = [[GoodsDetailViewController alloc] init];
    goodsdetail.IDstring = _id;
    [self.navigationController pushViewController:goodsdetail animated:YES];
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSRange range = [_url rangeOfString:@"id/"]; //现获取要截取的字符串位置
    NSString * result = [_url substringFromIndex:range.location]; //截取字符串
    NSString *iddd = result;
    NSDictionary *dict = @{@"type":_url_type};
    
    NSString *strurl = [API stringByAppendingString:[NSString stringWithFormat:@"site/share_return/%@",iddd]];
    NSLog(@"%@",strurl);
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _title = [[responseObject objectForKey:@"data"] objectForKey:@"title"];
            _imgstr = [[responseObject objectForKey:@"data"] objectForKey:@"img"];
            _call_link = [[responseObject objectForKey:@"data"] objectForKey:@"call_link"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)createrightbutton
{
    //自定义一个导航条右上角的一个button
    //UIImage *issueImage = [UIImage imageNamed:@"home_icon_xinxi"];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, 30, 30);
    [but setTitle:@"分享" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    but.titleLabel.font = [UIFont systemFontOfSize:13];
    [but addTarget:self action:@selector(issueBton) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:but];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
}
- (void)issueBton
{
    // 1、设置分享的内容，并将内容添加到数组中
    NSString *shareText = _title;
    NSString *strurl = [NSString stringWithFormat:@"%@%@",API_img,_imgstr];
    UIImageView *imageview = [[UIImageView alloc] init];
    [imageview sd_setImageWithURL:[NSURL URLWithString:strurl]];
    UIImage *shareImage = imageview.image;
    NSURL *shareUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.hui-shenghuo.cn/apk/%@",_url]];
    NSArray *activityItemsArray = @[shareText,shareUrl];
    
    
    // 自定义的CustomActivity，继承自UIActivity
    CustomActivity *customActivity = [[CustomActivity alloc]initWithTitle:@"wangsk" ActivityImage:[UIImage imageNamed:@"app_logo 5"] URL:[NSURL URLWithString:@"http://blog.csdn.net/flyingkuikui"] ActivityType:@"Custom"];
    NSArray *activityArray = @[customActivity];
    
    // 2、初始化控制器，添加分享内容至控制器
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItemsArray applicationActivities:activityArray];
    activityVC.modalInPopover = YES;
    // 3、设置回调
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // ios8.0 之后用此方法回调
        UIActivityViewControllerCompletionWithItemsHandler itemsBlock = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
            NSLog(@"activityType == %@",activityType);
            if (completed == YES) {
                NSLog(@"completed");
            }else{
                NSLog(@"cancel");
            }
        };
        activityVC.completionWithItemsHandler = itemsBlock;
    }else{
        // ios8.0 之前用此方法回调
        UIActivityViewControllerCompletionHandler handlerBlock = ^(UIActivityType __nullable activityType, BOOL completed){
            NSLog(@"activityType == %@",activityType);
            if (completed == YES) {
                NSLog(@"completed");
            }else{
                NSLog(@"cancel");
            }
        };
        activityVC.completionHandler = handlerBlock;
    }
    // 4、调用控制器
    [self presentViewController:activityVC animated:YES completion:nil];
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
