//
//  GouwucheViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/22.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "GouwucheViewController.h"
#import "DWQConfigFile.h"
#import "DWQCartTableViewCell.h"
#import "DWQShopModel.h"
#import "DWQGoodsModel.h"
#import "DWQTableHeaderView.h"
#import <AFNetworking.h>
#import "SuredingdanViewController.h"
#import "MBProgressHUD+TVAssistant.h"

#import "PrefixHeader.pch"

@interface GouwucheViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *issueButton;
    UIButton *DeleteButton;
    BOOL _isHiddenNavigationBarWhenDisappear;//记录当页面消失时是否需要隐藏系统导航
    BOOL _isHasTabBarController;//是否含有tabbar
    BOOL _isHasNavitationController;//是否含有导航
    NSDictionary *goodsdict;
    
    NSArray *_DataArr;
    CGFloat height;
}
@property (strong,nonatomic)NSMutableArray *dataArray;
@property (strong,nonatomic)NSMutableArray *selectedArray;
@property (strong,nonatomic)UITableView *myTableView;
@property (strong,nonatomic)UIButton *allSellectedButton;
@property (strong,nonatomic)UILabel *totlePriceLabel;
@end

@implementation GouwucheViewController

- (void)viewDidLayoutSubviews{
    CGFloat phoneVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (phoneVersion >= 11.0) {
        height = self.view.safeAreaInsets.bottom;
    }else{
        height = 0;
    }
    WBLog(@"h = %lf",height);
    [self setupCustomBottomView];
}
#pragma mark - viewController life cicle
- (void)viewWillAppear:(BOOL)animated {
    
    if (_isHasNavitationController == YES) {
        if (self.navigationController.navigationBarHidden == YES) {
            _isHiddenNavigationBarWhenDisappear = NO;
        } else {
            self.navigationController.navigationBarHidden = YES;
            _isHiddenNavigationBarWhenDisappear = YES;
        }
    }
    
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
    if (self.selectedArray.count > 0) {
        for (DWQGoodsModel *model in self.selectedArray) {
            model.select = NO;//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
        }
        [self.selectedArray removeAllObjects];
    }
    
    //初始化显示状态
    _allSellectedButton.selected = NO;
    _totlePriceLabel.attributedText = [self DWQSetString:@"￥0.00"];
    
//    [self post];
}
#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
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
    NSString *strurl = [API stringByAppendingString:@"shop/shopping_cart"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
            NSLog(@"购物车success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
            NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
            //NSArray *array = nil;
            if ([array isKindOfClass:[NSArray class]]) {
                _DataArr = [[NSArray alloc] init];
                _DataArr = array;
                DWQShopModel *model = [[DWQShopModel alloc]init];
                [model configGoodsArrayWithArray:array];
                [self.dataArray addObject:model];
                
            }
            if (self.dataArray.count > 0) {
                
                [self setupCartView];
                
            } else {
                [self setupCartEmptyView];
                
            }
        }else if ([[responseObject objectForKey:@"status"] integerValue]==2){
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
            [userinfo removeObjectForKey:@"username"];
            [userinfo removeObjectForKey:@"phone_type"];
            [userinfo removeObjectForKey:@"uid"];
            [userinfo removeObjectForKey:@"pwd"];
            [userinfo removeObjectForKey:@"is_bind_property"];
            [userinfo removeObjectForKey:@"Cookie"];
            [userinfo removeObjectForKey:@"is_new"];
            [userinfo removeObjectForKey:@"token"];
            [userinfo removeObjectForKey:@"tokenSecret"];
            NSHTTPCookieStorage *manager = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *cookieStorage = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (NSHTTPCookie *cookie in cookieStorage) {
                [manager deleteCookie:cookie];
            }
            //                [self logout];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
-(void)creatData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ShopCarSources" ofType:@"plist" inDirectory:nil];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSArray *array = [dic objectForKey:@"data"];
    if (array.count > 0) {
        for (NSDictionary *dic in array) {
            DWQShopModel *model = [[DWQShopModel alloc]init];
//            model.shopID = [dic objectForKey:@"id"];
//            model.shopName = [dic objectForKey:@"shopName"];
//            model.sID = [dic objectForKey:@"sid"];
            [model configGoodsArrayWithArray:[dic objectForKey:@"items"]];
            [self.dataArray addObject:model];
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    _isHasTabBarController = self.tabBarController?NO:YES;
    _isHasNavitationController = self.navigationController?NO:YES;
    
////#warning 模仿请求数据,延迟2s加载数据,实际使用时请移除更换
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
    //[self creatData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"gouwuchexiangou" object:nil];
    [self setupCustomNavigationBar];
    [self Changeleftbut];
    [self post];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadgouwuche) name:@"shuaxingouwuche" object:nil];
    // Do any additional setup after loading the view.
}
- (void)reloadgouwuche
{
    NSLog(@"刷新购物车");
    [self post];
}
- (void)change{
    [MBProgressHUD showToastToView:self.view withText:@"此商品限购次数已到"];
}
- (void)viewWillDisappear:(BOOL)animated {
    if (_isHiddenNavigationBarWhenDisappear == YES) {
        self.navigationController.navigationBarHidden = NO;
    }
}

/*
 *
 *  计算已选中商品金额
 */
-(void)countPrice {
    double totlePrice = 0.0;
    
    for (DWQGoodsModel *model in self.selectedArray) {
        
        double price = [model.price doubleValue];
        
        totlePrice += price * model.count;
    }
    NSString *string = [NSString stringWithFormat:@"￥%.2f",totlePrice];
    self.totlePriceLabel.attributedText = [self DWQSetString:string];
}

#pragma mark - 初始化数组
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedArray;
}

