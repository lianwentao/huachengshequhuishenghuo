//
//  version41mallViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/12/22.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "version41mallViewController.h"
#import "SegmentView.h"
#import "CenterTouchTableView.h"
#import "YWPageHeadView.h"
#import "version41mallchildViewController.h"

#import "xianshiqianggouViewController.h"
#import "WRNavigationBar.h"
#import "WRImageHelper.h"
#import "MJRefresh.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "GSKeyChainDataManager.h"
#import "JKBannarView.h"
#import "PYSearch.h"
#import "searchreslutsViewController.h"
#import "shangpinliebiaoViewController.h"
#import "ShangpinfenleiViewController.h"
#import "GouwucheViewController.h"
#import "NewPagedFlowView.h"

#import "GoodsDetailViewController.h"
#import "circledetailsViewController.h"
#import "acivityViewController.h"
#import "activitydetailsViewController.h"
#import "weixiuViewController.h"
#import "shangpinerjiViewController.h"
#import "WebViewController.h"
#import "youhuiquanViewController.h"
#import "youhuiquanxiangqingViewController.h"
#import "noticeViewController.h"
#import "MoreViewController.h"
#import "circledetailsViewController.h"
#import "youxianjiaofeiViewController.h"
#import "openDoorViewController.h"
#import "FacePayViewController.h"
#import "jujiayanglaoViewController.h"
#import "selectHomeViewController.h"
#import "blueyaViewController.h"
#import "bangdingqianViewController.h"
#import "shangpinliebiaoViewController.h"
#import "MyhomeViewController.h"
#import "xinfangshouceViewController.h"
#import "xianshiqianggouerjiViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import "LoginViewController.h"
#import "huodongwebviewViewController.h"

#import "newxianshiqianggouViewController.h"

#define NAVBAR_COLORCHANGE_POINT (-IMAGE_HEIGHT + NAV_HEIGHT)
#define NAV_HEIGHT 64
#define IMAGE_HEIGHT 0
#define SCROLL_DOWN_LIMIT 70
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LIMIT_OFFSET_Y -(IMAGE_HEIGHT + SCROLL_DOWN_LIMIT)
@interface version41mallViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,NewPagedFlowViewDelegate,NewPagedFlowViewDataSource,UISearchBarDelegate>{
    NSArray *HeaDataArr;
    NSArray *centerArr;
    NSArray *guanggaoArr;
    NSArray *shangpinArr;
    NSArray *fenleiArr;
    NSArray *pro_discount_listArr;
    
    JKBannarView *bannerView;
    
    NSArray *_searcharr;
    
    int _pagenum;
    
    UIButton *_tmpBtn;
    
    NSString *moregoodsid;
    
    UIImageView *redcountimage;
    
    NSInteger secondsCountDown;//倒计时总时长
    NSTimer *countDownTimer;
    UILabel *daylabel;
    UILabel *hourslabel;
    UILabel *mlabel;
    UILabel *slabel;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) CenterTouchTableView *mainTableView;
//自定义导航栏
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) SegmentView *segmentView;
//@property (nonatomic, strong) UIImageView *headerImageView;
//@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, assign) BOOL canScroll;//mainTableView是否可以滚动
@property (nonatomic, assign) BOOL isBacking;//是否正在pop

//@property (nonatomic, strong) headBackView *headView;
//空白view，可以加空间
@property (nonatomic, strong) UIView *tabHeadView;
//空白view高度
@property (nonatomic, assign) CGFloat tabHeadViewHeight;
//头部图片高度
@property (nonatomic, assign) CGFloat HeaderImageViewHeight;
//头部总高度
@property (nonatomic, assign) CGFloat offHeight;


//@property(nonatomic,strong)CCPagedScrollView *imageScrollView;
@property (nonatomic,strong) YWPageHeadView *pageHeadView;

@end

@implementation version41mallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavItems];;
    [self wr_setNavBarBarTintColor:[UIColor whiteColor]];
    [self wr_setNavBarBackgroundAlpha:0];
    
    [self getdata];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushgoods:) name:@"zhuyemianpush" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"changetitle" object:nil];
//    if (@available(iOS 11.0, *)) {
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
//    //如果使用自定义的按钮去替换系统默认返回按钮，会出现滑动返回手势失效的情况
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    //注册允许外层tableView滚动通知-解决和分页视图的上下滑动冲突问题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    //分页的scrollView左右滑动的时候禁止mainTableView滑动，停止滑动的时候允许mainTableView滑动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:IsEnablePersonalCenterVCMainTableViewScroll object:nil];
    
    
    
    //这三个高度必须先算出来，建议请求完数据知道高度以后再调用下面代码
    
//    self.HeaderImageViewHeight = 0;
//    self.offHeight = self.tabHeadViewHeight + self.HeaderImageViewHeight;
    
    // Do any additional setup after loading the view.
}
- (void)change
{
    [_mainTableView.mj_header beginRefreshing];
}
- (void)setupNavItems
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.navigationItem setTitleView:view];
    
    UIButton *butleft = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 30, 30)];
    [butleft setImage:[UIImage imageNamed:@"fenlei"] forState:UIControlStateNormal];
    butleft.backgroundColor = [UIColor redColor];
    [butleft addTarget:self action:@selector(onClickLeft) forControlEvents:UIControlEventTouchUpInside];
    butleft.backgroundColor = [UIColor clearColor];
    [view addSubview:butleft];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 5, 30, 30)];
    [but setImage:[UIImage imageNamed:@"gouwuche"] forState:UIControlStateNormal];
    but.backgroundColor = [UIColor redColor];
    [but addTarget:self action:@selector(onClickRight) forControlEvents:UIControlEventTouchUpInside];
    but.backgroundColor = [UIColor clearColor];
    [view addSubview:but];
    redcountimage = [[UIImageView alloc] initWithFrame:CGRectMake(27, 2, 6, 6)];
    redcountimage.layer.masksToBounds = YES;
    redcountimage.layer.cornerRadius = 3;
    redcountimage.backgroundColor = [UIColor redColor];
    redcountimage.hidden = NO;
    [but addSubview:redcountimage];
    
    UISearchBar *customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(50,5, (self.view.frame.size.width-120), 34)];
    customSearchBar.delegate = self;
    customSearchBar.showsCancelButton = NO;
    customSearchBar.placeholder = @"搜一搜";
    customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [view addSubview:customSearchBar];
    
    UIButton *searchbut = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbut.frame = CGRectMake(0, 0, Main_width-70, 34);
    [customSearchBar addSubview:searchbut];
    [searchbut addTarget:self action:@selector(getsearchs) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffsetY  = scrollView.contentOffset.y;
    
        //临界点偏移量
        CGFloat mainy = [self.mainTableView rectForSection:0].origin.y;
        //    NSLog(@"mainy====%f",mainy);
        CGFloat criticalPointOffsetY = [self.mainTableView rectForSection:0].origin.y - NAVHEIGHT;
        //WBLog(@"%f--%f--%f",currentOffsetY,mainy,criticalPointOffsetY);
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < -NAVHEIGHT) {
        [self updateNavBarButtonItemsAlphaAnimated:.0f];
    } else {
        [self updateNavBarButtonItemsAlphaAnimated:1.0f];
    }
    
    if (offsetY > NAVBAR_COLORCHANGE_POINT)
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self wr_setNavBarBackgroundAlpha:alpha];
        [self updateSearchBarColor:alpha];
    }
    else
    {
        [self wr_setNavBarBackgroundAlpha:0];
        [self.searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    //第二部分：
    //利用contentOffset处理内外层scrollView的滑动冲突问题
    if (currentOffsetY < criticalPointOffsetY) {
        if (!self.canScroll) {
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        }
        //WBLog(@"******______*********");
    } else {
        
        scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
        self.canScroll = NO;
        //WBLog(@"#########******______*********");
    }
    //    //限制下拉的距离
    //    if(offsetY < LIMIT_OFFSET_Y) {
    //        [scrollView setContentOffset:CGPointMake(0, LIMIT_OFFSET_Y)];
    //    }
}

- (void)updateNavBarButtonItemsAlphaAnimated:(CGFloat)alpha
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.navigationController.navigationBar wr_setBarButtonItemsAlpha:alpha hasSystemBackIndicator:NO];
    }];
}

