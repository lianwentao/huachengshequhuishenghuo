//
//  gamesViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/7.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "gamesViewController.h"
#import "tanchishechichichiViewController.h"
#import "shuduViewController.h"
#import "CSXGameAddController.h"
@interface gamesViewController ()

@end

@implementation gamesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"随便玩玩";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI
{
    NSArray *titlearr = @[@"小小贪吃蛇~",@"数独",@"2048"];
    for (int i=0; i<3; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0, 100+65*i, Main_width, 50);
        [but setTitle:[titlearr objectAtIndex:i] forState:UIControlStateNormal];
        but.tag = i;
        but.backgroundColor = randomColor;
        [but addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
    }
}
- (void)buttonclick:(UIButton *)sender
{
    if (sender.tag==0) {
        [self.navigationController pushViewController:[tanchishechichichiViewController new] animated:YES];
    }else if (sender.tag==1){
        [self.navigationController pushViewController:[shuduViewController new] animated:YES];
    }else{
        CSXGameAddController *gameVC = [[CSXGameAddController alloc]init];
        gameVC.dimension = 4;
        gameVC.threshold = 2048;
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController pushViewController:gameVC animated:YES];
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
