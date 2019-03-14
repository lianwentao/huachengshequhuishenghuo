//
//  shouFangViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/15.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "shouFangViewController.h"
#import <AFNetworking.h>
#import "MJRefresh.h"
#import "shouFangDetailViewController.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#import "PrefixHeader.pch"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+TVAssistant.h"
#import "sfListModel.h"
#import "labelModel.h"

#import "CQTopBarViewController.h"
#import "Text5.h"
#import "Text2.h"
#import "Text3.h"
#import "Text4.h"
@interface shouFangViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    
    NSMutableArray *zuJinArr;
    NSMutableArray *mianJiArr;
    NSMutableArray *fangXingArr;
    NSMutableArray *gengDuoArr;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    NSInteger pageNum;
    sfListModel *model;
    NSMutableArray *dataSourceArr;
    
    UISearchBar *customSearchBar;
    
    NSMutableArray *kkkArr;
    NSMutableArray *labelArr;
}
@property (nonatomic,strong)UITableView         *tableView;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic,copy)NSString         *money;
@property (nonatomic,copy)NSString         *housetype;
@property (nonatomic,copy)NSString         *defaultType;
@property (nonatomic,copy)NSString         *acreage;
@property (nonatomic,copy)NSString         *moneyOne;
@property (nonatomic,copy)NSString         *moneyTwo;
@property (nonatomic,copy)NSString         *acreageOne;
@property (nonatomic,copy)NSString         *acreageTwo;
@property (nonatomic, strong) CQTopBarViewController *topBar;

@end

@implementation shouFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航控制器的代理为self
    //    self.navigationController.delegate = self;
//    [self loadData];
//    [self loadData1];
//    [self CreateTableview];
    [self createdaohangolan];
    [self shaixuanList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction5:) name:NSStringFromClass([Text5 class]) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction2:) name:NSStringFromClass([Text2 class]) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction3:) name:NSStringFromClass([Text3 class]) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction4:) name:NSStringFromClass([Text4 class]) object:nil];
    
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
#pragma mark - 租房筛选框
-(void)shaixuanList{
    
    self.topBar = [[CQTopBarViewController alloc] init];
    self.topBar.sectionTitles = @[@"售价",@"面积",@"房型",@"排序"];
    self.topBar.pageViewClasses = @[[Text5 class],[Text2 class],[Text3 class],[Text4 class]];
    [self addChildViewController:self.topBar];
    [self.view addSubview:self.topBar.view];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.topBar.footerView.bounds.size.height)style:UITableViewStylePlain ];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.topBar.footerView addSubview:_tableView];
    
    
    WS(ws);