- (void)updateSearchBarColor:(CGFloat)alpha
{
    UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:alpha];
    UIImage *image = [UIImage imageNamed:@"search"];
    image = [image wr_updateImageWithTintColor:color alpha:alpha];
    [self.searchButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.searchButton setTitleColor:CIrclecolor forState:UIControlStateNormal];
}
- (void)onClickLeft
{
    ShangpinfenleiViewController *shangfenlei = [[ShangpinfenleiViewController alloc] init];
    shangfenlei.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shangfenlei animated:YES];
}
- (void)onClickRight
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefaults objectForKey:@"token"];
    if (str==nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        GouwucheViewController *gouwuche = [[GouwucheViewController alloc] init];
        gouwuche.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gouwuche animated:YES];
    }
    
}
- (void)onClickSearchBtn
{
    [self getsearchs];
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
- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
//
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isBacking = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:PersonalCenterVCBackingStatus object:nil userInfo:@{@"isBacking":@(self.isBacking)}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isBacking = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:PersonalCenterVCBackingStatus object:nil userInfo:@{@"isBacking":@(self.isBacking)}];
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods
- (void)setupSubViews {
    self.mainTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView addSubview:self.tabHeadView];
    
    
    self.pageHeadView.parentScrollView = self.mainTableView;  //这个必须设置
    //self.pageHeadView.chidlScrollView = self.imageScrollView.scrollView; //这个必须设置
    
    
    [self.mainTableView addSubview:self.pageHeadView];
    //[self.pageHeadView addSubview:self.imageScrollView];
    //[self.view addSubview:self.naviView];
    
    
}
- (void)acceptMsg:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    if ([notification.name isEqualToString:@"leaveTop"]) {
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
        }
        WBLog(@"1111");
    } else if ([notification.name isEqualToString:IsEnablePersonalCenterVCMainTableViewScroll]) {
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.mainTableView.scrollEnabled = YES;
            WBLog(@"122222");
        } else if([canScroll isEqualToString:@"0"]) {
            self.mainTableView.scrollEnabled = NO;
            WBLog(@"111133333");
        }
        WBLog(@"22222");
    }
}

#pragma mark - UiScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    //通知分页子控制器列表返回顶部
    [[NSNotificationCenter defaultCenter] postNotificationName:SegementViewChildVCBackToTop object:nil];
    return YES;
}

/**
 * 处理联动
 * 因为要实现下拉头部放大的问题，tableView设置了contentInset，所以试图刚加载的时候会调用一遍这个方法，所以要做一些特殊处理，
 */
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    //当前y轴偏移量
//    CGFloat currentOffsetY  = scrollView.contentOffset.y;
//    
//    //临界点偏移量
//    CGFloat mainy = [self.mainTableView rectForSection:0].origin.y;
//    //    NSLog(@"mainy====%f",mainy);
//    CGFloat criticalPointOffsetY = [self.mainTableView rectForSection:0].origin.y - NAVHEIGHT;
//    WBLog(@"%f--%f--%f",currentOffsetY,mainy,criticalPointOffsetY);
//    //    NSLog(@"criticalPointOffsetY====%f",criticalPointOffsetY);
//    //    NSLog(@"NAVHEIGHT====%f",NAVHEIGHT);
//    //第一部分: 更改导航栏的背景图的透明度
//    CGFloat alpha = 0;
//    if (currentOffsetY <= 0) {
//        alpha = 0;
//    } else if ((currentOffsetY > 0) && currentOffsetY < 400) {
//        alpha = currentOffsetY / 400;
//    } else {
//        alpha = 1;
//    }
//    self.naviView.backgroundColor = kRGBA(255, 126, 15, alpha);
//    
//    
//    
//    //第三部分：
//    /**
//     * 处理头部自定义背景视图 (如: 下拉放大)
//     * 图片会被拉伸多出状态栏的高度
//     */
//    //     NSLog(@"currentOffsetY === %f",currentOffsetY);
//    //    if(currentOffsetY <= -self.offHeight) {
//    //
//    //        if (self.isEnlarge) {
//    //
//    //            _pageHeadView.y  = currentOffsetY;
//    //            _pageHeadView.height = -currentOffsetY-self.tabHeadViewHeight;
//    //
//    //
//    //             _imageScrollView.height = -currentOffsetY-self.tabHeadViewHeight;
//    //            [_imageScrollView adjustSubViewHeight];
//    //
//    //        }else{
//    //            scrollView.contentOffset = CGPointMake(0, -self.offHeight);
//    //            scrollView.bounces = NO;
//    //
//    //        }
//    //
//    //
//    //    }else {
//    ////        _imageScrollView.y = -(currentOffsetY + self.offHeight);
//    //        scrollView.bounces = YES;
//    //    }
//}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.backgroundColor = [UIColor greenColor];
    
    [cell.contentView addSubview:self.segmentView];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Main_Height;
}

//#pragma mark - Lazy
//- (UIView *)naviView {
//    if (!_naviView) {
//        _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_width, NAVHEIGHT)];
//        _naviView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
//        //添加返回按钮
//        UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [backButton setImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
//        backButton.frame = CGRectMake(5, 8 + NAVIGATIONBARHEIGHT, 28, 25);
//        backButton.adjustsImageWhenHighlighted = YES;
//        [backButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
//        [_naviView addSubview:backButton];
//
//        //添加消息按钮
//        UIButton *messageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        [messageButton setImage:[UIImage imageNamed:@"shareIcon"] forState:(UIControlStateNormal)];
//        messageButton.frame = CGRectMake(Main_width - 35, 8 + NAVIGATIONBARHEIGHT, 25, 25);
//        messageButton.adjustsImageWhenHighlighted = YES;
//        [messageButton addTarget:self action:@selector(gotoShare) forControlEvents:(UIControlEventTouchUpInside)];
//        [_naviView addSubview:messageButton];
//    }
//    return _naviView;
//}


/*
 *
 */
//- (UIView *)setPageViewControllers {
//    if (!_segmentView) {
//        //设置子控制器
//        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
//        NSMutableArray *titlearr = [NSMutableArray arrayWithCapacity:0];
//        for (int i=0; i<fenleiArr.count; i++) {
//            version41mallchildViewController *vc = [[version41mallchildViewController alloc] init];
//            [arr addObject:vc];
//            vc.id = [[fenleiArr objectAtIndex:i] objectForKey:@"id"];
//            [titlearr addObject:[[fenleiArr objectAtIndex:i] objectForKey:@"cate_name"]];
//        }
//        NSArray *titleArray = titlearr;
//        SegmentView *segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, Main_width, Main_Height-NAVHEIGHT) controllers:arr titleArray:titleArray parentController:self];
//        //注意：不能通过初始化方法传递selectedIndex的初始值，因为内部使用的是Masonry布局的方式, 否则设置selectedIndex不起作用
//
//        _segmentView = segmentView;
//    }
//    return _segmentView;
//}
- (void)createui
{
    [self setupSubViews];
    //初始化变量
    self.canScroll = YES;
    
    self.mainTableView = [[CenterTouchTableView alloc]initWithFrame:CGRectMake(0, -NAVHEIGHT, Main_width, Main_Height+NAVHEIGHT-LCL_HomeIndicator_Height)];
    [self.view addSubview:self.mainTableView];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注意：这里不能使用动态高度_headimageHeight, 不然tableView会往下移，在iphone X下，头部不放大的时候，上方依然会有白色空白
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(shuaxin)];
    
    _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);//内容视图开始正常显示的坐标为(0, HeaderImageViewHeight)
    
    long H1;
    long H2;
    if ([pro_discount_listArr isKindOfClass:[NSArray class]]&&pro_discount_listArr.count>0) {
        H1 =212+8+10+50;
        
    }else{
        H1 = 0;
        
    }
    if ([shangpinArr isKindOfClass:[NSArray class]]&&shangpinArr.count>0) {
        H2 =10+50+10+120;
        
    }else{
        H2 = 0;
        
    }
    //view.frame.size.height+view.frame.origin.y+H1+10+H2+10/////15+width+15+20+10+15+width+20+15
    _tabHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_width, Main_width/(2.5)+10+2*(Main_width-24-30*5)/5+15+15+20+10+15+20+15+H1+10+H2-LCL_HomeIndicator_Height)];
    
    
    
    
