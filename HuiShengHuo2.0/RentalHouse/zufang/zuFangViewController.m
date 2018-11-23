//
//  zuFangViewController.m
//  HuiShengHuo2.0
//
//  Created by admin on 2018/11/15.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "zuFangViewController.h"
#import <AFNetworking.h>
#import "MJRefresh.h"
#import "zuFangDetailViewController.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#import "PrefixHeader.pch"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+TVAssistant.h"
#import "JSDropDownMenu.h"
#import "zfListModel.h"
//筛选
#import "ZJChooseControlView.h"
#import "ZJChooseShowView.h"

@interface zuFangViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource,ZJChooseControlDelegate,UISearchBarDelegate>{
    
    NSMutableArray *zuJinArr;
    NSMutableArray *mianJiArr;
    NSMutableArray *fangXingArr;
    NSMutableArray *gengDuoArr;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    NSInteger pageNum;
    NSMutableArray *dataSourceArr;
    UISearchBar *customSearchBar;
   
}
@property(nonatomic ,strong) UITableView *tableView;
@property (nonatomic,copy)NSString         *community_name;
@property(nonatomic ,weak) ZJChooseControlView *chooseControlView;
@property(nonatomic ,strong) ZJChooseShowView *showView;
@end

@implementation zuFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航控制器的代理为self
//    self.navigationController.delegate = self;
    [self loadData];
    [self loadData1];
    [self CreateTableview];
    [self createdaohangolan];
    [self shaixuanList];
//    [self setUpAllView];
   
}
-(void)setUpAllView{
    NSArray *array = @[@"租金",@"面积",@"房型",@"排序"];
    ZJChooseControlView *chooseView = [[ZJChooseControlView alloc]initWithFrame:CGRectMake(0, 64, Main_width, 45)];
    chooseView.delegate = self;
    chooseView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    chooseView.layer.borderWidth = 0.5;
    [chooseView setUpAllViewWithTitleArr:array];
    _chooseControlView = chooseView;
    [self.view addSubview:chooseView];
    [self.view addSubview:_tableView];
}
-(ZJChooseShowView *)showView{
    if (!_showView) {
        _showView = [[ZJChooseShowView alloc]initWithFrame:CGRectMake(0, 109, Main_width, Main_Height - 109)];
        _showView.hidden = YES;
    }
    return _showView;
}

-(void)chooseControlWithBtnArray:(NSArray *)array button:(UIButton *)sender{
    
    [self.view addSubview:self.showView];
    self.showView.hidden = NO;
    [self.showView chooseControlViewBtnArray:array Action:sender];
    
}

-(void)loadData{

    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSString *www = [userinfo objectForKey:@"token"];
    NSLog(@"www = %@",www);

    NSDictionary *dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    
    NSLog(@"dict = %@",dict);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSLog(@"dict = %@",dict);
    //secondHouseType/getmoney secondHouseType/getacreage  secondHouseType/gethousetype secondHouseType/getdefault
    NSString *strurl = [API stringByAppendingString:@"secondHouseType/getdefault"];
    NSLog(@"strurl = %@",strurl);
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"gouwuche--%@",responseObject);
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
    
}
-(void)loadData1{
    
    
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    if (_community_name == NULL) {
        
        _community_name = @"";
    }
    
    NSDictionary *dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"money":@"",@"moneyOne":@"",@"moneyTwo ":@"",@"acreage":@"",@"areaOne":@"",@"areaTwo":@"",@"housetype ":@"",@"default":@"",@"page":@"",@"community_name":_community_name};
    
    NSLog(@"dict = %@",dict);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSLog(@"dict = %@",dict);
    NSString *strurl = [API stringByAppendingString:@"secondHouseType/getSellList"];
    NSLog(@"strurl = %@",strurl);
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"gouwuche--%@",responseObject);
        
        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"dataStr = %@",dataStr);
        NSArray *dataArr = responseObject[@"data"][@"list"];
        NSLog(@"dataSourceArr = %@",dataArr);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        dataSourceArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArr) {
            zfListModel *model =  [[zfListModel alloc]initWithDictionary:dic error:nil];
             [dataSourceArr addObject:model];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
    
}
#pragma mark - 自定义导航栏
- (void)createdaohangolan{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.navigationItem setTitleView:view];
    //设置搜索框
    UISearchBar *customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10,5, (self.view.frame.size.width-120), 34)];
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
- (void)cancleButtonClicked:(UISearchBar *)sender{
    NSLog(@"customSearchBar.text = %@", customSearchBar.text);
    _community_name = customSearchBar.text;
    [self loadData];
}
#pragma mark - 租房筛选框
-(void)shaixuanList{
    
    zuJinArr = [NSMutableArray arrayWithObjects:@"不限", @"500以下", @"500-1000元", @"1000-1500元", @"1500-2000元", nil];
    mianJiArr = [NSMutableArray arrayWithObjects:@"不限", @"50平米以下", @"50-70平米", @"70-90平米", @"90-110平米", nil];
    fangXingArr = [NSMutableArray arrayWithObjects:@"不限", @"一室", @"二室", @"三室", @"四室", nil];
    gengDuoArr = [NSMutableArray arrayWithObjects:@"默认排序", @"最新发布", @"价格从低到高", @"价格从高到低", @"面积从大到小", nil];
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
}
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 4;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
//    if (column==2) {
//
//        return YES;
//    }
    
