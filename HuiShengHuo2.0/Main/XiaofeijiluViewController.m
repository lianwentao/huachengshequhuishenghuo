//
//  XiaofeijiluViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/30.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "XiaofeijiluViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "xiaofeijiluTableViewCell.h"
#import "UITableView+PlaceHolderView.h"
#import "MJRefresh.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
@interface XiaofeijiluViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    NSMutableArray *_DataArr;
    int _pnum;
}

@end

@implementation XiaofeijiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消费记录";
    _pnum = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self post];
    [self createtableview];
    // Do any additional setup after loading the view.
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
    
    NSString *urlstr = [API stringByAppendingString:@"userCenter/my_wallet"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        _DataArr = [[NSMutableArray alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
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
            //                [self logout];
        }else{
            _DataArr = nil;
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView.mj_header endRefreshing];
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post1
{
    _pnum = _pnum + 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"p":[NSString stringWithFormat:@"%d",_pnum],@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
    
    NSString *urlstr = [API stringByAppendingString:@"userCenter/my_wallet"];
    [manager GET:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *stringnumber = [[_DataArr objectAtIndex:0] objectForKey:@"total_Pages"];
        NSInteger i = [stringnumber integerValue];
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            if (_pnum > i) {
                _TableView.mj_footer.state = MJRefreshStateNoMoreData;
                [_TableView.mj_footer resetNoMoreData];
            }else{
                [_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
                [_TableView.mj_footer endRefreshing];
            }
        }else{
            _DataArr = nil;
            //[MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView.mj_footer endRefreshing];
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.backgroundColor = [UIColor whiteColor];
    _TableView.delegate = self;
    _TableView.dataSource = self;
//    _TableView.enablePlaceHolderView = YES;
    _TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
    __weak typeof(self) weakSelf = self;
    _TableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    [_TableView.mj_header beginRefreshing];
    [self.view addSubview:_TableView];
}
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //[_TableView.mj_header endRefreshing];
        [self post];
    });
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
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"   ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    // 从重用队列里查找可重用的cell
    xiaofeijiluTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (cell==nil) {
        cell = [[xiaofeijiluTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    NSLog(@"%@",[[_DataArr objectAtIndex:indexPath.section] objectForKey:@"log_title"]);
    cell.labeltitle.text = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"log_title"];
    NSString *typestring = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"atype"];
    int i = [typestring intValue];
    NSString *amountstring = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"amount"];
    if (i==1) {
        cell.total_amount.textColor = [UIColor greenColor];
    cell.total_amount.text = [NSString stringWithFormat:@"+¥%@",amountstring];
    }if (i==2){
    cell.total_amount.textColor = [UIColor redColor];
    cell.total_amount.text = [NSString stringWithFormat:@"-¥%@",amountstring];
    }
    
    cell.labelnum.text = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"log_description"];
    NSString *timestring = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"paytime"];
    NSTimeInterval interval   =[timestring doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate: date];
    cell.timelabel.text = dateString;
    NSString *pay = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"paytype"];
    if ([pay isEqualToString:@"alipay"]) {
        cell.paytype.text = @"支付方式:支付宝";
    }else if ([pay isEqualToString:@"wxpay"]){
        cell.paytype.text = @"支付方式:微信";
    }else if ([pay isEqualToString:@"bestpay"]) {
        cell.paytype.text = @"支付方式:翼支付";
    }else{
        cell.paytype.text = @"支付方式:一卡通支付";
    }
    return cell;
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
