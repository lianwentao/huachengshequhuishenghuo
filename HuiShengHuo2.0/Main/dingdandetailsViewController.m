//
//  dingdandetailsViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/6.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "dingdandetailsViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "UIImageView+WebCache.h"
#import "AllPayViewController.h"
#import "pingjiaViewController.h"
#import "tuikuanViewController.h"
#import "HalfCircleActivityIndicatorView.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
@interface dingdandetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_DataArr;
    UITableView *_TableView;
    
    UIButton *zhifubut;
    UIButton *deletebut;
    UIButton *tuikuanbut;
    UIButton *shouhuobut;
    
    float _price;
    NSString *shouhuoid;
    HalfCircleActivityIndicatorView *LoadingView;
}

@end

@implementation dingdandetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _price = 0;
    
    [self post];
    [self LoadingView];
    [LoadingView startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"changepingjiatuikuanzhuangtai" object:nil];
    // Do any additional setup after loading the view.
}
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    [self.view addSubview:LoadingView];
}
- (void)change
{
    [self post];
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64-64)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
    
    UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height-64, kScreen_Width, 64)];
    bottomview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomview];
    
    zhifubut = [UIButton buttonWithType:UIButtonTypeCustom];
    zhifubut.frame = CGRectMake(kScreen_Width-100, 10, 80, 44);
    zhifubut.layer.cornerRadius = 13;
    [zhifubut.layer setBorderWidth:0.6];
    [zhifubut setTitle:@"支付" forState:UIControlStateNormal];
    [zhifubut setTitleColor:HColor(199, 8, 10) forState:UIControlStateNormal];
    [zhifubut.layer setBorderColor:[HColor(199, 8, 10)CGColor]];
    [zhifubut addTarget:self action:@selector(zhifu) forControlEvents:UIControlEventTouchUpInside];
    [bottomview addSubview:zhifubut];
    
    deletebut = [UIButton buttonWithType:UIButtonTypeCustom];
    deletebut.frame = CGRectMake(kScreen_Width-200, 10, 80, 44);
    deletebut.layer.cornerRadius = 13;
    [deletebut setTitle:@"删除" forState:UIControlStateNormal];
    [deletebut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deletebut addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [deletebut.layer setBorderWidth:0.6];
    [bottomview addSubview:deletebut];
}
- (void)delete
{
    UIAlertController*alert = [UIAlertController
                               alertControllerWithTitle: nil
                               message: @"确认删除订单"
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
                          [self post1];
                      }]];
    //弹出提示框
    [self presentViewController:alert
                       animated:YES completion:nil];
    
}
- (void)zhifu
{
    int j=1;
    for (int i=0; i<_DataArr.count; i++) {
        if ([[[_DataArr objectAtIndex:i] objectForKey:@"is_shop"] intValue]==1) {
            j = j + 1;
        }
    }
    NSLog(@"%d",j);
    if (j>=2) {
        [MBProgressHUD showToastToView:self.view withText:@"该订单含有已下架商品,请重新下单"];
    }else{
        AllPayViewController *pay = [[AllPayViewController alloc] init];
        pay.order_id = [[_DataArr objectAtIndex:0] objectForKey:@"oid"];
        pay.price = [NSString stringWithFormat:@"%.2f",[_totleprice floatValue]-[[[_DataArr objectAtIndex:0] objectForKey:@"m_c_amount"] floatValue]];
        [self.navigationController pushViewController:pay animated:YES];
    }
}
#pragma mark ----联网请求---
-(void)post1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSString *idstring;
    for (int i=0; i<_DataArr.count; i++) {
        idstring = [[_DataArr objectAtIndex:i] objectForKey:@"id"];
        [arr addObject:idstring];
    }
    NSString *string;
    string = [arr componentsJoinedByString:@","];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"id":string,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSString *urlstr = [API stringByAppendingString:@"userCenter/del_shopping_order"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteshopid" object:nil userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"id":_id,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSString *urlstr = [API stringByAppendingString:@"userCenter/shopping_order_details"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _DataArr = [[NSMutableArray alloc] init];
        
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
            
            [self createtableview];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            _DataArr = nil;
        }
        [LoadingView stopAnimating];
        LoadingView.hidden = YES;
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return _DataArr.count;
    }else{
        return 1;
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 120;
    }else if (indexPath.section<3){
        return 80;
    } else{
        return 120;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    // 从重用队列里查找可重用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        UIImageView *statusimageview = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width-100, 10, 65, 65)];
        [cell.contentView addSubview:statusimageview];
        
        int j = [[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"status"] intValue];
        if (j==2) {
            statusimageview.image = [UIImage imageNamed:@"iv_daifahuo"];
            deletebut.hidden = YES;
            zhifubut.hidden = YES;
            
            UIButton *tuikuanbut = [UIButton buttonWithType:UIButtonTypeCustom];
            tuikuanbut.frame = CGRectMake(kScreen_Width-50, 75, 40, 25);
            tuikuanbut.layer.cornerRadius = 5;
            [tuikuanbut.layer setBorderWidth:0.6];
            tuikuanbut.tag = indexPath.row;
            [tuikuanbut.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [tuikuanbut setTitle:@"退款" forState:UIControlStateNormal];
            [tuikuanbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //                [tuikuanbut.layer setBorderColor:[[UIColor redColor]CGColor]];
            [tuikuanbut addTarget:self action:@selector(tuikuan:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:tuikuanbut];
        }if (j==9) {
            statusimageview.image = [UIImage imageNamed:@"iv_yituikuan"];
            deletebut.hidden = YES;
            zhifubut.hidden = YES;
        }if (j==8) {
            statusimageview.image = [UIImage imageNamed:@"iv_tuikuanzhong"];
            deletebut.hidden = YES;
            zhifubut.hidden = YES;
        }if (j==6){
            statusimageview.image = [UIImage imageNamed:@"iv_daituikuan"];
            deletebut.hidden = YES;
            zhifubut.hidden = YES;
        }if (j==3) {
            deletebut.hidden = YES;
            zhifubut.hidden = YES;
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(kScreen_Width-100, 75, 40, 25);
            but.layer.cornerRadius = 5;
            [but.layer setBorderWidth:0.6];
            [but setTitle:@"收货" forState:UIControlStateNormal];
            but.tag = indexPath.row;
            [but.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [but.layer setBorderColor:[[UIColor redColor]CGColor]];
            [but addTarget:self action:@selector(shouhuo:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
            
            UIButton *tuikuanbut = [UIButton buttonWithType:UIButtonTypeCustom];
            tuikuanbut.frame = CGRectMake(kScreen_Width-50, 75, 40, 25);
            tuikuanbut.layer.cornerRadius = 5;
            [tuikuanbut.layer setBorderWidth:0.6];
            [tuikuanbut.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [tuikuanbut setTitle:@"退款" forState:UIControlStateNormal];
            tuikuanbut.tag = indexPath.row;
            [tuikuanbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //                [tuikuanbut.layer setBorderColor:[[UIColor redColor]CGColor]];
            [tuikuanbut addTarget:self action:@selector(tuikuan:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:tuikuanbut];
        }if (j==4) {
            deletebut.hidden = YES;
            zhifubut.hidden = YES;
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(kScreen_Width-100, 75, 40, 25);
            but.layer.cornerRadius = 5;
            [but.layer setBorderWidth:0.6];
            [but.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [but setTitle:@"评价" forState:UIControlStateNormal];
            but.tag = indexPath.row;
            [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [but.layer setBorderColor:[[UIColor redColor]CGColor]];
            [but addTarget:self action:@selector(pingjia:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
            
            UIButton *tuikuanbut = [UIButton buttonWithType:UIButtonTypeCustom];
            tuikuanbut.frame = CGRectMake(kScreen_Width-50, 75, 40, 25);
            tuikuanbut.layer.cornerRadius = 5;
            [tuikuanbut.layer setBorderWidth:0.6];
            [tuikuanbut.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [tuikuanbut setTitle:@"退款" forState:UIControlStateNormal];
            tuikuanbut.tag = indexPath.row;
            [tuikuanbut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //                [tuikuanbut.layer setBorderColor:[[UIColor redColor]CGColor]];
            [tuikuanbut addTarget:self action:@selector(tuikuan:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:tuikuanbut];
        }if (j==1){
            deletebut.hidden = NO;
            zhifubut.hidden = NO;
        }if (j==7) {
            deletebut.hidden = NO;
            zhifubut.hidden = YES;
        }
        if (zhifubut.hidden == YES) {
            deletebut.frame = CGRectMake(kScreen_Width-100, 10, 80, 44);
        }
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        NSString *strurl = [API_img stringByAppendingString:[[_DataArr objectAtIndex:indexPath.row]objectForKey:@"title_img"]];
        [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
        [cell.contentView addSubview:imageview];
        UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, kScreen_Width-120-10, 30)];
        namelabel.font = nomalfont;
        NSString *string = [NSString stringWithFormat:@"%@ X%@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"title"],[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"number"]];
        namelabel.text = string;
        [cell.contentView addSubview:namelabel];
        UILabel *pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, kScreen_Width-120-10, 30)];
        pricelabel.font = nomalfont;
        pricelabel.textColor = [UIColor redColor];
        pricelabel.text = [NSString stringWithFormat:@"单价:¥%@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"price"]];
        [cell.contentView addSubview:pricelabel];
        
        UILabel *labelline = [[UILabel alloc] initWithFrame:CGRectMake(0, 119, kScreen_Width, 1)];
        labelline.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:labelline];
    }else if (indexPath.section==1){
        UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreen_Width-20, 30)];
        timelabel.font = nomalfont;
        NSTimeInterval interval    =[[[_DataArr objectAtIndex:0] objectForKey:@"addtime"] doubleValue];
        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString       = [formatter stringFromDate: date];
        timelabel.text = [NSString stringWithFormat:@"下单日期:%@",dateString];
        [cell.contentView addSubview:timelabel];
        UILabel *dingdanbianhaolabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, kScreen_Width-20, 30)];
        dingdanbianhaolabel.font = nomalfont;
        dingdanbianhaolabel.text = [NSString stringWithFormat:@"订单编号:%@",_ordernumber];
        [cell.contentView addSubview:dingdanbianhaolabel];
        
        UILabel *labelline = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, kScreen_Width, 1)];
        labelline.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:labelline];
    }else if (indexPath.section==2){
        UILabel *zhifufangshilabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreen_Width-20, 30)];
        zhifufangshilabel.font = nomalfont;
        UILabel *zhifuruqilabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, kScreen_Width-20, 30)];
        zhifuruqilabel.font = nomalfont;
        UILabel *labelline1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, kScreen_Width, 1)];
        labelline1.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:labelline1];
        if ([[[_DataArr objectAtIndex:0] objectForKey:@"is_pay"] isEqualToString:@"1"]) {
            zhifufangshilabel.text = @"支付方式:未支付";
        }else{
            NSString *pay_type;
            if ([[[_DataArr objectAtIndex:0] objectForKey:@"pay_type"] isEqualToString:@"wxpay"]) {
                pay_type = @"微信支付";
            }else if([[[_DataArr objectAtIndex:0] objectForKey:@"pay_type"] isEqualToString:@"bestpay"]){
                pay_type = @"翼支付";
            }else if([[[_DataArr objectAtIndex:0] objectForKey:@"pay_type"] isEqualToString:@"alipay"]){
                pay_type = @"支付宝";
            }else {
                pay_type = @"一卡通支付";
            }
            zhifufangshilabel.text = [NSString stringWithFormat:@"支付方式:%@",pay_type];
        }
        [cell.contentView addSubview:zhifufangshilabel];
        
        if ([[[_DataArr objectAtIndex:0] objectForKey:@"pay_time"] isKindOfClass:[NSNull class]]) {
            zhifuruqilabel.text = @"支付日期:无";
        }else{
            NSString *timestring = [[_DataArr objectAtIndex:0] objectForKey:@"pay_time"];
            NSTimeInterval interval   =[timestring doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *dateString = [formatter stringFromDate: date];
            zhifuruqilabel.text = [NSString stringWithFormat:@"支付日期:%@",dateString];
        }
        [cell.contentView addSubview:zhifuruqilabel];
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreen_Width-20-120, 30)];
        for (int i=0; i<_DataArr.count; i++) {
            NSString *price = [[_DataArr objectAtIndex:i] objectForKey:@"price"];
            float f = [price floatValue];
            _price = _price + f;
        }
        label.text = [NSString stringWithFormat:@"商品金额: %@元",_totleprice];
        label.font = nomalfont;
        [cell.contentView addSubview:label];
        
        UILabel *labelline = [[UILabel alloc] initWithFrame:CGRectMake(0, 119, kScreen_Width, 1)];
        labelline.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.contentView addSubview:labelline];
        
        UILabel *amountlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, kScreen_Width-20-120, 30)];
        amountlabel.font = nomalfont;
        [cell.contentView addSubview:amountlabel];
        float amount = [[[_DataArr objectAtIndex:0] objectForKey:@"m_c_amount"] floatValue];
        if (amount>0) {
            amountlabel.text = [NSString stringWithFormat:@"优惠使用: %.2f",amount];
        }else{
            amountlabel.text = @"优惠使用: 无";
        }
        
        UILabel *liuyanlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, kScreen_Width-20-120, 30)];
        [cell.contentView addSubview:liuyanlabel];
        liuyanlabel.font = nomalfont;
        NSString *liuyan = [[_DataArr objectAtIndex:0] objectForKey:@"description"];
        if ([liuyan isEqualToString:@""]) {
            liuyanlabel.text = @"买家留言: 无";
        }else{
            liuyanlabel.text = [NSString stringWithFormat:@"买家留言: %@",liuyan];
        }
        UILabel *shifu = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-160, 65, 150, 30)];
        shifu.font = [UIFont systemFontOfSize:20];
        shifu.textColor = [UIColor redColor];
        [cell.contentView addSubview:shifu];
        //float shifumoney = [_DataArr objectAtIndex:0];
        shifu.text = [NSString stringWithFormat:@"实付: ¥%.2f",[_totleprice floatValue]-amount];
    }//
    return cell;
}
- (void)shouhuo:(UIButton *)sender
{
    shouhuoid = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"id"];
    //初始化警告框
    UIAlertController*alert = [UIAlertController
                               alertControllerWithTitle: nil
                               message: @"是否确认收货"
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
                          [self postshouhuo];
                      }]];
    //弹出提示框
    [self presentViewController:alert
                       animated:YES completion:nil];
}
-(void)postshouhuo
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = @{@"id":shouhuoid};
    NSString *urlstr = [API stringByAppendingString:@"userCenter/order_accept"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [self post];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)pingjia:(UIButton *)sender
{
    pingjiaViewController *pingjia = [[pingjiaViewController alloc] init];
    pingjia.oid = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"oid"];
    pingjia.order_info_id = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"id"];
    pingjia.imageurl = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"title_img"];
    pingjia.name = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"title"];
    pingjia.p_id = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"p_id"];
    [self.navigationController pushViewController:pingjia animated:YES];
}
- (void)tuikuan:(UIButton *)sender
{
    tuikuanViewController *tuikuan = [[tuikuanViewController alloc] init];
    tuikuan.oid = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"oid"];
    tuikuan.order_info_id = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"id"];
    tuikuan.imageurl = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"title_img"];
    tuikuan.name = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"title"];
    tuikuan.price = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"price"];
    [self.navigationController pushViewController:tuikuan animated:YES];
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