#pragma mark - 布局页面视图
#pragma mark -- 自定义导航
- (void)setupCustomNavigationBar {
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DWQSCREEN_WIDTH, DWQNaigationBarHeight)];
    backgroundView.backgroundColor = DWQColorFromRGB(236, 236, 236);
    [self.view addSubview:backgroundView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, DWQNaigationBarHeight - 0.5, DWQSCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"购物车";
    titleLabel.font = [UIFont systemFontOfSize:20];
    
    titleLabel.center = CGPointMake(self.view.center.x, (DWQNaigationBarHeight - 20)/2.0 + 20);
    CGSize size = [titleLabel sizeThatFits:CGSizeMake(300, 44)];
    titleLabel.bounds = CGRectMake(0, 0, size.width + 20, size.height);
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 20, 40, 44);
    [backButton setImage:[UIImage imageNamed:dwq_BackButtonString] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}
#pragma mark -- 自定义底部视图
- (void)setupCustomBottomView {
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = DWQColorFromRGB(245, 245, 245);
    backgroundView.tag = TAG_CartEmptyView + 1;
    [self.view addSubview:backgroundView];
    
    //当有tabBarController时,在tabBar的上面
    if (_isHasTabBarController == YES) {
        backgroundView.frame = CGRectMake(0, DWQSCREEN_HEIGHT -  2*DWQTabBarHeight-height, DWQSCREEN_WIDTH, DWQTabBarHeight);
    } else {
        backgroundView.frame = CGRectMake(0, DWQSCREEN_HEIGHT -  DWQTabBarHeight-height, DWQSCREEN_WIDTH, DWQTabBarHeight);
    }
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, DWQSCREEN_WIDTH, 1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:16];
    selectAll.frame = CGRectMake(10, 5, 80, DWQTabBarHeight - 10);
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:dwq_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:dwq_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    //结算按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = HColor(199, 8, 10);
    btn.frame = CGRectMake(DWQSCREEN_WIDTH - 80, 0, 80, DWQTabBarHeight);
    [btn setTitle:@"去结算" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor redColor];
    [backgroundView addSubview:label];
    
    label.attributedText = [self DWQSetString:@"¥0.00"];
    CGFloat maxWidth = DWQSCREEN_WIDTH - selectAll.bounds.size.width - btn.bounds.size.width - 30;
    //    CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, DWQTabBarHeight)];
    label.frame = CGRectMake(selectAll.bounds.size.width + 20, 0, maxWidth - 10, DWQTabBarHeight);
    self.totlePriceLabel = label;
}

- (NSMutableAttributedString*)DWQSetString:(NSString*)string {
    
    NSString *text = [NSString stringWithFormat:@"合计:%@",string];
    NSMutableAttributedString *DWQString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:@"合计:"];
    [DWQString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    [DWQString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:rang];
    return DWQString;
}
#pragma mark -- 购物车为空时的默认视图
- (void)changeView {
    if (self.dataArray.count > 0) {
        UIView *view = [self.view viewWithTag:TAG_CartEmptyView];
        if (view != nil) {
            [view removeFromSuperview];
        }
        
        [self setupCartView];
    } else {
        UIView *bottomView = [self.view viewWithTag:TAG_CartEmptyView + 1];
        [bottomView removeFromSuperview];
        
        [self.myTableView removeFromSuperview];
        self.myTableView = nil;
        [self setupCartEmptyView];
    }
}

