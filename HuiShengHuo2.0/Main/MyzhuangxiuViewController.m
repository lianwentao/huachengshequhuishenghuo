//
//  MyzhuangxiuViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/27.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "MyzhuangxiuViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "activitydetailsViewController.h"
#import "acivityViewController.h"
#import "weixiuViewController.h"
#import "GoodsDetailViewController.h"
#import "WebViewController.h"
#import "fenxiangzhuangxiuViewController.h"
@interface MyzhuangxiuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    
    NSArray *_DataArr;
}

@end

@implementation MyzhuangxiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的装修";
    self.view.backgroundColor = BackColor;
    [self getData];
    
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)createUI
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.backgroundColor = BackColor;
    [self.view addSubview:_TableView];
}

#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _DataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    // 从重用队列里查找可重用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.row==0) {
        tableView.rowHeight = 55;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_width, 55)];
        [cell.contentView addSubview:label];
        label.font = font15;
        label.textAlignment = NSTextAlignmentCenter;
        NSTimeInterval interval    =[[[_DataArr objectAtIndex:indexPath.section] objectForKey:@"uptime"] doubleValue];
        NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString       = [formatter stringFromDate: date];
        label.text = dateString;
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.tag = indexPath.section;
        but.frame = CGRectMake(Main_width-30-15, 12.5, 30, 30);
        [but setImage:[UIImage imageNamed:@"mine_icon_share"] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(shareicon:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:but];
    }else{
        UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, Main_width-25, 0)];
        contentlabel.numberOfLines = 0;
        NSString *base64 = [[_DataArr objectAtIndex:indexPath.section] objectForKey:@"content"];
        
        //NSData *data1 = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
        //NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[base64 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString: attributedString];
        contentlabel.attributedText = string;
        contentlabel.font = [UIFont systemFontOfSize:16];// weight:10
        CGSize size = [contentlabel sizeThatFits:CGSizeMake(contentlabel.frame.size.width, MAXFLOAT)];
        contentlabel.frame = CGRectMake(contentlabel.frame.origin.x, contentlabel.frame.origin.y, size.width,  size.height);
        
        [cell.contentView addSubview:contentlabel];
        tableView.rowHeight = 30+contentlabel.frame.origin.y+contentlabel.frame.size.height;
    }
    return cell;
}
- (void)shareicon:(UIButton *)sender
{
    fenxiangzhuangxiuViewController *fenxiang = [[fenxiangzhuangxiuViewController alloc] init];
    NSString *base64 = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"content"];
    
    //NSData *data1 = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    //NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[base64 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString: attributedString];
    
    NSTimeInterval interval    =[[[_DataArr objectAtIndex:sender.tag] objectForKey:@"uptime"] doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    fenxiang.time =dateString;
    fenxiang.content = string;
    
    [self.navigationController pushViewController:fenxiang animated:YES];
}
- (void)createuissssss
{
    UIImageView *iamgeview = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width/2-60, RECTSTATUS.size.height+44+100, 120, 120)];
    iamgeview.image = [UIImage imageNamed:@"pinglunweikong"];
    [self.view addSubview:iamgeview];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iamgeview.frame.size.width+iamgeview.frame.origin.y+25, Main_width, 20)];
    label1.text = @"选择小慧为您推荐的装修商";
    label1.font = font15;
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.frame.size.width+label1.frame.origin.y+20, 0, 20)];
    label2.text = @"查看每天的装修进度";
    label2.textAlignment = NSTextAlignmentCenter;
    CGSize size = [label2 sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    label2.frame = CGRectMake(label2.frame.origin.x, label2.frame.origin.y, size.width,  size.height);
    label2.font = [UIFont systemFontOfSize:15];
    label2.frame = CGRectMake(Main_width/2-size.width/2, label1.frame.size.width+label1.frame.origin.y+20, size.width, 20);
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, label2.frame.size.width+label2.frame.origin.y+15, 0, 20)];
    label3.text = @"展示每天的装修进度";
    label3.textAlignment = NSTextAlignmentCenter;
    CGSize size1 = [label3 sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
    label3.frame = CGRectMake(label3.frame.origin.x, label3.frame.origin.y, size1.width,  size1.height);
    label3.font = [UIFont systemFontOfSize:15];
    label3.frame = CGRectMake(Main_width/2-size1.width/2, label2.frame.size.width+label2.frame.origin.y+15, size.width, 20);
    [self.view addSubview:label3];
    
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(label2.frame.origin.x-20, label1.frame.size.width+label1.frame.origin.y+20+3, 6, 6)];
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = 3;
    circle.backgroundColor = CIrclecolor;
    [self.view addSubview:circle];
    
    UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(label2.frame.origin.x-20, label2.frame.size.width+label2.frame.origin.y+20+3, 6, 6)];
    circle1.layer.masksToBounds = YES;
    circle1.layer.cornerRadius = 3;
    circle1.backgroundColor = CIrclecolor;
    [self.view addSubview:circle1];
    
    UIButton *suer = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:suer];
    suer.backgroundColor = QIColor;
    [suer setTitle:@"选择装修服务商" forState:UIControlStateNormal];
    suer.frame = CGRectMake(0, Main_Height-49, Main_width, 49);
    [suer addTarget:self action:@selector(suer) forControlEvents:UIControlEventTouchUpInside];
}
- (void)suer
{
    [self getData1];
}
#pragma mark ------联网请求---
-(void)getData1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"community_id":[defaults objectForKey:@"community_id"],@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"site/get_Advertising/c_name/hc_my_decoration"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            NSString *url_id = [[arr objectAtIndex:0] objectForKey:@"id"];
            NSString *url_type = [[arr objectAtIndex:0] objectForKey:@"url_type"];
            NSString *url = [[arr objectAtIndex:0] objectForKey:@"adv_url"];
            NSString *goodsid = [[arr objectAtIndex:0] objectForKey:@"adv_inside_url"];
            if ([url_type isEqualToString:@"5"]) {
                weixiuViewController *weixiu = [[weixiuViewController alloc] init];
                weixiu.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:weixiu animated:YES];
            }if ([url_type isEqualToString:@"3"]) {
                acivityViewController *aciti = [[acivityViewController alloc] init];
                aciti.hidesBottomBarWhenPushed = YES;
                aciti.url = [[arr objectAtIndex:0] objectForKey:@"type_name"];

                [self.navigationController pushViewController:aciti animated:YES];
            }if ([url_type isEqualToString:@"4"]) {
                activitydetailsViewController *acti = [[activitydetailsViewController alloc] init];
                acti.url = [[arr objectAtIndex:0] objectForKey:@"type_name"];
                acti.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:acti animated:YES];
            }if ([url_type isEqualToString:@"7"]) {
                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",url_id];
                UIWebView *callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }if ([url_type isEqualToString:@"2"]) {
                GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
                NSRange range = [url_id rangeOfString:@"id/"]; //现获取要截取的字符串位置
                NSString * result = [url_id substringFromIndex:range.location+3]; //截取字符串
                goods.IDstring = result;
                goods.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:goods animated:YES];
            }if ([url_type isEqualToString:@"10"]||[url_type isEqualToString:@"0"]){
                WebViewController *web = [[WebViewController alloc] init];
                web.url = url;
                web.url_type = @"1";
                web.title = @"小慧推荐";
                NSRange range = [goodsid rangeOfString:@"id/"]; //现获取要截取的字符串位置
                NSString * result = [goodsid substringFromIndex:range.location+3]; //截取字符串
                web.id = result;
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
            }
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSString *strurl = [API stringByAppendingString:@"userCenter/my_decoration"];
    [manager GET:strurl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"success==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _DataArr = [responseObject objectForKey:@"data"];
        }else{
            [self createuissssss];
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
