//
//  joinViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/20.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "joinViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+TVAssistant.h"

#import "PrefixHeader.pch"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface joinViewController ()

@end

@implementation joinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"参与的服务";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self post];
    // Do any additional setup after loading the view.
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
  
    NSString *urlstr = [API stringByAppendingString:@"userCenter/my_service_menu"];
    [manager POST:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
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
