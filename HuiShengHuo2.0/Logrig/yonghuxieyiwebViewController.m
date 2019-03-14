//
//  yonghuxieyiwebViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/25.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "yonghuxieyiwebViewController.h"

@interface yonghuxieyiwebViewController ()<UIWebViewDelegate>

@end

@implementation yonghuxieyiwebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createdaohangolan];
    [self readDocfile];
    // Do any additional setup after loading the view.
}
#pragma mark - 自定义导航栏
- (void)createdaohangolan
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    but.frame = CGRectMake(10, 10+rectStatus.size.height, 50, 35);
    [but setTitle:@"返回" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:but];
    [but addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10+rectStatus.size.height, Main_width, 35)];
    label.text = @"用户协议";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
}
- (void)cancle
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)readDocfile{
    //NSString * ducumentLocation = [[NSBundle mainBundle]pathForResource:@"协议" ofType:@"docx"];
    
    NSURL *url = [NSURL URLWithString:[API stringByAppendingString:@"userCenter/user_agreement"]];
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-44-RECTSTATUS.size.height)];
    webView.delegate = self;
    webView.multipleTouchEnabled = YES;
    webView.scalesPageToFit = YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
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