#pragma mark - 头部广告
    [bannerView imageViewClick:^(JKBannarView * _Nonnull barnerview, NSInteger index) {
        NSLog(@"点击图片%ld",index);
        NSString *url_type = [[HeaDataArr objectAtIndex:index] objectForKey:@"url_type"];
        NSString *url_id = [[HeaDataArr objectAtIndex:index] objectForKey:@"url_id"];
        NSString *urltypename = [[HeaDataArr objectAtIndex:index] objectForKey:@"type_name"];
        if ([url_type isEqualToString:@"5"]) {
            weixiuViewController *weixiu = [[weixiuViewController alloc] init];
            weixiu.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:weixiu animated:YES];
        }if ([url_type isEqualToString:@"3"]) {
            acivityViewController *aciti = [[acivityViewController alloc] init];
            aciti.hidesBottomBarWhenPushed = YES;
            aciti.url = urltypename;
            [self.navigationController pushViewController:aciti animated:YES];
        }if ([url_type isEqualToString:@"4"]) {
            activitydetailsViewController *acti = [[activitydetailsViewController alloc] init];
            acti.url = urltypename;
            acti.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:acti animated:YES];
        }if ([url_type isEqualToString:@"7"]) {
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",url_id];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }if ([url_type isEqualToString:@"1"]) {
            shangpinliebiaoViewController *liebiao = [[shangpinliebiaoViewController alloc] init];
            shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
            NSString *type_name = [[HeaDataArr objectAtIndex:index] objectForKey:@"type_name"];
            NSRange range = [type_name rangeOfString:@"id/"]; //现获取要截取的字符串位置
            NSString * result = [type_name substringFromIndex:range.location+3]; //截取字符串
            liebiao.id = result;
            erji.id = result;
            erji.hidesBottomBarWhenPushed = YES;
            liebiao.hidesBottomBarWhenPushed = YES;
            
            
            //1.创建会话管理者
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            //2.封装参数
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"cate_id":result};
            
            NSString *strurl = [API stringByAppendingString:@"shop/pro_list_cate"];
            [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSArray *arr = [responseObject objectForKey:@"data"];
                if (![arr isKindOfClass:[NSArray class]]) {
                    [self.navigationController pushViewController:erji animated:YES];
                }else{
                    [self.navigationController pushViewController:liebiao animated:YES];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"failure--%@",error);
            }];
            
            
        }if ([url_type isEqualToString:@"6"]) {
            //优惠券
            NSString *type_name = [[HeaDataArr objectAtIndex:index] objectForKey:@"type_name"];
            
            WebViewController *web = [[WebViewController alloc] init];
            web.url_type = @"2";
            web.title = @"优惠券";
            web.url = type_name;
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }if ([url_type isEqualToString:@"8"]) {
            youhuiquanViewController *youhuiquan = [[youhuiquanViewController alloc] init];
            youhuiquan.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:youhuiquan animated:YES];
        }if ([url_type isEqualToString:@"9"]) {
            youhuiquanxiangqingViewController *youhuiquan = [[youhuiquanxiangqingViewController alloc] init];
            youhuiquan.hidesBottomBarWhenPushed = YES;
            NSRange range = [urltypename rangeOfString:@"id/"]; //现获取要截取的字符串位置
            NSString * result = [urltypename substringFromIndex:range.location+3]; //截取字符串
            youhuiquan.id = result;
            [self.navigationController pushViewController:youhuiquan animated:YES];
        }if ([url_type isEqualToString:@"2"]) {
            GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
            NSRange range = [urltypename rangeOfString:@"id/"]; //现获取要截取的字符串位置
            NSString * result = [urltypename substringFromIndex:range.location+3]; //截取字符串
            goods.IDstring = result;
            goods.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goods animated:YES];
        }if ([url_type isEqualToString:@"10"]) {
            WebViewController *web = [[WebViewController alloc] init];
            web.url = url_id;
            web.url_type = @"1";
            //web.jpushstring = @"jpush";
            web.title = @"小慧推荐";
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }if ([url_type isEqualToString:@"11"]) {
            noticeViewController *notice = [[noticeViewController alloc] init];
            notice.hidesBottomBarWhenPushed = YES;
            NSRange range = [url_id rangeOfString:@"id/"]; //现获取要截取的字符串位置
            NSString * result = [url_id substringFromIndex:range.location+3]; //截取字符串
            notice.id = result;
            //notice.jpushstring = @"jpush";
            [self.navigationController pushViewController:notice animated:YES];
        }if ([url_type isEqualToString:@"12"]){
            
        }if ([url_type isEqualToString:@"13"]){
            circledetailsViewController *circle = [[circledetailsViewController alloc] init];
            NSRange range = [urltypename rangeOfString:@"id/"]; //现获取要截取的字符串位置
            NSString * result = [urltypename substringFromIndex:range.location+3]; //截取字符串
            circle.id = result;
            circle.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:circle animated:YES];
        }if ([url_type isEqualToString:@"14"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_id]];
        }if ([url_type isEqualToString:@"15"]){
            youxianjiaofeiViewController *youxian = [[youxianjiaofeiViewController alloc] init];
            youxian.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:youxian animated:YES];
        }if ([url_type isEqualToString:@"16"]){
            NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
            NSString *is_bind_property = [userdf objectForKey:@"is_bind_property"];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
            NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
            NSString *strurl = [API stringByAppendingString:@"property/binding_community"];
            [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@-000000-%@",[responseObject objectForKey:@"msg"],responseObject);
                NSArray *arrrrr = [[NSArray alloc] init];
                if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                    arrrrr = [responseObject objectForKey:@"data"];
                    if (arrrrr.count>1) {
                        selectHomeViewController *selecthome = [[selectHomeViewController alloc] init];
                        selecthome.homeArr = arrrrr;
                        selecthome.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:selecthome animated:YES];
                    }else{
                        MyhomeViewController *myhome = [[MyhomeViewController alloc] init];
                        myhome.room_id = [[arrrrr objectAtIndex:0] objectForKey:@"room_id"];
                        myhome.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:myhome animated:YES];
                    }
                    [defaults setObject:@"2" forKey:@"is_bind_property"];
                    [userdf synchronize];
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
                    //                            [self logout];
                }else{
                    bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
                    bangding.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:bangding animated:YES];
                    
                    [defaults setObject:@"1" forKey:@"is_bind_property"];
                    [userdf synchronize];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failure--%@",error);
            }];
        }if ([url_type isEqualToString:@"17"]){
            NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
            NSString *is_bind_property = [userdf objectForKey:@"is_bind_property"];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
            NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
            NSString *strurl = [API stringByAppendingString:@"property/binding_community"];
            [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@-000000-%@",[responseObject objectForKey:@"msg"],responseObject);
                NSArray *arrrrr = [[NSArray alloc] init];
                if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                    arrrrr = [responseObject objectForKey:@"data"];
                    if (arrrrr.count>1) {
                        selectHomeViewController *selecthome = [[selectHomeViewController alloc] init];
                        selecthome.homeArr = arrrrr;
                        selecthome.rukoubiaoshi = @"layakaimen";
                        selecthome.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:selecthome animated:YES];
                    }else{
                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
                        NSDictionary *dict = @{@"apk_token":uid_username,@"room_id":[[arrrrr objectAtIndex:0] objectForKey:@"room_id"],@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
                        NSString *strurl = [API stringByAppendingString:@"property/checkIsAjb"];
                        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            NSLog(@"%@-11111-%@",[responseObject objectForKey:@"msg"],responseObject);
                            NSDictionary *dicccc = [[NSDictionary alloc] init];
                            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                                dicccc = [responseObject objectForKey:@"data"];
                                if ([dicccc isKindOfClass:[NSDictionary class]]) {
                                    blueyaViewController *blueya = [[blueyaViewController alloc] init];
                                    blueya.Dic = dicccc;
                                    blueya.hidesBottomBarWhenPushed = YES;
                                    [self.navigationController pushViewController:blueya animated:YES];
                                }else{
                                    [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
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
                                //                                        [self logout];
                            }else{
                                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                            }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            NSLog(@"failure--%@",error);
                        }];
                    }
                    [defaults setObject:@"2" forKey:@"is_bind_property"];
                    [userdf synchronize];
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
                    //                            [self logout];
                }else{
                    bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
                    bangding.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:bangding animated:YES];
                    [defaults setObject:@"1" forKey:@"is_bind_property"];
                    [userdf synchronize];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"failure--%@",error);
            }];
        }if ([url_type isEqualToString:@"18"]){
            FacePayViewController *face = [[FacePayViewController alloc] init];
            face.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:face animated:YES];
        }if ([url_type isEqualToString:@"19"]){
            jujiayanglaoViewController *hujia = [[jujiayanglaoViewController alloc] init];
            hujia.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hujia animated:YES];
        }if ([url_type isEqualToString:@"20"]){
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            if ([user objectForKey:@"username"]==nil) {
                LoginViewController *log = [[LoginViewController alloc] init];
                [self presentViewController:log animated:YES completion:nil];
            }else{
                huodongwebviewViewController *web = [[huodongwebviewViewController alloc] init];
                web.url = urltypename;
                
                
                //         http://www.dsyg42.com/ec/app_index?username=18503408643&sign=hshObj&atitude=112.727884&longitude=37.690397&uuid=990009261666328
                
                web.url = [NSString stringWithFormat:@"%@?username=%@&sign=hshObj&atitude=%@&longitude=%@&uuid=%@",urltypename,[user objectForKey:@"username"],[user objectForKey:@"latitude"],[user objectForKey:@"longitude"],GSKeyChainDataManager.readUUID];
                web.title = @"东森易购";
                NSLog(@"weburl---%@---%@",web.url,GSKeyChainDataManager.readUUID);
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
            }
        }if ([url_type isEqualToString:@"21"]){
            xinfangshouceViewController *xinfang = [[xinfangshouceViewController alloc] init];
            xinfang.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:xinfang animated:YES];
        }
    }];
    [_tabHeadView addSubview:bannerView];
    
