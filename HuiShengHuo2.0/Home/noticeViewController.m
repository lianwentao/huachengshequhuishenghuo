//
//  noticeViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/7.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "noticeViewController.h"

@interface noticeViewController ()

@end

@implementation noticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通告详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    UIWebView *webview = [[UIWebView alloc] init];
    webview.frame = self.view.frame;
    [self.view addSubview:webview];
    NSString *string = [NSString stringWithFormat:@"property/notice_details/id/%@",_id];
  
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API,string]];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    // Do any additional setup after loading the view.
}
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
