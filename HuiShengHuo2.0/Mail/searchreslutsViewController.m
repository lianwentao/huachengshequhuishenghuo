//
//  searchreslutsViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/27.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "searchreslutsViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "GoodsDetailViewController.h"
#import "MJRefresh.h"
#import "UITableView+PlaceHolderView.h"
#import "liebiaomodel.h"
#import "liebiaoTableViewCell.h"
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#import "PrefixHeader.pch"
@interface searchreslutsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray *_DataArr;
    int _pagenum;
    
    UIImageView *wushujuimageView;
    UILabel *wushujulabel;
    
    NSMutableArray *modelArr;
}

@end

@implementation searchreslutsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pagenum = 1;
    self.title = @"搜索结果";
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"搜索内容--%@",_searchs);
    _DataArr = [[NSMutableArray alloc] init];
    modelArr = [[NSMutableArray alloc] init];
    [self post];
    [self createtableview];
    // Do any additional setup after loading the view.
}
#pragma mark ------联网请求---
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"m_id":[user objectForKey:@"community_id"],@"key":_searchs,@"hui_community_id":[user objectForKey:@"community_id"]};
   
    NSString *strurl = [API stringByAppendingString:@"shop/goods_search"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1){
            [_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
            
            for (int i=0; i<_DataArr.count; i++) {
                liebiaomodel *model = [[liebiaomodel alloc] init];
                model.imagestring = [[_DataArr objectAtIndex:i] objectForKey:@"title_thumb_img"];
                model.title = [[_DataArr objectAtIndex:i] objectForKey:@"title"];
                model.tagArr = [[_DataArr objectAtIndex:i] objectForKey:@"goods_tag"];
                model.nowprice = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:i] objectForKey:@"price"]];
                model.yuanprice = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:i] objectForKey:@"original"]];
                model.unit = [[_DataArr objectAtIndex:i] objectForKey:@"unit"];
                model.yishou = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:i] objectForKey:@"order_num"]];
                model.biaoshi = @"0";//1代表限时抢购，0代表其他商品
                
                model.is_time = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:i] objectForKey:@"discount"]];
                model.is_new = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:i] objectForKey:@"is_new"]];
                model.is_hot = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:i] objectForKey:@"is_hot"]];
                model.kucun = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:i] objectForKey:@"inventory"]];
                
                model.id = [[_DataArr objectAtIndex:i] objectForKey:@"id"];
                model.tagname = [[_DataArr objectAtIndex:i] objectForKey:@"tagname"];
                model.tagid = [[_DataArr objectAtIndex:i] objectForKey:@"tagid"];
                model.title_img = [[_DataArr objectAtIndex:i] objectForKey:@"title_img"];
                model.exihours = [NSString stringWithFormat:@"%@",[[_DataArr objectAtIndex:i] objectForKey:@"exist_hours"]];
                [modelArr addObject:model];
            }
            wushujuimageView.hidden = YES;
            wushujulabel.hidden = YES;
        }else{
            _DataArr = nil;
            wushujuimageView.hidden = NO;
            wushujulabel.hidden = NO;
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)post1
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    _pagenum = _pagenum + 1;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *mid = [user objectForKey:@"community_id"];
    NSDictionary *dict = @{@"m_id":mid,@"key":_searchs,@"p":[NSString stringWithFormat:@"%d",_pagenum],@"hui_community_id":[user objectForKey:@"community_id"]};
    
    NSString *strurl = [API stringByAppendingString:@"shop/goods_search"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum>i) {
                _tableView.mj_footer.state = MJRefreshStateNoMoreData;
                [_tableView.mj_footer resetNoMoreData];
            }else{
                
                for (int i=0; i<arr.count; i++) {
                    liebiaomodel *model = [[liebiaomodel alloc] init];
                    model.imagestring = [[arr objectAtIndex:i] objectForKey:@"title_thumb_img"];
                    model.title = [[arr objectAtIndex:i] objectForKey:@"title"];
                    model.tagArr = [[arr objectAtIndex:i] objectForKey:@"goods_tag"];
                    model.nowprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"price"]];
                    model.yuanprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"original"]];
                    model.unit = [[arr objectAtIndex:i] objectForKey:@"unit"];
                    model.yishou = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"order_num"]];
                    model.biaoshi = @"0";//1代表限时抢购，0代表其他商品
                    model.is_new = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_new"]];
                    model.is_hot = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_hot"]];
                    model.is_time = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"discount"]];
                    model.kucun = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"inventory"]];
                    
                    model.id = [[arr objectAtIndex:i] objectForKey:@"id"];
                    model.tagname = [[arr objectAtIndex:i] objectForKey:@"tagname"];
                    model.tagid = [[arr objectAtIndex:i] objectForKey:@"tagid"];
                    model.title_img = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                    model.exihours = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"exist_hours"]];
                    
                    
                    [modelArr addObject:model];
                }
                [_DataArr addObjectsFromArray:arr];
                [_tableView.mj_footer endRefreshing];
            }
            
        }
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)createtableview
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
    
    wushujuimageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2-50, _tableView.frame.size.height/2-120, 100, 100)];
    wushujuimageView.image = [UIImage imageNamed:@"pinglunweikong"];
    wushujuimageView.contentMode = UIViewContentModeScaleAspectFit;
    //imageView.center = _TableView.center;
    //[_tableView addSubview:wushujuimageView];
    
    wushujulabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2-150, _tableView.frame.size.height/2-20, 300, 40)];
    wushujulabel.textColor = [UIColor grayColor];
    wushujulabel.textAlignment = NSTextAlignmentCenter;
    wushujulabel.text = @"暂无数据^_^";
    //label.center = CGPointMake(_TableView.center.x, _TableView.center.y+80);
    //[_tableView addSubview:wushujulabel];
    
//    wushujuimageView.hidden = NO;
//    wushujulabel.hidden = NO;
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110+12.5;
}
// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"facepayjiluTableViewCell";
    NSLog(@"-----------111==%@",modelArr);
    liebiaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[liebiaoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    cell.backgroundColor = BackColor;
    cell.model = [modelArr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailViewController *gooddetail = [[GoodsDetailViewController alloc] init];
    gooddetail.IDstring = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:gooddetail animated:YES];
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