#pragma mark - 分类
    UIView *view = [[UIView alloc] init];
    CGFloat width = (Main_width-24-30*5)/5;//(Main_width-24-30*5)/5+15+15+20+10+15+width+20+15
    if (centerArr.count<6) {
        view.frame = CGRectMake(12, bannerView.frame.size.height+10, Main_width-24, width+30+20+15);
    }else{
        view.frame = CGRectMake(12, bannerView.frame.size.height+10, Main_width-24, 15+width+15+20+10+15+width+20+15);
    }
    view.layer.cornerRadius = 5;
    view.clipsToBounds = YES;
    view.layer.borderColor = [UIColor colorWithHexString:@"#EFEFEF"].CGColor;
    view.layer.borderWidth = 1;
    [_tabHeadView addSubview:view];
    
    CGFloat labelwidth = (Main_width-24)/5;
    if (centerArr.count<6){
        for (int i=0; i<centerArr.count; i++) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*30+i*width, 15, width, width)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
            [view addSubview:imageview];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*labelwidth, 15+width+15, labelwidth, 20)];
            label.text = [[centerArr objectAtIndex:i] objectForKey:@"cate_name"];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];
            
            UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
            but.frame = CGRectMake(labelwidth*i, 15, labelwidth, labelwidth);
            but.tag = i;
            [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:but];
        }
    }else if (centerArr.count>=10) {
        for (int i=0; i<9; i++) {
            if (i<5) {
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*30+i*width, 15, width, width)];
                [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
                [view addSubview:imageview];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*labelwidth, 15+width+15, labelwidth, 20)];
                label.text = [[centerArr objectAtIndex:i] objectForKey:@"cate_name"];
                label.font = [UIFont systemFontOfSize:13];
                label.textAlignment = NSTextAlignmentCenter;
                [view addSubview:label];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(labelwidth*i, 15, labelwidth, labelwidth);
                but.tag = i;
                [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:but];
            }else{
                
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+(i-5)*30+(i-5)*width, 15+width+15+20+10, width, width)];
                
                [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
                [view addSubview:imageview];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i-5)*labelwidth, 15+width+15+20+10+15+width, labelwidth, 20)];
                
                label.font = [UIFont systemFontOfSize:13];
                label.textAlignment = NSTextAlignmentCenter;
                [view addSubview:label];
                
                
                [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
                label.text = [[centerArr objectAtIndex:i] objectForKey:@"cate_name"];
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(labelwidth*(i-5), 15+width+15+20+10, labelwidth, labelwidth);
                but.tag = i;
                [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:but];
            }
        }
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+(9-5)*30+(9-5)*width, 15+width+15+20+10, width, width)];
        imageview.image = [UIImage imageNamed:@"iv_icon_all"];
        
        [view addSubview:imageview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((9-5)*labelwidth, 15+width+15+20+10+15+width, labelwidth, 20)];
        
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"全部";
        [view addSubview:label];
        
        
        
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(labelwidth*(9-5), 15+width+15+20+10, labelwidth, labelwidth);
        but.tag = 9;
        [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:but];
    }else{
        for (int i=0; i<centerArr.count; i++) {
            if (i<5) {
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+i*30+i*width, 15, width, width)];
                [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
                [view addSubview:imageview];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*labelwidth, 15+width+15, labelwidth, 20)];
                label.text = [[centerArr objectAtIndex:i] objectForKey:@"cate_name"];
                label.font = [UIFont systemFontOfSize:13];
                label.textAlignment = NSTextAlignmentCenter;
                [view addSubview:label];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(labelwidth*i, 15, labelwidth, labelwidth);
                but.tag = i;
                [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:but];
            }else{
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15+(i-5)*30+(i-5)*width, 15+width+15+20+10, width, width)];
                [imageview sd_setImageWithURL:[NSURL URLWithString:[API_img stringByAppendingString:[[centerArr objectAtIndex:i] objectForKey:@"icon"]]] placeholderImage:[UIImage imageNamed:@"展位图正"]];
                [view addSubview:imageview];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((i-5)*labelwidth, 15+width+15+20+10+15+width, labelwidth, 20)];
                label.text = [[centerArr objectAtIndex:i] objectForKey:@"cate_name"];
                label.font = [UIFont systemFontOfSize:13];
                label.textAlignment = NSTextAlignmentCenter;
                [view addSubview:label];
                
                UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                but.frame = CGRectMake(labelwidth*(i-5), 15+width+15+20+10, labelwidth, labelwidth);
                but.tag = i;
                [but addTarget:self action:@selector(pusherji:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:but];
            }
        }
    }
    
#pragma mark - 限时抢购
    
    
    
    if ([pro_discount_listArr isKindOfClass:[NSArray class]]&&pro_discount_listArr.count>0) {
        
        UIView *xianshitoubu = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height+view.frame.origin.y+10, Main_width, 50)];
//        xianshitoubu.backgroundColor = QIColor;
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(10, 17, 75, 19);
        titleLab.text = @"限时秒杀";
        titleLab.textColor = [UIColor colorWithHexString:@"#FF2035"];
        titleLab.font = [UIFont systemFontOfSize:18];
        [xianshitoubu addSubview:titleLab];
        
        UILabel *fuLab = [[UILabel alloc]init];
        fuLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame)+10, 22, 113, 14);
        fuLab.text = @"限时限量 火速来秒";
        fuLab.textColor = [UIColor colorWithHexString:@"#FF2035"];
        fuLab.font = [UIFont systemFontOfSize:13];
        [xianshitoubu addSubview:fuLab];
        [_tabHeadView addSubview:xianshitoubu];
        
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.frame = CGRectMake(Main_width-10-50, 17, 50, 19);
        [moreBtn setTitle:@"更多 >" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithHexString:@"#9C9C9C"] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        [xianshitoubu addSubview:moreBtn];
        
