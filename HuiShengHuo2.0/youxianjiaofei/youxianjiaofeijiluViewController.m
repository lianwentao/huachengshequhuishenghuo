//
//  youxianjiaofeijiluViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/18.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "youxianjiaofeijiluViewController.h"
#import "youxianjiaofeiViewController.h"
#import "facepaymodel.h"
#import <AFNetworking.h>
#import "MJRefresh.h"
#import "youxianjiaofeiTableViewCell.h"
#import "youxianjiaofeimodel.h"
@interface youxianjiaofeijiluViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_DataArr;
    NSMutableArray *modelArr;
    
    UITableView *_TabelView;
    
    int _pagenum;
}

@end

@implementation youxianjiaofeijiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"有线缴费记录";
    
    _DataArr = [NSMutableArray arrayWithCapacity:0];
    modelArr = [NSMutableArray arrayWithCapacity:0];
    [self createUI];
    [self getData];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 60, 40);
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)backBtnClicked{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[youxianjiaofeiViewController class]]) {
            youxianjiaofeiViewController *revise =(youxianjiaofeiViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
}
- (void)createUI
{
    _TabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TabelView.delegate = self;
    _TabelView.dataSource = self;
    _TabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TabelView.backgroundColor = BackColor;
    _TabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
    [self.view addSubview:_TabelView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *staus = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"status"];
    if ([staus isEqualToString:@"1"]) {
        return 400-25-12.5;
    }else{
        return 400;
    }
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"facepayjiluTableViewCell";
    NSLog(@"-----------111==%@",modelArr);
    youxianjiaofeiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[youxianjiaofeiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    cell.model = [modelArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *strurl = [API stringByAppendingString:@"property/wired_order_list"];
    [manager GET:strurl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        [_DataArr removeAllObjects];
        [modelArr removeAllObjects];
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
            for (int i=0; i<_DataArr.count; i++) {
                youxianjiaofeimodel *model = [[youxianjiaofeimodel alloc] init];
                NSTimeInterval interval    =[[[_DataArr objectAtIndex:i] objectForKey:@"addtime"] doubleValue];
                NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString       = [formatter stringFromDate: date];
                model.addtime = dateString;
                model.amount = [NSString stringWithFormat:@"有线电视缴费:%@元",[[_DataArr objectAtIndex:i] objectForKey:@"amount"]];
                model.order_number = [[_DataArr objectAtIndex:i] objectForKey:@"order_number"];
                model.fullname = [[_DataArr objectAtIndex:i] objectForKey:@"fullname"];
                model.pay_type = [[_DataArr objectAtIndex:i] objectForKey:@"pay_type"];
                model.wired_num = [[_DataArr objectAtIndex:i] objectForKey:@"wired_num"];
                model.staus = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:i] objectForKey:@"status"]];
                NSTimeInterval interval1    =[[[_DataArr objectAtIndex:i] objectForKey:@"uptime"] doubleValue];
                NSDate *date1               = [NSDate dateWithTimeIntervalSince1970:interval1];
                
                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString1       = [formatter stringFromDate:date1];
                model.uptime = dateString1;
                
                [modelArr addObject:model];
            }
        }
        [_TabelView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)postup
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum = _pagenum+1;
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum];
    NSDictionary *dict = nil;
    dict = @{@"p":string};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *strurl = [API stringByAppendingString:@"property/wired_order_list"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSArray *arr = [[NSArray alloc] init];
            arr = [responseObject objectForKey:@"data"];
            [_DataArr addObjectsFromArray:arr];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum>i) {
                _TabelView.mj_footer.state = MJRefreshStateNoMoreData;
                [_TabelView.mj_footer resetNoMoreData];
            }else{
                for (int i=0; i<arr.count; i++) {
                    youxianjiaofeimodel *model = [[youxianjiaofeimodel alloc] init];
                    NSTimeInterval interval    =[[[arr objectAtIndex:i] objectForKey:@"addtime"] doubleValue];
                    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateString       = [formatter stringFromDate: date];
                    model.addtime = dateString;
                    model.amount = [NSString stringWithFormat:@"%@:%@元",[[arr objectAtIndex:i] objectForKey:@"c_name"],[[arr objectAtIndex:i] objectForKey:@"amount"]];
                    model.order_number = [[arr objectAtIndex:i] objectForKey:@"order_number"];
                    model.fullname = [[arr objectAtIndex:i] objectForKey:@"fullname"];
                    model.pay_type = [[arr objectAtIndex:i] objectForKey:@"pay_type"];
                    model.wired_num = [[arr objectAtIndex:i] objectForKey:@"wired_num"];
                    model.staus = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"status"]];
                    NSTimeInterval interval1    =[[[arr objectAtIndex:i] objectForKey:@"uptime"] doubleValue];
                    NSDate *date1               = [NSDate dateWithTimeIntervalSince1970:interval1];
                    
                    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateString1       = [formatter stringFromDate:date1];
                    model.uptime = dateString1;
                    [modelArr addObject:model];
                }
            }
            
        }
        [_TabelView.mj_footer endRefreshing];
        [_TabelView reloadData];
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
