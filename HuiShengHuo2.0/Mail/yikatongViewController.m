//
//  yikatongViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2017/12/21.
//  Copyright © 2017年 晋中华晟. All rights reserved.
//

#import "yikatongViewController.h"
#import <AFNetworking.h>
#import "MBProgressHUD+TVAssistant.h"
#import "FacepayjiluViewController.h"
#import "youxianjiaofeijiluViewController.h"
#import "mywuyegongdanViewController.h"
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#import "PrefixHeader.pch"
#import "jiatingjiaofeijiluViewController.h"
#import "myserviceViewController.h"
@interface yikatongViewController ()
{
    UITextField *_textFieldcard;
    UITextField *_textFieldregion;
    
    UIButton *_sendBut;
    int timeDown; //60秒后重新获取验证码
    NSTimer *timer;
    
    NSString *_key;
    
    MBProgressHUD *_HUD;
}

@end

@implementation yikatongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一卡通支付";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self createui];
    // Do any additional setup after loading the view.
}
- (void)createui
{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, rectStatus.size.height+50, kScreen_Width, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    _textFieldcard = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width-20, 50)];
    _textFieldcard.placeholder = @"请输入卡号";
    _textFieldcard.backgroundColor = [UIColor whiteColor];
    _textFieldcard.keyboardType = UIKeyboardTypeNumberPad;
    _textFieldcard.tag = 1000;
    [view1 addSubview:_textFieldcard];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, rectStatus.size.height+50+55, kScreen_Width, 50)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    _textFieldregion = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width-20, 50)];
    _textFieldregion.placeholder = @"请输入验证码";
    _textFieldregion.keyboardType = UIKeyboardTypeNumberPad;
    _textFieldregion.backgroundColor = [UIColor whiteColor];
    _textFieldregion.tag = 1001;
    [view2 addSubview:_textFieldregion];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    
    //发送验证码按钮
    _sendBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBut.clipsToBounds=YES;
    _sendBut.frame = CGRectMake(kScreen_Width-150, 5, 120, 40);
    _sendBut.layer.cornerRadius = 15;
    [_sendBut.layer setBorderWidth:1];
    [_sendBut.layer setBorderColor:[[UIColor redColor]CGColor]];
    [_sendBut setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_sendBut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _sendBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_sendBut addTarget:self action:@selector(daojishi) forControlEvents:UIControlEventTouchUpInside];
    [_textFieldregion addSubview:_sendBut];
    
    UIButton *logbut = [UIButton buttonWithType:UIButtonTypeCustom];
    logbut.clipsToBounds=YES;
    logbut.layer.cornerRadius=30;//圆角
    logbut.frame = CGRectMake(15, 240, self.view.frame.size.width-30, 60);
    [logbut setTitle:@"支付" forState:UIControlStateNormal];
    logbut.backgroundColor = [UIColor redColor];
    [logbut addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logbut];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    UITextField * field3=(UITextField *)[self.view viewWithTag:1000];
    UITextField * field4=(UITextField *)[self.view viewWithTag:1001];
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        
        
        NSLog(@"swipe down");
        
    
        [field3 resignFirstResponder];
        [field4 resignFirstResponder];
    }
}
- (void)pay
{
    if (_textFieldcard.text.length==0) {
        [MBProgressHUD showToastToView:self.view withText:@"请输入卡号"];
    }else if(_textFieldregion.text.length==0){
        [MBProgressHUD showToastToView:self.view withText:@"请输入验证码"];
    }else{
        [self postpay];
    }
}
#pragma mark - 发送验证码
- (void)daojishi
{
    if (_textFieldcard.text.length==0) {
        [MBProgressHUD showToastToView:self.view withText:@"请输入卡号"];
    }else{
        [self CreatePost];
        timeDown = 59;
        [self handleTimer];
        timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    }
}
-(void)handleTimer
{
    
    if(timeDown>=0)
    {
        [_sendBut setUserInteractionEnabled:NO];
        int sec = ((timeDown%(24*3600))%3600)%60;
        [_sendBut setTitle:[NSString stringWithFormat:@"(%d)后重发",sec] forState:UIControlStateNormal];
    }
    else
    {
        [_sendBut setUserInteractionEnabled:YES];
        [_sendBut setTitle:@"重新发送" forState:UIControlStateNormal];
        [timer invalidate];
        
    }
    timeDown = timeDown - 1;
}
- (void)CreatePost
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数//600000011730
    NSDictionary *dict = @{@"cardno":_textFieldcard.text,@"id":_id};
    NSString *url = [API stringByAppendingString:@"userCenter/pay_shopping_order/typename/hcpay"];
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"%@",responseObject);
            _key = [[responseObject objectForKey:@"data"] objectForKey:@"key"];
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            //            [LoadingView stopAnimating];
            //            LoadingView.hidden = YES;
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)postpay
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uid_username = [MD5 MD5:[NSString stringWithFormat:@"%@%@",[user objectForKey:@"uid"],[user objectForKey:@"username"]]];
    NSDictionary *dict = @{@"key":_key,@"cardno":_textFieldcard.text,@"price":_price,@"order_id":_id,@"rand":_textFieldregion.text,@"otype":_otype,@"apk_token":uid_username,@"token":[user objectForKey:@"token"],@"tokenSecret":[user objectForKey:@"tokenSecret"]};
    NSString *_url = [API stringByAppendingString:@"userCenter/pay_shopping_check"];
    [manager POST:_url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [self GeneralButtonAction1];
            if ([_otype isEqualToString:@"wy"]) {
                jiatingjiaofeijiluViewController *jilu = [[jiatingjiaofeijiluViewController alloc] init];
                [self.navigationController pushViewController:jilu animated:YES];
            }else if ([_otype isEqualToString:@"hd"]){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else if ([_otype isEqualToString:@"dm"]){
                FacepayjiluViewController *jilu = [[FacepayjiluViewController alloc] init];
                [self.navigationController pushViewController:jilu animated:YES];
            }else if ([_otype isEqualToString:@"yx"]){
                youxianjiaofeijiluViewController *jilu = [[youxianjiaofeijiluViewController alloc] init];
                [self.navigationController pushViewController:jilu animated:YES];
            }else if ([_otype isEqualToString:@"se"]){
                myserviceViewController *mtse = [[myserviceViewController alloc] init];
                [self.navigationController pushViewController:mtse animated:YES];
            }else if ([_otype isEqualToString:@"wo"]){
                mywuyegongdanViewController *vc = [[mywuyegongdanViewController alloc] init];
                if ([_prepay isEqualToString:@"1"]) {
                    vc.titleselect = @"0";
                }else{
                    vc.titleselect = @"1";
                }
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            //            [LoadingView stopAnimating];
            //            LoadingView.hidden = YES;
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"failure--%@",error);
    }];
}
- (void)GeneralButtonAction1{
    //初始化进度框，置于当前的View当中
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"请稍后...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    //细节文字
    //_HUD.detailsLabelText = @"请耐心等待";
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        [self chevsuess];
        sleep(3);
        
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           [_HUD removeFromSuperview];
           _HUD = nil;
       }];
}
- (void)chevsuess
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSLog(@"--type%@",_otype);
    NSString *type;
    if ([_otype isEqualToString:@"wy"]) {
        type = @"property";
    }else if ([_otype isEqualToString:@"hd"]){
        type = @"activity";
    }else if ([_otype isEqualToString:@"dm"]){
        type = @"face";
    }else if ([_otype isEqualToString:@"yx"]){
        type = @"wired";
    }else if ([_otype isEqualToString:@"se"]){
        type = @"serve";
    }else if ([_otype isEqualToString:@"wo"]){
        type = @"work";
    }else{
        type = @"shop";
    }
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = @{@"id":_id,@"type":type,@"prepay":@"0",@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *urlstr = [API stringByAppendingString:@"userCenter/confirm_order_payment"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"zhifushifouchenggong--%@--%@--%@",[responseObject objectForKey:@"msg"],responseObject,dict);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"监测成--");
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"wuyejiaofeichenggong" object:nil userInfo:nil];
            if ([_otype isEqualToString:@"wy"]) {
                
            }else if ([_otype isEqualToString:@"hd"]){
                
            }else if ([_otype isEqualToString:@"dm"]){
                
            }else if ([_otype isEqualToString:@"yx"]){
                
            }else if ([_otype isEqualToString:@"se"]){
                [self postfuwususess];
            }else if ([_otype isEqualToString:@"se"]){
                
            }else{
                [self postsusess];
                [self postsusess1];
            }
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}


//判断服务订单成功否
-(void)postfuwususess
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = @{@"id":_id};
    NSString *urlstr = [API stringByAppendingString:@"Jpush/service_order_toAmountWorker_push"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"fuwuzhifu--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
//判断商城订单成功否
-(void)postsusess
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = @{@"id":_id};
    NSString *urlstr = [API stringByAppendingString:@"site/merchant_push"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"zhifu--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)postsusess1
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *dict = @{@"oid":_id};
    NSString *urlstr = [API stringByAppendingString:@"Jpush/distribution_push"];
    [manager POST:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"zhifu1--%@--%@",[responseObject objectForKey:@"msg"],responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
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
