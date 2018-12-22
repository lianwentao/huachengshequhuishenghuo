//
//  version41mallchildViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/22.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "version41mallchildViewController.h"
#import "liebiaomodel.h"
#import "liebiaoTableViewCell.h"
#import "GoodsDetailViewController.h"
@interface version41mallchildViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *biaoqianarr;
    UIButton *_tmpBtn;
    NSString *liebiaoid;
    
    NSMutableArray *liebiaoArr;
    NSMutableArray *modelArr;
    
    UITableView *_TabelView;
    NSArray *_searcharr;
    
    int _pagenum;
    
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isHeader;

@end

@implementation version41mallchildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self postliebiao];
    
    
    // Do any additional setup after loading the view.
}
-(void)setui{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height - NAVHEIGHT - SegmentHeaderViewHeight-49)];
    //        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_TabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(postliebiao)];
    _TabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(postup)];
    _tableView.rowHeight = 110+12.5;
    [self.view addSubview:_tableView];
}
//- (UITableView *)tableView {
//    if (!_tableView) {
//        
//    }
//    return _tableView;
//}

-(void)postliebiao
{
    _pagenum = 1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"id":_id};
    //3.发送GET请求
    /*
     第一个参数:请求路径(NSString)+ 不需要加参数
     第二个参数:发送给服务器的参数数据
     第三个参数:progress 进度回调
     第四个参数:success  成功之后的回调(此处的成功或者是失败指的是整个请求)
     task:请求任务
     responseObject:注意!!!响应体信息--->(json--->oc))
     task.response: 响应头信息
     第五个参数:failure 失败之后的回调
     */
    NSString *strurl = [API stringByAppendingString:@"shop/hotCateProlist"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        liebiaoArr = [[NSMutableArray alloc] init];
        modelArr = [NSMutableArray arrayWithCapacity:0];
        
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        arr = [responseObject objectForKey:@"data"];
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            for (int i=0; i<arr.count; i++) {
                liebiaomodel *model = [[liebiaomodel alloc] init];
                model.imagestring = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                model.title = [[arr objectAtIndex:i] objectForKey:@"title"];
                model.tagArr = [[arr objectAtIndex:i] objectForKey:@"goods_tag"];
                model.nowprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"price"]];
                model.yuanprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"original"]];
                model.unit = [[arr objectAtIndex:i] objectForKey:@"unit"];
                model.yishou = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"order_num"]];
                model.biaoshi = @"0";//1代表限时抢购，0代表其他商品
                
                model.id = [[arr objectAtIndex:i] objectForKey:@"id"];
                model.tagname = [[arr objectAtIndex:i] objectForKey:@"tagname"];
                model.tagid = [[arr objectAtIndex:i] objectForKey:@"tagid"];
                model.title_img = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                model.exihours = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"exist_hours"]];
                model.is_time = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"discount"]];
                model.is_new = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_new"]];
                model.is_hot = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_hot"]];
                model.kucun = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"inventory"]];
                [modelArr addObject:model];
            }
            [liebiaoArr addObjectsFromArray:arr];
        }
        [self setui];
        
        [_TabelView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)postup
{
    _pagenum = _pagenum+1;
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"id":_id,@"p":[NSString stringWithFormat:@"%d",_pagenum]};
    //3.发送GET请求
    /*
     第一个参数:请求路径(NSString)+ 不需要加参数
     第二个参数:发送给服务器的参数数据
     第三个参数:progress 进度回调
     第四个参数:success  成功之后的回调(此处的成功或者是失败指的是整个请求)
     task:请求任务
     responseObject:注意!!!响应体信息--->(json--->oc))
     task.response: 响应头信息
     第五个参数:failure 失败之后的回调
     */
    NSString *strurl = [API stringByAppendingString:@"shop/hotCateProlist"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"center---success--%@--%@",[responseObject class],responseObject);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            arr = [responseObject objectForKey:@"data"];
            NSString *stringnumber = [[arr objectAtIndex:0] objectForKey:@"total_Pages"];
            NSInteger i = [stringnumber integerValue];
            if (_pagenum>i) {
                _TabelView.mj_footer.state = MJRefreshStateNoMoreData;
                [_TabelView.mj_footer resetNoMoreData];
            }else{
                for (int i=0; i<arr.count; i++) {
                    liebiaomodel *model = [[liebiaomodel alloc] init];
                    model.imagestring = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                    model.title = [[arr objectAtIndex:i] objectForKey:@"title"];
                    model.tagArr = [[arr objectAtIndex:i] objectForKey:@"goods_tag"];
                    model.nowprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"price"]];
                    model.yuanprice = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"original"]];
                    model.unit = [[arr objectAtIndex:i] objectForKey:@"unit"];
                    model.yishou = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"order_num"]];
                    model.biaoshi = @"0";//1代表限时抢购，0代表其他商品
                    model.is_time = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"discount"]];
                    model.exihours = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"exist_hours"]];
                    model.is_new = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_new"]];
                    model.is_hot = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_hot"]];
                    model.kucun = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"inventory"]];
                    model.id = [[arr objectAtIndex:i] objectForKey:@"id"];
                    model.tagname = [[arr objectAtIndex:i] objectForKey:@"tagname"];
                    model.tagid = [[arr objectAtIndex:i] objectForKey:@"tagid"];
                    model.title_img = [[arr objectAtIndex:i] objectForKey:@"title_img"];
                    [modelArr addObject:model];
                }
                [liebiaoArr addObjectsFromArray:arr];
            }
            [_TabelView.mj_footer endRefreshing];
            [_TabelView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIndetifier = @"facepayjiluTableViewCell";
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
