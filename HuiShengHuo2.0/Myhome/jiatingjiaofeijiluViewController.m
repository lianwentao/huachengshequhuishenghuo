//
//  jiatingjiaofeijiluViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/22.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "jiatingjiaofeijiluViewController.h"
#import <AFNetworking.h>
#import "zhangdanjiluCell.h"
#import "fukuanjilumodel.h"
#import "UIViewController+BackButtonHandler.h"
#import "jiatingzhangdanViewController.h"
#import "UITableView+PlaceHolderView.h"
#import "MJRefresh.h"
@interface jiatingjiaofeijiluViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TabelView;
    NSMutableArray *_DataArr;
    NSMutableArray *dataarr;
    int _pagenum;
}

@end

@implementation jiatingjiaofeijiluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单记录";
   _pagenum = 1;
    
    [self createUI];
    [self getData];
    // Do any additional setup after loading the view.
}
- (void)createUI
{
    _TabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TabelView.delegate = self;
    _TabelView.dataSource = self;
    _TabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TabelView.backgroundColor = BackColor;
    _TabelView.enablePlaceHolderView = YES;
    [self.view addSubview:_TabelView];
    _TabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
}
- (BOOL)navigationShouldPopOnBackButton{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[jiatingzhangdanViewController class]]) {
            jiatingzhangdanViewController *revise =(jiatingzhangdanViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
    return NO;
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 222.5;
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"zhangdanjilucell";
    NSLog(@"-----------111==%@",_DataArr);
    zhangdanjiluCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[zhangdanjiluCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    cell.model = [_DataArr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"room_id":_room_id,@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/get_property_order"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"---%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        _DataArr = [[NSMutableArray alloc] init];
        dataarr = [[NSMutableArray alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [_DataArr removeAllObjects];
            [dataarr removeAllObjects];
            dataarr = [responseObject objectForKey:@"data"];
            if ([dataarr isKindOfClass:[NSArray class]]) {
                for (int i=0; i<dataarr.count; i++) {
                    fukuanjilumodel *model = [[fukuanjilumodel alloc] init];
                    NSTimeInterval interval    =[[[dataarr objectAtIndex:i] objectForKey:@"pay_time"] doubleValue];
                    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateString       = [formatter stringFromDate: date];
                    model.time = dateString;
                    //model.time = [[dataarr objectAtIndex:i] objectForKey:@"pay_time"];
                    model.biahao = [NSString stringWithFormat:@"付款编号:%@",[[dataarr objectAtIndex:i] objectForKey:@"order_num"]];
                    model.price = [NSString stringWithFormat:@"%@:%@元",[[dataarr objectAtIndex:i] objectForKey:@"charge_type"],[[dataarr objectAtIndex:i] objectForKey:@"sumvalue"]];
                    NSString *pay_type = [[dataarr objectAtIndex:i] objectForKey:@"pay_type"];
                    if ([pay_type isEqualToString:@"alipay"]) {
                        model.name = @"缴费方式:支付宝";
                    }else if ([pay_type isEqualToString:@"wxpay"]){
                        model.name = @"缴费方式:微信";
                    }else if ([pay_type isEqualToString:@"bestpay"]){
                        model.name = @"缴费方式:翼支付";
                    }else{
                        model.name = @"缴费方式:一卡通支付";
                    }
                    //bestpay
                    [_DataArr addObject:model];
                }
                [_TabelView reloadData];
            }
        }
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
    //2.封装参数
    NSString *string = [NSString stringWithFormat:@"%d",_pagenum];
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
    dict = @{@"room_id":_room_id,@"apk_token":uid_username,@"p":string,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    
    NSString *strurl = [API stringByAppendingString:@"property/get_property_order"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSArray *arr = [[NSArray alloc] init];
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum>i) {
                _TabelView.mj_footer.state = MJRefreshStateNoMoreData;
                [_TabelView.mj_footer resetNoMoreData];
            }else{
                
                dataarr = [responseObject objectForKey:@"data"];
                if ([dataarr isKindOfClass:[NSArray class]]) {
                    for (int i=0; i<dataarr.count; i++) {
                        fukuanjilumodel *model = [[fukuanjilumodel alloc] init];
                        NSTimeInterval interval    =[[[dataarr objectAtIndex:i] objectForKey:@"pay_time"] doubleValue];
                        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                        
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *dateString       = [formatter stringFromDate: date];
                        model.time = dateString;
                        //model.time = [[dataarr objectAtIndex:i] objectForKey:@"pay_time"];
                        model.biahao = [NSString stringWithFormat:@"付款编号:%@",[[dataarr objectAtIndex:i] objectForKey:@"order_num"]];
                        model.price = [NSString stringWithFormat:@"%@:%@元",[[dataarr objectAtIndex:i] objectForKey:@"charge_type"],[[dataarr objectAtIndex:i] objectForKey:@"sumvalue"]];
                        NSString *pay_type = [[dataarr objectAtIndex:i] objectForKey:@"pay_type"];
                        if ([pay_type isEqualToString:@"alipay"]) {
                            model.name = @"缴费方式:支付宝";
                        }else if ([pay_type isEqualToString:@"wxpay"]){
                            model.name = @"缴费方式:微信";
                        }else if ([pay_type isEqualToString:@"bestpay"]){
                            model.name = @"缴费方式:翼支付";
                        }else{
                            model.name = @"缴费方式:一卡通支付";
                        }
                        //bestpay
                        [_DataArr addObject:model];
                    }
                    [_TabelView reloadData];
                }
            }
        }
        NSLog(@"%@==%@",[responseObject objectForKey:@"msg"],responseObject);
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
