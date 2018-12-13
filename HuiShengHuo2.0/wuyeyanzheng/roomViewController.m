//
//  roomViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/25.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "roomViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "Person.h"
#import "BMChineseSort.h"
#import "danyuanViewController.h"
#import "FacePayViewController.h"
#import "yanzhengjiaofeiViewController.h"
#import "PrefixHeader.pch"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height

@interface roomViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_DataArr;
    UITableView *_Tableview;
}

@end

@implementation roomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择房号";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self post];
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _Tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height) ];
    _Tableview.estimatedRowHeight = 0;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _Tableview.tableHeaderView = view;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
    _Tableview.tableFooterView = view1;
    _Tableview.delegate = self;
    _Tableview.dataSource = self;
    [self.view addSubview:_Tableview];
}
#pragma mark - UITableView -

//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _DataArr.count;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    NSString *string = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"code"];
    cell.textLabel.text = string;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *string = [NSString stringWithFormat:@"%@%@",_address,[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"code"]];
    NSLog(@"%@__%@____%@",string,_community_id,_community_name);
    NSDictionary *dict = @{@"address":string,@"community_id":_community_id,@"community_name":_community_name,@"building_id":_build_id,@"build_name":_build_name,@"units":[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"unit"],@"room_id":[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"],@"company_id":_company_id,@"company_name":_company_name,@"department_id":_department_id,@"department_name":_department_name,@"floor":[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"floors"],@"code":[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"code"]};
    
    NSLog(@"--%@",_biaoshi);
    if (![_biaoshi isEqualToString:@"jiaofei"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changetextfield" object:nil userInfo:dict];
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[FacePayViewController class]]) {
                
                FacePayViewController *facepay = (FacePayViewController *)controller;
                [self.navigationController popToViewController:facepay animated:YES];
            }
        }
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changetextfieldyanzheng" object:nil userInfo:dict];
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[yanzhengjiaofeiViewController class]]) {
                
                yanzhengjiaofeiViewController *yanzheng = (yanzhengjiaofeiViewController *)controller;
                [self.navigationController popToViewController:yanzheng animated:YES];
            }
        }
    }
}
#pragma mark ----联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
    NSDictionary *dict = @{@"community_id":_community_id,@"building_id":_build_id,@"units":_lou,@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
    NSString *urlstr = [API stringByAppendingString:@"property/get_pro_room"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _DataArr = [[NSMutableArray alloc] init];
        
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
        }else if ([[responseObject objectForKey:@"status"] integerValue]==2){
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            [userinfo removeObjectForKey:@"username"];
            [userinfo removeObjectForKey:@"phone_type"];
            [userinfo removeObjectForKey:@"uid"];
            [userinfo removeObjectForKey:@"pwd"];
            [userinfo removeObjectForKey:@"is_bind_property"];
            [userinfo removeObjectForKey:@"Cookie"];
            [userinfo removeObjectForKey:@"is_new"];
            [userinfo removeObjectForKey:@"token"];
            [userinfo removeObjectForKey:@"tokenSecret"];
            NSHTTPCookieStorage *manager = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (NSHTTPCookie *cookie in cookieStorage) {
                [manager deleteCookie:cookie];
            }
//            [self logout];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_Tableview reloadData];
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
