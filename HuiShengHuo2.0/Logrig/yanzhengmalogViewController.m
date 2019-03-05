//
//  yanzhengmalogViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/1/12.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "yanzhengmalogViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import <AFNetworking.h>
#import "GSKeyChainDataManager.h"
#import "yonghuxieyiwebViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#import "PrefixHeader.pch"
@interface yanzhengmalogViewController ()<UITextFieldDelegate>
{
    UIButton *surcebut1;
    UIButton *surcebut2;
    UITextField *mimatext;
    UITextField *phonbe;
    UITextField *yanzhengmatext;
    
    UIButton *yanzhengmabut;
    int timeDown; //60秒后重新获取验证码
    NSTimer *timer;
}

@end

@implementation yanzhengmalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"哈哈";
    self.view.backgroundColor = [UIColor whiteColor];
    [self CreateLog];
    [self createdaohangolan];
    
    [self downshoushi];
    // Do any additional setup after loading the view.
}
#pragma mark - 自定义导航栏
- (void)createdaohangolan
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    but.frame = CGRectMake(10, 10+rectStatus.size.height, 50, 35);
    [but setTitle:@"返回" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:but];
    [but addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10+rectStatus.size.height, kScreenWidth, 35)];
    label.text = @"验证码登录";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
}
- (void)cancle
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)CreateLog
{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    NSArray *imagearr = [[NSArray alloc] initWithObjects:@"login_icon_iphone",@"login_icon_key",@"login_icon_clock", nil];
    for (int i=0; i<2; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10+rectStatus.size.height+50+i*75+20, 35, 35)];
        imageview.image = [UIImage imageNamed:[imagearr objectAtIndex:i]];
        [self.view addSubview:imageview];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 10+rectStatus.size.height+50+50+10+i*75, self.view.frame.size.width-15*2, 0.5)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        [self.view addSubview:view];
    }
    //登录
    UIButton *logbut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logbut.clipsToBounds=YES;
    
    logbut.layer.cornerRadius=30;//圆角
    logbut.frame = CGRectMake(15, 10+rectStatus.size.height+150+50, self.view.frame.size.width-30, 60);
    [logbut setTitle:@"登录" forState:UIControlStateNormal];
    logbut.backgroundColor = QIColor;
    [logbut.titleLabel setFont:font18];
    [logbut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logbut addTarget:self action:@selector(log) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logbut];
    //
    
    
    
    
    yanzhengmatext = [[UITextField alloc] initWithFrame:CGRectMake(65, 10+rectStatus.size.height+50+20+75, self.view.frame.size.width-100, 40)];
    yanzhengmatext.placeholder = @"6位验证码";
    yanzhengmatext.tag = 1000;
    yanzhengmatext.keyboardType = UIKeyboardTypeNumberPad;
    yanzhengmatext.delegate = self;
    [self.view addSubview:yanzhengmatext];
    
    phonbe = [[UITextField alloc] initWithFrame:CGRectMake(65, 10+rectStatus.size.height+50+20, self.view.frame.size.width-65, 40)];
    phonbe.placeholder = @"手机号码";
    phonbe.tag=1001;
    phonbe.keyboardType = UIKeyboardTypeNumberPad;
    phonbe.delegate = self;
    [self.view addSubview:phonbe];
    
    //发送验证码按钮
    yanzhengmabut = [UIButton buttonWithType:UIButtonTypeCustom];
    yanzhengmabut.clipsToBounds=YES;
    //yanzhengmabut.layer.cornerRadius=30;//圆角
    yanzhengmabut.frame = CGRectMake(self.view.frame.size.width-150, 10+rectStatus.size.height+50+10+75, 120, 40);
    yanzhengmabut.layer.cornerRadius = 15;
    [yanzhengmabut.layer setBorderWidth:1];
    [yanzhengmabut.titleLabel setFont:font15];
    [yanzhengmabut.layer setBorderColor:QIColor.CGColor];
    [yanzhengmabut setTitle:@"获取验证码" forState:UIControlStateNormal];
    [yanzhengmabut setTitleColor:QIColor forState:UIControlStateNormal];
    yanzhengmabut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [yanzhengmabut addTarget:self action:@selector(daojishi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yanzhengmabut];
    
//    //收不到验证码
//    UIButton *NOyanzhengmabut = [[UIButton alloc] initWithFrame:CGRectMake(15, 310+60+15, (self.view.frame.size.width-30)/2, 40)];
//    [NOyanzhengmabut setTitle:@"收不到验证码" forState:UIControlStateNormal];
//    [NOyanzhengmabut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.view addSubview:NOyanzhengmabut];
    
    UILabel *xieyilabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Main_Height-100, Main_width, 20)];
    xieyilabel.textAlignment = NSTextAlignmentCenter;
    [xieyilabel setFont:[UIFont systemFontOfSize:13]];
    //xieyilabel.text = @"注册即表示您已同意《社区慧生活用户注册协议》";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"登录即表示您已同意《社区慧生活用户注册协议》"];
    [attrStr setAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:QIColor}
                     range:NSMakeRange(9, 13)];
    xieyilabel.attributedText = attrStr;
    [self.view addSubview:xieyilabel];
    
    UIButton *xieyibut = [UIButton buttonWithType:UIButtonTypeCustom];
    xieyibut.frame = CGRectMake(Main_width/2, Main_Height-100, Main_width/2, 20);
    [xieyibut addTarget:self action:@selector(openxieyi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:xieyibut];
}
- (void)openxieyi
{
    yonghuxieyiwebViewController *xieyi = [yonghuxieyiwebViewController new];
    [self presentViewController:xieyi animated:YES completion:nil];
}
- (void)log
{
    NSString *phone = phonbe.text;
    NSString *reg = yanzhengmatext.text;
    if (phone.length==0) {
        [MBProgressHUD showToastToView:self.view withText:@"手机号不能为空"];
    }else if (reg.length==0) {
        [MBProgressHUD showToastToView:self.view withText:@"验证码不能为空"];
    }else {
        [self CreatePost2];
    }
}
#pragma mark - 发送验证码
- (void)daojishi
{
//    NSString *phoneNumber =phonbe.text;
//    
//    if(![self isValidateMobile:phoneNumber])
//    {
//        [MBProgressHUD showToastToView:self.view withText:@"手机号格式错误"];
//    }else
//    {
//        [self CreatePost];
//        timeDown = 59;
//        [self handleTimer];
//        timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
//    }
    [self CreatePost];
    
}
-(void)handleTimer
{
    
    if(timeDown>=0)
    {
        [yanzhengmabut setUserInteractionEnabled:NO];
        int sec = ((timeDown%(24*3600))%3600)%60;
        [yanzhengmabut setTitle:[NSString stringWithFormat:@"(%d)后重发",sec] forState:UIControlStateNormal];
        
    }
    else
    {
        [yanzhengmabut setUserInteractionEnabled:YES];
        [yanzhengmabut setTitle:@"重新发送" forState:UIControlStateNormal];
        [timer invalidate];
        
    }
    timeDown = timeDown - 1;
}
- (void)CreatePost
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    
    
    //2.封装参数
    NSString *gudingzifuchuan = @"hui-shenghuo.api_sms";
    NSString *gudingjiami = [MD5 MD5:gudingzifuchuan];
    //NSString *TEACHERLower      = [TEACHER lowercaseString];
    NSString *str2 = [[gudingjiami lowercaseString] substringWithRange:NSMakeRange(8,16)];
    NSString *timestring = [NSString stringWithFormat:@"%ld",time(NULL)];
    NSString *str3 = [NSString stringWithFormat:@"%@%@%@",timestring,str2,timestring];
    NSString *str4 = [MD5 MD5:[str3 lowercaseString]];
    NSString *str5 = [[str4 lowercaseString] substringWithRange:NSMakeRange(0,16)];
    NSString *ApiSmstoken = str5;//,@"ApiSmstoken":ApiSmstoken,@"ApiSmstokentime":timestring
    NSLog(@"%@---%@---%@---%@---%@---%@",gudingzifuchuan,gudingjiami,str2,str3,str4,str5);
    NSDictionary *dict = @{@"sms_type":@"login",@"username":phonbe.text,@"ApiSmstoken":ApiSmstoken,@"ApiSmstokentime":timestring};
    NSString *strurl = [API stringByAppendingString:@"site/reg_send_sms"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"发送验证码成功");
            timeDown = 59;
            [self handleTimer];
            timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
            [MBProgressHUD showToastToView:self.view withText:@"验证码发送成功"];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)CreatePost2
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [[NSDictionary alloc] init];
    if ([userdefaults objectForKey:@"registrationID"]==nil){
        dict = @{@"mobile_vcode":yanzhengmatext.text,@"username":phonbe.text,@"phone_type":@"2"};
    }else{
        dict = @{@"mobile_vcode":yanzhengmatext.text,@"username":phonbe.text,@"phone_type":@"2",@"phone_name":[userdefaults objectForKey:@"registrationID"]};
    }
    
    NSLog(@"dict--%@",dict);
    NSString *strurl = [API stringByAppendingString:@"site/login_verify"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@---%@",[responseObject objectForKey:@"msg"],responseObject);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
            [MBProgressHUD showToastToView:self.view withText:@"登录成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logsusess" object:nil userInfo:nil];
            //存储用户信息
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:phonbe.text forKey:@"username"];
            [defaults setObject:[[responseObject objectForKey:@"data"] objectForKey:@"uid"] forKey:@"uid"];
            [defaults setObject:@"2" forKey:@"phone_type"];
            [defaults setObject:[[responseObject objectForKey:@"data"] objectForKey:@"pwd"] forKey:@"pwd"];
            NSString *is_bind_property = [[responseObject objectForKey:@"data"] objectForKey:@"is_bind_property"];
            [defaults setObject:is_bind_property forKey:@"is_bind_property"];
            NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            [defaults setObject: cookiesData forKey:@"Cookie"];
            [defaults synchronize];
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [phonbe resignFirstResponder];
    [yanzhengmatext resignFirstResponder];
}
- (void)downshoushi{
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
}
//点击空白处的手势要实现的方法
-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    UITextField * field3=(UITextField *)[self.view viewWithTag:1000];
    UITextField * field4=(UITextField *)[self.view viewWithTag:1001];
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        
        
        
        NSLog(@"swipe down");
        
        [field4 resignFirstResponder];
        [field3 resignFirstResponder];
    }
    
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
/*手机号码验证 MODIFIED BY LYH*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex =@"^1[3,8]\\d{9}|14[5,7,9]\\d{8}|15[^4]\\d{8}|17[^2,4,9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
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
