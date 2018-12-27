//
//  afteryanzhengViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/8/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "afteryanzhengViewController.h"
#import "yanzhengjiaofeiViewController.h"
#import "newwuyejiaofeijiluViewController.h"
#import "jiaofeixiangqingViewController.h"
#import <AFNetworking.h>
#import "wuyeqianfeiViewController.h"

@interface afteryanzhengViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    
    NSArray *_DataArr;
}

@end

@implementation afteryanzhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BackColor;
    self.title = @"我的房屋";
    
    [self createtableview];
    [self createrightbutton];
    
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"shuaxinmyhome" object:nil];
    // Do any additional setup after loading the view.
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
- (void)change
{
    [self getData];
}
- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/binding_community"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _DataArr = [[NSArray alloc] init];
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
//            _DicData = [[NSDictionary alloc] init];
//            _DicData = [responseObject objectForKey:@"data"];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}

- (void)createrightbutton
{
    //自定义一个导航条右上角的一个button
    UIImage *issueImage = [UIImage imageNamed:@"ic_order5"];
    
    UIButton *issueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    issueButton.frame = CGRectMake(0, 0, 25, 25);
    [issueButton setBackgroundImage:issueImage forState:UIControlStateNormal];
    issueButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [issueButton addTarget:self action:@selector(issueBton) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
}
- (void)issueBton
{
    newwuyejiaofeijiluViewController *jilu = [[newwuyejiaofeijiluViewController alloc] init];
    [self.navigationController pushViewController:jilu animated:YES];
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.backgroundColor = BackColor;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return _DataArr.count;
    }else{
        return 1;
    }
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 10;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.section==0) {
        tableView.rowHeight = Main_width/2.6;
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_width/2.6)];
        imageview.image = [UIImage imageNamed:@"ic_wy_banner"];
        [cell.contentView addSubview:imageview];
    }else if (indexPath.section==1){
        tableView.rowHeight = 50;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 50)];
        label.font = font18;
        label.text = @"新增房屋";
        [cell.contentView addSubview:label];
    }else{
        tableView.rowHeight = 90;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, Main_width-20, 18)];
        label1.font = font18;
        label1.text = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"community_name"];
        [cell.contentView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 15+15+10, Main_width-20, 30)];
        label2.font = [UIFont systemFontOfSize:13];
        label2.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
        label2.text = [NSString stringWithFormat:@"地址:%@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"address"]];
        [cell.contentView addSubview:label2];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(jiatingchengyuan:) forControlEvents:UIControlEventTouchUpInside];
        but.frame = CGRectMake(Main_width-25-20, 32.5, 25, 25);
        but.tag = indexPath.row;
        [cell.contentView addSubview:but];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        yanzhengjiaofeiViewController *yanzheng = [[yanzhengjiaofeiViewController alloc] init];
        [self.navigationController pushViewController:yanzheng animated:YES];
    }if (indexPath.section==2) {
        NSString *ym = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"is_ym"];
        if ([ym isEqualToString:@"0"]) {
            wuyeqianfeiViewController *qianfei = [[wuyeqianfeiViewController alloc] init];
            qianfei.room_id = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"room_id"];
            [self.navigationController pushViewController:qianfei animated:YES];
        }else{
            jiaofeixiangqingViewController *xiangqing = [[jiaofeixiangqingViewController alloc] init];
            xiangqing.room_id = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"room_id"];
            [self.navigationController pushViewController:xiangqing animated:YES];
        }
    }
}
- (void)jiatingchengyuan:(UIButton *)sender
{
    //初始化警告框
    UIAlertController*alert = [UIAlertController
                               alertControllerWithTitle:@"提示"
                               message: @"是否解除绑定"
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
                          
                          //1.创建会话管理者
                          AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                          manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                          //2.封装参数
                          NSDictionary *dict = nil;
                          NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                          dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"id":[[_DataArr objectAtIndex:sender.tag] objectForKey:@"id"]};
                          NSString *strurl = [API stringByAppendingString:@"property/unsetBinding"];
                          [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              _DataArr = [[NSArray alloc] init];
                              NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
                              if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                                  [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                                  [self getData];
                                  [_TableView reloadData];
                              }else{
                                  [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                              }
                              
                              
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              NSLog(@"failure--%@",error);
                          }];
                      }]];
    //弹出提示框
    [self presentViewController:alert
                       animated:YES completion:nil];
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
