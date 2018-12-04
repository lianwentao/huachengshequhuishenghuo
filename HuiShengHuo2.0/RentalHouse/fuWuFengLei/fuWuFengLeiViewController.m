//
//  fuWuFengLeiViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/24.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fuWuFengLeiViewController.h"

@interface fuWuFengLeiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView         *tableView;

@end

@implementation fuWuFengLeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"服务分类";
    
    
}
-(void)createUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80-64)style:UITableViewStylePlain ];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //    WS(ws);
    //    dataSourceArr = [[NSMutableArray alloc] init];
    //    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        [ws.tableView.mj_footer endRefreshing];
    //        pageNum = 1;
    //        [ws loadData];
    //
    //    }];
    //    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        [ws.tableView.mj_header endRefreshing];
    //        [ws loadData];
    //    }];
    //    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
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
    
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(10, 10,Main_width-20, 120);
    imgView.backgroundColor = [UIColor colorWithRed:240/255.0 green:106/255.0 blue:157/255.0 alpha:1];
    [cell addSubview:imgView];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(10, CGRectGetMaxY(imgView.frame),Main_width/2-10, 30);
    titleLab.text = @"家用地暖清洗服务";
    titleLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.numberOfLines = 2;
    titleLab.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:titleLab];
    
    UILabel *priceLab = [[UILabel alloc]init];
    priceLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame), CGRectGetMaxY(imgView.frame), Main_width/2-10, 30);
    priceLab.text = @"￥60";
    priceLab.textColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:60/255.0 alpha:1];
    priceLab.font = [UIFont systemFontOfSize:15];
    priceLab.textAlignment = NSTextAlignmentRight;
    [cell addSubview:priceLab];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    shouFangDetailViewController *sfDetailVC = [[shouFangDetailViewController alloc] init];
    //    sfListModel *model = dataSourceArr[indexPath.row];
    //    sfDetailVC.sfID = model.id;
    //    [self.navigationController pushViewController:sfDetailVC animated:YES];
}

@end
