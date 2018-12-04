
//
//  fwflViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/28.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fwflViewController.h"
#import "fengLeiDetailViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "MJRefresh.h"
#import "feflModel.h"
#import "listModel.h"
#define btnWidth (Main_width-50)/4
@interface fwflViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView;
    feflModel *model;
}
@property (nonatomic,strong)NSMutableArray         *dataSourceArr;
@property (nonatomic,strong)NSMutableArray         *listArr;
@property (nonatomic,strong)NSMutableArray         *titleArr;
@property (nonatomic,strong)NSMutableArray         *topArr;

@end

@implementation fwflViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"服务分类";
    [self getData];
   
}
- (void)getData{
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"]};
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/service/index/serviceClassif"];
    [manager POST:strurl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        
        NSArray *dataArr = responseObject[@"data"];
        _dataSourceArr = [NSMutableArray array];
        
        for (NSDictionary *dic in dataArr) {
            model = [[feflModel alloc]initWithDictionary:dic error:NULL];
            [_dataSourceArr addObject:model];
    
        }
         NSLog(@"_dataSourceArr = %@",_dataSourceArr);
         _listArr = [NSMutableArray array];
        for (NSDictionary *listDic in model.list) {
            listModel *lModel = [[listModel alloc]initWithDictionary:listDic error:NULL];
            [_listArr addObject:lModel];
        }
        NSLog(@"_listArr = %@",_listArr);
        
        [self creatUI];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)creatUI{
    
    CGRect frame = CGRectMake(0, 0, Main_width, Main_Height);
    tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    
    //    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xiala)];
    //    tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - [self navBarBottom], 0, 0, 0);
    [self.view addSubview:tableView];
    //    [tableView.mj_header beginRefreshing];
}
#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
     return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
  
    _titleArr = [NSMutableArray array];
    for (int i = 0;  i < model.list.count; i++) {
        NSDictionary *dic = model.list[i];
        NSString *titleStr = [dic objectForKey:@"name"];
        [_titleArr addObject:titleStr];
    }
    
    NSLog(@"_titleArr = %@",_titleArr);

    for (int i = 0; i < _titleArr.count; i++) {

        UIButton *flBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        flBtn.backgroundColor = [UIColor yellowColor];
        flBtn.frame = CGRectMake(i*btnWidth+10, 10, btnWidth, 50);
        [flBtn setTitle:_titleArr[i] forState:UIControlStateNormal];
        flBtn.transform = CGAffineTransformMakeScale(0.9, 1);
        flBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [flBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [flBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        flBtn.tag = i + indexPath.section*100;
        [cell addSubview:flBtn];

    }
    
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(0, 59, Main_width, .5);
    line.backgroundColor = [UIColor blackColor];
    [cell addSubview:line];
   
    
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

   
   model = _dataSourceArr[section];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_width, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(2, 20, 2, 30);
    lineView.backgroundColor = [UIColor redColor];
    [headerView addSubview:lineView];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(10, 10, 150, 50);
    titleLab.text = model.name;
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:titleLab];
    return headerView;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)clickAction:(UIButton *)button {
  
    NSLog(@"你点击的按钮tag值为：%ld", button.tag);
    fengLeiDetailViewController *flVC = [[fengLeiDetailViewController alloc]init];
    [self.navigationController pushViewController:flVC animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PostSuccess" object:nil userInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
   
    
}
@end