//        UIButton *morebut = [UIButton buttonWithType:UIButtonTypeCustom];
//        morebut.frame = CGRectMake(Main_width-50, 10, 40, 15);
//        morebut.backgroundColor = QIColor;
//        //[cell.contentView addSubview:morebut];
        
        
        UIScrollView *backscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(18, 8+xianshitoubu.frame.size.height+xianshitoubu.frame.origin.y, Main_width-18*2, 212)];
        backscrollview.contentSize = CGSizeMake(125*pro_discount_listArr.count+16*(pro_discount_listArr.count-1), 212);
        backscrollview.showsVerticalScrollIndicator = NO;
        backscrollview.showsHorizontalScrollIndicator = NO;
       
        [_tabHeadView addSubview:backscrollview];
        
        for (int i=0; i<pro_discount_listArr.count; i++) {
            UIView *backview = [[UIView alloc] initWithFrame:CGRectMake((125+16)*i, 0, 125, 212)];
            backview.backgroundColor = [UIColor whiteColor];
            backview.layer.cornerRadius = 5;
            backview.clipsToBounds = YES;
            backview.layer.borderColor = [UIColor colorWithHexString:@"#F1F1F1"].CGColor;
            backview.layer.borderWidth=1;
            [backscrollview addSubview:backview];
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 16, 117, 100)];
            NSString *imgstr = [NSString stringWithFormat:@"%@%@",API_img,[[pro_discount_listArr objectAtIndex:i] objectForKey:@"title_thumb_img"]];
            [imageview sd_setImageWithURL:[NSURL URLWithString:imgstr] placeholderImage:[UIImage imageNamed:@"展位图长1.5"]];
            [backview addSubview:imageview];
            
            NSString *is_hot = [NSString stringWithFormat:@"%@",[[pro_discount_listArr objectAtIndex:i] objectForKey:@"is_hot"]];
            NSString *is_new = [NSString stringWithFormat:@"%@",[[pro_discount_listArr objectAtIndex:i] objectForKey:@"is_new"]];
            NSString *is_time = [NSString stringWithFormat:@"%@",[[pro_discount_listArr objectAtIndex:i] objectForKey:@"discount"]];
            
            UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(3, -4, 31, 31)];
            [backview addSubview:imageview1];
            if ([is_time isEqualToString:@"1"]) {
                imageview1.image = [UIImage imageNamed:@"秒杀"];
            }else if ([is_hot isEqualToString:@"1"]) {
                imageview1.image = [UIImage imageNamed:@"热卖"];
            }else if([is_new isEqualToString:@"1"]){
                imageview1.image = [UIImage imageNamed:@"上新"];
            }else{
                imageview1.alpha = 0;
            }
            
            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(5, imageview.frame.size.height+imageview1.frame.origin.y+15, 115, 23)];
            view1.backgroundColor = [UIColor colorWithRed:255/255.0 green:87/255.0 blue:34/255.0 alpha:1];
            view1.layer.cornerRadius = 12;
            [backview addSubview:view1];
            
            UILabel *julabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 35, 15)];
            
            julabel.textColor = [UIColor whiteColor];
            julabel.font = [UIFont systemFontOfSize:10];
            [view1 addSubview:julabel];
            if ([[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_stime"] integerValue]-time(NULL)>0) {
                secondsCountDown = [[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_stime"] integerValue]-time(NULL);//倒计时秒数
                julabel.text = @"距开始";
                
            }else if ([[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue]-time(NULL)<0){
                secondsCountDown = time(NULL)-[[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue];//已结束
            }else{
                secondsCountDown = [[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue]-time(NULL);
                julabel.text = @"距结束";
            }
            
            //                    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            //                    attch.image = [UIImage imageNamed:@"shijian"];
            //                    attch.bounds = CGRectMake(0, -3, 15, 15);
            //                    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            //                    [attri insertAttributedString:string atIndex:0];
            //                    label3.attributedText = attri;
            //                    label3.textColor = [UIColor whiteColor];
            //                    label3.textAlignment = NSTextAlignmentRight;
            //                    label3.font = [UIFont systemFontOfSize:14];
            //NSDictionary *dicttime = @{@"tag":[NSString stringWithFormat:@"%d",i]};
            //countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:dicttime repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
            //设置倒计时显示的时间
            NSString *str_day = [NSString stringWithFormat:@"%ld",secondsCountDown/3600/24];
            NSString *str_hour = [NSString stringWithFormat:@"%ld",secondsCountDown/3600%24];//时
            NSString *str_minute = [NSString stringWithFormat:@"%ld",(secondsCountDown%3600)/60];//分
            NSString *str_second = [NSString stringWithFormat:@"%ld",secondsCountDown%60];//秒
            
            daylabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 4, 15, 15)];
            daylabel.backgroundColor = [UIColor whiteColor];
            daylabel.layer.masksToBounds = YES;
            daylabel.layer.cornerRadius = 3;
            daylabel.textColor = QIColor;
            daylabel.textAlignment = NSTextAlignmentCenter;
            daylabel.text = str_day;
            daylabel.font = [UIFont systemFontOfSize:10];
            
            UILabel *labelmaohao = [[UILabel alloc] initWithFrame:CGRectMake(55, 4, 15, 15)];
            labelmaohao.text = @"天";
            labelmaohao.textColor = [UIColor whiteColor];
            labelmaohao.textAlignment = NSTextAlignmentCenter;
            labelmaohao.font = [UIFont systemFontOfSize:10];
            
            hourslabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 4, 15, 15)];
            hourslabel.backgroundColor = [UIColor whiteColor];
            hourslabel.layer.masksToBounds = YES;
            hourslabel.layer.cornerRadius = 3;
            hourslabel.textColor = QIColor;
            hourslabel.textAlignment = NSTextAlignmentCenter;
            hourslabel.text = str_hour;
            hourslabel.font = [UIFont systemFontOfSize:10];
            
            UILabel *labelmaohao1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 4, 10, 15)];
            labelmaohao1.text = @":";
            labelmaohao1.textColor = [UIColor whiteColor];
            labelmaohao1.textAlignment = NSTextAlignmentCenter;
            labelmaohao1.font = [UIFont systemFontOfSize:10];
            
            mlabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 4, 15, 15)];
            mlabel.backgroundColor = [UIColor whiteColor];
            mlabel.text = str_minute;
            mlabel.layer.masksToBounds = YES;
            mlabel.layer.cornerRadius = 3;
            mlabel.font = [UIFont systemFontOfSize:10];
            mlabel.textColor = QIColor;
            mlabel.textAlignment = NSTextAlignmentCenter;
            
            UILabel *labelmaohao2 = [[UILabel alloc] initWithFrame:CGRectMake(105, 4, 10, 15)];
            labelmaohao2.text = @":";
            labelmaohao2.textColor = [UIColor whiteColor];
            labelmaohao2.textAlignment = NSTextAlignmentCenter;
            labelmaohao2.font = [UIFont systemFontOfSize:10];
            
            slabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 4, 15, 15)];
            slabel.backgroundColor = [UIColor whiteColor];
            slabel.font = [UIFont systemFontOfSize:10];
            slabel.text = str_second;
            slabel.textAlignment = NSTextAlignmentCenter;
            slabel.layer.cornerRadius = 3;
            slabel.layer.masksToBounds = YES;
            slabel.textColor = QIColor;
            
            
            
            [view1 addSubview:daylabel];
            [view1 addSubview:hourslabel];
            [view1 addSubview:mlabel];
            [view1 addSubview:labelmaohao];
            [view1 addSubview:labelmaohao1];
            
            
            
            UILabel *labeltitle = [[UILabel alloc] initWithFrame:CGRectMake(6, view1.frame.size.height+view1.frame.origin.y+6, 108, 26)];
            labeltitle.font = [UIFont systemFontOfSize:12];
            labeltitle.numberOfLines = 2;
            labeltitle.text = [[pro_discount_listArr objectAtIndex:i] objectForKey:@"title"];
            [backview addSubview:labeltitle];
            
            UILabel *labelprice1 = [[UILabel alloc] initWithFrame:CGRectMake(6, labeltitle.frame.size.height+labeltitle.frame.origin.y+9, 125-28-6, 12)];
            labelprice1.font = [UIFont systemFontOfSize:13];
            labelprice1.textColor = QIColor;
            labelprice1.text = [NSString stringWithFormat:@"¥%@/%@",[[pro_discount_listArr objectAtIndex:i] objectForKey:@"price"],[[pro_discount_listArr objectAtIndex:i] objectForKey:@"unit"]];
            [backview addSubview:labelprice1];
            
            UILabel *labelprice2 = [[UILabel alloc] initWithFrame:CGRectMake(6, labelprice1.frame.size.height+labelprice1.frame.origin.y+6, 125-28-6, 9)];
            labelprice2.font = [UIFont systemFontOfSize:12];
            labelprice2.text = [NSString stringWithFormat:@"¥%@",[[pro_discount_listArr objectAtIndex:i] objectForKey:@"original"]];
            labelprice2.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1];
            NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:labelprice2.text attributes:attribtDic];
            labelprice2.attributedText = attribtStr;
            [backview addSubview:labelprice2];
            
            UIImageView *lijigoumaiimg = [[UIImageView alloc] initWithFrame:CGRectMake(125-28-6, labelprice1.frame.origin.y, 28, 25)];
            lijigoumaiimg.image = [UIImage imageNamed:@"ic_buynow"];
            [backview addSubview:lijigoumaiimg];
            
            UIButton *goodsbut = [UIButton buttonWithType:UIButtonTypeCustom];
            goodsbut.frame = CGRectMake(0, 0, 125, 212);
            goodsbut.tag = [[[pro_discount_listArr objectAtIndex:i] objectForKey:@"id"] integerValue];
            [goodsbut addTarget:self action:@selector(pushgoodsdetail:) forControlEvents:UIControlEventTouchUpInside];
            [backview addSubview:goodsbut];
        }
        
    }else{
        
    }
    
    
#pragma mark - 每日必逛
    if ([shangpinArr isKindOfClass:[NSArray class]]&&shangpinArr.count>0) {
        UIView *meiribiguang = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height+view.frame.origin.y+H1+10, Main_width, 50)];
