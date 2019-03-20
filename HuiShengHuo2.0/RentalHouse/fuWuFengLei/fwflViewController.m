
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
    NSArray *dataArr;
}
@property (nonatomic,strong)NSMutableArray         *dataSourceArr;
@property (nonatomic,strong)NSMutableArray         *listArr;
@property (nonatomic,strong)NSMutableArray         *titleArr;
//_idArr
@property (nonatomic,strong)NSMutableArray         *idArr;
@property (nonatomic,strong)NSMutableArray         *topArr;

@end

@implementation fwflViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"服务分类";
    [self getData];
   
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
- (void)getData{
    
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    dict = @{@"community_id":[userinfo objectForKey:@"community_id"],@"hui_community_id":[user objectForKey:@"community_id"]};
    
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/service/index/serviceClassif"];
    [manager POST:strurl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        WBLog(@"dataStr = %@",dataStr);
        
        dataArr = responseObject[@"data"];
        _dataSourceArr = [NSMutableArray array];
        
        for (NSDictionary *dic in dataArr) {
            model = [[feflModel alloc]initWithDictionary:dic error:NULL];
            [_dataSourceArr addObject:model];
        }
         WBLog(@"_dataSourceArr = %@",_dataSourceArr);
         _listArr = [NSMutableArray array];
        for (NSDictionary *listDic in model.list) {
            listModel *lModel = [[listModel alloc]initWithDictionary:listDic error:NULL];
            [_listArr addObject:lModel];
        }
        WBLog(@"_listArr = %@",_listArr);
        
        [self creatUI];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)creatUI{
    
    CGRect frame = CGRectMake(0, 0, Main_width, Main_Height);
    tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
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
    return dataArr.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
        NSArray *arr = [[NSArray alloc] init];
        arr = [[dataArr objectAtIndex:section-1] objectForKey:@"list"];
        return (arr.count+2)/3;
    }
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
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.section>0) {
        NSArray *arr = [[NSArray alloc] init];
        arr = [[dataArr objectAtIndex:indexPath.section-1] objectForKey:@"list"];
        CGFloat width = (Main_width-30-7*2)/3;
        if ((arr.count-indexPath.row*3)/3>=1) {
            for (int i=0; i<3; i++) {
                UILabel *backlabel = [[UILabel alloc] initWithFrame:CGRectMake(15+i*width+7*i, 10, width, 40)];
                backlabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
                backlabel.text = [[arr objectAtIndex:i+indexPath.row*3] objectForKey:@"name"];
                backlabel.font = Font(14);
                backlabel.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:backlabel];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(15+i*width+7*i, 10, width, 40);
                but.tag = [[[arr objectAtIndex:i+indexPath.row*3] objectForKey:@"id"] integerValue];
                [but setTitle:[[arr objectAtIndex:i+indexPath.row*3] objectForKey:@"name"] forState:UIControlStateNormal];
                but.titleLabel.font = Font(0.1);
                [but addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:but];
            }
        }else{
            for (int i=0; i<(arr.count-indexPath.row*3); i++) {
                UILabel *backlabel = [[UILabel alloc] initWithFrame:CGRectMake(15+i*width+7*i, 10, width, 40)];
                backlabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
                backlabel.text = [[arr objectAtIndex:i+indexPath.row*3] objectForKey:@"name"];
                backlabel.font = Font(14);
                backlabel.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:backlabel];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(15+i*width+7*i, 10, width, 40);
                but.tag = [[[arr objectAtIndex:i+indexPath.row*3] objectForKey:@"id"] integerValue];
                [but setTitle:[[arr objectAtIndex:i+indexPath.row*3] objectForKey:@"name"] forState:UIControlStateNormal];
                but.titleLabel.font = Font(0.1);
                [but addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:but];
            }
        }
    }else{
        CGFloat width = (Main_width-30-7*2)/3;
        UILabel *backlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, width, 40)];
        backlabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        backlabel.text = @"全部";
        backlabel.font = Font(14);
        backlabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:backlabel];
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(15, 10, width, 40);
        but.tag = -1000;
        [but setTitle:@"全部" forState:UIControlStateNormal];
        but.titleLabel.font = Font(0.1);
        [but addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:but];
    }
    
    return cell;
}

- (void)push:(UIButton *)sender
{
    if (sender.tag == -1000) {
        fengLeiDetailViewController *flVC = [[fengLeiDetailViewController alloc]init];
        flVC.fuwuid = @"";
        flVC.name = sender.titleLabel.text;
        flVC.tagStr = @"1";
        [self.navigationController pushViewController:flVC animated:YES];
    }else{
        fengLeiDetailViewController *flVC = [[fengLeiDetailViewController alloc]init];
        flVC.fuwuid = [NSString stringWithFormat:@"%ld",sender.tag];
        flVC.name = sender.titleLabel.text;
        flVC.tagStr = @"1";
        [self.navigationController pushViewController:flVC animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_width, 50)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(2, 10, 2, 30);
    lineView.backgroundColor = [UIColor redColor];
    [headerView addSubview:lineView];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(10, 0, 150, 50);
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = [UIColor redColor];
    [headerView addSubview:titleLab];
    if (section==0) {
        titleLab.text = @"全部";
    }else{
        model = _dataSourceArr[section-1];
        titleLab.text = model.name;
    }
    
    return headerView;
    
}


@end
