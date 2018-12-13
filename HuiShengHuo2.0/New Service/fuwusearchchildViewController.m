//
//  fuwusearchchildViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/7.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fuwusearchchildViewController.h"
#import "fuwusearchresultViewController.h"

#import "searchServiceViewController.h"

#define PYSEARCH_SEARCH_HISTORY_CACHE_PATH1 [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MLSearchhistories1.plist"] // 搜索商家历史存储路径
#define PYSEARCH_SEARCH_HISTORY_CACHE_PATH2 [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MLSearchhistories2.plist"] // 搜索服务历史存储路径

@interface fuwusearchchildViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_TableView;
    NSArray *dataarr;
}
/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *searchHistories1;
/** 搜索历史缓存保存路径, 默认为PYSEARCH_SEARCH_HISTORY_CACHE_PATH(PYSearchConst.h文件中的宏定义) */
@property (nonatomic, copy) NSString *searchHistoriesCachePath1;
@property (nonatomic, strong) NSMutableArray *searchHistories2;
/** 搜索历史缓存保存路径, 默认为PYSEARCH_SEARCH_HISTORY_CACHE_PATH(PYSearchConst.h文件中的宏定义) */
@property (nonatomic, copy) NSString *searchHistoriesCachePath2;

/** 搜索历史记录缓存数量，默认为20 */
@property (nonatomic, assign) NSUInteger searchHistoriesCount;
@end

@implementation fuwusearchchildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchHistoriesCount = 20;
    
    [self getdata];
    // Do any additional setup after loading the view.
}

//- (NSMutableArray *)searchHistories1
//{
//
//    if (!_searchHistories1) {
//        self.searchHistoriesCachePath1 = PYSEARCH_SEARCH_HISTORY_CACHE_PATH1;
//        _searchHistories1 = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath1]];
//
//    }
//    return _searchHistories1;
//}
//- (NSMutableArray *)searchHistories2
//{
//
//    if (!_searchHistories2) {
//        self.searchHistoriesCachePath2 = PYSEARCH_SEARCH_HISTORY_CACHE_PATH2;
//        _searchHistories2 = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath2]];
//
//    }
//    return _searchHistories2;
//}

- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath
{
    if ([_shangjiaorfuwu isEqualToString:@"sj"]) {
        _searchHistoriesCachePath1 = [searchHistoriesCachePath copy];
        // 刷新
        self.searchHistories1 = nil;
    }else{
        _searchHistoriesCachePath2 = [searchHistoriesCachePath copy];
        // 刷新
        self.searchHistories2 = nil;
    }
    
    
    [_TableView reloadData];
}
/** 进入搜索状态调用此方法 */
- (void)saveSearchCacheAndRefreshView:(NSString *)searchtext
{
    if ([_shangjiaorfuwu isEqualToString:@"sj"]) {
        //    // 先移除再刷新
        [self.searchHistories1 removeObject:searchtext];
        [self.searchHistories1 insertObject:searchtext atIndex:0];
        
        // 移除多余的缓存
        if (self.searchHistories1.count > self.searchHistoriesCount) {
            // 移除最后一条缓存
            [self.searchHistories1 removeLastObject];
        }
        // 保存搜索信息
        [NSKeyedArchiver archiveRootObject:self.searchHistories1 toFile:self.searchHistoriesCachePath1];
    }else{
        //    // 先移除再刷新
        [self.searchHistories2 removeObject:searchtext];
        [self.searchHistories2 insertObject:searchtext atIndex:0];
        
        // 移除多余的缓存
        if (self.searchHistories2.count > self.searchHistoriesCount) {
            // 移除最后一条缓存
            [self.searchHistories2 removeLastObject];
        }
        // 保存搜索信息
        [NSKeyedArchiver archiveRootObject:self.searchHistories2 toFile:self.searchHistoriesCachePath2];
    }

    
    [_TableView reloadData];
}
- (void)createtableview
{
    self.searchHistoriesCachePath1 = PYSEARCH_SEARCH_HISTORY_CACHE_PATH1;
    _searchHistories1 = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath1]];
    self.searchHistoriesCachePath2 = PYSEARCH_SEARCH_HISTORY_CACHE_PATH2;
    _searchHistories2 = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath2]];
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height-RECTSTATUS.size.height-44-50)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    _TableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //_TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
    [self.view addSubview:_TableView];
}

// return按钮操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    WBLog(@"----1111-----");
    
    return YES;
}