//        meiribiguang.backgroundColor = QIColor;
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.frame = CGRectMake(10, 17, 75, 19);
        titleLab.text = @"每日必逛";
        titleLab.textColor = [UIColor colorWithHexString:@"#555555FF"];
        titleLab.font = [UIFont systemFontOfSize:18];
        [meiribiguang addSubview:titleLab];
        
        UILabel *fuLab = [[UILabel alloc]init];
        fuLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame)+10, 22, 113, 14);
        fuLab.text = @"精挑细选 为你省钱";
        fuLab.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
        fuLab.font = [UIFont systemFontOfSize:13];
        [meiribiguang addSubview:fuLab];
        [_tabHeadView addSubview:meiribiguang];
        
        
        UIView *meiribiguangguanggao = [[UIView alloc] initWithFrame:CGRectMake(0, meiribiguang.frame.size.height+meiribiguang.frame.origin.y+10, Main_width, 120)];
        if ([shangpinArr isKindOfClass:[NSArray class]]) {
            long m = shangpinArr.count;
            for (int i=0; i<m; i++) {
                if (i%2 == 0) {
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12+(Main_width-24+2)*i/2, 0, Main_width/2-24/2, 120)];
                    view.backgroundColor = [UIColor whiteColor];
                    [meiribiguangguanggao addSubview:view];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, (Main_width-24)/2/1.5)];
                    imageview.clipsToBounds = YES;
                    imageview.layer.cornerRadius = 3;
                    NSURL *url = [NSURL URLWithString:[API_img stringByAppendingString:[[shangpinArr objectAtIndex:i] objectForKey:@"img"]]];
                    [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"展位图长1.5"]];
                    [view addSubview:imageview];
                    
                                    UIButton *dianjibut = [UIButton buttonWithType:UIButtonTypeCustom];
                                    dianjibut.frame = imageview.frame;
                                    dianjibut.tag = i;
                                    [dianjibut addTarget:self action:@selector(centerguanggao:) forControlEvents:UIControlEventTouchUpInside];
                                    [view addSubview:dianjibut];
                    
                }else{
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12+(Main_width-24+2)*i/2, 0, Main_width/2-24/2, 120)];
                    view.backgroundColor = [UIColor whiteColor];
                    [meiribiguangguanggao addSubview:view];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, (Main_width-24)/2/1.5)];
                    NSURL *url = [NSURL URLWithString:[API_img stringByAppendingString:[[shangpinArr objectAtIndex:i] objectForKey:@"img"]]];
                    [imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"展位图长1.5"]];
                    [view addSubview:imageview];
                    
                                    UIButton *dianjibut = [UIButton buttonWithType:UIButtonTypeCustom];
                                    dianjibut.frame = imageview.frame;
                                    dianjibut.tag = i;
                                    //                    [[[centerguanggaoarr objectAtIndex:i] objectForKey:@"id"] longValue];
                                    [dianjibut addTarget:self action:@selector(centerguanggao:) forControlEvents:UIControlEventTouchUpInside];
                                    [view addSubview:dianjibut];
                    
                }
            }
        }
        
//        meiribiguangguanggao.backgroundColor = BackColor;
         meiribiguangguanggao.backgroundColor = [UIColor whiteColor];
        [_tabHeadView addSubview:meiribiguangguanggao];
        
        
        
    }else{
        
    }
    
#pragma mark - 更多好货
    UIView *gengduohaohuo = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height+view.frame.origin.y+H1+10+H2, Main_width, 50)];
