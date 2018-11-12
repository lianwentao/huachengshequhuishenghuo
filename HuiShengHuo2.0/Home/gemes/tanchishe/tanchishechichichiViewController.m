//
//  tanchishechichichiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/5/7.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "tanchishechichichiViewController.h"
#import "background.h"
@interface tanchishechichichiViewController ()
@property (nonatomic,weak)background * back;
@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)CADisplayLink * display;
@property (nonatomic,strong)UILabel *hint;
@end

@implementation tanchishechichichiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"贪吃蛇";
    
    _hint = [[UILabel alloc] init];
    _hint.frame = CGRectMake(50, 120, self.view.frame.size.width-100, 25);
    _hint.textColor = QIColor;
    _hint.text = @"点击屏幕任意位置开始游戏";
    
    self.direction=1;
    background *back=[[background alloc]init];
    back.frame=CGRectMake(0, RECTSTATUS.size.height+44,self.view.frame.size.width,self.view.frame.size.height-RECTSTATUS.size.height-44);
    [self.view addSubview:back];
    _back=back;
    //添加定时动画
    CADisplayLink *displaylink=[CADisplayLink displayLinkWithTarget:self selector:@selector(moveWithDirection:)];
    displaylink.preferredFramesPerSecond=9;
    self.display=displaylink;
    [self newUISwipeGestureRecognizer];
    [self.view addSubview:_hint];
    
    // Do any additional setup after loading the view.
}
//开始游戏
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.hint.alpha=0;
}
//通过手势改变方向
-(void)changeDirection:(UISwipeGestureRecognizer *)sender{
    UISwipeGestureRecognizer *swipe=sender;
    if (swipe.direction==UISwipeGestureRecognizerDirectionDown&&self.direction!=3) {
        self.direction=1;
    }else if (swipe.direction==UISwipeGestureRecognizerDirectionLeft&&self.direction!=4){
        self.direction=2;
    }else if (swipe.direction==UISwipeGestureRecognizerDirectionUp&&self.direction!=1){
        self.direction=3;
    }else if(swipe.direction==UISwipeGestureRecognizerDirectionRight&&self.direction!=2){
        self.direction=4;
    }
    
}
//创建手势
-(void)newUISwipeGestureRecognizer{
    UISwipeGestureRecognizer *sgr=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeDirection:)];
    sgr.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:sgr];
    UISwipeGestureRecognizer *sgr1=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeDirection:)];
    sgr1.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:sgr1];
    UISwipeGestureRecognizer *sgr2=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeDirection:)];
    sgr2.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:sgr2];UISwipeGestureRecognizer *sgr3=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeDirection:)];
    sgr3.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:sgr3];
}
//蛇按方向移动
-(void)moveWithDirection:(NSInteger)direction{
    direction=self.direction;
    SnakeDirection dir=0;
    switch (direction) {
        case 1:
            dir=SnakeDirectionNone;
            break;
        case 2:
            dir=SnakeDirectionLeft;
            break;
        case 3:
            dir=SnakeDirectionup;
            break;
        case 4:
            dir=SnakeDirectionRight;
            break;
    }
    [_back moveWithDirection:dir];
    [self ChangeSpeed];
    [self dead];
}
//蛇的速度随着身体长度加快
-(void)ChangeSpeed{
    if (self.back.bodyLength>8&&self.back.bodyLength<=15) {
        self.display.preferredFramesPerSecond=12;
        _back.color=[UIColor orangeColor];
    }else if (self.back.bodyLength>15&&self.back.bodyLength<=25){
        self.display.preferredFramesPerSecond=15;
        _back.color=[UIColor brownColor];
    }else if (self.back.bodyLength>25&&self.back.bodyLength<=35){
        self.display.preferredFramesPerSecond=18;
        _back.color=[UIColor purpleColor];
    }else if (self.back.bodyLength>35&&self.back.bodyLength<=50){
        self.display.preferredFramesPerSecond=24;
        _back.color=[UIColor grayColor];
    }else if (self.back.bodyLength>50){
        self.display.preferredFramesPerSecond=30;
        _back.color=[UIColor blackColor];
    }
    
    
}
//游戏结束判定
-(void)dead{
    NSLog(@"x=%f,y=%f",_back.headpoint.x,_back.headpoint.y);
    for (int i=0; i<self.back.bodyLength; i++) {
        if (_back.points.lastObject==_back.points[i]||(!CGRectContainsPoint(CGRectMake(20, 21, 335, 625),_back.headpoint))) {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 667)];
            view.backgroundColor=[UIColor whiteColor];
            view.alpha=1;
            [self.view addSubview:view];
            [self.display invalidate];
            self.display=nil;
            NSString *string=[self achievement];
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"游戏结束" message:string preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertaction=[UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                view.alpha=0;
                [self viewDidLoad];
            }];
            [alert addAction:alertaction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


-(NSString *)achievement{
    
    
    if (_back.bodyLength<20) {
        NSString *string=[NSString stringWithFormat:@"游戏结果：蛇身长度%ld,你的蛇还是一条小蛇",_back.bodyLength];
        return string;
    }else if (_back.bodyLength>=20&&_back.bodyLength<50){
        NSString *string=[NSString stringWithFormat:@"游戏结果：蛇身长度%ld,你的蛇成长为一条大蛇",_back.bodyLength];
        return string;
    }else {
        NSString *string=[NSString stringWithFormat:@"游戏结果：蛇身长度%ld,你的蛇成长为一条蛇王",_back.bodyLength];
        return string;
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
