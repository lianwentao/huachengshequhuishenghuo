//
//  wuyejiaofeiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/6.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "wuyejiaofeiViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "AllPayViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import "HalfCircleActivityIndicatorView.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "jiaofeijiluViewController.h"
@interface wuyejiaofeiViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    NSMutableArray *_DataArr;
    NSMutableDictionary *_Dic;
    UIButton *_tmpBtn;
    UILabel *_pricelabel;
    HalfCircleActivityIndicatorView *LoadingView;
}

@end

@implementation wuyejiaofeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物业缴费";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self post];
    //[self createtableview];
    [self createview];
    [self LoadingView];
    [self createRightbut];
    [LoadingView startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"wuyejiaofeichenggong" object:nil];
    // Do any additional setup after loading the view.
}
- (void)change{
    [self post];
}
- (void)jiaofeijilu
{
    jiaofeijiluViewController *jilu = [[jiaofeijiluViewController alloc] init];
    jilu.room_id = [[_DataArr objectAtIndex:0] objectForKey:@"room_id"];
    [self.navigationController pushViewController:jilu animated:YES];
}
- (void)createRightbut
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"缴费记录" style:UIBarButtonItemStyleDone target:self action:@selector(jiaofeijilu)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    [self.view addSubview:LoadingView];
}
- (void)createview
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 17, kScreen_Width-150, 30)];
    _pricelabel.text = [NSString stringWithFormat:@"付款: ¥0.0"];
    [view addSubview:_pricelabel];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(kScreen_Width-150, 10, 140, 44);
    but.layer.cornerRadius = 13;
    [but.layer setBorderWidth:0.6];
    [but setTitle:@"立即支付" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [but.layer setBorderColor:[[UIColor redColor]CGColor]];
    [but addTarget:self action:@selector(zhifu) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:but];
}
- (void)zhifu
{
    if (_tmpBtn==nil) {
        [MBProgressHUD showToastToView:self.view withText:@"请选择一期物业账单"];
    }else{
        [self post1];
    }
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64-64) ];
    //_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.backgroundColor = [UIColor whiteColor];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataArr.count+2;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.row==0) {
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreen_Width-20, 150)];
        backview.backgroundColor = [UIColor redColor];
        backview.alpha = 1;
        backview.layer.cornerRadius = 15;
        [backview.layer setMasksToBounds:YES];
        
        backview.layer.borderWidth = 0.5;
        backview.layer.borderColor = [[UIColor blackColor] CGColor];
        [cell.contentView addSubview:backview];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreen_Width-20-30, 30)];
        label1.text = [_Dic objectForKey:@"community_name"];
        label1.textColor = [UIColor whiteColor];
        [backview addSubview:label1];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, kScreen_Width-50, 25)];
        NSString *unit = [NSString stringWithFormat:@"%@单元",[_Dic objectForKey:@"unit"]];
        NSString *string = [NSString stringWithFormat:@"%@-%@-%@",[_Dic objectForKey:@"building_name"],unit,[_Dic objectForKey:@"code"]];
        label2.textColor = [UIColor whiteColor];
        label2.text = string;
        [backview addSubview:label2];
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 75, kScreen_Width, 20)];
        lineview.backgroundColor = [UIColor whiteColor];
        [backview addSubview:lineview];
        
        UIView *whiteview = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreen_Width, 70)];
        whiteview.backgroundColor = [UIColor whiteColor];
        whiteview.alpha = 1;
        whiteview.layer.cornerRadius = 15;
        [whiteview.layer setMasksToBounds:YES];
        [backview addSubview:whiteview];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, kScreen_Width-20-30, 30)];
        label4.text = [_Dic objectForKey:@"mobile"];
        label4.textColor = [UIColor blackColor];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width-20-30, 30)];
        label3.text = [NSString stringWithFormat:@"%@  %@",[_Dic objectForKey:@"fullname"],label4.text];
        label3.textColor = [UIColor blackColor];
        [whiteview addSubview:label3];
        
        UILabel *totleprice = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, kScreen_Width-30, 30)];
        
        totleprice.textColor = [UIColor blackColor];
        [whiteview addSubview:totleprice];
        if ([[_Dic objectForKey:@"bill_list"] isKindOfClass:[NSNull class]]) {
            totleprice.text = @"物业费用合计:¥ 0.0";
        }else{
            totleprice.text = [NSString stringWithFormat:@"物业费用合计:¥ %@",[[_Dic objectForKey:@"bill_list"] objectForKey:@"tot_sumvalue"]];
        }
        
        tableView.rowHeight = 170;
    }else if (indexPath.row==1) {
        cell.textLabel.text = @"账单明细";
        tableView.rowHeight = 50;
    }else if(indexPath.row>1) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(20, 20, 30, 30);
        [but setImage:[UIImage imageNamed:@"shop_icon_xuanze_dianjiqian"] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:@"shop_icon_tianch_dianjihou"] forState:UIControlStateSelected];
        [but addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        but.tag = indexPath.row-2;
        [cell.contentView addSubview:but];
        
        UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, kScreen_Width-80, 20)];
        timelabel.text = [NSString stringWithFormat:@"%@-%@",[[_DataArr objectAtIndex:indexPath.row-2] objectForKey:@"startdate"],[[_DataArr objectAtIndex:indexPath.row-2] objectForKey:@"enddate"]];
        timelabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:timelabel];

        UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, kScreen_Width-80, 20)];
        contentlabel.text = [NSString stringWithFormat:@"本期费用合计:¥ %@",[[_DataArr objectAtIndex:indexPath.row-2] objectForKey:@"sumvalue"]];
        contentlabel.alpha = 0.5;
        contentlabel.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:contentlabel];
        
        tableView.rowHeight = 70;
    }
    return cell;
}
- (void)buttonClick:(UIButton *)button {
    //button.selected = !button.selected;
    if (_tmpBtn == nil){
        button.selected = YES;
        _tmpBtn = button;
        _tmpBtn.tag = button.tag;
    }
    else if (_tmpBtn !=nil && _tmpBtn == button){
        button.selected = YES;
        _tmpBtn.tag = button.tag;
    }
    else if (_tmpBtn!= button && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        button.selected = YES;
        _tmpBtn = button;
        _tmpBtn.tag = button.tag;
    }
    _pricelabel.text = [NSString stringWithFormat:@"付款: ¥ %@",[[_DataArr objectAtIndex:button.tag] objectForKey:@"sumvalue"]];
}
#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *strurl = [API stringByAppendingString:@"property/get_user_bill"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        _DataArr = [[NSMutableArray alloc] init];
        _Dic = [[NSMutableDictionary alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            if ([[[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"bill_list"] isKindOfClass:[NSNull class]]) {
                _DataArr = nil;
                _Dic = [[responseObject objectForKey:@"data"] objectAtIndex:0];
                [LoadingView stopAnimating];
                LoadingView.hidden = YES;
                [self createtableview];
            }else{
                _DataArr = [[[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:@"bill_list"] objectForKey:@"list"];
                _Dic = [[responseObject objectForKey:@"data"] objectAtIndex:0];
                [LoadingView stopAnimating];
                LoadingView.hidden = YES;
                [self createtableview];
            }
        }else{
            _DataArr = nil;
            _Dic = nil;
        }
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post1{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSString *bill_id = [[_DataArr objectAtIndex:_tmpBtn.tag] objectForKey:@"bill_id"];
    NSString *room_id = [[_DataArr objectAtIndex:_tmpBtn.tag] objectForKey:@"room_id"];
    NSString *community_id = [[_DataArr objectAtIndex:_tmpBtn.tag] objectForKey:@"community_id"];
    NSString *community_name = [[_DataArr objectAtIndex:_tmpBtn.tag] objectForKey:@"community_name"];
    NSString *unit = [[_DataArr objectAtIndex:_tmpBtn.tag] objectForKey:@"unit"];
    NSString *code = [[_DataArr objectAtIndex:_tmpBtn.tag] objectForKey:@"code"];
    NSString *charge_type = [[_DataArr objectAtIndex:_tmpBtn.tag] objectForKey:@"charge_type"];
    NSString *sumvalue = [[_DataArr objectAtIndex:_tmpBtn.tag] objectForKey:@"sumvalue"];
    NSString *time = [[_DataArr objectAtIndex:_tmpBtn.tag] objectForKey:@"time"];
    NSString *startdate = [[_DataArr objectAtIndex:_tmpBtn.tag] objectForKey:@"startdate"];
    NSString *enddate = [[_DataArr objectAtIndex:_tmpBtn.tag] objectForKey:@"enddate"];
    NSDictionary *dict = @{@"bill_id":bill_id,@"room_id":room_id,@"community_id":community_id,@"community_name":community_name,@"unit":unit,@"code":code,@"charge_type":charge_type,@"sumvalue":sumvalue,@"bill_time":time,@"startdate":startdate,@"enddate":enddate};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *strurl = [API stringByAppendingString:@"property/make_property_order"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        //_Dic = [[NSMutableDictionary alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            AllPayViewController *pay = [[AllPayViewController alloc] init];
            pay.order_id = [[responseObject objectForKey:@"data"] objectForKey:@"id"];
            pay.price = [[responseObject objectForKey:@"data"] objectForKey:@"sumvalue"];
            pay.type = @"2";
            [self.navigationController pushViewController:pay animated:YES];
        }else{
            
        }
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
