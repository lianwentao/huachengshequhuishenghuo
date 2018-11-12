//
//  homedetailsViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/6.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "homedetailsViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "wuyeViewController.h"
#import "wuyeteamViewController.h"
#import "UITableView+PlaceHolderView.h"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
#import "PrefixHeader.pch"

@interface homedetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    NSMutableArray *_DataArr;
    NSMutableDictionary *_Dic;
}

@end

@implementation homedetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self post];
    [self Createtableview];
    // Do any additional setup after loading the view.
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    NSString *cid = [userd objectForKey:@"community_id"];
    dict = @{@"c_id":cid};
    NSString *strurl = [API stringByAppendingString:@"site/pro_work_list"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        arr = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
        _DataArr = arr;
        _Dic = [responseObject objectForKey:@"data"];
        [_TableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)Createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height)];
    [self.view addSubview:_TableView];
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.enablePlaceHolderView = YES;
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (indexPath.row==0) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screen_Width, 40)];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        label1.text = [user objectForKey:@"community_name"];
        label1.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, screen_Width, 40)];
        NSString *num = [_Dic objectForKey:@"t_num"];
        label2.text = [NSString stringWithFormat:@"本社区共计%@位人员为您服务",num];
        label2.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label2];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake((screen_Width-120)/2, 150, 120, 40);
        [but setTitle:@"查看服务团队" forState:UIControlStateNormal];
        but.titleLabel.font = [UIFont systemFontOfSize:15];
        but.layer.cornerRadius = 15;
        but.backgroundColor = [UIColor redColor];
        [but addTarget:self action:@selector(chakantuandui) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:but];
        
        tableView.rowHeight = 200;
    }if (indexPath.row==1) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screen_Width, 40)];
        label1.text = @"本月综合评分";
        label1.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label1];
        
        for (int i=0; i<5; i++) {//circle_icon_xingxing_dianjihou
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake((screen_Width-230)/2+50*i, 60, 30, 30);
            [but setImage:[UIImage imageNamed:@"circle_icon_xingxing_dianjiqian"] forState:UIControlStateNormal];
            [but setImage:[UIImage imageNamed:@"circle_icon_xingxing_dianjihou"] forState:UIControlStateSelected];
            but.tag=i;
            if (but.tag<4) {
                but.selected = YES;
            }else{
                but.selected = NO;
            }
            [cell.contentView addSubview:but];
        }
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, screen_Width, 40)];
        NSString *num = [_Dic objectForKey:@"s_num"];
        label2.text = [NSString stringWithFormat:@"本%@位业主参与",num];
        label2.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label2];
        
        tableView.rowHeight = 150;
    }if (indexPath.row>1) {
        UIImageView *avravsimageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        avravsimageview.layer.masksToBounds = YES;
        avravsimageview.layer.cornerRadius = 20;
        avravsimageview.backgroundColor = [UIColor lightGrayColor];
        NSString *imgstr = [[_DataArr objectAtIndex:indexPath.row-2] objectForKey:@"avatars"];
        NSString *imgurl = [API_img stringByAppendingString:imgstr];
        [avravsimageview sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
        [cell.contentView addSubview:avravsimageview];
        
        UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, screen_Width-70, 20)];
        timelabel.font = [UIFont systemFontOfSize:15];
        
        NSString *base64date = [[_DataArr objectAtIndex:indexPath.row-2] objectForKey:@"addtime"];
        NSString *base64name = [[_DataArr objectAtIndex:indexPath.row-2] objectForKey:@"title"];
        
        NSData *dataname = [[NSData alloc] initWithBase64EncodedString:base64name options:0];
        NSString *labeltext2 = [[NSString alloc] initWithData:dataname encoding:NSUTF8StringEncoding];
        
        timelabel.text = [NSString stringWithFormat:@"%@  %@",labeltext2,base64date];
        [cell.contentView addSubview:timelabel];
        
        UILabel *contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, screen_Width-25, 0)];
        contentlabel.numberOfLines = 0;
    
        NSString *base64 = [[_DataArr objectAtIndex:indexPath.row-2] objectForKey:@"content"];
        if (base64!=nil) {
            NSData *data1 = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
            NSString *labeltext = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
            contentlabel.text = labeltext;
        }
        CGSize size = [contentlabel sizeThatFits:CGSizeMake(contentlabel.frame.size.width, MAXFLOAT)];
        contentlabel.frame = CGRectMake(contentlabel.frame.origin.x, contentlabel.frame.origin.y, size.width,  size.height);
        contentlabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:contentlabel];
        
        tableView.rowHeight = 60+size.height;
    }
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>1) {
        wuyeViewController *wuye = [[wuyeViewController alloc] init];
        wuye.title = @"详情";
        wuye.id = [[_DataArr objectAtIndex:indexPath.row-2] objectForKey:@"id"];
        [self.navigationController pushViewController:wuye animated:YES];
    }
}
- (void)chakantuandui
{
    wuyeteamViewController *team = [[wuyeteamViewController alloc] init];
    team.title = @"服务团队";
    [self.navigationController pushViewController:team animated:YES];
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
