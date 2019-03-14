//
//  newfuwudingdandetailsViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newfuwudingdandetailsViewController.h"
#import "cancledingdanViewController.h"
#import "pingjiadingdanViewController.h"
#import "tousuViewController.h"
#import "serviceDetailViewController.h"
@interface newfuwudingdandetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_TableView;
    MBProgressHUD *_HUD;
    NSDictionary *datadic;
    AppDelegate *myDelegate;
}

@end

@implementation newfuwudingdandetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的订单";
    myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    datadic = [[NSDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getdata) name:@"newpingjiadingdan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getdata) name:@"newquxiaodingdan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getdata) name:@"newtousudingdan" object:nil];
    [self getdata];
    // Do any additional setup after loading the view.
}
- (void)getdata
{
    //初始化进度框，置于当前的View当中
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"加载中...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSDictionary *dict = nil;
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        dict = @{@"id":_dingdanid,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *API_NOAPK = [defaults objectForKey:@"API_NOAPK"];
        NSString *strurl = [API_NOAPK stringByAppendingString:@"/Service/order/OrderDetail"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                datadic = [responseObject objectForKey:@"data"];
            }else{
                datadic = nil;
            }
            [self createtableview];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WBLog(@"failure--%@",error);
            [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
        }];
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.bounces = NO;
    [self.view addSubview:_TableView];
}

