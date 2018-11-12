//
//  CSXGameAddController.m
//  Game2048
//
//  Created by CSX on 2017/1/12.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "CSXGameAddController.h"
#import "CSXGamebordView.h"
#import "AMConfig.h"

@interface CSXGameAddController ()
{
    CGFloat _boardWith;
    CSXGamebordView *gameView;

}
@end

@implementation CSXGameAddController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"2048";
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:226/255.0 blue:212/255.0 alpha:1];
    [self getInitalize];
    [self createView];
    
}
- (void)getInitalize{
    
    self.dimension = self.dimension<2? 2:self.dimension;
    self.threshold = self.threshold<8? 8:self.threshold;

    _boardWith = 260.0;//游戏区域的长度和高度
   
    
}

- (void)createView{
    gameView = [[CSXGamebordView alloc]initWithFrame:CGRectMake(W_WIDTH/2-_boardWith/2, H_HIGH/2-_boardWith/2, _boardWith, _boardWith) andContent:self.dimension];
    gameView.backgroundColor = [UIColor colorWithRed:142/255.0 green:138/255.0 blue:125/255.0 alpha:1];
    [self.view addSubview:gameView];
    
    UISwipeGestureRecognizer *swip_right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDirection:)];
    [swip_right setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swip_right];
    UISwipeGestureRecognizer *swip_left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDirection:)];
    [swip_left setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swip_left];
    UISwipeGestureRecognizer *swip_up = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDirection:)];
    [swip_up setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swip_up];
    UISwipeGestureRecognizer *swip_down = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDirection:)];
    [swip_down setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swip_down];
    
    
    UIButton *myCreateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    myCreateButton.frame = CGRectMake(0, H_HIGH-60, 100, 40);
    [myCreateButton setTitle:@"返回" forState:UIControlStateNormal];
    [myCreateButton addTarget:self action:@selector(buttonBackChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myCreateButton];
    
}
- (void)buttonBackChoose{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)chooseDirection:(UISwipeGestureRecognizer *)sender{
    [gameView getChangeWithDirection:sender.direction];
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
