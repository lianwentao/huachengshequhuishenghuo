//
//  huodongdingdanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/6.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "huodongdingdanViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+TVAssistant.h"

#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface huodongdingdanViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    NSMutableDictionary *_Dic;
    NSMutableArray *_DataArr;
}

@end

@implementation huodongdingdanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
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
    NSDictionary *dict = @{@"id":_id,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *urlstr = [API stringByAppendingString:@"activity/my_activity_info"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _DataArr = [[NSMutableArray alloc] init];
        _Dic = [[NSMutableDictionary alloc] init];
        NSLog(@"success活动详情--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _Dic = [responseObject objectForKey:@"data"];
            _DataArr = [[responseObject objectForKey:@"data"] objectForKey:@"r_list"];
        }else{
            _Dic = nil;
            _DataArr = nil;
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }else{
        if ([_DataArr isKindOfClass:[NSArray class]]) {
            return _DataArr.count+1;
        }else{
            return 0;
        }

    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text = _nametitle;
            tableView.rowHeight = 45;
        }if (indexPath.row==1) {
            UILabel *order_number = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screen_Width-30, 20)];
            order_number.text = [NSString stringWithFormat:@"订单编号:%@",[_Dic objectForKey:@"order_number"]];
            [cell.contentView addSubview:order_number];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 31, screen_Width-20, 0.5)];
            view.alpha = 0.2;
            view.backgroundColor = [UIColor blackColor];
            [cell.contentView addSubview:view];
            tableView.rowHeight = 32;
        }if (indexPath.row==2) {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screen_Width-30, 20)];
            NSString *timestring = [_Dic objectForKey:@"end_time"];
            NSTimeInterval interval   =[timestring doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateString = [formatter stringFromDate: date];
            label1.text = [NSString stringWithFormat:@"结束时间: %@",dateString];
            [cell.contentView addSubview:label1];
            UILabel *mingelabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, screen_Width-30, 20)];
            NSString *personalnum = [_Dic objectForKey:@"personal_num"];
            if ([personalnum isEqualToString:@"0"]) {
                mingelabel.text = @"名额: 不限";
            }else{
                mingelabel.text = [NSString stringWithFormat:@"名额: %@人",personalnum];
            }
            [cell.contentView addSubview:mingelabel];
            UILabel *phonelabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 200, 20)];
            phonelabel.text = @"咨询热线:400-6535-355";
            [cell.contentView addSubview:phonelabel];
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(225, 70, 75, 20);
            [but addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
            [but setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateNormal];
            [cell.contentView addSubview:but];
            tableView.rowHeight = 100;
        }if (indexPath.row==3){
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(screen_Width/2-75, 15, 150, 40);
            [but setBackgroundColor:HColor(199, 8, 10)];
            [cell.contentView addSubview:but];
        }
    }else{
        if (indexPath.row==0) {
            cell.textLabel.text = @"进度";
        }else{
            
        }
    }
    
    return cell;
}
- (void)call
{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4006535355"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
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
