//
//  louhaoViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/25.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "louhaoViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "Person.h"
#import "BMChineseSort.h"
#import "danyuanViewController.h"

#import "PrefixHeader.pch"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface louhaoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_DataArr;
    UITableView *_Tableview;
}
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;
@end

@implementation louhaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择楼号";
    
    NSLog(@"%@",_id);
    [self post];
    [self createtableview];
    // Do any additional setup after loading the view.
}
- (void)createtableview
{
    _Tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height)];
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
    Person *p = [_DataArr objectAtIndex:indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@楼",p.name];
    cell.textLabel.text = string;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Person *p = [_DataArr objectAtIndex:indexPath.row];
    danyuanViewController *danyuan = [[danyuanViewController alloc] init];
    danyuan.community_id = _id;
    danyuan.community_name = _community_name;
    
    danyuan.build_id = p.city_id;
    danyuan.build_name = p.name;
    
    danyuan.units = p.region_id;
    
    danyuan.company_id = _company_id;
    danyuan.company_name = _company_name;
    danyuan.department_id = _department_id;
    danyuan.department_name = _department_name;
    
    NSString *string = [NSString stringWithFormat:@"%@楼",p.name];
    danyuan.address = [NSString stringWithFormat:@"%@%@",_address,string];
    danyuan.lou = p.name;
    
    danyuan.biaoshi = _biaoshi;
    [self.navigationController pushViewController:danyuan animated:YES];
}

#pragma mark ----联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
    NSDictionary *dict = @{@"community_id":_id,@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
    
    NSString *urlstr = [API stringByAppendingString:@"property/get_pro_building"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"*****%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        _DataArr = [[NSMutableArray alloc] init];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        arr = [responseObject objectForKey:@"data"];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            for (int i = 0; i<[arr count]; i++) {
                Person *p = [[Person alloc] init];
                p.name = [[arr objectAtIndex:i] objectForKey:@"name"];
                p.id = [[arr objectAtIndex:i] objectForKey:@"community_id"];
                p.city_id = [[arr objectAtIndex:i] objectForKey:@"id"];
                p.region_id = [[arr objectAtIndex:i] objectForKey:@"units"];
                [_DataArr addObject:p];
            }
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