//    return NO;
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
//
//    if (column==0) {
//        return YES;
//    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
//    if (column==0) {
//        return 0.3;
//    }
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    return _currentData2Index;
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
            
        return zuJinArr.count;
    } else if (column==1){
        
        return mianJiArr.count;
        
    } else if (column==2){
        
        return fangXingArr.count;
    }else if (column==3){
        
        return gengDuoArr.count;
    }
    
    return 0;
}
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    
    switch (column) {
        case 0: return @"租金";
            break;
        case 1: return @"面积";
            break;
        case 2: return @"房型";
            break;
        case 3: return @"排序";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        
        return zuJinArr[indexPath.row];
        
    } else if (indexPath.column==1) {
        
        return mianJiArr[indexPath.row];
        
    } else if (indexPath.column==2) {
        
        return fangXingArr[indexPath.row];
        
    }else {
        
        return gengDuoArr[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
       
       _currentData2Index = indexPath.row;
        
    } else if(indexPath.column == 1){
        
        _currentData2Index = indexPath.row;
        
    } else{
        
       _currentData2Index = indexPath.row;
    }
}
#pragma mark - 租房列表
- (void)CreateTableview{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height-110)style:UITableViewStylePlain ];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    WS(ws);
    dataSourceArr = [[NSMutableArray alloc] init];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.tableView.mj_footer endRefreshing];
        pageNum = 1;
        [ws loadData1];
        
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [ws.tableView.mj_header endRefreshing];
        [ws loadData1];
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

    zfListModel *model = dataSourceArr[indexPath.row];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(10, 10, 100, 100);
    [imgView sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:model.head_img]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
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
    NSString *str9 = [NSString stringWithFormat:@"|%@/%@",model.floor,model.house_floor];
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
    rengZhengLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, CGRectGetMaxY(titleLab.frame)+5, 80, 20);
    rengZhengLab.text = @"物业认证";
    rengZhengLab.backgroundColor = [UIColor colorWithRed:252/255.0 green:88/255.0 blue:48/255.0 alpha:1];
    rengZhengLab.textColor = [UIColor whiteColor];
    rengZhengLab.font = [UIFont systemFontOfSize:15];
    rengZhengLab.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:rengZhengLab];
    
    NSArray *labArr = model.label;
    NSDictionary *nameDic = labArr[0];
   NSString *labStr = [nameDic objectForKey:@"label_name"];
    
    UILabel *biaoQianLab = [[UILabel alloc]init];
    biaoQianLab.frame = CGRectMake(CGRectGetMaxX(rengZhengLab.frame)+5, CGRectGetMaxY(titleLab.frame)+5, 50, 20);
    biaoQianLab.text = labStr;
    biaoQianLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    biaoQianLab.textColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:60/255.0 alpha:1];
    biaoQianLab.font = [UIFont systemFontOfSize:15];
    biaoQianLab.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:biaoQianLab];
    
    UILabel *priceLab = [[UILabel alloc]init];
    priceLab.frame = CGRectMake(CGRectGetMaxX(imgView.frame)+5, CGRectGetMaxY(rengZhengLab.frame)+5, 100, 30);
    priceLab.text = @"1500元/月";
//    priceLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    priceLab.textColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:60/255.0 alpha:1];
    priceLab.font = [UIFont systemFontOfSize:17];
    priceLab.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:priceLab];
    
    UILabel *jPriceLab = [[UILabel alloc]init];
    jPriceLab.frame = CGRectMake(CGRectGetMaxX(priceLab.frame)+5, CGRectGetMaxY(rengZhengLab.frame)+10, kScreen_Width-20-100-100, 20);
    jPriceLab.text = @"1500元/平米";
    //    jPriceLab = [UIColor colorWithRed:255/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    jPriceLab.textColor = [UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1];
    jPriceLab.font = [UIFont systemFontOfSize:14];
    jPriceLab.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:jPriceLab];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    zuFangDetailViewController *zfDetailVC = [[zuFangDetailViewController alloc] init];
//    liebiao.id = [[fenleiArr objectAtIndex:indexPath.section-4] objectForKey:@"id"];
//    liebiao.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zfDetailVC animated:YES];
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
