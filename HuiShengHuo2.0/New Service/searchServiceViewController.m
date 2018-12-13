//
//  searchServiceViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/12/11.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "searchServiceViewController.h"
#import "View+MASAdditions.h"
#import "serviceDetailViewController.h"

#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "fwListModel.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface searchServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageNum;
    UILabel *titlelabel;
}
@property (nonatomic,strong)UITableView         *tableView;
@property (nonatomic,strong)NSMutableArray         *dataSourceArr;

@end

@implementation searchServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"搜索结果";
    [self getdata];
    [self createdUI];
}
- (void)getdata
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],_canshu:_key};
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
                
                fwListModel *model = [[fwListModel alloc]initWithDictionary:dic error:NULL];
                [_dataSourceArr addObject:model];
            }
            
            [_tableView reloadData];
//            [self setupNavItems];
            
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)setupNavItems{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 44)];
    [self.navigationItem setTitleView:view];
    
    fwListModel *model = _dataSourceArr[0];
    titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, Main_width-90, 40)];
    NSLog(@"%@",model.title);
    titlelabel.text = model.title;
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.font = [UIFont systemFontOfSize:20];
    [view addSubview:titlelabel];
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
    return 40+(Main_width-80)/2.5;
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
    
    fwListModel *model = _dataSourceArr[indexPath.row];
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(10, 10,Main_width-20, (Main_width-80)/2.5);
    [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:model.title_img]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
    imgView.layer.cornerRadius = 5;
    imgView.clipsToBounds = YES;
    [cell addSubview:imgView];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(10, CGRectGetMaxY(imgView.frame),Main_width/2-10, 30);
    titleLab.text = model.title;
    titleLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.numberOfLines = 2;
    titleLab.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:titleLab];
    
    UILabel *priceLab = [[UILabel alloc]init];
    priceLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame), CGRectGetMaxY(imgView.frame), Main_width/2-10, 30);
    priceLab.text = [NSString stringWithFormat:@"￥%@",model.price];
    priceLab.textColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:60/255.0 alpha:1];
    priceLab.font = [UIFont systemFontOfSize:15];
    priceLab.textAlignment = NSTextAlignmentRight;
    [cell addSubview:priceLab];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    serviceDetailViewController *sfDetailVC = [[serviceDetailViewController alloc] init];
    fwListModel *model = _dataSourceArr[indexPath.row];
    sfDetailVC.serviceID = model.id;
    [self.navigationController pushViewController:sfDetailVC animated:YES];
}

@end