- (void)setupCartEmptyView {
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, DWQNaigationBarHeight, DWQSCREEN_WIDTH, DWQSCREEN_HEIGHT - DWQNaigationBarHeight)];
    backgroundView.tag = TAG_CartEmptyView;
    [self.view addSubview:backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pinglunweikong"]];
    img.center = CGPointMake(DWQSCREEN_WIDTH/2.0, DWQSCREEN_HEIGHT/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.center = CGPointMake(DWQSCREEN_WIDTH/2.0, DWQSCREEN_HEIGHT/2.0 - 10);
    warnLabel.bounds = CGRectMake(0, 0, DWQSCREEN_WIDTH, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车为空!";
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.textColor = DWQColorFromHex(0x706F6F);
    [backgroundView addSubview:warnLabel];
}
#pragma mark -- 购物车有商品时的视图
- (void)setupCartView {
    //创建底部视图
    [self setupCustomBottomView];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero];
    
    table.delegate = self;
    table.dataSource = self;
    
    table.rowHeight = dwq_CartRowHeight;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = DWQColorFromRGB(245, 246, 248);
    [self.view addSubview:table];
    self.myTableView = table;
    
    if (_isHasTabBarController) {
        table.frame = CGRectMake(0, DWQNaigationBarHeight, DWQSCREEN_WIDTH, DWQSCREEN_HEIGHT - DWQNaigationBarHeight - 2*DWQTabBarHeight-height);
    } else {
        table.frame = CGRectMake(0, DWQNaigationBarHeight, DWQSCREEN_WIDTH, DWQSCREEN_HEIGHT - DWQNaigationBarHeight - DWQTabBarHeight-height);
    }
    
    [table registerClass:[DWQTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"DWQHeaderView"];
    [self reloadTable];
   
}
#pragma mark --- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    DWQShopModel *model = [self.dataArray objectAtIndex:section];
    return model.goodsArray.count;
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWQCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DWQCartReusableCell"];
    if (cell == nil) {
        cell = [[DWQCartTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DWQCartReusableCell"];
    }
    
    DWQShopModel *shopModel = self.dataArray[indexPath.section];
    DWQGoodsModel *model = [shopModel.goodsArray objectAtIndex:indexPath.row];
    
    __block typeof(cell)wsCell = cell;
    
    [cell numberAddWithBlock:^(NSInteger number) {
        wsCell.dwqNumber = number;
        model.count = number;
        
        //[shopModel.goodsArray replaceObjectAtIndex:indexPath.row withObject:model];
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell numberCutWithBlock:^(NSInteger number) {
        
        wsCell.dwqNumber = number;
        model.count = number;
        
        //[shopModel.goodsArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell cellSelectedWithBlock:^(BOOL select) {
        
        model.select = select;
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        [self verityAllSelectState];
        [self verityGroupSelectState:indexPath.section];
        
        [self countPrice];
    }];
    
    [cell reloadDataWithModel:model];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            DWQShopModel *shop = [self.dataArray objectAtIndex:indexPath.section];
            DWQGoodsModel *model = [shop.goodsArray objectAtIndex:indexPath.row];
            NSLog(@"%@",model.goodsID);
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            goodsdict = @{@"id":[[_DataArr objectAtIndex:indexPath.section] objectForKey:@"id"],@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"],@"hui_community_id":[user objectForKey:@"community_id"]};
            [self deletegoods];
            [shop.goodsArray removeObjectAtIndex:indexPath.row];
            //    删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if (shop.goodsArray.count == 0) {
                [self.dataArray removeObjectAtIndex:indexPath.section];
            }
            
            //判断删除的商品是否已选择
            if ([self.selectedArray containsObject:model]) {
                //从已选中删除,重新计算价格
                [self.selectedArray removeObject:model];
                [self countPrice];
            }
            
            NSInteger count = 0;
            for (DWQShopModel *shop in self.dataArray) {
                count += shop.goodsArray.count;
            }
            
            if (self.selectedArray.count == count) {
                _allSellectedButton.selected = YES;
            } else {
                _allSellectedButton.selected = NO;
            }
            
            if (count == 0) {
                [self changeView];
            }
            //如果删除的时候数据紊乱,可延迟0.5s刷新一下
            [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
-(void)deletegoods
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSLog(@"%@",goodsdict);
    NSString *strurl = [API stringByAppendingString:@"shop/del_shopping_cart"];
    [manager POST:strurl parameters:goodsdict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        //NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)reloadTable {
    [self.myTableView reloadData];
}
#pragma mark -- 页面按钮点击事件
#pragma mark --- 返回按钮点击事件
- (void)backButtonClick:(UIButton*)button {
    if (_isHasNavitationController == NO) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark --- 全选按钮点击事件
- (void)selectAllBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (DWQGoodsModel *model in self.selectedArray) {
        model.select = NO;
    }
    [self.selectedArray removeAllObjects];
    
    if (button.selected) {
        
        for (DWQShopModel *shop in self.dataArray) {
            shop.select = YES;
            for (DWQGoodsModel *model in shop.goodsArray) {
                model.select = YES;
                [self.selectedArray addObject:model];
            }
        }
        
    } else {
        for (DWQShopModel *shop in self.dataArray) {
            shop.select = NO;
        }
    }
    
    [self.myTableView reloadData];
    [self countPrice];
}
#pragma mark --- 确认选择,提交订单按钮点击事件
- (void)goToPayButtonClick:(UIButton*)button {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    if (self.selectedArray.count > 0) {
        NSString *jsonString = nil;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (DWQGoodsModel * model in self.selectedArray)
        {
        NSLog(@"%@=%@=%@=%@=%@=%@",model.goodsName,model.titleimg,model.tagid,model.goodsID,model.number,model.price);
            NSDictionary *dic = @{@"tagid":model.tagid,@"p_id":model.goodsID,@"p_title":model.goodsName,@"p_title_img":model.titleimg,@"price":model.price,@"number":[NSString stringWithFormat:@"%ld",model.count]};
                [arr addObject:dic];
        }
        NSLog(@"%@==%@", _totlePriceLabel.text,arr);
        double totlePrice = 0.0;
        
        for (DWQGoodsModel *model in self.selectedArray) {

            double price = [model.price doubleValue];
            
            totlePrice += price * model.count;
        }
        
        NSString *string = [NSString stringWithFormat:@"%.2f",totlePrice];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[userinfo objectForKey:@"uid"],[userinfo objectForKey:@"username"]]];
        NSDictionary *dict = @{@"m_id":[userinfo objectForKey:@"community_id"],@"para_amount":string,@"products":jsonString,@"apk_token":uid_username,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"],@"hui_community_id":[userinfo objectForKey:@"community_id"]};
        NSString *strurl = [API stringByAppendingString:@"shop/submit_order_before"];
        [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //
            WBLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
            NSString *status = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"status"]];
            if ([status isEqualToString:@"1"]) {
                SuredingdanViewController *sure = [[SuredingdanViewController alloc] init];
                sure.Dic = [responseObject objectForKey:@"data"];
                sure.jsonstring = jsonString;
                [self.navigationController pushViewController:sure animated:YES];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
            
            //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    } else {
        [MBProgressHUD showToastToView:self.view withText:@"你还没有选择任何商品"];
    }
}

- (void)verityGroupSelectState:(NSInteger)section {
    
    // 判断某个区的商品是否全选
    DWQShopModel *tempShop = self.dataArray[section];
    // 是否全选标示符
    BOOL isShopAllSelect = YES;
    for (DWQGoodsModel *model in tempShop.goodsArray) {
        // 当有一个为NO的是时候,将标示符置为NO,并跳出循环
        if (model.select == NO) {
            isShopAllSelect = NO;
            break;
        }
    }
    
    DWQTableHeaderView *header = (DWQTableHeaderView *)[self.myTableView headerViewForSection:section];
    header.select = isShopAllSelect;
    tempShop.select = isShopAllSelect;
}

- (void)verityAllSelectState {
    
    NSInteger count = 0;
    for (DWQShopModel *shop in self.dataArray) {
        count += shop.goodsArray.count;
    }
    
    if (self.selectedArray.count == count) {
        _allSellectedButton.selected = YES;
    } else {
        _allSellectedButton.selected = NO;
    }
}
#pragma mark - 修改系统导航栏下一个界面的返回按钮title
- (void)Changeleftbut
{
    //修改系统导航栏下一个界面的返回按钮title
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
}
//#pragma mark - 导航栏rightbutton
//- (void)addRightBtn
//{
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
//}
//- (void)onClickedOKbtn
//{
//    NSLog(@"onClickedOKbtn");
//}

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
