//
//  sfHuoDongDetailViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/17.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "sfHuoDongDetailViewController.h"
#import <AFNetworking.h>
#import "WKWebViewJavascriptBridge.h"
@interface sfHuoDongDetailViewController ()<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *wkwebview;
    
}
@property (nonatomic, strong) UIProgressView *progressView;


@end

@implementation sfHuoDongDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"售房小贴士";

    [self loadData];
}
-(void)loadData{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"house_type":@"2"};
    
    NSLog(@"dict = %@",dict);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSLog(@"dict = %@",dict);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *strurl = [API stringByAppendingString:@"secondHouseType/getCareful"];
    NSLog(@"strurl = %@",strurl);
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"gouwuche--%@",responseObject);
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        
        NSDictionary *dataDic = responseObject[@"data"];
        NSString *textStr = [dataDic objectForKey:@"content"];

        NSData *data1 = [[NSData alloc] initWithBase64EncodedString:textStr options:0];
        NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
        
        UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
        [webview loadHTMLString:labeltext baseURL:nil];
        [self.view addSubview:webview];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}


@end