//    dataSourceArr = [[NSMutableArray alloc] init];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.tableView.mj_footer endRefreshing];
        pageNum = 1;
        [ws loadData];
        
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.tableView.mj_header endRefreshing];
        pageNum = pageNum+1;
        [ws loadData];
    }];
    [_tableView.mj_header beginRefreshing];
    
}
- (void)InfoNotificationAction5:(NSNotification *)notification{
    [self.topBar topBarReplaceObjectsAtIndexes:0 withObjects:notification.userInfo[@"text"]];
    self.topBar.titleTextColor = [UIColor colorWithHexString:@"#FF5722"];
    NSString *str = notification.userInfo[@"text"];
    NSLog(@"notification = %@",notification.userInfo[@"text"]);
    if ([str isEqualToString:@"不限"]) {
        _money = @"0";
    }else if ([str isEqualToString:@"30万元以下"]) {
        _money = @"1";
    }else if ([str isEqualToString:@"30-50万元"]) {
        _money = @"2";
    }else if ([str isEqualToString:@"50-70万元"]) {
        _money = @"3";
    }else if ([str isEqualToString:@"70-90万元"]) {
        _money = @"4";
    }else{
        NSArray *array = [str componentsSeparatedByString:@"-"];//从字符-中分隔成2个元素的数组
        _moneyOne = [array objectAtIndex:0];
        _moneyTwo = [array objectAtIndex:1];
        
    }
    [self loadData];
}
- (void)InfoNotificationAction2:(NSNotification *)notification{
    [self.topBar topBarReplaceObjectsAtIndexes:1 withObjects:notification.userInfo[@"text"]];
    NSString *str = notification.userInfo[@"text"];
    NSLog(@"str = %@",str);
    if ([str isEqualToString:@"不限"]) {
        _acreage = @"0";
    }else if ([str isEqualToString:@"50平米以下"]) {
        _acreage = @"1";
    }else if ([str isEqualToString:@"50-70平米"]) {
        _acreage = @"2";
    }else if ([str isEqualToString:@"70-90平米"]) {
        _acreage = @"3";
    }else if ([str isEqualToString:@"90-110平米"]) {
        _acreage = @"4";
    }else{
        NSArray *array = [str componentsSeparatedByString:@"-"];//从字符-中分隔成2个元素的数组
        _acreageOne = [array objectAtIndex:0];
        _acreageTwo = [array objectAtIndex:1];
    }
    [self loadData];
}
- (void)InfoNotificationAction3:(NSNotification *)notification{
    [self.topBar topBarReplaceObjectsAtIndexes:2 withObjects:notification.userInfo[@"text"]];
    NSString *str = notification.userInfo[@"text"];
    if ([str isEqualToString:@"不限"]) {
        _housetype = @"0";
    }else if ([str isEqualToString:@"一室"]) {
        _housetype = @"1";
    }else if ([str isEqualToString:@"二室"]) {
        _housetype = @"2";
    }else if ([str isEqualToString:@"三室"]) {
        _housetype = @"3";
    }else if ([str isEqualToString:@"四室"]) {
        _housetype = @"4";
    }
    [self loadData];
    
}
- (void)InfoNotificationAction4:(NSNotification *)notification{
    [self.topBar topBarReplaceObjectsAtIndexes:3 withObjects:notification.userInfo[@"text"]];
    NSString *str = notification.userInfo[@"text"];
    NSLog(@"str = %@",str);
    if ([str isEqualToString:@"默认排序"]) {
        _defaultType = @"0";
    }else if ([str isEqualToString:@"最新发布"]) {
        _defaultType = @"1";
    }else if ([str isEqualToString:@"价格从低到高"]) {
        _defaultType = @"2";
    }else if ([str isEqualToString:@"价格从高到低"]) {
        _defaultType = @"3";
    }else if ([str isEqualToString:@"面积从大到小"]) {
        _defaultType = @"4";
    }
    [self loadData];
}

-(void)loadData{

    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSLog(@"community_name = %@",_community_name);
    if (_community_name == NULL) {
        _community_name = @"";
    }
    if (_money == NULL) {
        _money = @"";
    }
    if (_housetype == NULL) {
        _housetype = @"";
    }
    if (_defaultType == NULL) {
        _defaultType = @"";
    }
    if (_acreage == NULL) {
        _acreage = @"";
    }
    if (_acreageOne == NULL) {
        _acreageOne = @"";
    }
    if (_acreageTwo == NULL) {
        _acreageTwo = @"";
    }
    if (_moneyTwo == NULL) {
        _moneyTwo = @"";
    }
    if (_moneyOne == NULL) {
        _moneyOne = @"";
    }

    NSDictionary *dict = @{@"money":_money,@"moneyOne":_moneyOne,@"moneyTwo ":_moneyTwo,@"acreage":_acreage,@"areaOne":_acreageOne,@"areaTwo":_acreageTwo,@"housetype ":_housetype,@"default":_defaultType,@"page":@"",@"community_name":_community_name,@"community_id":[userinfo objectForKey:@"community_id"],@"page":[NSString stringWithFormat:@"%ld",pageNum]};

    NSLog(@"dict = %@",dict);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
  
    NSString *strurl = [API stringByAppendingString:@"secondHouseType/getSellList"];
    NSLog(@"strurl = %@",strurl);
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        
        NSString *stringnumber = responseObject[@"data"][@"CountPage"];
        NSInteger i = [stringnumber integerValue];
        NSLog(@"stringnumber = %@",stringnumber);
        if (pageNum>i && i != 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
            NSArray *dataArr = responseObject[@"data"][@"list"];
            kkkArr = responseObject[@"data"][@"list"];

            if (pageNum == 1) {
                dataSourceArr = [[NSMutableArray alloc]init];
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
                sfListModel *model =  [[sfListModel alloc]initWithDictionary:dic error:nil];
                [dataSourceArr addObject:model];
            }
            [self.tableView reloadData];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
//    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"dataStr = %@",dataStr);
//        NSArray *dataArr = responseObject[@"data"][@"list"];
//        kkkArr = responseObject[@"data"][@"list"];
////        [_tableView.mj_header endRefreshing];
////        [_tableView.mj_footer endRefreshing];
////        dataSourceArr = [NSMutableArray array];
////
////        kkkArr = responseObject[@"data"][@"list"];
////        for (NSDictionary *dic in dataArr) {
////            model =  [[sfListModel alloc]initWithDictionary:dic error:nil];
////            [dataSourceArr addObject:model];
////        }
////
////        [_tableView reloadData];
//
//        [_tableView.mj_header endRefreshing];
//        [_tableView.mj_footer endRefreshing];
//        if (pageNum == 1) {
//            dataSourceArr = [[NSMutableArray alloc]init];
//        }
//        if (![dataArr isKindOfClass:[NSArray class]]) {
//            [_tableView reloadData];
//            [_tableView.mj_footer endRefreshingWithNoMoreData];
//            return ;
//        }
//        if ([dataArr count] < 10) {
//            [_tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//        dataSourceArr = [NSMutableArray array];
//        for (NSDictionary *dic in dataArr) {
//
//            sfListModel *model =  [[sfListModel alloc]initWithDictionary:dic error:nil];
//
//            [dataSourceArr addObject:model];
//
//        }
//        [self.tableView reloadData];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"failure--%@",error);
//    }];
    
}

#pragma mark - 自定义导航栏
- (void)createdaohangolan{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.navigationItem setTitleView:view];
    //设置搜索框
    customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10,5, (self.view.frame.size.width-120), 34)];
    customSearchBar.delegate = self;
    customSearchBar.showsCancelButton = NO;
    customSearchBar.placeholder = @"请输入小区或地址";
    customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [view addSubview:customSearchBar];
    
    UIButton *sousuoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sousuoBtn.frame = CGRectMake(self.view.frame.size.width-50, 5, 30, 30);
    [sousuoBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [sousuoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sousuoBtn addTarget:self action:@selector(cancleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:sousuoBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}



#pragma mark - 租房列表
- (void)CreateTableview{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, self.view.frame.size.width, self.view.frame.size.height-RECTSTATUS.size.height+44-44)style:UITableViewStylePlain ];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];

    WS(ws);
