//
//  rentalhouseViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/11/15.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "rentalhouseViewController.h"
#import "zushouweituoViewController.h"
@interface rentalhouseViewController ()

@end

@implementation rentalhouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *arr = @[@"租房",@"售房",@"发布房源"];
    for (int i = 0; i < 3 ; i ++) {
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