//
//  serviceViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/23.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "serviceViewController.h"
#import "WRNavigationBar.h"
#import "View+MASAdditions.h"
#import "serviceDetailViewController.h"

#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "fwListModel.h"
#import "fwflViewController.h"
#define IMAGE_HEIGHT 0
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface serviceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger pageNum;
}
@property (nonatomic,strong)UITableView         *tableView;
@property (nonatomic,strong)NSMutableArray         *dataSourceArr;
@end

@implementation serviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self getData];
    [self createdUI];
}
- (void)getData
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    if ([_sqfStr isEqualToString:@"0"]) {
        dict = @{@"c_id":[userinfo objectForKey:@"community_id"],@"i_id":_sID,@"p":[NSString stringWithFormat:@"%ld",pageNum]};
    }else{
        dict = @{@"p":[NSString stringWithFormat:@"%ld",pageNum],@"c_id":[userinfo objectForKey:@"community_id"],@"category":_sID};
    }
    NSLog(@"dict = %@",dict);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API_NOAPK = [defaults objectForKey:@"API_NOAPK"];
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/service/service/serviceList"];
    
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        
        NSArray *dataArr = responseObject[@"data"];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        arr = [responseObject objectForKey:@"data"];
        NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
        NSInteger i = [stringnumber integerValue];
        if (pageNum>i) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            
            if (pageNum == 1) {
                _dataSourceArr = [[NSMutableArray alloc]init];
            }
            if (![dataArr isKindOfClass:[NSArray class]]) {
                [_tableView reloadData];
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            if ([dataArr count] < 10) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            for (NSDictionary *dic in dataArr) {
                
                fwListModel *model = [[fwListModel alloc]initWithDictionary:dic error:NULL];
                [_dataSourceArr addObject:model];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
//    [manager POST:strurl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"dataStr = %@",dataStr);
//
//        NSArray *dataArr = responseObject[@"data"];
//        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
//        arr = [responseObject objectForKey:@"data"];
//        NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
//        NSInteger i = [stringnumber integerValue];
//        if (pageNum>i) {
//           [_tableView.mj_footer endRefreshingWithNoMoreData];
//        }else{
//            [_tableView.mj_header endRefreshing];
//            [_tableView.mj_footer endRefreshing];
//
//            if (pageNum == 1) {
//                _dataSourceArr = [[NSMutableArray alloc]init];
//            }
//            if (![dataArr isKindOfClass:[NSArray class]]) {
//                [_tableView reloadData];
//                [_tableView.mj_footer endRefreshingWithNoMoreData];
//                return ;
//            }
//            if ([dataArr count] < 10) {
//                [_tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//            for (NSDictionary *dic in dataArr) {
//
//                fwListModel *model = [[fwListModel alloc]initWithDictionary:dic error:NULL];
//                [_dataSourceArr addObject:model];
//            }
//            [self.tableView reloadData];
//        }
////        [_tableView.mj_header endRefreshing];
////        [_tableView.mj_footer endRefreshing];
//////        _dataSourceArr = [NSMutableArray array];
//////        for (NSDictionary *dic in dataArr) {
//////
//////            fwListModel *model = [[fwListModel alloc]initWithDictionary:dic error:NULL];
//////            [_dataSourceArr addObject:model];
//////        }
//////
//////        [_tableView reloadData];
////
////        if (pageNum == 1) {
////            _dataSourceArr = [[NSMutableArray alloc]init];
////        }
////        if (![dataArr isKindOfClass:[NSArray class]]) {
////            [_tableView reloadData];
////            [_tableView.mj_footer endRefreshingWithNoMoreData];
////            return ;
////        }
////        if ([dataArr count] < 10) {
////            [_tableView.mj_footer endRefreshingWithNoMoreData];
////        }
////        for (NSDictionary *dic in dataArr) {
////
////            fwListModel *model = [[fwListModel alloc]initWithDictionary:dic error:NULL];
////            [_dataSourceArr addObject:model];
////        }
////        [self.tableView reloadData];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}
-(void)createdUI{
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, Main_width, 80);
    topView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(10, 22.5, 30*2.4, 30);
    imgView.image = [UIImage imageNamed:@"fw_xzfl"];
    [topView addSubview:imgView];
    
    UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    itemBtn.layer.cornerRadius = 8.0;
    itemBtn.backgroundColor =  [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
    itemBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [itemBtn setTitle:_sName forState:UIControlStateNormal];
    [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [topView addSubview:itemBtn];
    CGSize size = [_sName sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys: itemBtn.titleLabel.font,NSFontAttributeName, nil]];
    CGFloat itemBtnH = size.height+10;
    CGFloat itemBtnW = size.width+10;
    itemBtn.frame = CGRectMake(90, 22.5, itemBtnW,itemBtnH);
    [itemBtn addTarget:self action:@selector(itemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80-64)style:UITableViewStylePlain ];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(IMAGE_HEIGHT - [self navBarBottom]+80, 0, 0, 0);
    [self.view addSubview:_tableView];
    
    WS(ws);
//    _dataSourceArr = [[NSMutableArray alloc] init];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.tableView.mj_footer endRefreshing];
        pageNum = 1;
        [ws getData];
        
    }];
//     _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.tableView.mj_header endRefreshing];
        pageNum = pageNum+1;
        [ws getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)postup{
     pageNum = pageNum+1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = nil;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    if ([_sqfStr isEqualToString:@"0"]) {
        dict = @{@"c_id":[userinfo objectForKey:@"community_id"],@"i_id":_sID,@"p":[NSString stringWithFormat:@"%ld",pageNum]};
    }else{
        dict = @{@"c_id":[userinfo objectForKey:@"community_id"],@"category":_sID,@"p":[NSString stringWithFormat:@"%ld",pageNum]};
    }
    NSLog(@"dict = %@",dict);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API_NOAPK = [defaults objectForKey:@"API_NOAPK"];
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/service/service/serviceList"];
    [manager POST:strurl parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        arr = [responseObject objectForKey:@"data"];
        NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
        NSInteger i = [stringnumber integerValue];
        if (pageNum>i) {
            _tableView.mj_footer.state = MJRefreshStateNoMoreData;
            [_tableView.mj_footer resetNoMoreData];
        }else{
            for (NSDictionary *dic in arr) {
                
                fwListModel *model = [[fwListModel alloc]initWithDictionary:dic error:NULL];
                [_dataSourceArr addObject:model];
            }
        }
        
        [_tableView.mj_footer endRefreshing];
        [_tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)itemAction{
    fwflViewController *fVC = [[fwflViewController alloc]init];
    [self.navigationController pushViewController:fVC animated:YES];
}
- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40+(Main_width-40)/2.5;
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
    imgView.frame = CGRectMake(10, 10,Main_width-20, (Main_width-40)/2.5);
    [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:model.title_img]] placeholderImage:[UIImage imageNamed:@"展位图长2.5"]];
    imgView.layer.cornerRadius = 5;
    imgView.clipsToBounds = YES;
    [cell addSubview:imgView];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(10, CGRectGetMaxY(imgView.frame),Main_width/2-20, 30);
    titleLab.text = model.title;
    titleLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    titleLab.font = [UIFont systemFontOfSize:14];
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
    
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(10, 39+(Main_width-40)/2.5, Main_width-20, .5);
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [cell addSubview:line];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    serviceDetailViewController *sfDetailVC = [[serviceDetailViewController alloc] init];
    fwListModel *model = _dataSourceArr[indexPath.row];
    sfDetailVC.serviceID = model.id;
    sfDetailVC.serviceTitle = model.title;
    [self.navigationController pushViewController:sfDetailVC animated:YES];
}

@end
