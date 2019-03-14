//
//  jiaofeiViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/8.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "jiaofeiViewController.h"
#import "MenuButton.h"
#import "wuyejiaofeiViewController.h"
#import <AFNetworking.h>
#import "MD5.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
@interface jiaofeiViewController (){
    
}
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *itemButtons;

@property(assign,nonatomic)NSUInteger upIndex;

@property(assign,nonatomic)NSUInteger downIndex;

@property(strong,nonatomic)UIImageView *closeImgView;

@property(strong,nonatomic)NSMutableArray *ary;

@end

@implementation jiaofeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self post];
    //添加底部关闭按钮
    [self insertCloseImg];
    //添加手势点击事件
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan:)];
    [self.view addGestureRecognizer:touch];
    // Do any additional setup after loading the view.
}
-(void)post
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *API = [defaults objectForKey:@"API"];
    NSString *strurl = [API stringByAppendingString:@"property/get_chargeitem"];
    [manager GET:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //NSLog(@"success==%@==%lu",[responseObject objectForKey:@"msg"],_DataArr.count);
        NSLog(@"success--%@--%@",[responseObject class],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            _ary = [[NSMutableArray alloc] init];
            _ary = [responseObject objectForKey:@"data"];
            
            //添加菜单按钮
            [self setMenu];
            
            
            //定时器控制每个按钮弹出的时间
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(popupBtn) userInfo:nil repeats:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (NSMutableArray *)itemButtons
{
    if (_itemButtons == nil) {
        _itemButtons = [NSMutableArray array];
    }
    return _itemButtons;
}
//
//-(NSArray *)ary{
//
//    if (_ary==nil) {
//
//        _ary = [NSArray array];
//
//        _ary = @[@"shop_icon_tianch_dianjihou",@"shop_icon_tianch_dianjihou",@"shop_icon_tianch_dianjihou"];
//    }
//
//    return _ary;
//}

-(void)loadView{
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    //获取截取的背景图片，便于达到模糊背景效果
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景图2.5"]];
    //模糊效果层
    UIView *blurView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [blurView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.8]];
    
    [imgView addSubview:blurView];
    [view addSubview:imgView];
    
    self.view = view;
}
- (void)viewWillAppear:(BOOL)animated{
    
//    [super viewWillAppear:animated];
//
//    [UIView animateWithDuration:0.6 animations:^{
//
//        _closeImgView.transform = CGAffineTransformRotate(_closeImgView.transform, M_PI);
//    }];
}

- (void)insertCloseImg{
    
    UIImage *img = [UIImage imageNamed:@"tabbar_compose_background_icon_close"];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    
    imgView.frame = CGRectMake(self.view.center.x-20, self.view.frame.size.height-30, 30, 30);
    
    [self.view addSubview:imgView];
    
    _closeImgView = imgView;
    
}


- (void)popupBtn{
    
    if (_upIndex == self.itemButtons.count) {
        
        [self.timer invalidate];
        
        _upIndex = 0;
        
        return;
    }
    
    MenuButton *btn = self.itemButtons[_upIndex];
    
    [self setUpOneBtnAnim:btn];
    
    _upIndex++;
}

//设置按钮从第一个开始向上滑动显示
- (void)setUpOneBtnAnim:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        btn.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        
        //获取当前显示的菜单控件的索引
        _downIndex = self.itemButtons.count - 1;
    }];
    
}


//按九宫格计算方式排列按钮
- (void)setMenu{
    int cols = 3;
    int col = 0;
    int row = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat wh = 90;
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - cols * wh) / (cols + 1);
    CGFloat oriY = 300;
    
    for (int i = 0; i < self.ary.count; i++) {
        
        NSArray *imgary = @[@"shop_icon_tianch_dianjihou",@"shop_icon_tianch_dianjihou",@"shop_icon_tianch_dianjihou"];
        MenuButton *btn = [MenuButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *img = [UIImage imageNamed:imgary[i]];
        NSString *title = [[_ary objectAtIndex:i] objectForKey:@"name"];
        
        [btn setImage:img forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        
        col = i % cols;
        row = i / cols;
        
        x = margin + col * (margin + wh);
        y = row * (margin + wh) + oriY;
        
        btn.frame = CGRectMake(x, y, wh, wh);
        
        btn.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
        
        btn.tag = [[[_ary objectAtIndex:i] objectForKey:@"id"] integerValue];
        
        [btn addTarget:self action:@selector(touchDownBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.itemButtons addObject:btn];
        
        [self.view addSubview:btn];
        
    }
    
}

//点击按钮进行放大动画效果直到消失
- (void)touchDownBtn:(MenuButton *)btn{
    
    NSLog(@"%ld为btn.tag的值，根据不同的按钮需要做什么操作可以写这里",btn.tag);
    
    [UIView animateWithDuration:0.5 animations:^{
        btn.transform = CGAffineTransformMakeScale(2.0, 2.0);
        btn.alpha = 0;
    }];
    NSString *obj = [NSString stringWithFormat:@"%ld",btn.tag];
    [self performSelector:@selector(dismiss:) withObject:obj/*可传任意类型参数*/ afterDelay:0.5];
    
}
- (void)dismiss:(NSString *)obj
{
    NSDictionary *dict = @{@"jiaofeiid":obj};
    if ([_biaoshi isEqualToString:@"shouye"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushjiaofei1" object:nil userInfo:dict];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushjiaofei2" object:nil userInfo:dict];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置按钮从后往前下落
- (void)returnUpVC{
    
    if (_downIndex == -1) {
        
        [self.timer invalidate];
        
        return;
    }
    
    MenuButton *btn = self.itemButtons[_downIndex];
    
    [self setDownOneBtnAnim:btn];
    
    _downIndex--;
}

//按钮下滑并返回上一个控制器
- (void)setDownOneBtnAnim:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.6 animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }];
    
}

//点击事件返回上一控制器,并且旋转145弧度关闭按钮
-(void)touchesBegan:(UITapGestureRecognizer *)touches{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(returnUpVC) userInfo:nil repeats:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _closeImgView.transform = CGAffineTransformRotate(_closeImgView.transform, -M_PI_2*1.5);
    }];
    
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
