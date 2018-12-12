//
//  fuwusearchViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/7.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "fuwusearchViewController.h"
#import "fuwusearchchildViewController.h"
#import "fuwusearchresultViewController.h"
#import "searchServiceViewController.h"
#define PYSEARCH_SEARCH_HISTORY_CACHE_PATH1 [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MLSearchhistories1.plist"] // 搜索商家历史存储路径
#define PYSEARCH_SEARCH_HISTORY_CACHE_PATH2 [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MLSearchhistories2.plist"] // 搜索服务历史存储路径
@interface fuwusearchViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate,UITextFieldDelegate>{
    UITextField *text;
}

@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;

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

@implementation fuwusearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchHistoriesCachePath1 = PYSEARCH_SEARCH_HISTORY_CACHE_PATH1;
    _searchHistories1 = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath1]];
    self.searchHistoriesCachePath2 = PYSEARCH_SEARCH_HISTORY_CACHE_PATH2;
    _searchHistories2 = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:self.searchHistoriesCachePath2]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setui];
    [self setTitlebar];
    self.searchHistoriesCount = 20;
    // Do any additional setup after loading the view.
}

-(void)setTitlebar
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-100, 44)];
    [self.navigationItem setTitleView:view];
    UIImageView *bgimg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, Main_width-100-30, 30)];
    bgimg.backgroundColor = [UIColor whiteColor];
    bgimg.layer.cornerRadius = 15;
    bgimg.layer.borderColor = [[UIColor grayColor] CGColor];
    bgimg.layer.borderWidth = 1;
    [bgimg.layer setMasksToBounds:YES];
    bgimg.userInteractionEnabled = YES;
    [view addSubview:bgimg];
    //
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 16, 16)];
    img.image = [UIImage imageNamed:@"common_btn_search"];
    [bgimg addSubview:img];
    
    text = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+10, 0, bgimg.frame.size.width-20, 30)];
    text.placeholder = @"请输入搜索内容";
    text.textColor = [UIColor blackColor];
    text.font = [UIFont systemFontOfSize:14];
    text.delegate = self;
    [text becomeFirstResponder];
    text.returnKeyType = UIReturnKeySearch;
    [bgimg addSubview:text];
    
}
/** 视图完全显示 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 弹出键盘
    [text becomeFirstResponder];
}

/** 视图即将消失 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 回收键盘
    [text resignFirstResponder];
}
// return按钮操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    WBLog(@"--%ld",self.titleView.selectIndex);
    [text endEditing:YES];
    
    [self saveSearchCacheAndRefreshView:text.text];
    
    
    if (self.titleView.selectIndex == 0) {
        fuwusearchresultViewController *result = [[fuwusearchresultViewController alloc] init];
        result.key = text.text;
        result.canshu = @"i_key";
        result.url = @"/service/institution/merchantList";
        [self.navigationController pushViewController:result animated:YES];
    }else{
        searchServiceViewController *result = [[searchServiceViewController alloc] init];
        result.key = text.text;
        result.canshu = @"s_key";
        result.url = @"/service/service/serviceList";
        [self.navigationController pushViewController:result animated:YES];
        
    }
    return YES;
}
- (void)setSearchHistoriesCachePath:(NSString *)searchHistoriesCachePath
{
    if (self.titleView.selectIndex == 0) {
        _searchHistoriesCachePath1 = [searchHistoriesCachePath copy];
        // 刷新
        self.searchHistories1 = nil;
    }else{
        _searchHistoriesCachePath2 = [searchHistoriesCachePath copy];
        // 刷新
        self.searchHistories2 = nil;
    }
    
}
/** 进入搜索状态调用此方法 */
- (void)saveSearchCacheAndRefreshView:(NSString *)searchtext
{
    if (self.titleView.selectIndex == 0) {
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
}

-(void)rightmengbutClick{
    WBLog(@"asd");
}
- (void)setui
{
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSString *title in @[@"sj",@"fw"]) {
        fuwusearchchildViewController *vc = [[fuwusearchchildViewController alloc]init];
        vc.shangjiaorfuwu = title;
        [childVCs addObject:vc];
    }
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, CGRectGetWidth(self.view.bounds), 50) titles:@[@"商家",@"服务"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:17];
    self.titleView.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(247)/255.0 blue:(248)/255.0 alpha:0.54];
    self.titleView.titleNormalColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.54];
    self.titleView.selectIndex = 0;
    
    [self.view addSubview:_titleView];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    //self.pageContentView.contentViewCanScroll = YES;//设置滑动属性
    [self.view addSubview:_pageContentView];
}
#pragma mark --
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
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
