//
//  pingLunViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "pingLunViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "scoreDetailModel.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface pingLunViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSourceArr;
    NSInteger pageNum;
}
@property (nonatomic , strong)UITableView *tableView;
@end

@implementation pingLunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"评论";
    [self getData];
    [self createUI];
}
- (void)getData{
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    dict = @{@"id":_plID};
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/service/service/scoreList"];
    [manager POST:strurl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        NSArray *dataArr = responseObject[@"data"];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        dataSourceArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArr) {
            scoreDetailModel *model = [[scoreDetailModel alloc]initWithDictionary:dic error:NULL];
            [dataSourceArr addObject:model];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)createUI{
    CGRect frame = CGRectMake(0, 0, Main_width, Main_Height);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    WS(ws);
    dataSourceArr = [[NSMutableArray alloc] init];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.tableView.mj_footer endRefreshing];
        pageNum = 1;
        [ws getData];
        
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.tableView.mj_header endRefreshing];
        pageNum = pageNum+1;
        [ws getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - tableview delegate / dataSource
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
    scoreDetailModel *model = dataSourceArr[indexPath.section];
    UIImageView *headImg = [[UIImageView alloc]init];
    headImg.frame = CGRectMake(10, 10, 50, 50);
    [headImg sd_setImageWithURL:[NSURL URLWithString:model.avatars] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
