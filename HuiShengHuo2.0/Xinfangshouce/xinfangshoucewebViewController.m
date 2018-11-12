//
//  xinfangshoucewebViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/27.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "xinfangshoucewebViewController.h"
#import "WebViewJavascriptBridge.h"
@interface xinfangshoucewebViewController ()<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *wkwebview;
}
@end

@implementation xinfangshoucewebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    wkwebview = [[WKWebView alloc] init];
    wkwebview.frame = CGRectMake(0, 0, Main_width, Main_Height);
    wkwebview.UIDelegate = self;
    wkwebview.navigationDelegate = self;
    [self.view addSubview:wkwebview];
    
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [wkwebview loadRequest:request];
    // Do any additional setup after loading the view.
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
