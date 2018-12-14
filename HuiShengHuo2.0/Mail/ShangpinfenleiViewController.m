//
//  ShangpinfenleiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/22.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "ShangpinfenleiViewController.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "shangpinerjiViewController.h"
#import "xianshiqianggouViewController.h"
#import "PYSearch.h"
#import "searchreslutsViewController.h"
#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
#import "PrefixHeader.pch"

@interface ShangpinfenleiViewController ()<UITableViewDelegate,UITableViewDataSource,PYSearchViewControllerDelegate>
{
    NSString *prentid;
    NSMutableArray *_DataArr;
    NSMutableArray *_DataArr1;
    
    UITableView *_tableView;
    UIScrollView *_Scrollview;
    
    UIButton *_tmpBtn;
    
    NSString *_biaoji;
    
    NSArray *_searcharr;
}

@end

@implementation ShangpinfenleiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(100, 0, screen_Width-100, screen_Height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self createdaohangolan];
    [self post];
    // Do any additional setup after loading the view.
}
- (BOOL)navigationShouldPopOnBackButton{
    UIViewController *viewc = self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
    [self.navigationController popToViewController:viewc animated:YES];
    return YES;
}
#pragma mark - 自定义导航栏
- (void)createdaohangolan
{
    //修改系统导航栏下一个界面的返回按钮title
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-100, 44)];
    [self.navigationItem setTitleView:view];
    
    UISearchBar *customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,5, (self.view.frame.size.width-100), 34)];
    customSearchBar.showsCancelButton = NO;
    customSearchBar.placeholder = @"搜一搜";
    customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [view addSubview:customSearchBar];
    
    UIButton *searchbut = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbut.frame = CGRectMake(0, 0, screen_Width-100, 34);
    [customSearchBar addSubview:searchbut];
    [searchbut addTarget:self action:@selector(getsearchs) forControlEvents:UIControlEventTouchUpInside];
}
- (void)getsearchs
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"id":[user objectForKey:@"community_id"]};
    //3.发送GET请求
    /*
     */
    NSString *strurl = [API stringByAppendingString:@"shop/goods_search_keys"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _searcharr = [[NSArray alloc] init];
            _searcharr = [responseObject objectForKey:@"data"];
            [self search];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)search
{//apk/shop/goods_search_keys
    NSArray *hotSeaches = _searcharr;
    NSLog(@"%@****%@",hotSeaches,_searcharr);
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索商品",@"") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        searchreslutsViewController *searchvc = [[searchreslutsViewController alloc] init];
        searchvc.searchs = searchViewController.searchBar.text;
        [searchViewController.navigationController pushViewController:searchvc animated:YES];
    }];
    searchViewController.hotSearchStyle = 0;
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark ------联网请求---
-(void)post{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSString *strurl = [API stringByAppendingString:@"shop/area_topclass"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"]};
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        arr = [responseObject objectForKey:@"data"];
        _DataArr = [[NSMutableArray alloc] init];
        _DataArr = arr;
        _biaoji = [[_DataArr objectAtIndex:0] objectForKey:@"id"];
        [self createtui];
        [self post1];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
-(void)post1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    dict = @{@"id":_biaoji,@"c_id":[user objectForKey:@"community_id"]};
    NSString *strurl = [API stringByAppendingString:@"shop/area_category"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        _DataArr1 = [[NSMutableArray alloc] init];
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            arr = [responseObject objectForKey:@"data"];
        }else{
            arr = nil;
        }
        _DataArr1 = arr;
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)createtui
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, 100, screen_Height-RECTSTATUS.size.height-44)];
    view.backgroundColor = BackColor;
    [self.view addSubview:view];
    _Scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0 , 100, screen_Height-RECTSTATUS.size.height-44)];
    _Scrollview.backgroundColor = BackColor;
    _Scrollview.showsVerticalScrollIndicator = NO;
    [_Scrollview setContentSize:CGSizeMake(100, 55*_DataArr.count)];
    [view addSubview:_Scrollview];
    for (int i=0; i<_DataArr.count; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setTitle:[[_DataArr objectAtIndex:i] objectForKey:@"cate_name"] forState:UIControlStateNormal];
        [but.titleLabel setFont:font15];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [but setTitleColor:QIColor forState:UIControlStateSelected];
        [but addTarget:self action:@selector(blick:) forControlEvents:UIControlEventTouchUpInside];
        but.tag = [[[_DataArr objectAtIndex:i] objectForKey:@"id"] integerValue];
    
        but.frame = CGRectMake(0, 55*i, 100, 55);
        [_Scrollview addSubview:but];
        if (i==0) {
            but.selected = YES;
            _tmpBtn = but;
        }
        UIImage *image = [self createImageWithColor:BackColor];
        UIImage *image1 = [self createImageWithColor:[UIColor whiteColor]];
        [but setBackgroundImage:image forState:UIControlStateNormal];
        [but setBackgroundImage:image1 forState:UIControlStateSelected];
    }
}
- (UIImage *)createImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)blick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    
    if (_tmpBtn == nil){
        sender.selected = YES;
        
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        
        _tmpBtn = sender;
    }
    
    _biaoji = [NSString stringWithFormat:@"%ld",sender.tag];
    [self post1];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _DataArr1.count;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_DataArr1 objectAtIndex:section] objectForKey:@"cate_name"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont boldSystemFontOfSize:15];
    header.contentView.backgroundColor = [UIColor whiteColor];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"-+-+-+-+%@",_DataDic);
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    NSArray *arr = [[_DataArr1 objectAtIndex:indexPath.section] objectForKey:@"sub_arr"];
    for (int i=0; i<arr.count; i++) {
        if (i%3==0) {
            UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5+(10+(screen_Width-100-120)/3+30)*(i/3), (screen_Width-100-120)/3, (screen_Width-100-120)/3)];
            NSString *string = [[arr objectAtIndex:i] objectForKey:@"icon"];
            NSString *strurl = [API_img stringByAppendingString:string];
            [imageview1 sd_setImageWithURL:[NSURL URLWithString: strurl]];
            [cell.contentView addSubview:imageview1];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5+(10+(screen_Width-100-120)/3+30)*(i/3)+(screen_Width-100-120)/3, (screen_Width-100)/3, 30)];
            NSString *labestr = [[arr objectAtIndex:i] objectForKey:@"cate_name"];
            label.text = labestr;
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(0, (screen_Width-100)/3*(i/3)+10, (screen_Width-100)/3, (screen_Width-100)/3);
            but.tag = [[[arr objectAtIndex:i] objectForKey:@"id"] integerValue];
            but.backgroundColor = [UIColor clearColor];
            [but setTitle:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_limit"]] forState:UIControlStateNormal];
            [but.titleLabel setFont:[UIFont systemFontOfSize:0.1]];
            [but addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
        }if (i%3==1) {
            UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(20+(screen_Width-100)/3, 5+(10+(screen_Width-100-120)/3+30)*(i/3), (screen_Width-100-120)/3, (screen_Width-100-120)/3)];
            NSString *string = [[arr objectAtIndex:i] objectForKey:@"icon"];
            NSString *strurl = [API_img stringByAppendingString:string];
            [imageview1 sd_setImageWithURL:[NSURL URLWithString: strurl]];
            [cell.contentView addSubview:imageview1];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((screen_Width-100)/3, 5+(10+(screen_Width-100-120)/3+30)*(i/3)+(screen_Width-100-120)/3, (screen_Width-100)/3, 30)];
            NSString *labestr = [[arr objectAtIndex:i] objectForKey:@"cate_name"];
            label.text = labestr;
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake((screen_Width-100)/3, (screen_Width-100)/3*(i/3)+10, (screen_Width-100)/3, (screen_Width-100)/3);
            but.tag = [[[arr objectAtIndex:i] objectForKey:@"id"] integerValue];
            [but setTitle:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_limit"]] forState:UIControlStateNormal];
            [but.titleLabel setFont:[UIFont systemFontOfSize:0.1]];
            but.backgroundColor = [UIColor clearColor];
            [but addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
        }if (i%3==2) {
            UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(20+(screen_Width-100)/3*2, 5+(10+(screen_Width-100-120)/3+30)*(i/3), (screen_Width-100-120)/3, (screen_Width-100-120)/3)];
            NSString *string = [[arr objectAtIndex:i] objectForKey:@"icon"];
            NSString *strurl = [API_img stringByAppendingString:string];
            [imageview1 sd_setImageWithURL:[NSURL URLWithString: strurl]];
            [cell.contentView addSubview:imageview1];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((screen_Width-100)/3*2, 5+(10+(screen_Width-100-120)/3+30)*(i/3)+(screen_Width-100-120)/3, (screen_Width-100)/3, 30)];
            NSString *labestr = [[arr objectAtIndex:i] objectForKey:@"cate_name"];
            label.text = labestr;
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake((screen_Width-100)/3*2, (screen_Width-100)/3*(i/3)+10, (screen_Width-100)/3, (screen_Width-100)/3);
            [but setTitle:[NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"is_limit"]] forState:UIControlStateNormal];
            [but.titleLabel setFont:[UIFont systemFontOfSize:0.1]];
            but.tag = [[[arr objectAtIndex:i] objectForKey:@"id"] integerValue];
            but.backgroundColor = [UIColor clearColor];
            [but addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:but];
        }
    }
    if (arr.count%3==0) {
        tableView.rowHeight = arr.count/3*(screen_Width-100)/3;
    }else{
        tableView.rowHeight = (arr.count+3)/3*(screen_Width-100)/3;
    }
    
    return cell;
}
- (void)push:(UIButton *)sendre{
    NSLog(@"%ld",sendre.tag);
    
    if ([sendre.titleLabel.text isEqualToString:@"1"]) {
        xianshiqianggouViewController *xianshi = [[xianshiqianggouViewController alloc] init];
        xianshi.id = [NSString stringWithFormat:@"%ld",sendre.tag];
        [self.navigationController pushViewController:xianshi animated:YES];
    }else{
        shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
        erji.id = [NSString stringWithFormat:@"%ld",sendre.tag];
        [self.navigationController pushViewController:erji animated:YES];
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
