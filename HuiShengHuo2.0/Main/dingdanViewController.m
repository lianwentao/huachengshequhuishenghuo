
//
//  dingdanViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/6.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "dingdanViewController.h"
#import "dingdanchildViewController.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
@interface dingdanViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
{
    NSMutableArray *_DataArr;
    UIButton *_tmpBtn;
    UITableView *_TableView;
    
    NSString *_status;
    int _pnum;
    
}
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@end

@implementation dingdanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商城订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setui];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change) name:@"deleteshopid" object:nil];
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.frame = CGRectMake(0, 0, 60, 40);
//    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = item;
    // Do any additional setup after loading the view.
}
- (void)change
{
}
-(BOOL)navigationShouldPopOnBackButton {
    WBLog(@"222");
    [self backBtnClicked];
    
    return YES;
}
- (void)backBtnClicked{
    WBLog(@"%@",_but_tag);
    if (_but_tag.length==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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

- (void)setui
{
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];//类型 qb->全部  dfw->待服务 dpj->待评价 wc->完成
    for (NSString *title in @[@"0",@"1",@"2",@"3"]) {
        dingdanchildViewController *vc = [[dingdanchildViewController alloc]init];
        vc.status = title;
        [childVCs addObject:vc];
    }
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, CGRectGetWidth(self.view.bounds), 50) titles:@[@"全部",@"待付款",@"待收货",@"评价/售后"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:17];
    self.titleView.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(247)/255.0 blue:(248)/255.0 alpha:0.54];
    self.titleView.titleNormalColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.54];
    self.titleView.selectIndex = 0;
    [self.view addSubview:_titleView];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    if (_but_tag.length==0) {
        self.pageContentView.contentViewCurrentIndex = 0;
    }else{
        self.pageContentView.contentViewCurrentIndex = [_but_tag integerValue];
    }
    
    //self.pageContentView.contentViewCanScroll = YES;//设置滑动属性
    [self.view addSubview:_pageContentView];
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