//    dataSourceArr = [[NSMutableArray alloc] init];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.tableView.mj_footer endRefreshing];
        pageNum = 1;
        [ws loadData];

    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.tableView.mj_header endRefreshing];
        [ws loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataSourceArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
    
    sfListModel *model = dataSourceArr[indexPath.row];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(10, 10, 100, 100);
    [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:model.head_img]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
    imgView.userInteractionEnabled = YES;
    imgView.clipsToBounds = YES;
    imgView.contentMode = UIViewContentModeScaleAspectFill;

    [cell addSubview:imgView];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, 10, kScreen_Width-20-5-100, 40);
    NSString *str = [NSString stringWithFormat:@"-%@室",model.room];
    NSString *str1 = [NSString stringWithFormat:@"%@厅",model.office];
    NSString *str2 = [NSString stringWithFormat:@"%@厨",model.kitchen];
    NSString *str3 = [NSString stringWithFormat:@"%@卫",model.guard];
    NSString *str4 = [str stringByAppendingString:str1];
    NSString *str5 = [str4 stringByAppendingString:str2];
    NSString *str6 = [str5 stringByAppendingString:str3];
    NSString *str7 = [model.community_name stringByAppendingString:str6];
    NSString *str8 = [NSString stringWithFormat:@"-面积%@平米",model.area];
    NSString *str9 = [NSString stringWithFormat:@"|%@/%@",model.house_floor,model.floor];
    NSString *str10 = [str7 stringByAppendingString:str8];
    NSString *titleStr = [str10 stringByAppendingString:str9];
    NSLog(@"titleStr = %@",titleStr);
    titleLab.text = titleStr;
    titleLab.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.numberOfLines = 2;
    titleLab.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:titleLab];

    UILabel *rengZhengLab = [[UILabel alloc]init];
    rengZhengLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, CGRectGetMaxY(titleLab.frame)+5, 65, 20);
    rengZhengLab.text = @"物业认证";
    rengZhengLab.backgroundColor = [UIColor colorWithRed:252/255.0 green:87/255.0 blue:34/255.0 alpha:1];
    rengZhengLab.textColor = [UIColor whiteColor];
    rengZhengLab.clipsToBounds = YES;
    rengZhengLab.layer.cornerRadius = 2;
    rengZhengLab.font = [UIFont systemFontOfSize:15];
    rengZhengLab.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:rengZhengLab];
    
    
     labelArr = [[kkkArr objectAtIndex:indexPath.row] objectForKey:@"label"];
    if ([labelArr isKindOfClass:[NSArray class]] && labelArr.count != 0) {
        UILabel *biaoQianLab = [[UILabel alloc]init];
        biaoQianLab.frame = CGRectMake(CGRectGetMaxX(rengZhengLab.frame)+5, CGRectGetMaxY(titleLab.frame)+5, 50, 20);
        NSDictionary *nameDic = labelArr[0];
        NSString *labStr = [nameDic objectForKey:@"label_name"];
        biaoQianLab.text = labStr;
        biaoQianLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        biaoQianLab.textColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:60/255.0 alpha:1];
        biaoQianLab.font = [UIFont systemFontOfSize:15];
        biaoQianLab.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:biaoQianLab];
    }
