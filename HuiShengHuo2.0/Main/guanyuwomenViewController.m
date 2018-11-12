//
//  guanyuwomenViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/6.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "guanyuwomenViewController.h"

@interface guanyuwomenViewController ()

@end

@implementation guanyuwomenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
    UIWebView *webview = [[UIWebView alloc] init];
    webview.frame = self.view.frame;
    [self.view addSubview:webview];
    NSString *string = @"userCenter/about_us";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API,string]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
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
