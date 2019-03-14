//
//  changenameViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/30.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "changenameViewController.h"
#import <AFNetworking.h>

#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"

@interface changenameViewController ()
{
    UITextField *textfiled;
    NSDictionary *dict;
    NSString *urlstr;
}

@end

@implementation changenameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self createtextfiled];
    // Do any additional setup after loading the view.
}
- (void)createtextfiled
{
    NSLog(@"%@",_name);
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, rectStatus.size.height+50, kScreen_Width, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    textfiled = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width-30, 50)];
    textfiled.text = _name;
    textfiled.textColor = [UIColor blackColor];
    textfiled.backgroundColor = [UIColor whiteColor];
    [view addSubview:textfiled];
    
    [self addRightBtn];
}
#pragma mark - 导航栏rightbutton
- (void)addRightBtn
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(tijiao)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)tijiao
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    dict = [[NSDictionary alloc] init];
    if ([self.title isEqualToString:@"修改姓名"]) {
        dict = @{@"fullname":textfiled.text,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }if ([self.title isEqualToString:@"修改昵称"]){
        dict = @{@"nickname":textfiled.text,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    }
    [self post];
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    urlstr = [API stringByAppendingString:@"userCenter/edit_center"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSDictionary *dic =  [NSDictionary dictionaryWithObject:textfiled.text forKey:@"name"];
            if ([self.title isEqualToString:@"修改姓名"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeinfomationfullname" object:nil userInfo:dic];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeinfomationnickname" object:nil userInfo:dic];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"修改失败");
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