//    for (int i = 0; i<kkkArr.count; i++) {
//        labelArr = [[kkkArr objectAtIndex:i] objectForKey:@"label"];
//    }
//    NSLog(@"kkkkk = %@",labelArr);
//    if (![labelArr isKindOfClass:[NSNull class]]) {
//        UILabel *biaoQianLab = [[UILabel alloc]init];
//        biaoQianLab.frame = CGRectMake(CGRectGetMaxX(rengZhengLab.frame)+5, CGRectGetMaxY(titleLab.frame)+5, 50, 20);
//        NSDictionary *nameDic = labelArr[0];
//        NSString *labStr = [nameDic objectForKey:@"label_name"];
//        biaoQianLab.text = labStr;
//        biaoQianLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
//        biaoQianLab.textColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:60/255.0 alpha:1];
//        biaoQianLab.font = [UIFont systemFontOfSize:15];
//        biaoQianLab.textAlignment = NSTextAlignmentCenter;
//        [cell addSubview:biaoQianLab];
//    }
   

    UILabel *priceLab = [[UILabel alloc]init];
    priceLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, CGRectGetMaxY(rengZhengLab.frame)+5, 100, 30);
    priceLab.text = [NSString stringWithFormat:@"%@元",model.total_price];
    //    priceLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    priceLab.textColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:60/255.0 alpha:1];
    priceLab.font = [UIFont systemFontOfSize:17];
    priceLab.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:priceLab];
    
    UILabel *jPriceLab = [[UILabel alloc]init];
    jPriceLab.frame = CGRectMake(CGRectGetMaxX(priceLab.frame)+5, CGRectGetMaxY(rengZhengLab.frame)+10, kScreen_Width-20-100-100, 20);
//    NSString *str11 = [NSString stringWithFormat:@"|%@室",model.room];
//    NSString *str22 = [NSString stringWithFormat:@"%@厅",model.office];
//    NSString *str33 = [NSString stringWithFormat:@"%@厨",model.kitchen];
//    NSString *str44 = [NSString stringWithFormat:@"%@卫",model.guard];
//    NSString *str55 = [str11 stringByAppendingString:str22];
//    NSString *str66 = [str55 stringByAppendingString:str33];
//    NSString *str77 = [str66 stringByAppendingString:str44];
//    NSString *str99 = [NSString stringWithFormat:@"|%@平米",model.area];
//    NSString *str1099 = [str77 stringByAppendingString:str99];
    
    jPriceLab.text = [NSString stringWithFormat:@"%@元/平米",model.unit_price];;
    jPriceLab.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
    jPriceLab.font = [UIFont systemFontOfSize:13];
    jPriceLab.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:jPriceLab];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    shouFangDetailViewController *sfDetailVC = [[shouFangDetailViewController alloc] init];
    sfListModel *model = dataSourceArr[indexPath.row];
    sfDetailVC.sfID = model.id;
    [self.navigationController pushViewController:sfDetailVC animated:YES];
}
- (void)cancleButtonClicked:(UISearchBar *)sender{
    NSLog(@"customSearchBar.text = %@", customSearchBar.text);
    _community_name = customSearchBar.text;
    [self loadData];
    [customSearchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate 协议

// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"---%@",searchBar.text);
    [customSearchBar resignFirstResponder];// 放弃第一响应者
    _community_name = searchBar.text;
    [self loadData];
    
}

// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    NSLog(@"textDidChange---%@",searchBar.text);
}
@end
