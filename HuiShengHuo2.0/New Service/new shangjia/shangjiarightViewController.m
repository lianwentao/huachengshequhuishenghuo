//
//  shangjiarightViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/8.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "shangjiarightViewController.h"
#import "newshangjiaViewController.h"
#import "UIImageView+WebCache.h"
#import "shopPingLunModel.h"

#import "MJRefresh.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface shangjiarightViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TableView;
    NSMutableArray *_DataArr;
    NSMutableArray *dataSourceArr;
    NSInteger pageNum;
}

@end

@implementation shangjiarightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self post];

    [self CreateTableview];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chuandi:) name:@"chuandititlearr" object:nil];
    // Do any additional setup after loading the view.
}
- (void)chuandi:(NSNotification *)info
{
    WBLog(@"---%@",info.userInfo);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    newshangjiaViewController *vc = (newshangjiaViewController *)[self parentViewController];//父控制器
    
    if (scrollView.contentOffset.y <= 0) {
        self.offsetType = OffsetTypeMin;
        scrollView.contentOffset = CGPointZero;
    } else {
        self.offsetType = OffsetTypeCenter;
    }
    
    
    if (vc.offsetType != OffsetTypeMax) {
        scrollView.contentOffset = CGPointZero;
    }
    if (vc.offsetType == OffsetTypeMax) {
        
    }
}
#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"id":_shopID,@"p":[NSString stringWithFormat:@"%ld",pageNum],@"hui_community_id":[user objectForKey:@"community_id"]};
    NSLog(@"评论 == %@",dict);
    
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/Service/institution/merchantComments"];
   
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"评论dataStr == %@",dataStr);
        
//        _DataArr = responseObject[@"data"];
//        dataSourceArr = [NSMutableArray array];
//        for (NSDictionary *dic in _DataArr) {
//            scoreDetailModel *model = [[scoreDetailModel alloc]initWithDictionary:dic error:NULL];
//            [dataSourceArr addObject:model];
//        }

//
        if ([responseObject[@"data"] isKindOfClass:[NSNull class]]) {
            NSLog(@"1111111111");
        }else{

            NSArray *dataArr = responseObject[@"data"];
            
            if (dataArr == nil) {
                NSLog(@"1111") ;
            }else{
                [_tableView.mj_footer endRefreshing];
                dataSourceArr = [NSMutableArray array];
                for (NSDictionary *dic in dataArr) {
                    shopPingLunModel *model = [[shopPingLunModel alloc]initWithDictionary:dic error:NULL];
                    [dataSourceArr addObject:model];
                }
                [_tableView reloadData];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - 创建tableview
- (void)CreateTableview
{
    _tableView = [[LWGesturePenetrationTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //_TableView.estimatedRowHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    WS(ws);
    dataSourceArr = [[NSMutableArray alloc] init];
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [ws.tableView.mj_footer endRefreshing];
//        pageNum = 1;
//        [ws post];
//
//    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.tableView.mj_header endRefreshing];
        pageNum = pageNum+1;
        [ws post];
    }];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - TableView的代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    shopPingLunModel *model = dataSourceArr[indexPath.section];
    UIImageView *headImg = [[UIImageView alloc]init];
    headImg.frame = CGRectMake(10, 10, 50, 50);
    [headImg sd_setImageWithURL:[NSURL URLWithString:model.avatars] placeholderImage:[UIImage imageNamed:@"展位图正"]];
    headImg.layer.cornerRadius = 25;
    headImg.clipsToBounds = YES;
    headImg.backgroundColor = [UIColor yellowColor];
    [cell addSubview:headImg];
    
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.frame = CGRectMake(CGRectGetMaxX(headImg.frame)+10, 10, 150, 20);
    nameLab.text = model.nickname;
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.textColor = [UIColor lightGrayColor];
    [cell addSubview:nameLab];
    
    int i = [model.score intValue];
    for (int j = 0; j<i; j++) {
        UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImg.frame)+10+j*20, CGRectGetMaxY(nameLab.frame), 20, 20)];
        starView.image = [UIImage imageNamed:@"circle_icon_xingxing_dianjihou"];
        [cell.contentView addSubview:starView];
    }
    
    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.frame = CGRectMake(Main_width-20-100, 10, 100, 20);
    NSTimeInterval time=[model.evaluatime doubleValue]+28800;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    timeLab.text = currentDateStr;
    timeLab.font = [UIFont systemFontOfSize:15];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.textColor = [UIColor lightGrayColor];
    [cell addSubview:timeLab];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(10, CGRectGetMaxY(headImg.frame)+10, Main_width-20, 20);
    titleLab.text = model.evaluate;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.textColor = [UIColor blackColor];
    [cell addSubview:titleLab];
    
    return cell;
    
}


@end
