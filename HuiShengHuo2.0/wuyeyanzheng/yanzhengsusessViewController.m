//
//  yanzhengsusessViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/25.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "yanzhengsusessViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"

#import "PrefixHeader.pch"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface yanzhengsusessViewController ()

@end

@implementation yanzhengsusessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询成功";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createui];
    // Do any additional setup after loading the view.
}
- (void)createui
{
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10, 100, screen_Width-20, 150)];
    backview.backgroundColor = [UIColor redColor];
    backview.alpha = 1;
    backview.layer.cornerRadius = 15;
    [backview.layer setMasksToBounds:YES];
    
    backview.layer.borderWidth = 0.5;
    backview.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.view addSubview:backview];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screen_Width-20-30, 30)];
    label1.text = [_dic objectForKey:@"community_name"];
    label1.textColor = [UIColor whiteColor];
    [backview addSubview:label1];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, screen_Width-50, 25)];
    NSString *unit = [NSString stringWithFormat:@"%@单元",[_dic objectForKey:@"unit"]];
    NSString *string = [NSString stringWithFormat:@"%@-%@-%@",[_dic objectForKey:@"building_name"],unit,[_dic objectForKey:@"code"]];
    label2.textColor = [UIColor whiteColor];
    label2.text = string;
    [backview addSubview:label2];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 75, screen_Width, 20)];
    lineview.backgroundColor = [UIColor whiteColor];
    [backview addSubview:lineview];
    
    UIView *whiteview = [[UIView alloc] initWithFrame:CGRectMake(0, 80, screen_Width, 70)];
    whiteview.backgroundColor = [UIColor whiteColor];
    whiteview.alpha = 1;
    whiteview.layer.cornerRadius = 15;
    [whiteview.layer setMasksToBounds:YES];
    [backview addSubview:whiteview];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screen_Width-20-30, 30)];
    label3.text = [_dic objectForKey:@"name"];
    label3.textColor = [UIColor blackColor];
    [whiteview addSubview:label3];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, screen_Width-20-30, 30)];
    if ([[_dic objectForKey:@"mp1"] isKindOfClass:[NSNull class]]||[[_dic objectForKey:@"mp1"] isEqualToString:@""]) {
        label4.text = @"未预留手机号";
    }else{
        label4.text = [_dic objectForKey:@"mp1"];
    }
    label3.textColor = [UIColor blackColor];
    [whiteview addSubview:label4];
    
    UIButton *yanzhnegbut = [UIButton buttonWithType:UIButtonTypeCustom];
    yanzhnegbut.clipsToBounds=YES;
    yanzhnegbut.layer.cornerRadius=30;//圆角
    yanzhnegbut.frame = CGRectMake(15, 310, self.view.frame.size.width-30, 60);
    [yanzhnegbut setTitle:@"绑定" forState:UIControlStateNormal];
    yanzhnegbut.backgroundColor = [UIColor redColor];
    [yanzhnegbut addTarget:self action:@selector(yanzheng) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yanzhnegbut];
}
- (void)yanzheng
{
    [self post];
}
#pragma mark ----联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSString *community_id = [_dic objectForKey:@"community_id"];
    NSString *community_name = [_dic objectForKey:@"community_name"];
    NSString *company_id = [_dic objectForKey:@"company_id"];
    NSString *company_name = [_dic objectForKey:@"company_name"];
    NSString *department_id = [_dic objectForKey:@"department_id"];
    NSString *department_name = [_dic objectForKey:@"department_name"];
    NSString *building_id = [_dic objectForKey:@"building_id"];
    NSString *building_name = [_dic objectForKey:@"building_name"];
    NSString *unit = [_dic objectForKey:@"unit"];
    NSString *floor = [_dic objectForKey:@"floor"];
    NSString *code = [_dic objectForKey:@"code"];
    NSString *room_id = [_dic objectForKey:@"room_id"];
    NSString *fullname = [_dic objectForKey:@"name"];
    NSString *mobile = [_dic objectForKey:@"mp1"];
    
    NSDictionary *dict = @{@"community_id":community_id,@"community_name":community_name,@"company_id":company_id,@"company_name":company_name,@"department_id":department_id,@"department_name":department_name,@"building_id":building_id,@"building_name":building_name,@"unit":unit,@"floor":floor,@"code":code,@"room_id":room_id,@"fullname":fullname,@"mobile":mobile,@"hui_community_id":community_id};
  
    NSString *urlstr = [API stringByAppendingString:@"property/pro_bind_user"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults removeObjectForKey:@"is_bind_property"];
            NSString *is_bind_property = @"2";
            [userdefaults setObject:is_bind_property forKey:@"is_bind_property"];
            [userdefaults synchronize];
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