-(void)rightmengbutClick{
    WBLog(@"asd");
}
- (void)getdata
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"]};
    NSString *strurl = [API_NOAPK stringByAppendingString:@"/service/index/serviceKeys"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dataarr = [NSArray array];
        WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            if ([_shangjiaorfuwu isEqualToString:@"sj"]) {
                dataarr = [[responseObject objectForKey:@"data"] objectForKey:@"i_key"];
            }else{
                dataarr = [[responseObject objectForKey:@"data"] objectForKey:@"s_key"];
            }
        }else{
            
            
        }
        [self createtableview];
        [_TableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        if ([_shangjiaorfuwu isEqualToString:@"sj"]) {
            return 1+_searchHistories1.count;
        }else{
            return 1+_searchHistories2.count;
        }
       
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"   ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 147;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"myhousecell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.section==0) {
        UIImageView *shuimg= [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 3, 20)];
        shuimg.backgroundColor = [UIColor blackColor];
        shuimg.alpha = 0.5;
        [cell.contentView addSubview:shuimg];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shuimg.frame)+10, CGRectGetMinY(shuimg.frame), 200, 20)];
        lab.text = @"热门";
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:lab];
        NSArray *tarr = dataarr;
        WBLog(@"%@--%@",tarr,dataarr);
        float butX = 15;
        float butY = CGRectGetMaxY(shuimg.frame)+10;
        for(int i = 0; i < tarr.count; i++){
            
            //宽度自适应
            NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            CGRect frame_W = [tarr[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDict context:nil];
            
            if (butX+frame_W.size.width+20>Main_width-15) {
                
                butX = 15;
                
                butY += 55;
            }
            
            UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(butX, butY, frame_W.size.width+20, 40)];
            [but setTitle:tarr[i] forState:UIControlStateNormal];
            [but setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            but.titleLabel.font = [UIFont systemFontOfSize:13];
            but.tag = i;
            [but addTarget:self action:@selector(pushrelust:) forControlEvents:UIControlEventTouchUpInside];
            but.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
            [cell.contentView addSubview:but];
            
            butX = CGRectGetMaxX(but.frame)+10;
            WBLog(@"%f",butY);
            tableView.rowHeight = butY+40;
        }
    }else{
        if (indexPath.row==0) {
            UIImageView *shuimg= [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 3, 20)];
            shuimg.backgroundColor = [UIColor blackColor];
            shuimg.alpha = 0.5;
            [cell.contentView addSubview:shuimg];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shuimg.frame)+10, CGRectGetMinY(shuimg.frame), 200, 20)];
            lab.text = @"历史";
            lab.textColor = [UIColor grayColor];
            lab.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:lab];
            tableView.rowHeight = 54;
        }else{
            // 添加关闭按钮
            UIButton *closetButton = [[UIButton alloc] init];
            // 设置图片容器大小、图片原图居中
            closetButton.mj_size = CGSizeMake(cell.mj_h, cell.mj_h);
            [closetButton setTitle:@"x" forState:UIControlStateNormal];
            [closetButton addTarget:self action:@selector(closeDidClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = closetButton;
            [closetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            if ([_shangjiaorfuwu isEqualToString:@"sj"]) {
                cell.textLabel.text = self.searchHistories1[indexPath.row-1];
            }else{
                cell.textLabel.text = self.searchHistories2[indexPath.row-1];
            }
            tableView.rowHeight = 50;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出选中的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
//    // 缓存数据并且刷新界面
//    [self saveSearchCacheAndRefreshView:cell.textLabel.text];
//    fuwusearchresultViewController *result = [[fuwusearchresultViewController alloc] init];
//    result.key = cell.textLabel.text;
//    if ([_shangjiaorfuwu isEqualToString:@"sj"]) {
//        result.canshu = @"i_key";
//        result.url = @"/service/institution/merchantList";
//    }else{
//        result.canshu = @"s_key";
//        result.url = @"/service/service/serviceList";
//    }
//    [self.navigationController pushViewController:result animated:YES];
    
    // 缓存数据并且刷新界面
    [self saveSearchCacheAndRefreshView:cell.textLabel.text];
    
    if ([_shangjiaorfuwu isEqualToString:@"sj"]) {
        fuwusearchresultViewController *result = [[fuwusearchresultViewController alloc] init];
        result.key = cell.textLabel.text;
        result.canshu = @"i_key";
        result.url = @"/service/institution/merchantList";
        [self.navigationController pushViewController:result animated:YES];
    }else{
        searchServiceViewController *result = [[searchServiceViewController alloc] init];
        result.canshu = @"s_key";
        result.key = cell.textLabel.text;
        result.url = @"/service/service/serviceList";
        [self.navigationController pushViewController:result animated:YES];
        
    }
}
- (void)closeDidClick:(UIButton *)sender
{
    // 获取当前cell
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    if ([_shangjiaorfuwu isEqualToString:@"sj"]) {
        // 移除搜索信息
        [self.searchHistories1 removeObject:cell.textLabel.text];
        // 保存搜索信息
        [NSKeyedArchiver archiveRootObject:self.searchHistories1 toFile:PYSEARCH_SEARCH_HISTORY_CACHE_PATH1];
    }else{
        // 移除搜索信息
        [self.searchHistories2 removeObject:cell.textLabel.text];
        // 保存搜索信息
        [NSKeyedArchiver archiveRootObject:self.searchHistories2 toFile:PYSEARCH_SEARCH_HISTORY_CACHE_PATH2];
    }
    
//    if (self.searchHistories.count == 0) {
//        self.tableView.tableFooterView.hidden = YES;
//
//
//    }
    
    // 刷新
    [_TableView reloadData];
}
-(void)pushrelust:(UIButton *)sender
{

    // 缓存数据并且刷新界面
    [self saveSearchCacheAndRefreshView:[dataarr objectAtIndex:sender.tag]];
    
    if ([_shangjiaorfuwu isEqualToString:@"sj"]) {
        fuwusearchresultViewController *result = [[fuwusearchresultViewController alloc] init];
        result.key = [dataarr objectAtIndex:sender.tag];
        result.canshu = @"i_key";
        result.url = @"/service/institution/merchantList";
         [self.navigationController pushViewController:result animated:YES];
    }else{
        searchServiceViewController *result = [[searchServiceViewController alloc] init];
        result.key = [dataarr objectAtIndex:sender.tag];
        result.canshu = @"s_key";
        result.url = @"/service/service/serviceList";
        [self.navigationController pushViewController:result animated:YES];
        
    }
   
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
