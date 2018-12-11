//
//  fuwusearchresultViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/11.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fuwusearchresultViewController.h"

@interface fuwusearchresultViewController ()

@end

@implementation fuwusearchresultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getdata];
    // Do any additional setup after loading the view.
}
- (void)getdata
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],_canshu:_key};
    NSString *strurl = [API_NOAPK stringByAppendingString:_url];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WBLog(@"---%@--%@--%@--%@",responseObject,[responseObject objectForKey:@"msg"],_key,_canshu);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
        }else{
            
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
