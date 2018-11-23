//
//  businessViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "businessViewController.h"
#import "View+MASAdditions.h"
//cell 滑动
#import "HomeNetApi.h"
#import "HomeImagesModel.h"
#import "HorScorllView.h"
@interface businessViewController ()<UITableViewDelegate,UITableViewDataSource,HorScorllViewImageClickDelegate>
@property (nonatomic,strong)UITableView         *tableView;

@end

@implementation businessViewController
{
    NSMutableArray *_homeImageArray;
    NSMutableArray *_homeTitleArray;
    
    HorScorllView *_horScorllView;
    UILabel *_textLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createdUI];
//    [self loadNetworkData];
}
-(void)createdUI{
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, Main_width, 80);
    topView.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:243/255.0 alpha:1];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(10, 10, 80, 60);
    imgView.backgroundColor = [UIColor grayColor];
    [topView addSubview:imgView];
    
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.layer.cornerRadius = 10.0;
    itemBtn.backgroundColor = [UIColor lightGrayColor];
    [itemBtn setTitle:@"保洁保洁保洁保洁保洁" forState:UIControlStateNormal];
    [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [topView addSubview:itemBtn];
    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(topView).offset(100);
        make.centerY.equalTo(topView);
        make.width.lessThanOrEqualTo(@200);
        make.height.equalTo(@30);
    }];
    [self.view addSubview:topView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80-64)style:UITableViewStylePlain ];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
     [self loadNetworkData];
    
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

- (void)loadNetworkData {
    
    _homeImageArray = @[].mutableCopy;
    _homeTitleArray = @[].mutableCopy;
    
    HomeNetApi *api = [[HomeNetApi alloc] initWithVid:@""];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        NSLog(@"%@",request.responseObject);
        for (NSDictionary *dic in request.responseObject[@"result"]) {
            //            HomeImagesModel *model = [[HomeImagesModel alloc] initWithDataDic:dic];
            [_homeImageArray addObject:dic[@"path"]];
            [_homeTitleArray addObject:dic[@"name"]];
            
        }
        
        _horScorllView.titles = _homeTitleArray;
        _horScorllView.images = _homeImageArray;
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}


#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
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
    
    
    _horScorllView = [[HorScorllView alloc] initWithFrame:CGRectMake(10, 80, Main_width-60, 100)];
    _horScorllView.delegate = self;
    [cell addSubview:_horScorllView];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2, [UIScreen mainScreen].bounds.size.width, 30)];
    
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:18];
    [cell addSubview:_textLabel];
    
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
- (void)horImageClickAction:(NSInteger)tag {
    NSLog(@"你点击的按钮tag值为：%ld",tag);
    
    _textLabel.text = [NSString stringWithFormat:@"你点击的按钮tag值为：%ld",tag];
}

@end
