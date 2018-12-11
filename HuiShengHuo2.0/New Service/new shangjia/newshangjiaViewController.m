//
//  newshangjiaViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/30.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "newshangjiaViewController.h"
#import "shangjialevelListview.h"
#import "shangjialeftViewController.h"
#import "shangjiarightViewController.h"

@interface newshangjiaViewController ()<UITableViewDelegate,UITableViewDataSource,shangjialevelListviewDelegate>
{
    NSDictionary *datadic;
    CGFloat _mainTableViewOldOffSet;
}
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, strong)UIScrollView *subScrollView;
@property(nonatomic, strong)shangjialeftViewController *subLeftVC;
@property(nonatomic, strong)shangjiarightViewController *subRightVC;
@property(nonatomic, strong)shangjialevelListview *levelListView;

@end

@implementation newshangjiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    

    // Do any additional setup after loading the view.
    
    [self getdata];
}
- (void)getdata
{
    //初始化进度框，置于当前的View当中
    static MBProgressHUD *_HUD;
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"加载中...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSDictionary *dict = nil;
        dict = @{@"id":_shangjiaid};
        NSString *strurl = [API_NOAPK stringByAppendingString:@"/Service/institution/merchantDetails"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            datadic = [[NSDictionary alloc] init];
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                datadic = [responseObject objectForKey:@"data"];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
            self.title = [datadic objectForKey:@"name"];
            [self putTogetheraddSubViews];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WBLog(@"failure--%@",error);
            [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
        }];
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}


#pragma mark - UI设置
/**
 组装视图
 */
-(void)putTogetheraddSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
}

/**
 UI懒加载
 */
-(UITableView *)mainTableView
{
    if (!_mainTableView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = 64;
        frame.size.height -= 64;
        _mainTableView.frame = frame;
        _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.showsVerticalScrollIndicator = NO;
        //设置代理
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        //设置头视图
        _mainTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_width, 240)];
        _mainTableView.tableHeaderView.backgroundColor =  [UIColor clearColor];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240)];
        headerView.backgroundColor = [UIColor whiteColor];
        _mainTableView.tableHeaderView = headerView;
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Main_width, 140)];
        [imgv sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[datadic objectForKey:@"index_img"]]] placeholderImage:[UIImage imageNamed:@"默认商家背景"]];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        [headerView addSubview:imgv];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(Main_width/2-40, 100, 80, 80)];
        view1.clipsToBounds = YES;
        view1.backgroundColor = [UIColor whiteColor];
        view1.layer.cornerRadius = 40;
        [headerView addSubview:view1];
        
        UIImageView *imgv2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        imgv2.clipsToBounds = YES;
        imgv2.layer.cornerRadius = 35;
        [imgv2 sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[datadic objectForKey:@"logo"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
        [view1 addSubview:imgv2];
        
        UIImageView *imgv3 = [[UIImageView alloc] initWithFrame:CGRectMake(42, 20+140, 27, 27)];
        imgv3.image = [UIImage imageNamed:@"联系商家"];
        [headerView addSubview:imgv3];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(22, 20+27+5+140, 67, 14)];
        label1.text = @"联系商家";
        label1.font = Font(13);
        label1.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1.0];
        label1.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(22, 20+27+5+14+5+140, 87, 14)];
        label2.font = Font(11);
        label2.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1.0];
        label2.text = [datadic objectForKey:@"telphone"];
        label2.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label2];
        
        UIImageView *imgv4 = [[UIImageView alloc] initWithFrame:CGRectMake(Main_width-27-42, 20+140, 27, 27)];
        imgv4.image = [UIImage imageNamed:@"服务"];
        [headerView addSubview:imgv4];
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(Main_width-15-120, 20+27+15+140, 120, 15)];
        label3.font = Font(14);
        label3.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1.0];
        label3.textAlignment = NSTextAlignmentRight;
        label3.text = [NSString stringWithFormat:@"共%@个服务 >",[datadic objectForKey:@"serviceCount"]];
        [headerView addSubview:label3];
    }
    return _mainTableView;
}

