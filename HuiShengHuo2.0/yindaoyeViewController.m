//
//  yindaoyeViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/7.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "yindaoyeViewController.h"
#import "XiaoquViewController.h"
#import "selectxiaoquViewController.h"

#define WIDTH (NSInteger)self.view.bounds.size.width
#define HEIGHT (NSInteger)self.view.bounds.size.height
@interface yindaoyeViewController ()<UIScrollViewDelegate>
{
    // 创建页码控制器
    UIPageControl *pageControl;
    // 判断是否是第一次进入应用
    BOOL flag;
}

@end

@implementation yindaoyeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arr = @[@"启动页2",@"启动页3",@"启动页4"];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -rectStatus.size.height, WIDTH, HEIGHT+rectStatus.size.height)];
    for (int i=0; i<3; i++) {
        UIImage *image = [UIImage imageNamed:[arr objectAtIndex:i]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        // 在最后一页创建按钮
        if (i == 2) {
            // 必须设置用户交互 否则按键无法操作
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, (HEIGHT+rectStatus.size.height)/2, WIDTH, HEIGHT+rectStatus.size.height);
            [button addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
        imageView.image = image;
        [myScrollView addSubview:imageView];
    }
    myScrollView.bounces = NO;
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.contentSize = CGSizeMake(WIDTH * 3, 0);
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    // Do any additional setup after loading the view.
}
// 点击按钮保存数据并切换根视图控制器
- (void) go:(UIButton *)sender{
    
    // 切换根视图控制器
    selectxiaoquViewController *xiaoqu = [[selectxiaoquViewController alloc] init];
    //self.view.window.rootViewController = [[XiaoquViewController alloc] init];
    [self.navigationController pushViewController:xiaoqu animated:YES];
}
#pragma mark - 隐藏导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
