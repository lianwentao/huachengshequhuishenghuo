//
//  newsuerViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/9/5.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newsuerViewController.h"
#import "AllPayViewController.h"
#import <AFNetworking.h>
#import "UIViewController+BackButtonHandler.h"
@interface newsuerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
}

@end

@implementation newsuerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单支付";
    self.view.backgroundColor = BackColor;
    [self createUI];
    // Do any additional setup after loading the view.
}
-(BOOL)navigationShouldPopOnBackButton {
    //[self chevsuess];
    NSLog(@"ssss");
    if ([_biaoshi isEqualToString:@"1"]) {
        
    }else{
        [self chevsuess];
    }
    return YES;
}
- (void)chevsuess
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSString *type;
    type = @"property";
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    //,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]
    NSDictionary *dict = @{@"id":[_DataDic objectForKey:@"oid"],@"type":type,@"prepay":@"0",@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"hui_community_id":[userinfo objectForKey:@"community_id"]};
    NSLog(@"---dict%@",dict);
    
    NSString *urlstr = [API stringByAppendingString:@"userCenter/confirm_order_payment"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@--%@--%@",[responseObject objectForKey:@"msg"],responseObject,dict);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)createUI
{
    _listArr = [_DataDic objectForKey:@"list"];
    if ([_biaoshi isEqualToString:@"1"]) {
        _ordnum = [_DataDic objectForKey:@"order_num"];
        _name = [_DataDic objectForKey:@"nickname"];
        _address = [_DataDic objectForKey:@"address"];
        _timevavle = [_DataDic objectForKey:@"addtime"];
        _ordid = [[[_listArr objectAtIndex:0] objectAtIndex:0] objectForKey:@"oid"];
        _samount = [_DataDic objectForKey:@"tot_sumvalue"];
        _listArr = [_DataDic objectForKey:@"list"];
    }else{
        _ordnum = [_DataDic objectForKey:@"order_num"];
        _name = [_DataDic objectForKey:@"nickname"];
        _address = [NSString stringWithFormat:@"%@%@单元%@",[_DataDic objectForKey:@"community_name"],[_DataDic objectForKey:@"unit"],[_DataDic objectForKey:@"code"]];
        _timevavle = [_DataDic objectForKey:@"addtime"];
        _ordid = [_DataDic objectForKey:@"oid"];
        _samount = [_DataDic objectForKey:@"sumvalue"];
    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(40, (Main_Height-352-RECTSTATUS.size.height-44-49)/2, Main_width-80, 352)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width-80, 57.5)];
    label1.text = @"账单";
    [label1 setFont:font18];
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];
    
    UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(10, label1.frame.size.height+label1.frame.origin.y+1, Main_width-100, 1)];
    lineview1.backgroundColor = BackColor;
    [view addSubview:lineview1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, lineview1.frame.size.height+15+lineview1.frame.origin.y, Main_width-100, 15)];
    label2.text = _name;
    label2.font = font18;
    [view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, label2.frame.size.height+label2.frame.origin.y+10, Main_width-100, 40)];
    
    
    label3.numberOfLines = 2;
    label3.text = _address;
    label3.alpha = 0.4;
    label3.font = [UIFont systemFontOfSize:13];
    [view addSubview:label3];
    
    UIView *lineview2 = [[UIView alloc] initWithFrame:CGRectMake(10, label3.frame.size.height+label3.frame.origin.y+5, Main_width-100, 1)];
    lineview2.backgroundColor = BackColor;
    [view addSubview:lineview2];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, lineview2.frame.size.height+lineview2.frame.origin.y+10, Main_width-100, 15)];
    label4.font = font15;
    label4.text = [NSString stringWithFormat:@"订单编号:%@",_ordnum];
    [view addSubview:label4];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(10, label4.frame.size.height+label4.frame.origin.y+10, Main_width-100, 15)];
    NSTimeInterval interval    =[_timevavle doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    label5.text = [NSString stringWithFormat:@"支付时间:%@",dateString];
    label5.font = font15;
    [view addSubview:label5];
    
    UIView *lineview3 = [[UIView alloc] initWithFrame:CGRectMake(10, label5.frame.size.height+label5.frame.origin.y+10, Main_width-100, 1)];
    lineview3.backgroundColor = BackColor;
    [view addSubview:lineview3];
    
    if ([_biaoshi isEqualToString:@"1"]) {
        long j=_listArr.count;
        for (int i = 0; i<_listArr.count; i++) {
            NSArray *arrlist = [_listArr objectAtIndex:i];
            j = arrlist.count+j;
        }
        UIView *wuyeview = [[UIView alloc] initWithFrame:CGRectMake(0, lineview3.frame.size.height+lineview3.frame.origin.y+15, Main_width-80, j*35)];
        [view addSubview:wuyeview];
        
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width-80, j*35)];
        _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _TableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _TableView.scrollEnabled = NO;
        _TableView.delegate = self;
        _TableView.dataSource = self;
        [wuyeview addSubview:_TableView];
    }else{
        UILabel *labeltype = [[UILabel alloc] initWithFrame:CGRectMake(10, lineview3.frame.size.height+lineview3.frame.origin.y+15, Main_width-80, 35)];
        labeltype.text = [_DataDic objectForKey:@"charge_type"];
        labeltype.font = font18;
        [view addSubview:labeltype];
        
        UILabel *labelshuidian = [[UILabel alloc] initWithFrame:CGRectMake(10, lineview3.frame.size.height+lineview3.frame.origin.y+15+50, (Main_width-80/2), 35)];
        NSTimeInterval interval    =[[_DataDic objectForKey:@"bill_time"] doubleValue];
        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString       = [formatter stringFromDate: date];
         labelshuidian.text = dateString;
        labelshuidian.font = font15;
        [view addSubview:labelshuidian];
        
        UILabel *amount = [[UILabel alloc] initWithFrame:CGRectMake((Main_width-80)/2, lineview3.frame.size.height+lineview3.frame.origin.y+15+50, (Main_width-80)/2-10, 35)];
        amount.text = [_DataDic objectForKey:@"sumvalue"];
        amount.font = font15;
        amount.textAlignment = NSTextAlignmentRight;
        [view addSubview:amount];
    }
    
    
    UIButton *suer = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:suer];
    suer.backgroundColor = QIColor;
    [suer setTitle:@"确认支付" forState:UIControlStateNormal];
    suer.frame = CGRectMake(0, Main_Height-49, Main_width, 49);
    [suer addTarget:self action:@selector(suer) forControlEvents:UIControlEventTouchUpInside];
}
- (void)suer
{
    NSLog(@"_ordid---%@",_ordid);
    AllPayViewController *allpay = [[AllPayViewController alloc] init];
    allpay.type = @"2";
    allpay.order_id = _ordid;
    allpay.price = _samount;
    [self.navigationController pushViewController:allpay animated:YES];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [_listArr objectAtIndex:section];
    return arr.count+1;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArr.count;
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
    return 35;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    NSArray *arr = [_listArr objectAtIndex:indexPath.section];
    if (indexPath.row==0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width-20, 35)];
        label.text = [[arr objectAtIndex:indexPath.row] objectForKey:@"charge_type"];
        label.font = font18;
        [cell.contentView addSubview:label];
    }else{
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_width/2, 35)];
        NSLog(@"%@",[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] class]);
        if ([[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] isKindOfClass:[NSNull class]]||[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] isEqualToString:@""]) {
            NSTimeInterval interval    =[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"bill_time"] doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString       = [formatter stringFromDate: date];
            label1.text = dateString;
        }else{
            NSTimeInterval interval    =[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"startdate"] doubleValue];
            NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString       = [formatter stringFromDate: date];
            
            NSTimeInterval interval1    =[[[arr objectAtIndex:indexPath.row-1] objectForKey:@"enddate"] doubleValue];
            NSDate *date1               = [NSDate dateWithTimeIntervalSince1970:interval1];
            
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString1       = [formatter stringFromDate: date1];
            label1.text = [NSString stringWithFormat:@"%@/%@",dateString,dateString1];
        }
        
        label1.font = font15;
        [cell.contentView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake((Main_width-100)/2, 0, (Main_width-100)/2-10, 35)];
        label2.font = font15;
        label2.textAlignment = NSTextAlignmentRight;
        label2.text = [[arr objectAtIndex:indexPath.row-1] objectForKey:@"sumvalue"];
        [cell.contentView addSubview:label2];
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
