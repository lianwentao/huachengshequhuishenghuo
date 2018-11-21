//
//  yanzhengjiaofeiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/8/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "yanzhengjiaofeiViewController.h"
#import "XiaoquViewController.h"
#import "jiaofeixiangqingViewController.h"
#import "wuyeqianfeiViewController.h"
#import "selectshangpuViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
@interface yanzhengjiaofeiViewController ()
{
    UITextField *textfield;
    
    NSString *community_id;
    NSString *building_id;
    NSString *community_name;
    NSString *building_name;
    NSString *code;
    NSString *units;
    NSString *room_id;
    NSString *name;
    NSString *phone;
    NSString *sign;
    NSString *c_name;
    NSString *company_id;
    NSString *company_name;
    NSString *department_id;
    NSString *department_name;
    NSString *floor;
    
    NSString *fullname;
    NSString *mobeil;
    NSString *is_ym;
    
    UILabel *label;
    
}

@end

@implementation yanzhengjiaofeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BackColor;
    self.title = @"缴费";
    
    [self createui];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"changetextfieldyanzheng" object:nil];
    // Do any additional setup after loading the view.
}
- (void)change:(NSNotification *)userinfo
{
    NSLog(@"--dizhi%@",userinfo.userInfo[@"address"]);
    //houselabel.text = userinfo.userInfo[@"address"];
    //@"community_id":_community_id,@"building_id":_build_id,@"units":@"",@"room_id":[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"code"]
    community_id = userinfo.userInfo[@"community_id"];
    community_name = userinfo.userInfo[@"community_name"];
    building_id = userinfo.userInfo[@"building_id"];
    building_name = userinfo.userInfo[@"build_name"];
    units = userinfo.userInfo[@"units"];
    room_id = userinfo.userInfo[@"room_id"];
    code = userinfo.userInfo[@"code"];
    company_id = userinfo.userInfo[@"company_id"];
    company_name = userinfo.userInfo[@"company_name"];
    department_id = userinfo.userInfo[@"department_id"];
    department_name = userinfo.userInfo[@"department_name"];
    floor = userinfo.userInfo[@"floor"];
    
    
    label.text = userinfo.userInfo[@"address"];
   // [self post];
}
- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"room_id":room_id,@"key_str":textfield.text,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/getPersonalInfo"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            fullname = [[responseObject objectForKey:@"data"] objectForKey:@"name"];
            mobeil = [[responseObject objectForKey:@"data"] objectForKey:@"mp1"];
            is_ym = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"is_ym"]];
            [self bangding];

        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)bangding
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"community_id":community_id,@"community_name":community_name,@"company_id":company_id,@"company_name":company_name,@"department_id":department_id,@"department_name":department_name,@"building_id":building_id,@"building_name":building_name,@"unit":units,@"floor":floor,@"code":code,@"room_id":room_id,@"fullname":fullname,@"mobile":mobeil,@"is_ym":is_ym};
    NSString *strurl = [API stringByAppendingString:@"property/pro_bind_user"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            if ([is_ym isEqualToString:@"0"]) {
                wuyeqianfeiViewController *qianfei = [[wuyeqianfeiViewController alloc] init];
                qianfei.room_id = room_id;
                [self.navigationController pushViewController:qianfei animated:YES];
            }else{
                jiaofeixiangqingViewController *xiangqing = [[jiaofeixiangqingViewController alloc] init];
                xiangqing.room_id = room_id;
                xiangqing.biaoshi = @"1";//1表示删除这个界面
                [self.navigationController pushViewController:xiangqing animated:YES];
            }
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)createui
{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 10+RECTSTATUS.size.height+40, Main_width, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 50)];
    label.text = @"请选择房屋";
    label.font = font15;
    label.alpha = 0.3;
    [view1 addSubview:label];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, Main_width, 50);
    [but addTarget:self action:@selector(selectehouse) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:but];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 70+RECTSTATUS.size.height+40, Main_width, 50)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    
    textfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, Main_width-60-10, 50)];
    textfield.placeholder = @"请输入业主姓名或手机号";
    textfield.font = [UIFont systemFontOfSize:15];
    [view2 addSubview:textfield];
    
    UIButton *yanzhengbut = [UIButton buttonWithType:UIButtonTypeCustom];
    yanzhengbut.frame = CGRectMake(Main_width-60, 10, 50, 30);
    yanzhengbut.backgroundColor = [UIColor colorWithRed:255/255.0 green:92/255.0 blue:34/255.0 alpha:1];
    [yanzhengbut setTitle:@"验证" forState:UIControlStateNormal];
    yanzhengbut.layer.cornerRadius = 2;
    [yanzhengbut.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [yanzhengbut addTarget:self action:@selector(yanzheng) forControlEvents:UIControlEventTouchUpInside];
    [yanzhengbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view2 addSubview:yanzhengbut];
}
- (void)yanzheng
{
    if (room_id == nil) {
        [MBProgressHUD showToastToView:self.view withText:@"请选择房屋"];
    }else if ([textfield.text isEqualToString:@""]){
        [MBProgressHUD showToastToView:self.view withText:@"请输入姓名或者手机号"];
    }else{
        [self getData];
    }
}
- (void)selectehouse
{
    XiaoquViewController *xiaoqu = [[XiaoquViewController alloc] init];
    xiaoqu.biaojistr = @"yezhu";
    xiaoqu.jiaofei = @"jiaofei";
    [self.navigationController pushViewController:xiaoqu animated:YES];
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
