//
//  fuwusearchresultViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/11.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fuwusearchresultViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "VOTagList.h"
#import "businessVCModel.h"
#import "serviceModel.h"
#import "serviceDetailViewController.h"
#import "newshangjiaViewController.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface fuwusearchresultViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageNum;
    NSMutableArray *labelArr;
    NSMutableArray *serviceArr;
    NSMutableArray *titleArr;
    NSMutableArray *titleImgArr;
    NSMutableArray *imgIDArr;
    UILabel *titlelabel;
    AppDelegate *myDelegate;
}
@property (nonatomic,strong)UITableView         *tableView;
@property (nonatomic,strong)NSMutableArray         *dataSourceArr;
@end

@implementation fuwusearchresultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"搜索结果";
    myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self getdata];
//    [self setupNavItems];
    [self createdUI];
}
- (void)getdata
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],_canshu:_key,@"hui_community_id":[user objectForKey:@"community_id"]};
   
    NSString *strurl = [API_NOAPK stringByAppendingString:_url];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WBLog(@"responseObject = %@",responseObject);
//        WBLog(@"---%@--%@--%@--%@",responseObject,[responseObject objectForKey:@"msg"],_key,_canshu);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSArray *dataArr = responseObject[@"data"];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            _dataSourceArr = [NSMutableArray array];
            for (NSDictionary *dic in dataArr) {
                businessVCModel *model = [[businessVCModel alloc]initWithDictionary:dic error:NULL];
                [_dataSourceArr addObject:model];
            }
           
            [_tableView reloadData];

        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)createdUI{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)style:UITableViewStylePlain ];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    WS(ws);
    _dataSourceArr = [[NSMutableArray alloc] init];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.tableView.mj_footer endRefreshing];
        pageNum = 1;
        [ws getdata];

    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.tableView.mj_header endRefreshing];
        pageNum = pageNum+1;
        [ws getdata];
    }];
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataSourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130+(Main_width-80)/2.5;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    businessVCModel *model = _dataSourceArr[indexPath.row];
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(10, 10, 60, 60);
    [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:model.logo]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
    imgView.layer.cornerRadius = 30;
    imgView.clipsToBounds = YES;
    [cell addSubview:imgView];

    //    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    imgBtn.frame = CGRectMake(10, 10, 60, 60);
    //    NSString *iconStr = model.u_img;
    //    if ([iconStr isKindOfClass:[NSString class]]?iconStr:@"") {
    //        [imgBtn xr_setButtonImageWithUrl:iconStr];
    //    }else{
    //        [imgBtn setImage:PlaceHolderImage_Icon forState:UIControlStateNormal];
    //    }

    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, 10, Main_width-20-60-5, 30);
    titleLab.text = model.name ;
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:titleLab];


    labelArr = [NSMutableArray array];
    for (int i = 0; i < model.category.count; i++) {
        NSDictionary *dic = model.category[i];
        NSString *labStr = [dic objectForKey:@"category_cn"];
        [labelArr addObject:labStr];
    }
    if (labelArr == nil) {
        
    }else{
        VOTagList *tagList = [[VOTagList alloc] initWithTags:labelArr];
        tagList.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, CGRectGetMaxY(titleLab.frame), Main_width-20-5-60, 20);
        tagList.multiLine = YES;
        tagList.multiSelect = YES;
        tagList.allowNoSelection = YES;
        tagList.vertSpacing = 20;
        tagList.horiSpacing = 10;
        tagList.selectedTextColor = [UIColor blackColor];
        tagList.tagBackgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        tagList.selectedTagBackgroundColor = [UIColor redColor];
        tagList.tagCornerRadius = 3;
        tagList.tagEdge = UIEdgeInsetsMake(2, 2, 2, 2);
        [cell addSubview:tagList];
    }
    

    titleImgArr = [NSMutableArray array];
    for (int i = 0; i < model.service.count; i++) {
        NSDictionary *dic = model.service[i];
        NSString *titleImgStr = [dic objectForKey:@"title_img"];
        [titleImgArr addObject:titleImgStr];
    }
    titleArr = [NSMutableArray array];
    for (int i = 0; i < model.service.count; i++) {
        NSDictionary *dic = model.service[i];
        NSString *titleStr = [dic objectForKey:@"title"];
        [titleArr addObject:titleStr];
    }
    imgIDArr = [NSMutableArray array];
    for (int i = 0;  i < model.service.count; i++) {
        NSDictionary *dic = model.service[i];
        NSString *titleStr = [dic objectForKey:@"id"];
        [imgIDArr addObject:titleStr];
    }
    if (titleImgArr == nil || titleArr == nil || imgIDArr == nil) {
        
    }else{
        UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, Main_width, 180)];
        backscrollview.contentSize = CGSizeMake((Main_width-40)*titleImgArr.count+16*(titleImgArr.count-1), 180);
        backscrollview.showsVerticalScrollIndicator = NO;
        backscrollview.showsHorizontalScrollIndicator = NO;
        backscrollview.userInteractionEnabled = YES;
        [cell addSubview:backscrollview];
        for (int i=0; i<titleImgArr.count; i++) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10+(i*(Main_width-30)),0 , Main_width-80, (Main_width-80)/2.5)];
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 3;
            [backscrollview addSubview:view];
            
            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.frame = CGRectMake(0,0 , Main_width-40, (Main_width-80)/2.5);
            [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:titleImgArr[i]]] placeholderImage:[UIImage imageNamed:@"展位图长2.5"]];
            imgView.layer.cornerRadius = 5;
            imgView.clipsToBounds = YES;
            [view addSubview:imgView];
            
            UIButton *goodsbut = [UIButton buttonWithType:UIButtonTypeCustom];
            goodsbut.frame = CGRectMake(0, 0, Main_width-40, (Main_width-80)/2.5);
            goodsbut.tag = [imgIDArr[i] integerValue]+100;
            [goodsbut addTarget:self action:@selector(pushgoods:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:goodsbut];
            
            UILabel *titleLab = [[UILabel alloc] init];
            titleLab.frame = CGRectMake(10+(i*(Main_width-30)), CGRectGetMaxY(imgView.frame), Main_width-40, 30);
            titleLab.text = titleArr[i];
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.font = [UIFont systemFontOfSize:18];
            [backscrollview addSubview:titleLab];
            
        }
    }
   

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    businessVCModel *model = _dataSourceArr[indexPath.row];
    newshangjiaViewController *shangJiaVC = [[newshangjiaViewController alloc] init];
    shangJiaVC.shangjiaid = model.id;
    shangJiaVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shangJiaVC animated:YES];
}
- (void)pushgoods:(UIButton *)sender{
    
    NSInteger i = sender.tag-100;
    NSLog(@"oooooo = %ld",i);
    serviceDetailViewController *svVC = [[serviceDetailViewController alloc] init];
    svVC.serviceID = [NSString stringWithFormat:@"%ld",i];
    svVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svVC animated:YES];
}

@end
