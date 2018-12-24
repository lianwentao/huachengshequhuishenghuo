//
//  TabBarViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/11/16.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//
#pragma mark - ===TabBar===
#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "MailHomeViewController.h"
#import "MainViewController.h"
#import "newserviceViewController.h"
#import "CircleViewController.h"
#import "LoginViewController.h"
#import "MoreViewController.h"
#import "newMallViewController.h"
#import "newhomeViewController.h"
#import "version41mallViewController.h"
@interface TabBarViewController ()<UITabBarControllerDelegate>
{
    UITabBarController *TabBar;
}

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TabBar = [[UITabBarController alloc] init];
    TabBar.delegate = self;
    [self SetTabBar];
    // Do any additional setup after loading the view.
}

#pragma mark - 初始化导航控制器
- (void)SetTabBar
{
    UINavigationController *HomeNavigation = [[UINavigationController alloc] initWithRootViewController:[[newhomeViewController alloc] init]];
    UINavigationController *MailNavigation = [[UINavigationController alloc] initWithRootViewController:[[version41mallViewController alloc] init]];
    UINavigationController *ServiceNavigation = [[UINavigationController alloc] initWithRootViewController:[[newserviceViewController alloc] init]];
    UINavigationController *CircleNavigation = [[UINavigationController alloc] initWithRootViewController:[[MoreViewController alloc] init]];
    UINavigationController *MainNavigation = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    UINavigationController *LoginNavigation = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc]  init]  ];
    
    HomeNavigation.tabBarItem.image = [[UIImage imageNamed:@"homedainjiqian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    HomeNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"homedainjihou"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MailNavigation.tabBarItem.image = [[UIImage imageNamed:@"shopdianjiqian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MailNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"shopdianjihou"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ServiceNavigation.tabBarItem.image = [[UIImage imageNamed:@"servicedianjiqian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ServiceNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"servicedianjihou"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CircleNavigation.tabBarItem.image = [[UIImage imageNamed:@"socialdianjiqian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    CircleNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"socialdianjihou"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MainNavigation.tabBarItem.image = [[UIImage imageNamed:@"maindianjiqian"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MainNavigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"maindianjihou"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    HomeNavigation.title = @"首页";
    MailNavigation.title = @"商城";
    ServiceNavigation.title = @"服务";
    CircleNavigation.title = @"邻里";
    MainNavigation.title = @"我的";
    
    //改变tabbarController 文字选中颜色(默认渲染为蓝色)
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:admincolor} forState:UIControlStateSelected];
    
    //创建一个数组包含个导航栏控制器
    NSArray *vcArry = [NSArray arrayWithObjects:HomeNavigation,MailNavigation,ServiceNavigation,CircleNavigation,MainNavigation, nil];
  
        self.viewControllers = vcArry;
 
   
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
