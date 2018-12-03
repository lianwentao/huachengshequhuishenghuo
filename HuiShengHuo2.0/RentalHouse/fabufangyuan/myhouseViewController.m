//
//  myhouseViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/19.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "myhouseViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import <AFNetworking.h>
#import "FSScrollContentView.h"
#import "ChildViewController.h"
@interface myhouseViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;

@end

@implementation myhouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的房产";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44, CGRectGetWidth(self.view.bounds), 50) titles:@[@"售房信息",@"租房信息"] delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:17];
    self.titleView.backgroundColor = [UIColor colorWithRed:(244)/255.0 green:(247)/255.0 blue:(248)/255.0 alpha:0.54];
    self.titleView.titleNormalColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.54];
    self.titleView.selectIndex = 0;
    [self.view addSubview:_titleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSString *title in @[@"2",@"1"]) {
        ChildViewController *vc = [[ChildViewController alloc]init];
        
        vc.house_type = title;
        [childVCs addObject:vc];
    }
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, RECTSTATUS.size.height+44+50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 0;
    //    self.pageContentView.contentViewCanScroll = NO;//设置滑动属性
    [self.view addSubview:_pageContentView];
    
    
    // Do any additional setup after loading the view.
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