//    gengduohaohuo.backgroundColor = QIColor;
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.frame = CGRectMake(10, 17, 75, 19);
    titleLab.text = @"更多好货";
    titleLab.textColor = [UIColor colorWithHexString:@"#555555FF"];
    titleLab.font = [UIFont systemFontOfSize:18];
    [gengduohaohuo addSubview:titleLab];
    
    UILabel *fuLab = [[UILabel alloc]init];
    fuLab.frame = CGRectMake(CGRectGetMaxX(titleLab.frame)+10, 22, 113, 14);
    fuLab.text = @"海量商品 等你来挑";
    fuLab.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    fuLab.font = [UIFont systemFontOfSize:13];
    [gengduohaohuo addSubview:fuLab];
    [_tabHeadView addSubview:gengduohaohuo];
    
    UIView *bottomline = [[UIView alloc] initWithFrame:CGRectMake(15, gengduohaohuo.frame.size.height+gengduohaohuo.frame.origin.y, Main_width-30, 1)];
    bottomline.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
    [_tabHeadView addSubview:bottomline];
    
    _mainTableView.tableHeaderView = _tabHeadView;
    
    _tabHeadView.backgroundColor = [UIColor whiteColor];
}
- (void)centerguanggao:(UIButton *)sender
{
    NSString *url_type = [[shangpinArr objectAtIndex:sender.tag] objectForKey:@"url_type"];
    NSString *url_id = [[shangpinArr objectAtIndex:sender.tag] objectForKey:@"id"];
    NSString *urltypename = [[shangpinArr objectAtIndex:sender.tag] objectForKey:@"type_name"];
    if ([url_type isEqualToString:@"5"]) {
        weixiuViewController *weixiu = [[weixiuViewController alloc] init];
        weixiu.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:weixiu animated:YES];
    }if ([url_type isEqualToString:@"3"]) {
        acivityViewController *aciti = [[acivityViewController alloc] init];
        aciti.hidesBottomBarWhenPushed = YES;
        aciti.url = urltypename;
        [self.navigationController pushViewController:aciti animated:YES];
    }if ([url_type isEqualToString:@"4"]) {
        activitydetailsViewController *acti = [[activitydetailsViewController alloc] init];
        acti.url = urltypename;
        acti.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:acti animated:YES];
    }if ([url_type isEqualToString:@"7"]) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",url_id];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }if ([url_type isEqualToString:@"1"]) {
        shangpinliebiaoViewController *liebiao = [[shangpinliebiaoViewController alloc] init];
        shangpinerjiViewController *erji = [[shangpinerjiViewController alloc] init];
        NSString *type_name = [[shangpinArr objectAtIndex:sender.tag] objectForKey:@"type_name"];
        NSRange range = [type_name rangeOfString:@"id/"]; //现获取要截取的字符串位置
        NSString * result = [type_name substringFromIndex:range.location+3]; //截取字符串
        liebiao.id = result;
        erji.id = result;
        erji.hidesBottomBarWhenPushed = YES;
        liebiao.hidesBottomBarWhenPushed = YES;
        
        
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"],@"cate_id":result};
        
        NSString *strurl = [API stringByAppendingString:@"shop/pro_list_cate"];
        [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"精选专栏-------------%@",responseObject);
            NSArray *arr = [responseObject objectForKey:@"data"];
            if (![arr isKindOfClass:[NSArray class]]) {
                [self.navigationController pushViewController:erji animated:YES];
            }else{
                [self.navigationController pushViewController:liebiao animated:YES];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"failure--%@",error);
        }];
    }if ([url_type isEqualToString:@"6"]) {
        //优惠券
        NSString *type_name = [[shangpinArr objectAtIndex:sender.tag] objectForKey:@"type_name"];
        
        WebViewController *web = [[WebViewController alloc] init];
        web.url_type = @"2";
        web.title = @"优惠券";
        web.url = type_name;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }if ([url_type isEqualToString:@"8"]) {
        youhuiquanViewController *youhuiquan = [[youhuiquanViewController alloc] init];
        youhuiquan.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:youhuiquan animated:YES];
    }if ([url_type isEqualToString:@"9"]) {
        youhuiquanxiangqingViewController *youhuiquan = [[youhuiquanxiangqingViewController alloc] init];
        youhuiquan.hidesBottomBarWhenPushed = YES;
        NSRange range = [urltypename rangeOfString:@"id/"]; //现获取要截取的字符串位置
        NSString * result = [urltypename substringFromIndex:range.location+3]; //截取字符串
        youhuiquan.id = result;
        [self.navigationController pushViewController:youhuiquan animated:YES];
    }if ([url_type isEqualToString:@"2"]) {
        GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
        NSRange range = [urltypename rangeOfString:@"id/"]; //现获取要截取的字符串位置
        NSString * result = [urltypename substringFromIndex:range.location+3]; //截取字符串
        goods.IDstring = result;
        goods.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goods animated:YES];
    }if ([url_type isEqualToString:@"10"]) {
        WebViewController *web = [[WebViewController alloc] init];
        web.url = url_id;
        web.url_type = @"1";
        //web.jpushstring = @"jpush";
        web.title = @"小慧推荐";
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }if ([url_type isEqualToString:@"11"]) {
        noticeViewController *notice = [[noticeViewController alloc] init];
        notice.hidesBottomBarWhenPushed = YES;
        NSRange range = [url_id rangeOfString:@"id/"]; //现获取要截取的字符串位置
        NSString * result = [url_id substringFromIndex:range.location+3]; //截取字符串
        notice.id = result;
        //notice.jpushstring = @"jpush";
        [self.navigationController pushViewController:notice animated:YES];
    }if ([url_type isEqualToString:@"12"]){
        
    }if ([url_type isEqualToString:@"13"]){
        circledetailsViewController *circle = [[circledetailsViewController alloc] init];
        circle.id = url_id;
        circle.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:circle animated:YES];
    }if ([url_type isEqualToString:@"14"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_id]];
    }if ([url_type isEqualToString:@"15"]){
        youxianjiaofeiViewController *youxian = [[youxianjiaofeiViewController alloc] init];
        youxian.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:youxian animated:YES];
    }if ([url_type isEqualToString:@"16"]){
        NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
        NSString *is_bind_property = [userdf objectForKey:@"is_bind_property"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
        NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
        NSString *strurl = [API stringByAppendingString:@"property/binding_community"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@-000000-%@",[responseObject objectForKey:@"msg"],responseObject);
            NSArray *arrrrr = [[NSArray alloc] init];
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                arrrrr = [responseObject objectForKey:@"data"];
                if (arrrrr.count>1) {
                    selectHomeViewController *selecthome = [[selectHomeViewController alloc] init];
                    selecthome.homeArr = arrrrr;
                    selecthome.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:selecthome animated:YES];
                }else{
                    MyhomeViewController *myhome = [[MyhomeViewController alloc] init];
                    myhome.room_id = [[arrrrr objectAtIndex:0] objectForKey:@"room_id"];
                    myhome.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:myhome animated:YES];
                }
                [defaults setObject:@"2" forKey:@"is_bind_property"];
                [userdf synchronize];
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
                bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
                bangding.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:bangding animated:YES];
                
                [defaults setObject:@"1" forKey:@"is_bind_property"];
                [userdf synchronize];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }if ([url_type isEqualToString:@"17"]){
        NSUserDefaults *userdf = [NSUserDefaults standardUserDefaults];
        NSString *is_bind_property = [userdf objectForKey:@"is_bind_property"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
        NSDictionary *dict = @{@"apk_token":uid_username,@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
        NSString *strurl = [API stringByAppendingString:@"property/binding_community"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@-000000-%@",[responseObject objectForKey:@"msg"],responseObject);
            NSArray *arrrrr = [[NSArray alloc] init];
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                arrrrr = [responseObject objectForKey:@"data"];
                if (arrrrr.count>1) {
                    selectHomeViewController *selecthome = [[selectHomeViewController alloc] init];
                    selecthome.homeArr = arrrrr;
                    selecthome.rukoubiaoshi = @"layakaimen";
                    selecthome.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:selecthome animated:YES];
                }else{
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[defaults objectForKey:@"uid"],[defaults objectForKey:@"username"]]];
                    NSDictionary *dict = @{@"apk_token":uid_username,@"room_id":[[arrrrr objectAtIndex:0] objectForKey:@"room_id"],@"token":[defaults objectForKey:@"token"],@"tokenSecret":[defaults objectForKey:@"tokenSecret"]};
                    NSString *strurl = [API stringByAppendingString:@"property/checkIsAjb"];
                    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        NSLog(@"%@-11111-%@",[responseObject objectForKey:@"msg"],responseObject);
                        NSDictionary *dicccc = [[NSDictionary alloc] init];
                        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                            dicccc = [responseObject objectForKey:@"data"];
                            if ([dicccc isKindOfClass:[NSDictionary class]]) {
                                blueyaViewController *blueya = [[blueyaViewController alloc] init];
                                blueya.Dic = dicccc;
                                blueya.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:blueya animated:YES];
                            }else{
                                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                            }
                        }else{
                            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
                        }
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"failure--%@",error);
                    }];
                }
                [defaults setObject:@"2" forKey:@"is_bind_property"];
                [userdf synchronize];
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
                bangdingqianViewController *bangding = [[bangdingqianViewController alloc] init];
                bangding.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:bangding animated:YES];
                [defaults setObject:@"1" forKey:@"is_bind_property"];
                [userdf synchronize];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"failure--%@",error);
        }];
    }if ([url_type isEqualToString:@"18"]){
        FacePayViewController *face = [[FacePayViewController alloc] init];
        face.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:face animated:YES];
    }if ([url_type isEqualToString:@"19"]){
        jujiayanglaoViewController *hujia = [[jujiayanglaoViewController alloc] init];
        hujia.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hujia animated:YES];
    }if ([url_type isEqualToString:@"20"]){
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        if ([user objectForKey:@"username"]==nil) {
            LoginViewController *log = [[LoginViewController alloc] init];
            [self presentViewController:log animated:YES completion:nil];
        }else{
            huodongwebviewViewController *web = [[huodongwebviewViewController alloc] init];
            web.url = urltypename;
            
            
            //         http://www.dsyg42.com/ec/app_index?username=18503408643&sign=hshObj&atitude=112.727884&longitude=37.690397&uuid=990009261666328
            
            web.url = [NSString stringWithFormat:@"%@?username=%@&sign=hshObj&atitude=%@&longitude=%@&uuid=%@",urltypename,[user objectForKey:@"username"],[user objectForKey:@"latitude"],[user objectForKey:@"longitude"],GSKeyChainDataManager.readUUID];
            web.title = @"东森易购";
            NSLog(@"weburl---%@---%@",web.url,GSKeyChainDataManager.readUUID);
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
    }if ([url_type isEqualToString:@"21"]){
        xinfangshouceViewController *xinfang = [[xinfangshouceViewController alloc] init];
        xinfang.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:xinfang animated:YES];
    }
}
//- (UITableView *)mainTableView {
//    if (!_mainTableView) {
//        //⚠️这里的属性初始化一定要放在mainTableView.contentInset的设置滚动之前, 不然首次进来视图就会偏移到临界位置，contentInset会调用scrollViewDidScroll这个方法。
//
//    }
//    return _mainTableView;
//}
////这是红色视图
//-(UIView *)tabHeadView{
//    if (!_tabHeadView) {
//
//
//    }
//    return _tabHeadView;
//}
////这是轮播
//- (CCPagedScrollView*)imageScrollView{
//    if (!_imageScrollView)
//    {
//
////        _imageScrollView = [[CCPagedScrollView alloc] initWithFrame:CGRectMake(0, 0,Main_width, self.HeaderImageViewHeight) animationDuration:0 isAuto:NO];
////
////        NSArray *imagesURLStrings = @[
////                                      @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
////                                      @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
////                                      @"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1542851892&di=0e59ba3566a6124310a0a94a7fe1d3d6&src=http://imgsrc.baidu.com/imgad/pic/item/d52a2834349b033b142032f71ece36d3d539bd77.jpg"
////                                      ];
////
////        NSMutableArray *array = [NSMutableArray array];
////        for (NSString *imgUrl in imagesURLStrings) {
////            [array addObject:[[CCPagedScrollViewItem alloc] initWithItemImageUrl:imgUrl itemTag:@(0)]];
////        }
////
////
////        _imageScrollView.items = array;
//    }
//
//    return _imageScrollView;
//}

