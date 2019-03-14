//
//  fuwudingdanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/5.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "fuwudingdanViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "PrefixHeader.pch"
#import "MBProgressHUD+TVAssistant.h"
#import "fuwudingdanTableViewCell.h"
#import "fuwudingdanxiangqingViewController.h"
#import "huodongdingdanViewController.h"
#import "UITableView+PlaceHolderView.h"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface fuwudingdanViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_DataArr;
    NSMutableArray *_DataArr1;
    UIButton *_tmpBtn;
    UITableView *_TableView;
    NSString *_url;
    
    UIImageView *wushujuimageView;
    UILabel *wushujulabel;
    
    UIScrollView *_scrollView;
}

@end

@implementation fuwudingdanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务订单";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self post];
    
    //  any additional setup after loading the view.
}
- (void)createui
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    int j;
    if ([_but_tag isEqualToString:@"1"]) {
        j=1;
    }else if ([_but_tag isEqualToString:@"2"]) {
        j=2;
    }else{
        j=0;
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, screen_Width, 64)];
    _scrollView.delegate = self;//设置代理
    [_scrollView setContentSize:CGSizeMake((screen_Width/4)*_DataArr.count, 64)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = NO;
    [self.view addSubview:_scrollView];
    NSArray *arrrrrrrr = @[[UIColor blackColor],[UIColor blueColor],[UIColor redColor],[UIColor grayColor],[UIColor greenColor]];
    for (int i=0; i<_DataArr.count; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(i*screen_Width/4, 0, screen_Width/4, 64);
        //but.backgroundColor = [arrrrrrrr objectAtIndex:i];
        [but setTitle:[[_DataArr objectAtIndex:i] objectForKey:@"name"] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitleColor:QIColor forState:UIControlStateSelected];
        but.titleLabel.font = [UIFont systemFontOfSize:17];
        but.tag = i;
        [but addTarget:self action:@selector(selectbut:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:but];
        
        if (i==j) {
            but.selected = YES;
            _tmpBtn = but;
        }
    }
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+_scrollView.frame.origin.y, screen_Width, 3)];
    lineview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:lineview];
    
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _scrollView.frame.origin.y+RECTSTATUS.size.height+44+3, screen_Width, screen_Height-(_scrollView.frame.origin.y+RECTSTATUS.size.height+44+3))];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.backgroundColor = HColor(244, 247, 248);
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
    wushujuimageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_Width/2-50, _TableView.frame.size.height/2-100, 100, 100)];
    wushujuimageView.image = [UIImage imageNamed:@"pinglunweikong"];
    wushujuimageView.contentMode = UIViewContentModeScaleAspectFit;
    //imageView.center = _TableView.center;
    //[_TableView addSubview:wushujuimageView];
    
    wushujulabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width/2-150, _TableView.frame.size.height/2-100+120, 300, 40)];
    wushujulabel.textColor = [UIColor grayColor];
    wushujulabel.textAlignment = NSTextAlignmentCenter;
    wushujulabel.text = @"暂无数据^_^";
    //label.center = CGPointMake(_TableView.center.x, _TableView.center.y+80);
    //[_TableView addSubview:wushujulabel];
    
    wushujuimageView.hidden = YES;
    wushujulabel.hidden = YES;
}
- (void)createtableview
{
    
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _DataArr1.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    // 从重用队列里查找可重用的cell
    fuwudingdanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (cell==nil) {
        cell = [[fuwudingdanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSLog(@"%ld",_tmpBtn.tag);
    if (_tmpBtn.tag==0) {
        cell.labeltitle.text = [[_DataArr1 objectAtIndex:indexPath.section] objectForKey:@"type_cn"];
        NSString *timestring = [[_DataArr1 objectAtIndex:indexPath.section] objectForKey:@"addtime"];
        NSTimeInterval interval   =[timestring doubleValue];
        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString = [formatter stringFromDate: date];
        cell.timelabel.text = dateString;
        cell.timelabel.textColor = HColor(187, 187, 187);
        //cell.contentlabel.text = [[_DataArr1 objectAtIndex:indexPath.section] objectForKey:@"description"];
    }else{
        cell.labeltitle.text = [[_DataArr1 objectAtIndex:indexPath.section] objectForKey:@"title"];
        NSString *timestring = [[_DataArr1 objectAtIndex:indexPath.section] objectForKey:@"enroll_end"];
        NSTimeInterval interval   =[timestring doubleValue];
        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString = [formatter stringFromDate: date];
        cell.timelabel.text = dateString;
        cell.timelabel.textColor = HColor(187, 187, 187);
    }
    NSNumber *statusstring = [[_DataArr1 objectAtIndex:indexPath.section] objectForKey:@"status"];
    int i = [statusstring intValue];
    if (i==0) {
        cell.contentlabel.text = @"·未处理";
        cell.contentlabel.textColor = HColor(187, 187, 187);
    }if (i==1){
        cell.contentlabel.text = @"·进行中";
        cell.contentlabel.textColor = HColor(187, 187, 187);
    }if (i==2){
        cell.contentlabel.text = @"·已完成";
        cell.contentlabel.textColor = HColor(187, 187, 187);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_tmpBtn.tag==0) {
        fuwudingdanxiangqingViewController *xiangqing = [[fuwudingdanxiangqingViewController alloc] init];
        xiangqing.id = [[_DataArr1 objectAtIndex:indexPath.section] objectForKey:@"id"];
        xiangqing.nametitle = [[_DataArr1 objectAtIndex:indexPath.section] objectForKey:@"type_cn"];
        [self.navigationController pushViewController:xiangqing animated:YES];
    }else{
        huodongdingdanViewController *huodong = [[huodongdingdanViewController alloc] init];
        huodong.hidesBottomBarWhenPushed = YES;
        huodong.id = [[_DataArr1 objectAtIndex:indexPath.section] objectForKey:@"id"];
        huodong.nametitle = [[_DataArr1 objectAtIndex:indexPath.section] objectForKey:@"title"];
        [self.navigationController pushViewController:huodong animated:YES];
    }
}
- (void)selectbut: (UIButton *)sender
{
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    _url = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"link"];
    [self post1];
}
-(void)post1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *urlstr = [API stringByAppendingString:[NSString stringWithFormat:@"%@",_url]];
    NSLog(@"--%@",urlstr);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        _DataArr1 = [[NSMutableArray alloc] init];
        
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr1 = [responseObject objectForKey:@"data"];
            wushujuimageView.hidden = YES;
            wushujulabel.hidden = YES;
        }else{
            _DataArr1 = nil;
            wushujuimageView.hidden = NO;
            wushujulabel.hidden = NO;
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
    NSDictionary *dict = @{@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
    NSString *API = [defaults objectForKey:@"API"];
    NSString *urlstr = [API stringByAppendingString:@"userCenter/my_service_menu"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _DataArr = [[NSMutableArray alloc] init];
        
        NSLog(@"success服务订单--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
            _url = [[_DataArr objectAtIndex:0] objectForKey:@"link"];
            [self createui];
            [self post1];
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
            _DataArr = nil;
            
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView reloadData];
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
