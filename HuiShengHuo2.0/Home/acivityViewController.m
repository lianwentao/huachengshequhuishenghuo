//
//  acivityViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/4.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "acivityViewController.h"
#import <AFNetworking.h>
#import "acivityTableViewCell.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "activitydetailsViewController.h"
#import "UITableView+PlaceHolderView.h"
#import "LoginViewController.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
#import "fuwudingdanViewController.h"
#import "huodongwebviewViewController.h"
@interface acivityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_DataArr;
    UITableView *_TableView;
}

@end

@implementation acivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"社区活动";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self Createtableview];
    //[self createrightbutton];
    
    if ([_jpushstring isEqualToString:@"jpush"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    // Do any additional setup after loading the view.
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
- (void)createrightbutton
{
    //自定义一个导航条右上角的一个button
    UIImage *issueImage = [UIImage imageNamed:@"icon_center_fuwu-2"];
    
    UIButton *issueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    issueButton.frame = CGRectMake(0, 0, 30, 30);
    [issueButton setBackgroundImage:issueImage forState:UIControlStateNormal];
    issueButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [issueButton addTarget:self action:@selector(issueBton) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
}
- (void)issueBton
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        fuwudingdanViewController *fuwudingdan = [[fuwudingdanViewController alloc] init];
        fuwudingdan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fuwudingdan animated:YES];
    }
}
- (void)back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"m_id":[user objectForKey:@"community_id"],@"hui_community_id":[user objectForKey:@"community_id"]};
    NSString *strurl = [API stringByAppendingString:_url];
    NSLog(@"----------------------------%@",strurl);
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
         NSLog(@"hahahahahsuccess--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1){
            _DataArr = [responseObject objectForKey:@"data"];
            self.title = [[_DataArr objectAtIndex:0] objectForKey:@"c_name"];
        }else{
            _DataArr = nil;
        }
        [_TableView reloadData];
        [_TableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)Createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [self.view addSubview:_TableView];
    _TableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    //_TableView.enablePlaceHolderView = YES;
    _TableView.separatorStyle = UITableViewCellEditingStyleNone;
    //_TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(post)];
    //上拉刷新
    //_TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
    __weak typeof(self) weakSelf = self;
    _TableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [_TableView.mj_header beginRefreshing];
}
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [self post];
    });
}
#pragma mark - TableView 占位图
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"pinglunweikong"];
}

- (NSString *)xy_noDataViewMessage {
    return @"暂无数据";
}
- (UIColor *)xy_noDataViewMessageColor {
    return [UIColor blackColor];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataArr.count;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20+45+(kScreen_Width-20)/(2.5);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    // 从重用队列里查找可重用的cell
    acivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (cell==nil) {
        cell = [[acivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.labeltitle.text = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *strurl = [API_img stringByAppendingString:[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"picture"]];
    NSLog(@"%@",strurl);
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
    //[cell.canyubut addTarget:self action:@selector(activtydetails:) forControlEvents:UIControlEventTouchUpInside];
    cell.canyubut.tag = [[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *outside_url = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"outside_url"];
    if ([outside_url isEqualToString:@""]) {
        activitydetailsViewController *acdetails = [[activitydetailsViewController alloc] init];
        acdetails.hidesBottomBarWhenPushed = YES;
        NSString *id = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
        acdetails.url = [NSString stringWithFormat:@"activity/activity_details/id/%@",id];
        [self.navigationController pushViewController:acdetails animated:YES];
    }else{
        huodongwebviewViewController *web = [[huodongwebviewViewController alloc] init];
        web.url = outside_url;
        web.title = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"title"];
        [self.navigationController pushViewController:web animated:YES];
        
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
