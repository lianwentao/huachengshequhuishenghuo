//
//  shangjialeftViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/8.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "shangjialeftViewController.h"
#import "newshangjiaViewController.h"
#import "LWGesturePenetrationTableView.h"
#import "shangjialevelListview.h"
#import "SYMoreButtonView.h"
#import "serviceDetailViewController.h"
@interface shangjialeftViewController ()<UITableViewDelegate,UITableViewDataSource,FSSegmentTitleViewDelegate>
{
    LWGesturePenetrationTableView *_TableView;
    shangjialevelListview *levellistview;
    NSArray *_DataArr;
    NSArray *catecoryarr;
    NSDictionary *datadic;
    BOOL _rightTVScrollUp;
    
    CGFloat _oldRightOffsetY;
    BOOL _didSelectLeftTVCell;//选中左边tableView cell
    
    long titleselect;
}
@property(nonatomic, strong)LWGesturePenetrationTableView *rightTableView;
@property(nonatomic, strong)UITableView *leftTableView;
@end

@implementation shangjialeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    titleselect = 0;
    [self CreateTableview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chuandi:) name:@"chuandititlearr" object:nil];
    // Do any additional setup after loading the view.
}
- (void)chuandi:(NSNotification *)info
{
    WBLog(@"---%@",info.userInfo);
    datadic = info.userInfo;
    catecoryarr = [NSArray array];
    catecoryarr = [datadic objectForKey:@"category"];
    _DataArr = [datadic objectForKey:@"service"];
}
#pragma mark --- UIScrollViewDelegate ---

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    newshangjiaViewController *vc = (newshangjiaViewController *)[self parentViewController];//父控制器
    
    NSLog(@"aaaaaaaaaaaaaa=====%f",scrollView.contentOffset.y);
    if (scrollView==_TableView&&!_didSelectLeftTVCell) {
        if (scrollView.contentOffset.y <= 0) {//rightTableView不能小于最小值（不能下滑的条件）
            self.offsetType = OffsetTypeMin;
            scrollView.contentOffset =CGPointZero;
        } else {
            self.offsetType = OffsetTypeCenter;
        }
        
        
        //联动逻辑：rightTableViews顶部section头消失出现 实现 leftTableView选择联动
        if (scrollView.contentOffset.y>_oldRightOffsetY) {
            _rightTVScrollUp = YES;
            _rightTVScrollDown =  !_rightTVScrollUp;
            
            
        } else if (scrollView.contentOffset.y<_oldRightOffsetY)
        {
            _rightTVScrollUp = NO;
            _rightTVScrollDown =  !_rightTVScrollUp;
        }
        
        
        if (vc.offsetType != OffsetTypeMax&&_rightTVScrollUp) {//vc.offsetType!= OffsetTypeMax  时rightTableView不能向上滑动（不能上滑的条件）
            scrollView.contentOffset = CGPointMake(0, _oldRightOffsetY);
        }
        if (vc.offsetType == OffsetTypeMax) {
            
        }
        
        NSLog(@"ccccccccccc=====%f",scrollView.contentOffset.y);
        _oldRightOffsetY = floorf(scrollView.contentOffset.y);
    }
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView==_TableView) {
        _didSelectLeftTVCell = NO;
        _oldRightOffsetY = floorf(scrollView.contentOffset.y);
    }
}
#pragma mark -  leftTableView rightTableView实现联动 : rightTableViews顶部section头消失出现 实现 leftTableView选择联动
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self scrollRightTableViewWhenSelectRowInLeftTableViewAtIndexPath:indexPath];
//    _didSelectLeftTVCell = YES;
    serviceDetailViewController *de = [[serviceDetailViewController alloc] init];
    de.serviceID = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"id"];
    de.serviceTitle = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    [self.navigationController pushViewController:de animated:YES];
}

-(void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    if (!_didSelectLeftTVCell&&tableView==_TableView&&_rightTVScrollUp) {
        NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:section+1 inSection:0];
        if ((section+1)<10) {
            [_leftTableView selectRowAtIndexPath:targetIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
        
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    if (!_didSelectLeftTVCell&&tableView==_TableView&&_rightTVScrollDown) {
        NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:section inSection:0];
        [_leftTableView selectRowAtIndexPath:targetIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    //
}


#pragma mark -
-(void)scrollRightTableViewWhenSelectRowInLeftTableViewAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.row;
    NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:NSNotFound inSection:section];
    [_rightTableView scrollToRowAtIndexPath:targetIndexPath atScrollPosition: UITableViewScrollPositionTop animated:YES];
}


#pragma mark - 创建tableview
- (void)CreateTableview
{
    _TableView = [[LWGesturePenetrationTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-45-RECTSTATUS.size.height-44)style:UITableViewStylePlain];
    //_TableView.estimatedRowHeight = 0;
    _TableView.bounces = NO;
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    [self.view addSubview:_TableView];
}

#pragma mark --
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    _DataArr = [NSArray array];
    WBLog(@"%ld--%ld",endIndex,startIndex);
    
    if (endIndex == 0) {
        _DataArr = [datadic objectForKey:@"service"];
        titleselect = 0;
        [_TableView reloadData];
    }else{
        titleselect = endIndex;
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSDictionary *dict = nil;
        dict = @{@"id":[datadic objectForKey:@"id"],@"category":[[catecoryarr objectAtIndex:endIndex-1] objectForKey:@"category"]};
        NSString *strurl = [API_NOAPK stringByAppendingString:@"/Service/institution/merchantService"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {

                _DataArr = [responseObject objectForKey:@"data"];
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
                
                [_TableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WBLog(@"failure--%@",error);
            [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
        }];
    }
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataArr.count;
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_width, 50)];
    headview.backgroundColor = BackColor;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    [arr addObject:@"全部"];
    NSArray *categoryarr = [datadic objectForKey:@"category"];
    for (int i=0; i<categoryarr.count; i++) {
        [arr addObject:[[categoryarr objectAtIndex:i] objectForKey:@"category_cn"]];
    }
    FSSegmentTitleView *titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, Main_width-60, 50) titles:arr delegate:nil indicatorType:3];
    
    titleView.delegate = self;
    titleView.titleSelectFont = [UIFont systemFontOfSize:15.5];
    titleView.selectIndex = titleselect;
    [headview addSubview:titleView];
    return headview;
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, Main_width-30, (Main_width-30)/2.5)];
    [imgview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"title_img"]]] placeholderImage:[UIImage imageNamed:@"201995-120HG1030762"]];
    imgview.clipsToBounds = YES;
    imgview.layer.cornerRadius = 10;
    [cell.contentView addSubview:imgview];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15+imgview.frame.size.height+imgview.frame.origin.y, Main_width*3/4, 15)];
    label1.text = [[_DataArr objectAtIndex:indexPath.row] objectForKey:@"title"];
    label1.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:label1];

    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(Main_width*3/4-15, 15+imgview.frame.size.height+imgview.frame.origin.y, Main_width/4, 15)];
    price.text = [NSString stringWithFormat:@"¥%@",[[_DataArr objectAtIndex:indexPath.row] objectForKey:@"price"]];
    price.font = [UIFont systemFontOfSize:14];
    price.textAlignment = NSTextAlignmentRight;
    price.textColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1.0];
    [cell.contentView addSubview:price];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, label1.frame.size.height+label1.frame.origin.y+10, Main_width-30, 0.5)];
    lineview.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05];
    [cell.contentView addSubview:lineview];
    
    tableView.rowHeight = lineview.frame.size.height+lineview.frame.origin.y;
    return cell;
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
