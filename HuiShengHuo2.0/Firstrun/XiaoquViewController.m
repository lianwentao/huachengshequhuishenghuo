//
//  XiaoquViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/23.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "XiaoquViewController.h"
#import "FirstRunViewController.h"
#import <AFNetworking.h>
#import "Person.h"
#import "BMChineseSort.h"
#import "edAddressViewController.h"
#import "louhaoViewController.h"
#import "HomeViewController.h"


#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
#import "PrefixHeader.pch"

@interface XiaoquViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_Tableview;
    NSMutableArray *_Dataarr;
    NSMutableArray *arr;
    
    UILabel *locationlabel;
    
    NSString *_strurl;
    
    NSString *location_region_name;
    NSString *location_region_id;
}

//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;


@end

@implementation XiaoquViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地区";
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationController.delegate=self;
    if ([_first isEqualToString:@"1"]) {
        [self.navigationItem setHidesBackButton:YES];
    }
    
    [self post];
    [self createtableview];
    
    
    //[self Createdaohanglan];
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


#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    //NSLog(@"===%@",_region_id);
    //3.发送GET请求
    /*
     第一个参数:请求路径(NSString)+ 不需要加参数
     第二个参数:发送给服务器的参数数据
     第三个参数:progress 进度回调
     第四个参数:success  成功之后的回调(此处的成功或者是失败指的是整个请求)
     task:请求任务
     responseObject:注意!!!响应体信息--->(json--->oc))
     task.response: 响应头信息
     第五个参数:failure 失败之后的回调
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
    NSString *API = [defaults objectForKey:@"API"];
    if ([_biaojistr isEqualToString:@"yezhu"]) {
//        _strurl = [API stringByAppendingString:@"property/get_pro_com"];
        _strurl = [API stringByAppendingString:@"site/get_community/city/418"];
    }else{
        _strurl = [API stringByAppendingString:@"site/get_community/city/418"];
    }
    [manager POST:_strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        _Dataarr = [[NSMutableArray alloc] initWithCapacity:0];
        arr = [[NSMutableArray alloc] init];
        arr = [responseObject objectForKey:@"data"];
        for (int i = 0; i<[arr count]; i++) {
            Person *p = [[Person alloc] init];
            p.name = [[arr objectAtIndex:i] objectForKey:@"name"];
            p.city_id = [[arr objectAtIndex:i] objectForKey:@"city_id"];
            p.region_id = [[arr objectAtIndex:i] objectForKey:@"region_id"];
            p.id = [[arr objectAtIndex:i] objectForKey:@"id"];
            p.company_id = [[arr objectAtIndex:i] objectForKey:@"company_id"];
            p.company_name = [[arr objectAtIndex:i] objectForKey:@"company_name"];
            p.department_id = [[arr objectAtIndex:i] objectForKey:@"department_id"];
            p.department_name = [[arr objectAtIndex:i] objectForKey:@"department_name"];
            p.is_new = [[arr objectAtIndex:i] objectForKey:@"is_new"];
            [_Dataarr addObject:p];
        }
        //根据Person对象的 name 属性 按中文 对 Person数组 排序
        self.indexArray = [BMChineseSort IndexWithArray:_Dataarr Key:@"name"];
        self.letterResultArr = [BMChineseSort sortObjectArray:_Dataarr Key:@"name"];
        [_Tableview reloadData];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - UITableView -
//section的titleHeader
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.indexArray objectAtIndex:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
}
//section右侧index数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
        Person *p = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = p.name;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    Person *p = [[_letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *str = p.name;
    if ([userinfo objectForKey:@"community_name"]==nil) {
        //初始化警告框
        UIAlertController*alert = [UIAlertController
                                   alertControllerWithTitle: @"提示"
                                   message: @"选择小区后，仅显示本小区的商品和购物车信息，首页顶部可重新选择小区"
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"取消"
                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              
                          }]];
        [alert addAction:[UIAlertAction
                          actionWithTitle:@"确定"
                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                          {
                              // 存储数据
                              [userinfo setObject:str forKey:@"community_name"];
                              [userinfo setObject:p.id forKey:@"community_id"];
                              [userinfo setObject:p.is_new forKey:@"is_new"];
                              // 立刻同步
                              [userinfo synchronize];
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil userInfo:nil];
                              [self.navigationController popToRootViewControllerAnimated:YES];
                          }]];
        //弹出提示框
        [self presentViewController:alert
                           animated:YES completion:nil];
    }else {
        if ([_biaojistr isEqualToString:@"1"]) {
            NSDictionary *dict = @{@"xiaoqu":str,@"city_id":p.city_id,@"id":p.id,@"region_id":p.region_id};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changexiaoquaddrss" object:nil userInfo:dict];
//            edAddressViewController *edaddress = self.navigationController.viewControllers[2];
//            [self.navigationController popToViewController:edaddress animated:YES];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                if ([controller isKindOfClass:[edAddressViewController class]]) {
                    edAddressViewController *edaddress = (edAddressViewController *)controller;
                    [self.navigationController popToViewController:edaddress animated:YES];
                }
            }
        }if ([_biaojistr isEqualToString:@"yezhu"]){
            louhaoViewController *louhao = [[louhaoViewController alloc] init];
            Person *p = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            louhao.id = p.id;
            louhao.address = p.name;
            louhao.community_name = p.name;
            
            louhao.company_id = p.company_id;
            louhao.company_name = p.company_name;
            louhao.department_id = p.department_id;
            louhao.department_name = p.department_name;
            
            louhao.biaoshi = _jiaofei;
            [self.navigationController pushViewController:louhao animated:YES];
        }if ([_biaojistr isEqualToString:@"0"]) {
            UIAlertController*alert = [UIAlertController
                                       alertControllerWithTitle: @"提示"
                                       message: @"选择小区后，仅显示本小区的商品和购物车信息，首页顶部可重新选择小区"
                                       preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction
                              actionWithTitle:@"取消"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                                  
                              }]];
            [alert addAction:[UIAlertAction
                              actionWithTitle:@"确定"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                              {
                                  // 存储数据
                                  [userinfo setObject:str forKey:@"community_name"];
                                  [userinfo setObject:p.id forKey:@"community_id"];
                                  [userinfo setObject:p.is_new forKey:@"is_new"];
                                  // 立刻同步
                                  [userinfo synchronize];
                                  NSLog(@"%@",[userinfo objectForKey:@"community_name"]);
                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"changetitle" object:nil userInfo:nil];
                                  [self.navigationController popToRootViewControllerAnimated:YES];
                              }]];
            //弹出提示框
            [self presentViewController:alert
                               animated:YES completion:nil];
            
        }
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
