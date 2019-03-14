//
//  CircleViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/16.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "CircleViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "MoreViewController.h"
#import "circledetailsViewController.h"

#import "PrefixHeader.pch"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height

@interface CircleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_DataArr;
    UITableView *_TableView;
}

@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"圈子";
    
    [self post];
    [self CreateTableView];
    // Do any additional setup after loading the view.
}
#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"community_id":[userinfo objectForKey:@"community_id"]};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *strurl = [API stringByAppendingString:@"social/SocialIndex"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        _DataArr = [[NSMutableArray alloc] init];
        _DataArr = [responseObject objectForKey:@"data"];
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
} 
- (void)CreateTableView
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-49)];
    [self.view addSubview:_TableView];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [[_DataArr objectAtIndex:0] objectForKey:@"list"];
    if (section==0) {
        return arr.count+1;
    }else{
        return 2;
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
    //NSLog(@"-+-+-+-+%@",_DataArr);
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (indexPath.section==0) {
        NSArray *arr = [[_DataArr objectAtIndex:0] objectForKey:@"list"];
        if (indexPath.row==0) {
            if (![arr isKindOfClass:[NSArray class]]) {
                tableView.rowHeight = 0;
            }else{
                tableView.rowHeight = 50;
                NSString *str = nil;
                str = [[_DataArr objectAtIndex:0] objectForKey:@"c_name"];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screen_Width/2, 40)];
                label.text = str;
                label.font = [UIFont systemFontOfSize:20];
                [cell.contentView addSubview:label];
            }
        }else if(indexPath.row>0){
            if (![arr isKindOfClass:[NSArray class]]) {
                tableView.rowHeight = 0;
            }else{
                tableView.rowHeight = 85;
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 75, 75)];
                imageview.layer.masksToBounds = YES;
                imageview.layer.cornerRadius = 37.5;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *API = [defaults objectForKey:@"API"];
                NSString *strurl = [API stringByAppendingString:[[arr objectAtIndex:indexPath.row-1]objectForKey:@"avatars"]];
                [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                [cell.contentView addSubview:imageview];
                
                UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(105, 80, screen_Width-105-15, 0.5)];
                viewline.backgroundColor = [UIColor blackColor];
                [cell.contentView addSubview:viewline];
                
                UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 10, screen_Width-105-15, 30)];
                NSString *base64 = [[arr objectAtIndex:indexPath.row-1] objectForKey:@"content"];
                
                if (base64!=nil) {
                    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
                    NSString *labeltext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    contentlabel.text = labeltext;
                }
                contentlabel.numberOfLines = 2;
                contentlabel.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:contentlabel];
                
                UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(105, 60, 15, 12)];
                imageview1.image = [UIImage imageNamed:@"circle_icon_pinglun_dianjiqian"];
                [cell.contentView addSubview:imageview1];
            }
        }
    }if (indexPath.section==1) {
        NSArray *arr = [[_DataArr objectAtIndex:1] objectForKey:@"list"];
        if (indexPath.row==0) {
            if (![arr isKindOfClass:[NSArray class]]) {
                tableView.rowHeight = 0;
            }else{
                tableView.rowHeight = 50;
                NSString *str = nil;
                str = [[_DataArr objectAtIndex:1] objectForKey:@"c_name"];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screen_Width/2, 40)];
                label.text = str;
                label.font = [UIFont systemFontOfSize:20];
                [cell.contentView addSubview:label];
            }
        }else {
            if (![arr isKindOfClass:[NSArray class]]) {
                tableView.rowHeight = 0;
            }else{
                tableView.rowHeight = 200;
                
                UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
                _scrollView.delegate = self;//设置代理
                [_scrollView setContentSize:CGSizeMake((self.view.frame.size.width)*arr.count, _scrollView.bounds.size.height)];
                _scrollView.showsHorizontalScrollIndicator = NO;
                _scrollView.pagingEnabled = YES;
                [cell.contentView addSubview:_scrollView];
                for (int i=0; i<arr.count; i++) {
                    UIView *acticityview = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width)*i+10, 0, self.view.frame.size.width-20, 200)];
                    // 设置圆角的大小
                    acticityview.layer.cornerRadius = 15;
                    [acticityview.layer setMasksToBounds:YES];
                    acticityview.backgroundColor = [UIColor blueColor];
                    [_scrollView addSubview:acticityview];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 60, 60)];
                    imageview.layer.masksToBounds = YES;
                    imageview.layer.cornerRadius = 37.5;
                    NSString *strurl = [API_img stringByAppendingString:[[arr objectAtIndex:i]objectForKey:@"avatars"]];
                    [imageview sd_setImageWithURL:[NSURL URLWithString: strurl]];
                    [acticityview addSubview:imageview];
                    
                    UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, screen_Width-70, 20)];
                    namelabel.font = [UIFont systemFontOfSize:18];
                    namelabel.text = [[arr objectAtIndex:i] objectForKey:@"nickname"];
                    namelabel.textColor = [UIColor whiteColor];
                    [acticityview addSubview:namelabel];
                    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, screen_Width-70, 20)];
                    timelabel.font = [UIFont systemFontOfSize:15];
                    NSTimeInterval interval    =[[[arr objectAtIndex:i] objectForKey:@"addtime"] doubleValue];
                    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateString       = [formatter stringFromDate: date];
                    timelabel.text = [NSString stringWithFormat:@"发起于:%@",dateString];
                    timelabel.textColor = [UIColor whiteColor];
                    [acticityview addSubview:timelabel];
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 80, screen_Width-30-20, 0.5)];
                    view.backgroundColor = [UIColor whiteColor];
                    [acticityview addSubview:view];
                    
                    UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 95, screen_Width-25, 0)];
                    contentlabel.numberOfLines = 0;
                    
                    NSString *base64 = [[arr objectAtIndex:i] objectForKey:@"content"];
                    if (base64!=nil) {
                        NSData *data1 = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
                        NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
                        contentlabel.text = labeltext;
                    }
                    CGSize size = [contentlabel sizeThatFits:CGSizeMake(contentlabel.frame.size.width, MAXFLOAT)];
                    contentlabel.frame = CGRectMake(contentlabel.frame.origin.x, contentlabel.frame.origin.y, size.width,  size.height);
                    contentlabel.font = [UIFont systemFontOfSize:16];
                    contentlabel.textColor = [UIColor whiteColor];
                    [acticityview addSubview:contentlabel];
                    
                    UILabel *labelnum = [[UILabel alloc] initWithFrame:CGRectMake(screen_Width-20-100, 130, 90, 25)];
                    NSString *num = [NSString stringWithFormat:@"%@人讨论",[[arr objectAtIndex:i] objectForKey:@"r_num"]];
                    labelnum.text = num;
                    labelnum.textColor = [UIColor whiteColor];
                    labelnum.textAlignment = NSTextAlignmentRight;
                    [acticityview addSubview:labelnum];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.tag = i;
                    [but addTarget:self action:@selector(circledetails:) forControlEvents:UIControlEventTouchUpInside];
                    but.frame = CGRectMake(10, 0, self.view.frame.size.width-20, 200);
                    [acticityview addSubview:but];
                    
                }
            }
        }
    }if (indexPath.section==2){
        NSArray *arr = [[_DataArr objectAtIndex:2] objectForKey:@"list"];
        if (indexPath.row==0) {
            if (![arr isKindOfClass:[NSArray class]]) {
                tableView.rowHeight = 0;
            }else{
                tableView.rowHeight = 50;
                NSString *str = nil;
                str = [[_DataArr objectAtIndex:2] objectForKey:@"c_name"];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screen_Width/2, 40)];
                label.text = str;
                label.font = [UIFont systemFontOfSize:20];
                [cell.contentView addSubview:label];
            }
        }else{
            if (![arr isKindOfClass:[NSArray class]]) {
                tableView.rowHeight = 0;
            }else{
                tableView.rowHeight = 10+(screen_Width/2-20+10)*((arr.count+1)/2);
                for (int i=0; i<arr.count; i++) {
                    if (i%2==0) {
                        UIView *view = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5+(screen_Width/2-20+10)*(i/2), screen_Width/2-20, screen_Width/2-20)];
                        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        view.layer.masksToBounds = YES;
                        view.layer.cornerRadius = 5;
                        [cell.contentView addSubview:view];
                        
                        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_Width/2-20, screen_Width/2-20-60)];
                        NSString *strurl = [API_img stringByAppendingString:[[arr objectAtIndex:i]objectForKey:@"img"]];
                        [imageview sd_setImageWithURL:[NSURL URLWithString:strurl]];
                        [view addSubview:imageview];
                        
                        UIImageView *imageviewtouxiang = [[UIImageView alloc] initWithFrame:CGRectMake(15, screen_Width/2-20-60-25, 50, 50)];
                        imageviewtouxiang.layer.masksToBounds = YES;
                        imageviewtouxiang.layer.cornerRadius = 25;
                        NSString *strurl1 = [API_img stringByAppendingString:[[arr objectAtIndex:i]objectForKey:@"avatars"]];
                        [imageviewtouxiang sd_setImageWithURL:[NSURL URLWithString: strurl1]];
                        [view addSubview:imageviewtouxiang];
                        
                        UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, screen_Width/2-20-60+25+5, screen_Width/2-20-20, 25)];
                        NSString *base64 = [[arr objectAtIndex:i] objectForKey:@"content"];
                        
                        if (base64!=nil) {
                            NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
                            NSString *labeltext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            contentlabel.text = labeltext;
                        }
                        contentlabel.numberOfLines = 2;
                        contentlabel.font = [UIFont systemFontOfSize:15];
                        [view addSubview:contentlabel];
                        
                        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                        but.frame = CGRectMake(15, 5+(screen_Width/2-20+10)*(i/2), screen_Width/2-20, screen_Width/2-20);
                        //but.backgroundColor = [UIColor clearColor];
                        [but addTarget:self action:@selector(circledetails1:) forControlEvents:UIControlEventTouchUpInside];
                        but.tag = i;
                        [cell.contentView addSubview:but];
                    }else{
                        UIView *view = [[UIImageView alloc] initWithFrame:CGRectMake(15+screen_Width/2-20+10, 5+(screen_Width/2-20+10)*(i/2), screen_Width/2-20, screen_Width/2-20)];
                        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        view.layer.masksToBounds = YES;
                        view.layer.cornerRadius = 5;
                        [cell.contentView addSubview:view];
                        
                        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_Width/2-20, screen_Width/2-20-60)];
                        NSString *strurl = [API_img stringByAppendingString:[[arr objectAtIndex:i]objectForKey:@"img"]];
                        [imageview sd_setImageWithURL:[NSURL URLWithString:strurl]];
                        [view addSubview:imageview];
                        
                        UIImageView *imageviewtouxiang = [[UIImageView alloc] initWithFrame:CGRectMake(15, screen_Width/2-20-60-25, 50, 50)];
                        imageviewtouxiang.layer.masksToBounds = YES;
                        imageviewtouxiang.layer.cornerRadius = 25;
                        NSString *strurl1 = [API_img stringByAppendingString:[[arr objectAtIndex:i]objectForKey:@"avatars"]];
                        [imageviewtouxiang sd_setImageWithURL:[NSURL URLWithString: strurl1]];
                        [view addSubview:imageviewtouxiang];
                        
                        UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, screen_Width/2-20-60+25+5, screen_Width/2-20-20, 25)];
                        NSString *base64 = [[arr objectAtIndex:i] objectForKey:@"content"];
                        
                        if (base64!=nil) {
                            NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
                            NSString *labeltext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; 
                            contentlabel.text = labeltext;
                        }
                        contentlabel.numberOfLines = 2;
                        contentlabel.font = [UIFont systemFontOfSize:15];
                        [view addSubview:contentlabel];
                        
                        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                        but.frame = CGRectMake(15+screen_Width/2-20+10, 5+(screen_Width/2-20+10)*(i/2), screen_Width/2-20, screen_Width/2-20);
                        //but.backgroundColor = [UIColor clearColor];
                        [but addTarget:self action:@selector(circledetails1:) forControlEvents:UIControlEventTouchUpInside];
                        but.tag = i;
                        [cell.contentView addSubview:but];
                    }
                }
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    circledetailsViewController *details = [[circledetailsViewController alloc] init];
    if (indexPath.section==0) {
        NSArray *arr = [[_DataArr objectAtIndex:0] objectForKey:@"list"];
        details.id = [[arr objectAtIndex:indexPath.row-1] objectForKey:@"id"];
    }
    
    [self.navigationController pushViewController:details animated:YES];
}
- (void)circledetails: (UIButton *)sender
{
    
        circledetailsViewController *details = [[circledetailsViewController alloc] init];
        
        NSArray *arr = [[_DataArr objectAtIndex:1] objectForKey:@"list"];
        details.id = [[arr objectAtIndex:sender.tag] objectForKey:@"id"];
    details.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:details animated:YES];
}
- (void)circledetails1: (UIButton *)sender
{
    circledetailsViewController *details = [[circledetailsViewController alloc] init];
    NSArray *arr = [[_DataArr objectAtIndex:2] objectForKey:@"list"];
    details.id = [[arr objectAtIndex:sender.tag] objectForKey:@"id"];
    details.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:details animated:YES];
}
- (void)butmore:(UIButton *)sender
{
    MoreViewController *more = [[MoreViewController alloc] init];
    more.hidesBottomBarWhenPushed = YES;
    if (sender.tag==1000) {
        more.c_id = [[_DataArr objectAtIndex:0] objectForKey:@"id"];
        more.title = @"邻里交流";
    }if (sender.tag==1001) {
        more.title = @"议事厅";
        more.c_id = [[_DataArr objectAtIndex:1] objectForKey:@"id"];
    }if(sender.tag==1002){
        more.title = @"二手交易";
        more.c_id = [[_DataArr objectAtIndex:2] objectForKey:@"id"];
    }
    [self.navigationController pushViewController:more animated:YES];
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
