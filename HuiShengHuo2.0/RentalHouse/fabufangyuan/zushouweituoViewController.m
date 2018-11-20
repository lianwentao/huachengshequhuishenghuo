//
//  zushouweituoViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/15.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "zushouweituoViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "fabuzufangViewController.h"
#import "fabushoufangViewController.h"
@interface zushouweituoViewController ()<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *wkwebview;
    
}

@end

@implementation zushouweituoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"租售委托";
    self.view.backgroundColor = [UIColor whiteColor];
    
    wkwebview = [[WKWebView alloc] init];
    wkwebview.frame = CGRectMake(0, RECTSTATUS.size.height+44, Main_width, Main_Height-RECTSTATUS.size.height-44-60);
    wkwebview.UIDelegate = self;
    wkwebview.navigationDelegate = self;
    [self.view addSubview:wkwebview];
    
    NSURL *url = [NSURL URLWithString:@"http://test.hui-shenghuo.cn/apk41/secondHouseType/secondHouseType"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [wkwebview loadRequest:request];
    
    
    [self setUI];
    // Do any additional setup after loading the view.
}
- (void)setUI
{
    UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height-60, Main_width, 60)];
    [self.view addSubview:bottomview];
    
    CGFloat width = (Main_width-20-40)/2;
    NSArray *arr1 = @[@"发布售房信息",@"发布租房信息"];
    NSArray *arr2 = @[[UIColor colorWithRed:255/255.0 green:143/255.0 blue:34/255.0 alpha:1],[UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1]];
    for (int i=0; i<2; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(10+width*i+40*i, 10, width, 40);
        [but setTitle:[arr1 objectAtIndex:i] forState:UIControlStateNormal];
        but.backgroundColor = [arr2 objectAtIndex:i];
        but.titleLabel.font = [UIFont systemFontOfSize:20];
        but.layer.cornerRadius = 5;
        but.tag = i;
        [but addTarget:self action:@selector(fabu:) forControlEvents:UIControlEventTouchUpInside];
        [bottomview addSubview:but];
    }
}
- (void)fabu:(UIButton *)sender
{
    if (sender.tag == 0) {
        fabushoufangViewController *shoufang = [[fabushoufangViewController alloc] init];
        [self.navigationController pushViewController:shoufang animated:YES];
    }else{
        fabuzufangViewController *zufang = [[fabuzufangViewController alloc] init];
        [self.navigationController pushViewController:zufang animated:YES];
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