-(UIScrollView *)subScrollView
{
    
    if (!_subScrollView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = 0;
        frame.size.height -= 109;
        _subScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _subScrollView.contentSize = CGSizeMake(Main_width*2, frame.size.height);
        _subScrollView.backgroundColor = [UIColor grayColor];
        _subScrollView.pagingEnabled = YES;
        _subScrollView.delegate = self;
        _subScrollView.bounces = NO;
        [_subScrollView addSubview:self.subLeftVC.view];
        [_subScrollView addSubview:self.subRightVC.view];
        
    }
    return _subScrollView;
}

-(shangjialevelListview *)levelListView
{
    if (!_levelListView) {
        _levelListView = [[shangjialevelListview alloc]initWithFrame:CGRectMake(0, 0, Main_width, 45)];
        _levelListView.delegate = self;
    }
    return _levelListView;
}

-(shangjialeftViewController *)subLeftVC
{
    if (!_subLeftVC) {
        _subLeftVC = [[shangjialeftViewController alloc] init];
        _subLeftVC.view.frame = self.subScrollView.bounds;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chuandititlearr" object:nil userInfo:datadic];
        [self addChildViewController:_subLeftVC];
    }
    return _subLeftVC;
}

-(shangjiarightViewController *)subRightVC
{
    if (!_subRightVC) {
        CGRect frame = self.subScrollView.bounds;
        frame.origin.x = Main_width;
        _subRightVC = [[shangjiarightViewController alloc]init];
        _subRightVC.view.frame =frame;
        [self addChildViewController:_subRightVC];
    }
    return _subRightVC;
}
#pragma mark - delegate实现

/**
 ELeMeOrderPageLevelListViewDelegate
 */
-(void)selectedButton:(BOOL)isLeftButton
{
    CGPoint offSet = _subScrollView.contentOffset;
    
    
    offSet.x = isLeftButton ? 0 : Main_width;
    
    [_subScrollView setContentOffset:offSet animated:YES];
}
/**
 UIScrollViewDelegate
 */


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.mainTableView]) {
        //
        //        NSLog(@"%lf, %lf", scrollView.contentOffset.y, scrollView.contentSize.height-scrollView.bounds.size.height);
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height-scrollView.bounds.size.height-0.5)) {//mainTableView 滚动不能超过最大值
            self.offsetType = OffsetTypeMax;
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height-scrollView.bounds.size.height);//(scrollView.contentSize.height-scrollView.bounds.size.height):mainTableView 可以滚动的最大偏移距离 超过等于最大偏移距离 不可以再向上滑动
            _mainTableViewOldOffSet = scrollView.contentSize.height-scrollView.bounds.size.height;
        } else if (scrollView.contentOffset.y <= 0) {
            self.offsetType = OffsetTypeMin;
        } else {
            self.offsetType = OffsetTypeCenter;
        }
        
        
        
        if ((self.levelListView.selectedIndex == 0 && self.subLeftVC.offsetType != OffsetTypeMin)&&(self.subLeftVC.rightTVScrollDown||(scrollView.contentOffset.y-_mainTableViewOldOffSet<0))) {//self.subLeftVC.offsetType != OffsetTypeMin时_mainTableView不能向下滑动（注释：当点菜页面显示并且商品列表tableView未达到最大偏移量之前，mainTableView不能向下滑动 ）
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, _mainTableViewOldOffSet);
        }
        
        
        if (self.levelListView.selectedIndex == 1 &&self.subRightVC.offsetType != OffsetTypeMin) {//当商家页面显示时，商家信息tableview偏移量不是最小状态 说明mainTableView 已经滚动到了最大值 在商家信息tableview偏移量未达到最小偏移量之前  mainTableView需要保持原来的偏移量不变
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, _mainTableViewOldOffSet);
        }
        
        _mainTableViewOldOffSet = scrollView.contentOffset.y;
        
    }
    
    if ([scrollView isEqual:self.subScrollView]) {
        [self.levelListView changeLineViewOffsetX:self.subScrollView.contentOffset.x];
    }
    
    
}

/**
 UITableViewDataSource
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNum = 1;
    return sectionNum;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 1;
    
    return rowNum;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.subScrollView removeFromSuperview];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    [cell.contentView addSubview:self.subScrollView];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
/**
 UITableViewDelegate
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = self.subScrollView.bounds.size.height;
    return rowHeight;
}

//分区头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat headerHeight = self.levelListView.bounds.size.height;
    return headerHeight;
}
//分区脚高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat footerHeight;
    return footerHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.levelListView;
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