////这是轮播的父控件
//-(YWPageHeadView *)pageHeadView{
//    if (!_pageHeadView) {
//        _pageHeadView = [[YWPageHeadView alloc]init];
//        _pageHeadView.parentView = self.view;  //这个必须设置
//        _pageHeadView.frame = CGRectMake(0, -self.offHeight,Main_width, self.HeaderImageViewHeight);
//    }
//    return _pageHeadView;
//}
-(void)getdata
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
        //1.创建会话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"]};
        //3.发送GET请求
        /*
         */
        NSString *strurl = [API stringByAppendingString:@"shop/shop_index"];
        [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //[_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
            //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
            WBLog(@"getversion41---success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
            centerArr = [[NSArray alloc] init];//头部广告下分类
            shangpinArr = [[NSArray alloc] init];
            fenleiArr = [[NSArray alloc] init];//下面的tableview数据
            pro_discount_listArr = [[NSArray alloc] init];//限时抢购
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                
                HeaDataArr = [[NSArray alloc] init];//头部
                HeaDataArr = [[responseObject objectForKey:@"data"] objectForKey:@"ad_hc_shopindex"];
                NSLog(@"headarr==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
                //NSLog(@"success--%@--%@",[responseObject class],responseObject);
                
                NSMutableArray *imagearr = [NSMutableArray array];
                bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 0, Main_width, Main_width/(2.5)) viewSize:CGSizeMake(Main_width,Main_width/(2.5))];
                
                if ([HeaDataArr isKindOfClass:[NSArray class]]) {
                    for (int i=0; i<HeaDataArr.count; i++) {
                        NSString *strurl = [API_img stringByAppendingString:[[HeaDataArr objectAtIndex:i]objectForKey:@"img"]];
                        NSLog(@"%@",strurl);
                        [imagearr addObject:strurl];
                        bannerView.items = imagearr;
                    }
                }else{
                    imagearr  =  nil;
                    
                }
                //            centerArr = [[responseObject objectForKey:@"data"] objectForKey:@"cate_list"];ad_hc_shop_center
                fenleiArr = [[responseObject objectForKey:@"data"] objectForKey:@"hot_cate_list"];
                centerArr = [[responseObject objectForKey:@"data"] objectForKey:@"cate_list"];
                shangpinArr = [[responseObject objectForKey:@"data"] objectForKey:@"ad_hc_shop_center"];
                pro_discount_listArr = [[[responseObject objectForKey:@"data"] objectForKey:@"pro_discount_list"] objectForKey:@"list"];
                
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *titlearr = [NSMutableArray arrayWithCapacity:0];
                for (int i=0; i<fenleiArr.count; i++) {
                    version41mallchildViewController *vc = [[version41mallchildViewController alloc] init];
                    [arr addObject:vc];
                    vc.id = [[fenleiArr objectAtIndex:i] objectForKey:@"id"];
                    [titlearr addObject:[[fenleiArr objectAtIndex:i] objectForKey:@"cate_name"]];
                }
                NSArray *titleArray = titlearr;
                SegmentView *segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, Main_width, Main_Height-NAVHEIGHT) controllers:arr titleArray:titleArray parentController:self];
                //注意：不能通过初始化方法传递selectedIndex的初始值，因为内部使用的是Masonry布局的方式, 否则设置selectedIndex不起作用
                
                _segmentView = segmentView;
            }else{
                
            }
            [self createui];
            [self.mainTableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
-(void)shuaxin
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"c_id":[user objectForKey:@"community_id"]};
    //3.发送GET请求
    /*
     */
    NSString *strurl = [API stringByAppendingString:@"shop/shop_index"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //[_DataArr addObjectsFromArray:[responseObject objectForKey:@"data"]];
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        WBLog(@"getversion41---success--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
//        centerArr = [[NSArray alloc] init];//头部广告下分类
//        shangpinArr = [[NSArray alloc] init];
//        fenleiArr = [[NSArray alloc] init];//下面的tableview数据
//        pro_discount_listArr = [[NSArray alloc] init];//限时抢购
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
            HeaDataArr = [[NSArray alloc] init];//头部
            HeaDataArr = [[responseObject objectForKey:@"data"] objectForKey:@"ad_hc_shopindex"];
            NSLog(@"headarr==%@==%@",[responseObject objectForKey:@"msg"],responseObject);
            //NSLog(@"success--%@--%@",[responseObject class],responseObject);
            
            NSMutableArray *imagearr = [NSMutableArray array];
            bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 0, Main_width, Main_width/(2.5)) viewSize:CGSizeMake(Main_width,Main_width/(2.5))];
            
            if ([HeaDataArr isKindOfClass:[NSArray class]]) {
                for (int i=0; i<HeaDataArr.count; i++) {
                    NSString *strurl = [API_img stringByAppendingString:[[HeaDataArr objectAtIndex:i]objectForKey:@"img"]];
                    NSLog(@"%@",strurl);
                    [imagearr addObject:strurl];
                    bannerView.items = imagearr;
                }
            }else{
                imagearr  =  nil;
                
            }
            //            centerArr = [[responseObject objectForKey:@"data"] objectForKey:@"cate_list"];ad_hc_shop_center
            fenleiArr = [[responseObject objectForKey:@"data"] objectForKey:@"hot_cate_list"];
            centerArr = [[responseObject objectForKey:@"data"] objectForKey:@"cate_list"];
            shangpinArr = [[responseObject objectForKey:@"data"] objectForKey:@"ad_hc_shop_center"];
            pro_discount_listArr = [[[responseObject objectForKey:@"data"] objectForKey:@"pro_discount_list"] objectForKey:@"list"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *titlearr = [NSMutableArray arrayWithCapacity:0];
            for (int i=0; i<fenleiArr.count; i++) {
                version41mallchildViewController *vc = [[version41mallchildViewController alloc] init];
                [arr addObject:vc];
                vc.id = [[fenleiArr objectAtIndex:i] objectForKey:@"id"];
                [titlearr addObject:[[fenleiArr objectAtIndex:i] objectForKey:@"cate_name"]];
            }
            NSArray *titleArray = titlearr;
            SegmentView *segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, Main_width, Main_Height-NAVHEIGHT) controllers:arr titleArray:titleArray parentController:self];
            //注意：不能通过初始化方法传递selectedIndex的初始值，因为内部使用的是Masonry布局的方式, 否则设置selectedIndex不起作用
            
            _segmentView = segmentView;
        }else{
            
        }
        [_mainTableView.mj_header endRefreshing];
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void) countDownAction{
    int i = [[countDownTimer.userInfo objectForKey:@"tag"] intValue];
    if ([[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_stime"] integerValue]-time(NULL)>0) {
        secondsCountDown = [[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_stime"] integerValue]-time(NULL);//倒计时秒数
    }else if ([[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue]-time(NULL)<0){
        secondsCountDown = time(NULL)-[[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue];//已结束
    }else{
        secondsCountDown = [[[pro_discount_listArr objectAtIndex:i] objectForKey:@"shop_cate_etime"] integerValue]-time(NULL);
        
    }
    NSString *str_day = [NSString stringWithFormat:@"%ld",secondsCountDown/3600/24];
    NSString *str_hour = [NSString stringWithFormat:@"%ld",secondsCountDown/3600%24];//时
    NSString *str_minute = [NSString stringWithFormat:@"%ld",(secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%ld",secondsCountDown%60];//秒
    //修改倒计时标签现实内容
    daylabel.text = str_day;
    hourslabel.text = str_hour;
    mlabel.text = str_minute;
    slabel.text = str_second;
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(secondsCountDown==0){
        [countDownTimer invalidate];
    }
}
- (void)pusherji:(UIButton *)sender
{
    NSString *islimtt = [NSString stringWithFormat:@"%@",[[centerArr objectAtIndex:sender.tag] objectForKey:@"is_limit"]];
    if (sender.tag==9) {
        ShangpinfenleiViewController *shangfenlei = [[ShangpinfenleiViewController alloc] init];
        shangfenlei.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shangfenlei animated:YES];
    }else{
        if ([islimtt isEqualToString:@"1"]) {
            xianshiqianggouerjiViewController *xianshi = [[xianshiqianggouerjiViewController alloc] init];
            xianshi.id = [[centerArr objectAtIndex:sender.tag] objectForKey:@"id"];
            xianshi.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:xianshi animated:YES];
        }else{
            shangpinliebiaoViewController *liebiao = [[shangpinliebiaoViewController alloc] init];
            //liebiao.title = [[centerArr objectAtIndex:sender.tag] objectForKey:@"cate_name"];
            liebiao.id = [[centerArr objectAtIndex:sender.tag] objectForKey:@"id"];
            liebiao.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:liebiao animated:YES];
        }
    }
}//pushgoodsdetail
- (void)pushgoodsdetail:(UIButton *)sender
{
    NSString *goodsid = [NSString stringWithFormat:@"%ld",sender.tag];
    GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
    goods.IDstring = goodsid;
    goods.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goods animated:YES];
}
- (void)pushgoods:(NSNotification *)user
{
    NSString *goodsid = [user.userInfo objectForKey:@"goodsid"];
    GoodsDetailViewController *goods = [[GoodsDetailViewController alloc] init];
    goods.IDstring = goodsid;
    goods.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goods animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)moreAction{
 
    newxianshiqianggouViewController *xsqgVC = [[newxianshiqianggouViewController alloc]init];
    xsqgVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xsqgVC animated:YES];
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
