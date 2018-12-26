//
//  xinfangshouceViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/24.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "xinfangshouceViewController.h"
#import <AFNetworking.h>
#import "xinfangshoucemolde.h"
#import "xinfangshouceCell.h"
#import "xinfangshoucewebViewController.h"
#import "UIImageView+WebCache.h"
#import "weixiuViewController.h"
#import "activitydetailsViewController.h"
#import "acivityViewController.h"
#import "GoodsDetailViewController.h"
#import "WebViewController.h"
#import "circledetailsViewController.h"
#import "shangpinerjiViewController.h"
@interface xinfangshouceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TabelView;
    
    NSMutableArray *_DataArr;
    NSArray *dataArr;
}

@end

@implementation xinfangshouceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新房手册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getData];
    [self CreateUI];
    // Do any additional setup after loading the view.
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    NSString *strurl = [API stringByAppendingString:@"memorandum/get_new_house"];
    [manager GET:strurl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        _DataArr = [NSMutableArray arrayWithCapacity:0];
        dataArr = [NSArray array];
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            dataArr = [responseObject objectForKey:@"data"];
        }
        [_TabelView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)CreateUI
{
    _TabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TabelView.delegate = self;
    _TabelView.dataSource = self;
//    _TabelView.estimatedRowHeight = 0;
//    _TabelView.estimatedSectionFooterHeight = 0;
//    _TabelView.estimatedSectionHeaderHeight = 0;
    _TabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TabelView.backgroundColor = BackColor;
    [self.view addSubview:_TabelView];
}

#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 100;
    }else{
        NSDictionary *dic = [[NSDictionary alloc] init];
        dic = [[dataArr objectAtIndex:indexPath.row-1] objectForKey:@"list"];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            return Main_width/2+20;
        }else{
            return (Main_width-30)/2+10;
        }
    }
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"xinfangshouceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.row==0) {
        cell.contentView.backgroundColor = BackColor;
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake((Main_width-135)/2, 10, 135, 70)];
        imageview.image = [UIImage imageNamed:@"xinfangshouce"];
        [cell.contentView addSubview:imageview];
    }else{
       NSDictionary *dic = [[NSDictionary alloc] init];
        dic = [[dataArr objectAtIndex:indexPath.row-1] objectForKey:@"list"];
        if (![[[dataArr objectAtIndex:indexPath.row-1] objectForKey:@"list"] isEqualToString:@""]) {
            NSLog(@"1111");
            UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, Main_width/2)];
            _scrollView.delegate = self;//设置代理
            
            _scrollView.showsHorizontalScrollIndicator = NO;
            [cell.contentView addSubview:_scrollView];
            NSArray *arr = [NSArray array];
            arr = [dic objectForKey:@"li"];
            [_scrollView setContentSize:CGSizeMake(Main_width*2/3*arr.count+15+15+10,Main_width/2)];
            for (int i=0; i<arr.count; i++) {
                UIImageView *imaeee = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*(Main_width*2/3)+10*i, 0, Main_width*2/3, Main_width/3)];
                NSString *url = [API_img stringByAppendingString:[[arr objectAtIndex:i] objectForKey:@"img"]];
                [imaeee sd_setImageWithURL:[NSURL URLWithString:url]];
                [_scrollView addSubview:imaeee];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(15+i*(Main_width*2/3)+10*i, 0, Main_width*2/3, Main_width/3);
                but.tag = i;
                NSString *url_type = [[arr objectAtIndex:i] objectForKey:@"url_type"];
                [but setTitle:url_type forState:UIControlStateNormal];
                [but.titleLabel setFont:[UIFont systemFontOfSize:1]];
                [but addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
                [_scrollView addSubview:but];
            }
        }else{
            NSLog(@"222");
            UIImageView *_imageview = [[UIImageView alloc] init];
            [cell.contentView addSubview:_imageview];
            
            UILabel *_content = [[UILabel alloc] init];
            [cell.contentView addSubview:_content];
            
            NSString *imageviewurl = [API_img stringByAppendingString:[[dataArr objectAtIndex:indexPath.row-1] objectForKey:@"article_image"]];
            
            NSString *content = [NSString stringWithFormat:@"%@.%@",[[dataArr objectAtIndex:indexPath.row-1] objectForKey:@"order_num"],[[dataArr objectAtIndex:indexPath.row-1] objectForKey:@"title"]];
            float height = 2;
            _imageview.frame = CGRectMake(15, 0, Main_width-30, (Main_width-30)/height);
            [_imageview sd_setImageWithURL:[NSURL URLWithString:imageviewurl] placeholderImage:[UIImage imageNamed:@"展位图正"]];
            
            _content.frame = CGRectMake(125, _imageview.frame.size.height-40, _imageview.frame.size.width-125, 40);
            _content.text = content;
        }
    }
    return cell;
}
- (void)click:(UIButton *)sender
{
    NSString *url_type = sender.titleLabel.text;
    NSString *url_id = [NSString stringWithFormat:@"%ld",sender.tag];
    
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
//        activitydetailsViewController *acti = [[activitydetailsViewController alloc] init];
//        acti.url = [[centerArr objectAtIndex:indexPath.row-1] objectForKey:@"type_name"];
//        acti.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:acti animated:YES];
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
//        WebViewController *web = [[WebViewController alloc] init];
//        web.url = url;
//        web.url_type = @"1";
//        web.title = @"小慧推荐";
//        NSRange range = [goodsid rangeOfString:@"id/"]; //现获取要截取的字符串位置
//        NSString * result = [goodsid substringFromIndex:range.location+3]; //截取字符串
//        web.id = result;
//        web.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:web animated:YES];
    }if ([url_type isEqualToString:@"12"]) {
        self.tabBarController.selectedIndex = 4;
    }if ([url_type isEqualToString:@"13"]) {
        circledetailsViewController *notice = [[circledetailsViewController alloc] init];
        notice.hidesBottomBarWhenPushed = YES;
        notice.id = url_id;
        [self.navigationController pushViewController:notice animated:YES];
    }if ([url_type isEqualToString:@"14"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_id]];
    }if ([url_type isEqualToString:@"1"]) {
        shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
        NSString *type_name = [[[[[dataArr objectAtIndex:3] objectForKey:@"list"] objectForKey:@"li"] objectAtIndex:sender.tag] objectForKey:@"type_name"];
        NSRange range = [type_name rangeOfString:@"id/"]; //现获取要截取的字符串位置
        NSString * result = [type_name substringFromIndex:range.location+3]; //截取字符串
        erji.id = result;
        erji.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:erji animated:YES];
    }
//    NSDictionary *dic = [[NSDictionary alloc] init];
//    dic = [[dataArr objectAtIndex:3] objectForKey:@"list"];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>0) {
        NSDictionary *dic = [[NSDictionary alloc] init];
        dic = [[dataArr objectAtIndex:indexPath.row-1] objectForKey:@"list"];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
        }else{
            xinfangshoucewebViewController *web = [[xinfangshoucewebViewController alloc] init];
            web.url = [[dataArr objectAtIndex:indexPath.row-1] objectForKey:@"url"];
            
            web.title = [[dataArr objectAtIndex:indexPath.row-1] objectForKey:@"title"];
            [self.navigationController pushViewController:web animated:YES];
        }
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