#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    if (indexPath.row == 0) {
        return 70;
    }else if (indexPath.row==1){
        return 170+65;
    }else if (indexPath.row==2){
        return 138;
    }else{
        return Main_width/1.76;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
        
    }
    if (indexPath.row== 0) {
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
        [imgview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[datadic objectForKey:@"title_img"]]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
        [cell.contentView addSubview:imgview];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(imgview.frame.size.width+15+imgview.frame.origin.x, 15, Main_width/2, 40)];
        label1.font = [UIFont systemFontOfSize:14];
        label1.text = [datadic objectForKey:@"s_name"];
        [cell.contentView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width*2/3-15, 15, Main_width/3, 40)];
        label2.text = @"查看服务详情 >";
        label2.alpha = 0.54;
        label2.font = [UIFont systemFontOfSize:12];
        label2.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label2];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(Main_width*2/3-15, 15, Main_width/3, 40);
        [but addTarget:self action:@selector(chakan) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:but];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 1)];
        line1.backgroundColor = [UIColor blackColor];
        line1.alpha = 0.05;
        [cell.contentView addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 69, Main_width-30, 1)];
        line2.backgroundColor = [UIColor blackColor];
        line2.alpha = 0.05;
        [cell.contentView addSubview:line2];
    }else if (indexPath.row==1){
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 115, 30)];
        imageview.image = [UIImage imageNamed:@"服务信息"];
        [cell.contentView addSubview:imageview];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(30, 50+15+10, 2, 140)];
        line1.backgroundColor = [UIColor blackColor];
        line1.alpha = 0.1;
        [cell.contentView addSubview:line1];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(32+10, 50+15, Main_width-32-10-15, 40)];
        label1.text = [NSString stringWithFormat:@"订单编号:%@",[datadic objectForKey:@"order_number"]];
        label1.font = [UIFont systemFontOfSize:12];
        label1.alpha = 0.54;
        [cell.contentView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(32+10, 50+15+40, Main_width-32-10-15, 40)];
        NSString *timestring = [datadic objectForKey:@"addtime"];
        NSTimeInterval interval   =[timestring doubleValue];
        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *dateString = [formatter stringFromDate: date];
        label2.text = [NSString stringWithFormat:@"下单时间:%@",dateString];
        label2.font = [UIFont systemFontOfSize:12];
        label2.alpha = 0.54;
        [cell.contentView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(32+10, 50+15+80, Main_width-32-10-15, 40)];
        label3.text = [NSString stringWithFormat:@"预约地址:%@",[datadic objectForKey:@"address"]];
        label3.numberOfLines = 2;
        label3.font = [UIFont systemFontOfSize:12];
        label3.alpha = 0.54;
        [cell.contentView addSubview:label3];
        
        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(32+10, 50+15+120, Main_width-32-10-15, 40)];
        label4.text = [NSString stringWithFormat:@"备注:%@",[datadic objectForKey:@"description"]];
        label4.alpha = 0.54;
        label4.numberOfLines = 2;
        label4.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:label4];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 169+65, Main_width-30, 1)];
        line2.backgroundColor = [UIColor blackColor];
        line2.alpha = 0.05;
        [cell.contentView addSubview:line2];
    }else if (indexPath.row==2){
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 75, 30)];
        imageview.image = [UIImage imageNamed:@"订单追踪"];
        [cell.contentView addSubview:imageview];
        
        NSString *status = [datadic objectForKey:@"status"];
        
        UIImageView *imgview2 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15+45, 100, 40)];
        if ([status isEqualToString:@"6"]) {
            imgview2.image = [UIImage imageNamed:[NSString stringWithFormat:@"追踪%@",@"5"]];
        }else{
            imgview2.image = [UIImage imageNamed:[NSString stringWithFormat:@"追踪%@",status]];
        }
        [cell.contentView addSubview:imgview2];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60+40+10, 120, 13)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:255/255.0 green:155/255.0 blue:7/255.0 alpha:1.0];
        
        if ([status isEqualToString:@"1"]) {
            label.text = @"待派单";
            label.frame = CGRectMake(30, 110, 120, 13);
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(Main_width-100, 15+45+10, 80, 30);
            [but setTitle:@"取消订单" forState:UIControlStateNormal];
            but.titleLabel.font = [UIFont systemFontOfSize:13];
            [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            but.clipsToBounds = YES;
            but.layer.cornerRadius = 10;
            but.layer.borderWidth = 1;
            but.alpha = 0.54;
            but.layer.borderColor = [UIColor blackColor].CGColor;
            [but addTarget:self action:@selector(quxiaodingdan) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
        }else if ([status isEqualToString:@"2"]){
            label.text = @"已派单";
            label.frame = CGRectMake(30+15, 110, 120, 13);
            
            UIButton *buttel = [UIButton buttonWithType:UIButtonTypeCustom];
            buttel.frame = CGRectMake(Main_width-60, 60, 30, 30);
            [buttel setImage:[UIImage imageNamed:@"师傅电话"] forState:UIControlStateNormal];
            [buttel addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:buttel];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-60-20-(Main_width*2/5), 60, Main_width*2/5, 12)];
            label1.font = Font(12);
            label1.alpha = 0.54;
            label1.textAlignment = NSTextAlignmentRight;
            label1.text = [datadic objectForKey:@"w_fullname"];
            [cell.contentView addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-60-20-(Main_width*2/5), 60+12+8, Main_width*2/5, 12)];
            label2.font = Font(12);
            label2.alpha = 0.54;
            label2.textAlignment = NSTextAlignmentRight;
            label2.text = [datadic objectForKey:@"mobile"];
            [cell.contentView addSubview:label2];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(Main_width-100, 60+12+8+10+12, 70, 25);
            [but setTitle:@"取消订单" forState:UIControlStateNormal];
            but.titleLabel.font = [UIFont systemFontOfSize:13];
            [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            but.clipsToBounds = YES;
            but.layer.cornerRadius = 10;
            but.layer.borderWidth = 1;
            but.alpha = 0.54;
            but.layer.borderColor = [UIColor blackColor].CGColor;
            [but addTarget:self action:@selector(quxiaodingdan) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
        }else if ([status isEqualToString:@"3"]){
            label.text = @"服务中";
            label.frame = CGRectMake(30+30, 110, 120, 13);
            
            UIButton *buttel = [UIButton buttonWithType:UIButtonTypeCustom];
            buttel.frame = CGRectMake(Main_width-60, 60, 30, 30);
            [buttel setImage:[UIImage imageNamed:@"师傅电话"] forState:UIControlStateNormal];
            [buttel addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:buttel];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-60-20-(Main_width*2/5), 60, Main_width*2/5, 12)];
            label1.font = Font(12);
            label1.alpha = 0.54;
            label1.textAlignment = NSTextAlignmentRight;
            label1.text = [datadic objectForKey:@"w_fullname"];
            [cell.contentView addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-60-20-(Main_width*2/5), 60+12+8, Main_width*2/5, 12)];
            label2.font = Font(12);
            label2.alpha = 0.54;
            label2.textAlignment = NSTextAlignmentRight;
            label2.text = [datadic objectForKey:@"mobile"];
            [cell.contentView addSubview:label2];
        }else if ([status isEqualToString:@"4"]){
            label.text = @"待评价";
            label.frame = CGRectMake(30+45, 110, 120, 13);
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(Main_width-100, 50, 70, 25);
            [but setTitle:@"评价" forState:UIControlStateNormal];
            but.titleLabel.font = [UIFont systemFontOfSize:13];
            [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            but.clipsToBounds = YES;
            but.layer.cornerRadius = 10;
            but.layer.borderWidth = 1;
            but.alpha = 0.54;
            but.layer.borderColor = [UIColor redColor].CGColor;
            [but addTarget:self action:@selector(pingjia) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
            
            UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
            but1.frame = CGRectMake(Main_width-100, 50+25+20, 70, 25);
            [but1 setTitle:@"投诉" forState:UIControlStateNormal];
            but1.titleLabel.font = [UIFont systemFontOfSize:13];
            [but1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            but1.clipsToBounds = YES;
            but1.layer.cornerRadius = 10;
            but1.layer.borderWidth = 1;
            but1.alpha = 0.54;
            but1.layer.borderColor = [UIColor blackColor].CGColor;
            [but1 addTarget:self action:@selector(tousu) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but1];
        }else if ([status isEqualToString:@"5"]){
            label.text = @"完成";
            label.frame = CGRectMake(30+60, 110, 120, 13);
            
            UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
            but1.frame = CGRectMake(Main_width-100, 60, 70, 25);
            [but1 setTitle:@"投诉" forState:UIControlStateNormal];
            but1.titleLabel.font = [UIFont systemFontOfSize:13];
            [but1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            but1.clipsToBounds = YES;
            but1.layer.cornerRadius = 10;
            but1.layer.borderWidth = 1;
            but1.alpha = 0.54;
            but1.layer.borderColor = [UIColor blackColor].CGColor;
            [but1 addTarget:self action:@selector(tousu) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but1];
        }else{
            label.text = @"订单已取消";
            label.frame = CGRectMake(30+20, 110, 120, 13);
        }
        [cell.contentView addSubview:label];
        
        
    }else{
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_width/1.76)];
        img.image = [UIImage imageNamed:@"底部"];
        [cell.contentView addSubview:img];
        tableView.rowHeight = Main_width/1.76;
    }
    return cell;
}
- (void)chakan
{
    serviceDetailViewController *dvc = [[serviceDetailViewController alloc] init];
    dvc.serviceID = [datadic objectForKey:@"s_id"];
    dvc.serviceTitle = [datadic objectForKey:@"s_name"];
    [self.navigationController pushViewController:dvc animated:YES];
}
- (void)tousu
{
    tousuViewController *tousu = [[tousuViewController alloc] init];
    tousu.dingdanid = [datadic objectForKey:@"id"];
    [self.navigationController pushViewController:tousu animated:YES];
}
- (void)pingjia
{
    pingjiadingdanViewController *pingjia = [[pingjiadingdanViewController alloc] init];
    pingjia.dingdanid = [datadic objectForKey:@"id"];
    [self.navigationController pushViewController:pingjia animated:YES];
}
- (void)call
{
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[datadic objectForKey:@"mobile"]];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (void)quxiaodingdan
{
    cancledingdanViewController *cancle = [[cancledingdanViewController alloc] init];
    cancle.dingdanid = [datadic objectForKey:@"id"];
    [self.navigationController pushViewController:cancle animated:YES];
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
