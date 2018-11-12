//
//  bangdingyanzhengViewController.m
//  HuiShengHuo2.0
//
//  Created by 晋中华晟 on 2018/3/20.
//  Copyright © 2018年 晋中华晟. All rights reserved.
//

#import "bangdingyanzhengViewController.h"
#import "selectHomeViewController.h"
#import "MBProgressHUD+TVAssistant.h"
#import <AFNetworking.h>
#import "MyhomeViewController.h"
@interface bangdingyanzhengViewController ()<UITextFieldDelegate>
{
    UITextField *phonbe;
    UITextField *yanzhengmatext;
    
    UIButton *yanzhengmabut;
    int timeDown; //60秒后重新获取验证码
    NSTimer *timer;
    
    MBProgressHUD *_HUD;
    
    NSArray *_DataArr;
    
    NSString *phonestring;
    NSString *yanzhengmastring;
}

@end

@implementation bangdingyanzhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _DataArr = [NSArray array];
    [self createUI];
    
    [self downshoushi];
    // Do any additional setup after loading the view.
}
- (void)createUI
{
    NSArray *imagearr = [[NSArray alloc] initWithObjects:@"login_icon_iphone",@"login_icon_key",@"login_icon_clock", nil];
    for (int i=0; i<2; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10+RECTSTATUS.size.height+50+i*75+20, 35, 35)];
        imageview.image = [UIImage imageNamed:[imagearr objectAtIndex:i]];
        [self.view addSubview:imageview];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 10+RECTSTATUS.size.height+50+50+10+i*75, self.view.frame.size.width-15*2, 0.5)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        [self.view addSubview:view];
    }
    yanzhengmatext = [[UITextField alloc] initWithFrame:CGRectMake(65, 10+RECTSTATUS.size.height+50+20+75, self.view.frame.size.width-100, 40)];
    yanzhengmatext.placeholder = @"6位验证码";
    yanzhengmatext.keyboardType = UIKeyboardTypeNumberPad;
    yanzhengmatext.delegate = self;
    yanzhengmatext.tag = 1000;
    //yanzhengmatext.backgroundColor = BackColor;
    [self.view addSubview:yanzhengmatext];
    
    phonbe = [[UITextField alloc] initWithFrame:CGRectMake(65, 10+RECTSTATUS.size.height+50+20, self.view.frame.size.width-65, 40)];
    phonbe.placeholder = @"手机号码";
    phonbe.tag = 1001;
    phonbe.keyboardType = UIKeyboardTypeNumberPad;
    phonbe.delegate = self;
    //phonbe.backgroundColor = BackColor;
    [self.view addSubview:phonbe];
    
    //发送验证码按钮
    yanzhengmabut = [UIButton buttonWithType:UIButtonTypeCustom];
    yanzhengmabut.clipsToBounds=YES;
    //yanzhengmabut.layer.cornerRadius=30;//圆角
    yanzhengmabut.frame = CGRectMake(self.view.frame.size.width-150, 10+RECTSTATUS.size.height+50+10+75, 120, 40);
    yanzhengmabut.layer.cornerRadius = 15;
    [yanzhengmabut.layer setBorderWidth:1];
    [yanzhengmabut.layer setBorderColor:[[UIColor redColor]CGColor]];
    [yanzhengmabut setTitle:@"获取验证码" forState:UIControlStateNormal];
    [yanzhengmabut setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    yanzhengmabut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [yanzhengmabut addTarget:self action:@selector(daojishi) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yanzhengmabut];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, yanzhengmatext.frame.size.height+yanzhengmatext.frame.origin.y+30, Main_width-40, 0)];
    label1.numberOfLines = 0;
    label1.text = @"i 若在物业预留的电话号码发生变化,请在物业办公室进行更改后,再进行业主认证";
    label1.font = [UIFont systemFontOfSize:14];
    CGSize size = [label1 sizeThatFits:CGSizeMake(label1.frame.size.width, MAXFLOAT)];
    label1.frame = CGRectMake(label1.frame.origin.x, label1.frame.origin.y, Main_width-40,  size.height);
    label1.alpha = 0.6;
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, label1.frame.size.height+label1.frame.origin.y+15, Main_width-40, 0)];
    label2.text = @"i 如果您不是业主,请联系业主邀请您加入房屋";
    label2.numberOfLines = 0;
    label2.font = [UIFont systemFontOfSize:14];
    CGSize size1 = [label2 sizeThatFits:CGSizeMake(label2.frame.size.width, MAXFLOAT)];
    label2.frame = CGRectMake(label2.frame.origin.x, label2.frame.origin.y, Main_width-40,  size1.height);
    label2.alpha = 0.6;
    [self.view addSubview:label2];
    
    UIButton *nextbut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextbut];
    nextbut.backgroundColor = QIColor;
    [nextbut setTitle:@"下一步" forState:UIControlStateNormal];
    nextbut.frame = CGRectMake(0, Main_Height-49, Main_width, 49);
    [nextbut addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
}
- (void)next
{
    phonestring = phonbe.text;
    yanzhengmastring = yanzhengmatext.text;
    if (phonestring.length==0) {
        [MBProgressHUD showToastToView:self.view withText:@"手机号不能为空"];
    }else if (yanzhengmastring.length==0) {
        [MBProgressHUD showToastToView:self.view withText:@"验证码不能为空"];
    }else {
        [self GeneralButtonAction1];
    }
}
- (void)GeneralButtonAction1{
    //初始化进度框，置于当前的View当中
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.labelText = @"绑定中,请稍后...";
    _HUD.labelFont = [UIFont systemFontOfSize:14];
    //细节文字
    //_HUD.detailsLabelText = @"请耐心等待";
    
    //显示对话框
    [_HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        //sleep(3);
        [self checksms];
    }// 在HUD被隐藏后的回调
       completionBlock:^{
           //操作执行完后取消对话框
           
       }];
}
#pragma mark - 发送验证码
- (void)daojishi
{
    NSString *phoneNumber =phonbe.text;
    
    if(![self isValidateMobile:phoneNumber])
    {
        [MBProgressHUD showToastToView:self.view withText:@"手机号格式错误"];
    }else
    {
        [self sendsms];
        timeDown = 59;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
    }
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
- (void)sendsms
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    phonestring = phonbe.text;
    NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
    
    NSString *gudingzifuchuan = @"hui-shenghuo.api_sms";
    NSString *gudingjiami = [MD5 MD5:gudingzifuchuan];
    //NSString *TEACHERLower      = [TEACHER lowercaseString];
    NSString *str2 = [[gudingjiami lowercaseString] substringWithRange:NSMakeRange(8,16)];
    NSString *timestring = [NSString stringWithFormat:@"%ld",time(NULL)];
    NSString *str3 = [NSString stringWithFormat:@"%@%@%@",timestring,str2,timestring];
    NSString *str4 = [MD5 MD5:[str3 lowercaseString]];
    NSString *str5 = [[str4 lowercaseString] substringWithRange:NSMakeRange(0,16)];
    NSString *ApiSmstoken = str5;//,@"ApiSmstoken":ApiSmstoken,@"ApiSmstokentime":timestring
    NSDictionary *dict = @{@"mobile":phonestring,@"ApiSmstoken":ApiSmstoken,@"ApiSmstokentime":timestring,@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
    NSString *strurl = [API stringByAppendingString:@"property/bind_send_sms"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            NSLog(@"发送验证码成功");
            [self handleTimer];
            [MBProgressHUD showToastToView:self.view withText:@"验证码发送成功"];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)checksms
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = @{@"mobile":phonestring,@"mobile_vcode":yanzhengmastring};
    NSString *strurl = [API stringByAppendingString:@"property/check_bind_sms"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@---%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            [self checknext];
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)checknext
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = @{@"mobile":phonestring};
    NSString *strurl = [API stringByAppendingString:@"apk/property/check_property_mobile"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_HUD removeFromSuperview];
        _HUD = nil;
        NSLog(@"--%@---%@",responseObject,[responseObject objectForKey:@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            
            _DataArr = [responseObject objectForKey:@"data"];
            [self surebangding];
            
        }else{
            [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure--%@",error);
    }];
}
- (void)surebangding
{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    //2.封装参数
    NSDictionary *dict = @{@"mobile":phonestring};
    NSString *strurl = [API stringByAppendingString:@"property/property_bind_user"];
    [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"--%@---%@",responseObject,[responseObject objectForKey:@"msg"]);
        
        if ([[responseObject objectForKey:@"status"] integerValue]==1) {
            selectHomeViewController *selecthome = [[selectHomeViewController alloc] init];
            selecthome.homeArr = _DataArr;
            [self.navigationController pushViewController:selecthome animated:YES];
        }else{
            selectHomeViewController *selecthome = [[selectHomeViewController alloc] init];
            selecthome.homeArr = _DataArr;
            [self.navigationController pushViewController:selecthome animated:YES];
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
