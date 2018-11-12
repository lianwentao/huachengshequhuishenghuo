//
//  shuduViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/7.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "shuduViewController.h"
#import "SudoView.h"
@interface shuduViewController ()

@end

@implementation shuduViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数独";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createView];
    // Do any additional setup after loading the view.
}
- (void)createView{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, RECTSTATUS.size.height+44, Main_width-60, 36)];
    label.textColor = QIColor;
    label.text = @"A-重置,C-回退上次操作";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    SudoView *sudoView = [[SudoView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width + 150)];
    [self.view addSubview:sudoView];
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
