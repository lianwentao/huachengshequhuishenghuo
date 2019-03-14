//
//  ServiceViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/16.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "ServiceViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "HalfCircleActivityIndicatorView.h"
#import "acivityViewController.h"
#import "joinViewController.h"
#import "activitydetailsViewController.h"
#import "weixiuViewController.h"
#import "fuwudingdanViewController.h"
#import "youhuiquanxiangqingViewController.h"
#import "youhuiquanViewController.h"
#import "shangpinerjiViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import "circledetailsViewController.h"
#import "LoginViewController.h"
#import "PrefixHeader.pch"
#import "youxianjiaofeiViewController.h"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height

@interface ServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *issueButton;
    UITableView *_TableView;
    NSMutableArray *_DataArr;
    
    UIImageView *NoUrlimageview;
    UIButton *Againbut;
    HalfCircleActivityIndicatorView *LoadingView;
}


@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"服务";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createrightbutton];
    [self post];
    [self CreateTableView];
    [self createnotice];
    [self LoadingView];
    [LoadingView startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadtable) name:@"changetitle" object:nil];
    // Do any additional setup after loading the view.
}
 -(void)reloadtable
{
    [self post];
}
- (void)createnotice
{
    NoUrlimageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-50, 100, 100)];
    NoUrlimageview.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:NoUrlimageview];
    Againbut = [UIButton buttonWithType:UIButtonTypeCustom];
    Againbut.frame = CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-20+110, 100, 40);
    [Againbut setTitle:@"重新加载" forState:UIControlStateNormal];
    [Againbut setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [Againbut addTarget:self action:@selector(again) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Againbut];
    
    NoUrlimageview.hidden = YES;
    Againbut.hidden = YES;
}
#pragma mark - LoadingView
- (void)LoadingView
{
    LoadingView = [[HalfCircleActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/2, (self.view.frame.size.height-40)/2, 40, 40)];
    [self.view addSubview:LoadingView];
}
- (void)createrightbutton
{
    //自定义一个导航条右上角的一个button
    UIImage *issueImage = [UIImage imageNamed:@"icon_center_fuwu-2"];
    
    issueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    issueButton.frame = CGRectMake(0, 0, 30, 30);
    [issueButton setBackgroundImage:issueImage forState:UIControlStateNormal];
    issueButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [issueButton addTarget:self action:@selector(issueBton) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
}
- (void)issueBton
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        fuwudingdanViewController *fuwudingdan = [[fuwudingdanViewController alloc] init];
        fuwudingdan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fuwudingdan animated:YES];
    }
}
#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"community_id":[user objectForKey:@"community_id"],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    //3.发送GET请求
    /*
     第一个参数:请求路径(NSString)+ 不需要加参数
     第二个参数:发送给服务器的参数数据
     第三个参数:progress 进度回调
     第四个参数:success  成功之后的回调(此处的成功或者是失败指的是整个请求)
     task:请求任务
     responseObject:注意!!!响应体信息--->(json--->oc))
     task.response: 响应头信息
     第五个参数:failure 失败之后的回调
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *strurl = [API stringByAppendingString:@"site/getAppMenuMore"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        _DataArr = [[NSMutableArray alloc] init];
        _DataArr = [responseObject objectForKey:@"data"];
        [_TableView reloadData];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _TableView.hidden = NO;
            NoUrlimageview.hidden = YES;
            Againbut.hidden = YES;
            [LoadingView stopAnimating];
            LoadingView.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _TableView.hidden = YES;
        [LoadingView stopAnimating];
        LoadingView.hidden = YES;
        NoUrlimageview.hidden = NO;
        Againbut.hidden = NO;
        NSLog(@"failure--%@",error);
    }];
}
- (void)again
{
    NoUrlimageview.hidden = YES;
    Againbut.hidden = YES;
    [LoadingView startAnimating];
    [self post];
}
- (void)CreateTableView
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height) ];
    _TableView.backgroundColor = HColor(187, 187, 187);
    //_TableView.estimatedRowHeight = 0;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.backgroundColor = [UIColor whiteColor];
    _TableView.delegate = self;
    _TableView.dataSource = self;
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
    NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.row==0) {
        cell.textLabel.text = [[_DataArr objectAtIndex:indexPath.section] objectForKey:@"name"];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        tableView.rowHeight = 60;
        }else{
            NSArray *dataarr = [[_DataArr objectAtIndex:indexPath.section] objectForKey:@"list"];
            
            long WIDTH = screen_Width/2/5;
            tableView.rowHeight = (dataarr.count+3)/4*(screen_Width/8+40);
            for (int i=0; i<dataarr.count; i++) {
                if (i%4==0) {
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH, (screen_Width/8+40)*(i/4), screen_Width/8, screen_Width/8)];
                    NSString *strurl = [API_img stringByAppendingString:[[dataarr objectAtIndex:i] objectForKey:@"menu_logo"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [cell.contentView addSubview:imageview];
                    
                    NSString *is_available = [[dataarr objectAtIndex:i] objectForKey:@"is_available"];
                    if ([is_available isEqualToString:@"1"]) {
                        
                    }else{
                        UIImageView *smallview = [[UIImageView alloc] initWithFrame:CGRectMake(screen_Width/8-10, 0, 20, 20)];
                        smallview.image = [UIImage imageNamed:@"weikaifang"];
                        [imageview addSubview:smallview];
                    }
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2, (screen_Width/8+40)*(i/4)+screen_Width/8+5, screen_Width/8+WIDTH, 25)];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.text = [[dataarr objectAtIndex:i] objectForKey:@"menu_name"];
                    [cell.contentView addSubview:label];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(WIDTH/2, (screen_Width/8+40)*(i/4), screen_Width/8+WIDTH, (screen_Width/8+40));
                    [but setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
                    
                    [but.titleLabel setFont:[UIFont systemFontOfSize:1]];
                    but.titleLabel.textColor = [UIColor blackColor];
                    [but addTarget:self action:@selector(sssss:) forControlEvents:UIControlEventTouchUpInside];
                    NSString *url_type = [[dataarr objectAtIndex:i] objectForKey:@"url_type"];
                    but.tag = indexPath.section;
                    //but.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:but];
                    
//                    if (i=) {
//                        <#statements#>
//                    }
                }if (i%4==1) {
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*2+(screen_Width/8), (screen_Width/8+40)*(i/4), screen_Width/8, screen_Width/8)];
                    NSString *strurl = [API_img stringByAppendingString:[[dataarr objectAtIndex:i] objectForKey:@"menu_logo"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [cell.contentView addSubview:imageview];
                    
                    NSString *is_available = [[dataarr objectAtIndex:i] objectForKey:@"is_available"];
                    if ([is_available isEqualToString:@"1"]) {
                        
                    }else{
                        UIImageView *smallview = [[UIImageView alloc] initWithFrame:CGRectMake(screen_Width/8-10, 0, 20, 20)];
                        smallview.image = [UIImage imageNamed:@"weikaifang"];
                        [imageview addSubview:smallview];
                    }
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((screen_Width/8+WIDTH)+WIDTH/2, (screen_Width/8+40)*(i/4)+screen_Width/8+5, screen_Width/8+WIDTH, 25)];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.text = [[dataarr objectAtIndex:i] objectForKey:@"menu_name"];
                    [cell.contentView addSubview:label];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake((screen_Width/8+WIDTH)+WIDTH/2, (screen_Width/8+40)*(i/4), screen_Width/8+WIDTH, (screen_Width/8+40));
                    
                    [but setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
                    but.titleLabel.textColor = [UIColor clearColor];
                    [but.titleLabel setFont:[UIFont systemFontOfSize:1]];
                    [but addTarget:self action:@selector(sssss:) forControlEvents:UIControlEventTouchUpInside];
                    NSString *url_type = [[dataarr objectAtIndex:i] objectForKey:@"url_type"];
                    but.tag = indexPath.section;
                    but.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:but];
                }if (i%4==2) {
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*3+(screen_Width/8)*2, (screen_Width/8+40)*(i/4), screen_Width/8, screen_Width/8)];
                    NSString *strurl = [API_img stringByAppendingString:[[dataarr objectAtIndex:i] objectForKey:@"menu_logo"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [cell.contentView addSubview:imageview];
                    
                    NSString *is_available = [[dataarr objectAtIndex:i] objectForKey:@"is_available"];
                    if ([is_available isEqualToString:@"1"]) {
                        
                    }else{
                        UIImageView *smallview = [[UIImageView alloc] initWithFrame:CGRectMake(screen_Width/8-10, 0, 20, 20)];
                        smallview.image = [UIImage imageNamed:@"weikaifang"];
                        [imageview addSubview:smallview];
                    }
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((screen_Width/8+WIDTH)*2+WIDTH/2, (screen_Width/8+40)*(i/4)+screen_Width/8+5, screen_Width/8+WIDTH, 25)];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.text = [[dataarr objectAtIndex:i] objectForKey:@"menu_name"];
                    [cell.contentView addSubview:label];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake((screen_Width/8+WIDTH)*2+WIDTH/2, (screen_Width/8+40)*(i/4), screen_Width/8+WIDTH, (screen_Width/8+40)); //(screen_Width/8+40)*(i/4)
                    [but setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
                    [but.titleLabel setFont:[UIFont systemFontOfSize:1]];
                    but.titleLabel.textColor = [UIColor clearColor];
                    [but addTarget:self action:@selector(sssss:) forControlEvents:UIControlEventTouchUpInside];
                    NSString *url_type = [[dataarr objectAtIndex:i] objectForKey:@"url_type"];
                    but.tag = indexPath.section;
                    but.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:but];
                }if(i%4==3){
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*4+(screen_Width/8)*3, (screen_Width/8+40)*(i/4), screen_Width/8, screen_Width/8)];
                    NSString *strurl = [API_img stringByAppendingString:[[dataarr objectAtIndex:i] objectForKey:@"menu_logo"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [cell.contentView addSubview:imageview];
                    
                    
                    NSString *is_available = [[dataarr objectAtIndex:i] objectForKey:@"is_available"];
                    if ([is_available isEqualToString:@"1"]) {
                        
                    }else{
                        UIImageView *smallview = [[UIImageView alloc] initWithFrame:CGRectMake(screen_Width/8-10, 0, 20, 20)];
                        smallview.image = [UIImage imageNamed:@"weikaifang"];
                        [imageview addSubview:smallview];
                    }
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((screen_Width/8+WIDTH)*3+WIDTH/2, (screen_Width/8+40)*(i/4)+screen_Width/8+5, screen_Width/8+WIDTH, 25)];
                    label.font = [UIFont systemFontOfSize:15];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.text = [[dataarr objectAtIndex:i] objectForKey:@"menu_name"];
                    [cell.contentView addSubview:label];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake((screen_Width/8+WIDTH)*3+WIDTH/2, (screen_Width/8+40)*(i/4), screen_Width/8+WIDTH , (screen_Width/8+40));
                    [but addTarget:self action:@selector(sssss:) forControlEvents:UIControlEventTouchUpInside];
                    [but setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
                    [but.titleLabel setFont:[UIFont systemFontOfSize:1]];
                    but.titleLabel.textColor = [UIColor clearColor];
                    
                    //NSString *url_type = [[dataarr objectAtIndex:i] objectForKey:@"url_type"];
                    but.tag = indexPath.section;
                    but.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:but];
                }
            }
        }
    return cell;
}
- (void)sssss:(UIButton *)sender
{
    int row = [sender.titleLabel.text intValue];
    NSArray *dataarr = [NSArray array];
    dataarr = [[_DataArr objectAtIndex:sender.tag] objectForKey:@"list"];
    
    NSString *url_type = [[dataarr objectAtIndex:row] objectForKey:@"url_type"];
    NSString *is_available = [[dataarr objectAtIndex:row] objectForKey:@"is_available"];
    NSString *url_id = [[dataarr objectAtIndex:row] objectForKey:@"url_id"];
    [self push:url_id :url_type :is_available];
}
- (void)push:(NSString *)url_id :(NSString *)url_type :(NSString *)is_available
{
    if ([is_available isEqualToString:@"1"]) {
        if ([url_type isEqualToString:@"5"]) {
            weixiuViewController *weixiu = [[weixiuViewController alloc] init];
            weixiu.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:weixiu animated:YES];
        }if ([url_type isEqualToString:@"3"]) {
            acivityViewController *aciti = [[acivityViewController alloc] init];
            aciti.hidesBottomBarWhenPushed = YES;
            aciti.url = url_id;
            [self.navigationController pushViewController:aciti animated:YES];
        }if ([url_type isEqualToString:@"4"]) {
            activitydetailsViewController *acti = [[activitydetailsViewController alloc] init];
            acti.url = url_id;
            acti.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:acti animated:YES];
        }if ([url_type isEqualToString:@"7"]) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",url_id];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }if ([url_type isEqualToString:@"8"]) {
            youhuiquanViewController *youhuiquan = [[youhuiquanViewController alloc] init];
            youhuiquan.jpushstring = @"jpush";
            [self.navigationController presentViewController:youhuiquan animated:YES completion:nil];
        }if ([url_type isEqualToString:@"9"]) {
            youhuiquanxiangqingViewController *youhuiquan = [[youhuiquanxiangqingViewController alloc] init];
            youhuiquan.jpushstring = @"jpush";
            [self.navigationController presentViewController:youhuiquan animated:YES completion:nil];
        }if ([url_type isEqualToString:@"1"]) {
            
        }if ([url_type isEqualToString:@"12"]) {
            self.tabBarController.selectedIndex = 4;
        }if ([url_type isEqualToString:@"13"]) {
            circledetailsViewController *notice = [[circledetailsViewController alloc] init];
            notice.hidesBottomBarWhenPushed = YES;
            notice.id = url_id;
            [self.navigationController pushViewController:notice animated:YES];
        }if ([url_type isEqualToString:@"14"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_id]];
        }if([url_type isEqualToString:@"15"]) {
            youxianjiaofeiViewController *youxian = [[youxianjiaofeiViewController alloc] init];
            youxian.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:youxian animated:YES];
        }
    }else{
        [MBProgressHUD showToastToView:self.view withText:@"本小区暂未开放"];
    }
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
