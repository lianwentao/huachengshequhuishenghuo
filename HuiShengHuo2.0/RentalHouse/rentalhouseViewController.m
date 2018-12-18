//
//  rentalhouseViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/15.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "rentalhouseViewController.h"
#import "zushouweituoViewController.h"
#import "zuFangViewController.h"
#import "shouFangViewController.h"
#import "fengLeiDetailViewController.h"
#import "fuWuFengLeiViewController.h"
#import "fwflViewController.h"
#import "orderDetailsViewController.h"
@interface rentalhouseViewController ()

@end

@implementation rentalhouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *arr = @[@"租房",@"售房",@"发布房源",@"服务item",@"服务分类",@"订单详情"];
    for (int i = 0; i < arr.count ; i ++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.backgroundColor = QIColor;
        but.frame = CGRectMake(100, 100+80*i, 100, 50);
        [but setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        but.tag = i;
        [but addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
    }
    // Do any additional setup after loading the view.
}
- (void)click:(UIButton *)sender
{
    if (sender.tag == 2) {
        zushouweituoViewController *zushouweituo = [[zushouweituoViewController alloc] init];
        [self.navigationController pushViewController:zushouweituo animated:YES];
    }else if (sender.tag == 0){
        zuFangViewController *zushouweituo = [[zuFangViewController alloc] init];
        [self.navigationController pushViewController:zushouweituo animated:YES];
    }else if (sender.tag == 1){
        shouFangViewController *zushouweituo = [[shouFangViewController alloc] init];
        [self.navigationController pushViewController:zushouweituo animated:YES];
    }else if (sender.tag == 3){
        fengLeiDetailViewController *zushouweituo = [[fengLeiDetailViewController alloc] init];
        [self.navigationController pushViewController:zushouweituo animated:YES];
    }else if (sender.tag == 4){
        fwflViewController *zushouweituo = [[fwflViewController alloc] init];
        [self.navigationController pushViewController:zushouweituo animated:YES];
    }else{
        orderDetailsViewController *zushouweituo = [[orderDetailsViewController alloc] init];
        zushouweituo.stateStr = @"待派单";
        [self.navigationController pushViewController:zushouweituo animated:YES];
    }
}


@end
